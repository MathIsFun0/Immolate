#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void search() {
    struct LuaRandom state = randomseed(123);
    state = random(state);
    printf("GPU Output: <%.13lf>\n",state.out.d);
    state = random(state);
    printf("GPU Output: <%.13lf>\n",state.out.d);
    state = random(state);
    printf("GPU Output: <%.13lf>\n",state.out.d);
}