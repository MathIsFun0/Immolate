#include <string>
#include <vector>
#include <cstdint>
#include <limits>
#include <cmath>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <array>

const uint64_t MAX_UINT64 = 18446744073709551615ull;

typedef union DoubleLong {
    double dbl;
    uint64_t ulong;
} dbllong;

struct LuaRandom {
    uint64_t state[4];
    LuaRandom(double seed) {
        double d = seed;
        uint64_t r = 0x11090601;
        for (int i = 0; i < 4; i++) {
            uint64_t m = 1ull << (r & 255);
            r >>= 8;
            d = d * 3.14159265358979323846 + 2.7182818284590452354;
            dbllong u;
            u.dbl = d;
            if (u.ulong < m) u.ulong += m;
            state[i] = u.ulong;
        }
        for (int i = 0; i < 10; i++) {
            _randint();
        }
    }
    LuaRandom() {
        LuaRandom(0);
    }
    uint64_t _randint() {
        uint64_t z = 0;
        uint64_t r = 0;
        z = state[0];
        z = (((z<<31ull)^z)>>45ull)^((z&(MAX_UINT64<<1ull))<<18ull);
        r ^= z;
        state[0] = z;
        z = state[1];
        z = (((z<<19ull)^z)>>30ull)^((z&(MAX_UINT64<<6ull))<<28ull);
        r ^= z;
        state[1] = z;
        z = state[2];
        z = (((z<<24ull)^z)>>48ull)^((z&(MAX_UINT64<<9ull))<<7ull);
        r ^= z;
        state[2] = z;
        z = state[3];
        z = (((z<<21ull)^z)>>39ull)^((z&(MAX_UINT64<<17ull))<<8ull);
        r ^= z;
        state[3] = z;
        return r;
    }
    uint64_t randdblmem() {        
        return (_randint() & 4503599627370495ull) | 4607182418800017408ull;
    }
    double random() {
        dbllong u;
        u.ulong = randdblmem();
        return u.dbl - 1.0;
    }
    int randint(int min, int max) {
        return (int)(random()*(max-min+1))+min;
    }
};

#define DBL_EXPO 0x7FF0000000000000
#define DBL_MANT 0x000FFFFFFFFFFFFF

#define DBL_EXPO_SZ 11
#define DBL_MANT_SZ 52

#define DBL_EXPO_BIAS 1023

#if defined(_MSC_VER)
    #include <intrin.h>
    #pragma intrinsic(_BitScanReverse64)
#endif

// Cross-platform clzll implementation by chatgpt
int portable_clzll(uint64_t x) {
    if (x == 0) return 64; // Undefined for 0, by convention we return 64

#if defined(__GNUC__) || defined(__clang__)
    return __builtin_clzll(x);
#elif defined(_MSC_VER)
    unsigned long index;
    if (_BitScanReverse64(&index, x)) {
        return 63 - index;
    }
    return 64;
#else
    // Fallback for other compilers (manual bit manipulation)
    int n = 0;
    if (x <= 0x00000000FFFFFFFF) { n += 32; x <<= 32; }
    if (x <= 0x0000FFFFFFFFFFFF) { n += 16; x <<= 16; }
    if (x <= 0x00FFFFFFFFFFFFFF) { n += 8;  x <<= 8;  }
    if (x <= 0x0FFFFFFFFFFFFFFF) { n += 4;  x <<= 4;  }
    if (x <= 0x3FFFFFFFFFFFFFFF) { n += 2;  x <<= 2;  }
    if (x <= 0x7FFFFFFFFFFFFFFF) { n += 1; }
    return n;
#endif
}


// Faster fract by __init__ (about 4x speed improvement over fmod)
double fract(double x) {
    uint64_t x_int = *(uint64_t *)&x;
    uint64_t expo = (x_int & DBL_EXPO) >> DBL_MANT_SZ;
    if ((expo < DBL_EXPO_BIAS) || std::isnan(x)) {
        return x;
    }
    uint64_t expo_biased = expo - DBL_EXPO_BIAS;
    if (expo_biased >= DBL_MANT_SZ) {
        return 0;
    }
    uint64_t mant = x_int & DBL_MANT;
    uint64_t frac_mant = mant & ((1ull << (DBL_MANT_SZ - expo_biased)) - 1);
    if (frac_mant == 0) {
        return 0;
    }
    uint64_t frac_lzcnt = portable_clzll(frac_mant) - (64 - DBL_MANT_SZ);
    uint64_t res_expo = (expo - frac_lzcnt - 1) << DBL_MANT_SZ;
    uint64_t res_mant = (frac_mant << (frac_lzcnt + 1)) & DBL_MANT;
    uint64_t res = res_expo | res_mant;
    return *(double *)&res;
}

double pseudohash(std::string s) {
    double num = 1;
    for (size_t i = s.length(); i > 0; i--) {
        num = fract(1.1239285023/num*s[i-1]*3.141592653589793116+3.141592653589793116*i);
    }
    if (std::isnan(num)) return std::numeric_limits<double>::quiet_NaN();
    return num;
};

std::string anteToString(int a) {
    if (a < 10) return {(char)(0x30 + a)};
    else return {(char)(0x30 + a/10), (char)(0x30 + a%10)};
}

// More accurate rounding by __init__
// This passes 100,000,000 test cases in ~2 seconds
const double inv_prec = std::pow(10.0, 13);
const double two_inv_prec = std::pow(2.0, 13);
const double five_inv_prec = std::pow(5.0, 13);

double round13(double x) {
    double normal_case = std::round(x * inv_prec) / inv_prec;
    if (normal_case == (std::round(std::nextafter(x, -1) * inv_prec) / inv_prec)) {
        return normal_case;
    }
    double truncated = fract(x * two_inv_prec) * five_inv_prec;
    if (fract(truncated) >= 0.5) {
        return (std::floor(x * inv_prec) + 1) / inv_prec;
    }
    return std::floor(x * inv_prec) / inv_prec;
}

// Search-related utility functions
const std::string seedChars = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const int numChars = 35;

void nextSeed(std::array<int, 9>& seed) {
    bool carry = true;
    while (carry) {
        for (int i = 0; i < seed[0]; i++) {
            int j = seed[0]-i;
            if (carry) {
                seed[j]++;
                if (carry = (seed[j]>=numChars)) {
                    seed[j] -= numChars;
                }
            } else break;
        }
        if (carry) {
            if (seed[0]<8) {
                for (int i = 8; i >= 1; i--) {
                    seed[i] = 0;
                }
                seed[0]++;
            } else {
                seed[0] = 0;
            }
            carry = false;
        }
    }
}

std::string seedToString(std::array<int, 9> seed) {
    std::string strSeed;
    for (int i = 1; i <= seed[0]; i++) {
        strSeed.append(1, seedChars[seed[i]]);
    }
    return strSeed;
}

std::array<int, 9> stringToSeed(std::string strSeed) {
    std::array<int, 9> seed;
    seed[0] = strSeed.size();
    for (int i = 1; i <= seed[0]; i++) {
        seed[i] = seedChars.find(strSeed[i-1]);
    }
    return seed;
}