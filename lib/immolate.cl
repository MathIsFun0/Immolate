// Based on C++ program by 00001H and MathIsFun_
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#ifndef GAME_VERSION
    #define GAME_VERSION {0,9,3,14} //0.9.3n
#endif
#include "util.cl" // Contains utility functions
#include "seed.cl" // Contains seed/seed list info
#include "items.cl" // Contains item enums, lists, helper functions
#include "debug.cl" // Debug printing functions
#include "cache.cl" // Contains RNG Cache implementation
#include "instance.cl" // Contains random instance implementation and core functions
#include "functions.cl" // Contains utility functions for searching seeds - what the user would interact with