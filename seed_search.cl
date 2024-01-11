#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void search() {
    char8 in_seed = (char8)('1','2','3','4','5','6','7','8');
    struct Seed seed = s_new(in_seed);
    s_skip(&seed, 35);
    in_seed = s_to_string(&seed);
    struct RankedSeedList rsl = rs_new(1);
    rs_add(&rsl, 1, seed);
    printf("GPU Output: <");
    printf("%#v8hhx>\n",s_to_string(&(rsl.seeds[0])));
}