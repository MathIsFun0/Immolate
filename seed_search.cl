#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void search() {
    char8 in_seed = (char8)('1','1','1','1','1','1','1','1');
    struct Seed seed = s_new(in_seed);
    if (get_global_id(0) != 0) {
        s_skip(&seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < 10000000000; i+=get_global_size(0)) {
        struct GameInstance inst = i_new(seed);
        if (i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20 && i_randint(&inst, Misprint, 0, 20) == 20) {
            s_print(&seed);
        }
        s_skip(&seed,get_global_size(0));
    }
}