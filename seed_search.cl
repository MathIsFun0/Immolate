#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void search() {
    char8 in_seed = (char8)('1','1','1','1','1','1','1','1');
    struct Seed seed = s_new(in_seed);
    if (get_global_id(0) != 0) {
        s_skip(&seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < 1000000000000; i+=get_global_size(0)) {
        struct GameInstance inst = i_new(seed);
        bool good = true;
        for (int i = 0; i < 8; i++) {
            i_random(&inst, Lucky);
            if (i_random(&inst, Lucky) >= 1.0/25) {
                good = false;
                break;
            }
        }
        if (good) {
            s_print(&seed);
        }
        s_skip(&seed,get_global_size(0));
    }
}