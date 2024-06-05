__kernel void search(char8 starting_seed, long num_seeds, __global long* filter_cutoff) {
    seed _seed = s_new_c8(starting_seed);
    s_skip(&_seed, get_global_id(0));
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        instance inst = i_new(_seed);
        long score = filter(&inst);
        if (score >= filter_cutoff[0]) {
            text s_str = s_to_string(&_seed);
            printf("%s (%li)\n", s_str.str, score);
            if (score > filter_cutoff[0]) {
                #ifndef FIXED_FILTER_CUTOFF
                    filter_cutoff[0] = score;
                    barrier(CLK_GLOBAL_MEM_FENCE);
                #endif
            }
        }
        s_skip(&_seed,get_global_size(0));
    }
}