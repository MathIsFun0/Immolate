#ifndef UTIL_HPP
#define UTIL_HPP

#include <cmath>
#include <cstdint>
#include <string>
#include "tracy/Tracy.hpp"

const uint64_t MAX_UINT64 = 18446744073709551615ull;

typedef union DoubleLong {
  double dbl;
  uint64_t ulong;
} dbllong;

struct LuaRandom {
  uint64_t state[4];
  LuaRandom(double seed);
  LuaRandom();
  uint64_t _randint();
  uint64_t randdblmem();
  double random();
  int randint(int min, int max);
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

int portable_clzll(uint64_t x);
double fract(double x);
double pseudohash(std::string s);
double pseudohash_from(std::string s, double num);
double pseudostep(char s, int pos, double num);
std::string anteToString(int a);
double round13(double x);

#endif // UTIL_HPP