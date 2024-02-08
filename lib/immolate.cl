// Based on C++ program by 00001H and MathIsFun_
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#include "util.cl" // Contains utility functions
#include "seed.cl" // Contains seed/seed list info
#include "items.cl" // Contains item enums, lists, helper functions
#include "cache.cl" // Contains RNG Cache implementation
#include "instance.cl" // Contains random instance implementation and core functions
#include "functions.cl" // Contains utility functions for searching seeds - what the user would interact with