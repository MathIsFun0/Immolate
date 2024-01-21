#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable


__global struct RankedSeedList rs;

__kernel void search(char8 starting_seed, long num_seeds) {
    // Initialize global vars
    if (get_global_id(0) == 0) {
        rs_init(&rs, 1);
    }
    barrier(CLK_GLOBAL_MEM_FENCE);

    struct Seed seed = s_new(starting_seed);
    if (get_global_id(0) != 0) {
        s_skip(&seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        struct GameInstance inst = i_new(seed);
        long score = 0;
        i_random(&inst, Lucky);
        while (i_random(&inst, Lucky) < 1.0/25) {
            score++;
            i_random(&inst, Lucky);
        }
        rs_add(&rs, score, seed);
        s_skip(&seed,get_global_size(0));
    }
}