// Contains the RNG algorithms that Balatro uses.
#include <string.h>
#include <math.h>

/*
Pseudohash implementation
*/

// ChatGPT implementation
void resizeString(char **str, size_t newSize, char fillChar) {
    size_t currentSize = strlen(*str);
    
    if (newSize < currentSize) {
        (*str)[newSize] = '\0'; // Truncate the string
    } else if (newSize > currentSize) {
        *str = realloc(*str, newSize + 1); // Allocate memory for the new size
        if (*str == NULL) {
            // Handle allocation failure
            printf("Memory allocation failed\n");
            exit(EXIT_FAILURE);
        }
        memset(*str + currentSize, fillChar, newSize - currentSize); // Fill the added space with the specified character
        (*str)[newSize] = '\0'; // Null-terminate the string
    }
}

// Credits to 00001H for porting these algorithms to C++, which was the basis of my C and OpenCL ports
unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
long double fract(long double f) {
    return f-floor(f);
}
long double roundDigits(long double f, int d) {
    long double power = pow((float)10, d);
    return round(f*power)/power;
}

long double pseudohash(char* s) {
    resizeString(&s, 16, ' ');
    int mask = 0;
    for (int i = 15; i >= 0; i--) {
        mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
    }
    return roundDigits(fract(sqrt(fabs((long double)mask))),13);
}

// Other implementations:

/* Lua
function pseudohash(arg_175_0)
	arg_175_0 = string.sub(string.format("%-16s", arg_175_0), 1, 16)

	local var_175_0 = 0

	for iter_175_0 = #arg_175_0, 1, -1 do
		var_175_0 = bit.bxor(var_175_0, bit.lshift(var_175_0, 7) + bit.rshift(var_175_0, 3) + string.byte(arg_175_0, iter_175_0))
	end

	return tonumber(string.format("%.13f", math.sqrt(math.abs(var_175_0)) % 1))
end

Baseed
fl balahash(str s){
    s.resize(16uz,u8' ');
    bsn mask{0_bs};
    for(auto it=s.crbegin();it!=s.crend();++it){
        mask = b32_xor(mask,b32_lsh(mask,7uz)+b32_rsh(mask,3uz)+static_cast<sn>(*it));
    }
    return round_to_digits(fract(std::sqrt(static_cast<fl>(std::abs(mask)))),13_i);
}
*/

/*
Lua math.random implementation
*/

union DoubleLong {
    double d;
    unsigned long long ul;
};

static unsigned long long dbl2u64(double dbl) {
    union DoubleLong caster;
    caster.d = dbl;
    return caster.ul;
}

static double u642dbl(unsigned long long u64) {
    union DoubleLong caster;
    caster.ul = u64;
    return caster.d;
}

unsigned long long _randint(unsigned long long state[]) {
    unsigned long long z, r = 0;
    z = state[0];
    z = (((z<<31)^z)>>45)^((z&((unsigned long long)(long long)-1<<1))<<18);
    r ^= z;
    state[0] = z;
    z = state[1];
    z = (((z<<19)^z)>>30)^((z&((unsigned long long)(long long)-1<<6))<<28);
    r ^= z;
    state[1] = z;
    z = state[2];
    z = (((z<<24)^z)>>48)^((z&((unsigned long long)(long long)-1<<9))<<7);
    r ^= z;
    state[2] = z;
    z = state[3];
    z = (((z<<21)^z)>>39)^((z&((unsigned long long)(long long)-1<<17))<<8);
    r ^= z;
    state[3] = z;
    return r;
}

unsigned long long randdblmem(unsigned long long state[]) {
    return (_randint(state)&4503599627370495)|4607182418800017408;
}

void randomseed(unsigned long long state[], double d) {
    unsigned int r = 0x11090601;
    size_t i;
    for (i = 0; i < 4; i++) {
        unsigned long long u;
        unsigned int m = 1 << (r&255);
        r >>= 8;
        d = d*3.14159265358979323846+2.7182818284590452354;
        u = dbl2u64(d);
        if (u<m) u+=m;
        state[i] = u;
    }
    for (i = 0; i < 10; i++) {
        _randint(state);
    }
}
double random(unsigned long long state[]) {
    return u642dbl(randdblmem(state))-1.0;
}