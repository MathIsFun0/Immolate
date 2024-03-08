// Based on C++ program by 00001H and MathIsFun_
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#ifndef GAME_VERSION
    #define VER1 1
    #define VER2 0
    #define VER3 0
    #define VER4 14 //1.0.0n
    #define GAME_VERSION
#endif
#include "./lib/util.cl" // Contains utility functions
#include "./lib/seed.cl" // Contains seed/seed list info
#include "./lib/items.cl" // Contains item enums, lists, helper functions
#include "./lib/debug.cl" // Debug printing functions
#include "./lib/cache.cl" // Contains RNG Cache implementation
#include "./lib/instance.cl" // Contains random instance implementation and core functions
#include "functions.cl" // Contains utility functions for searching seeds - what the user would interact with