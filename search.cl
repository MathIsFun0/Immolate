#include "./filters/double_legendary.cl"

// Search
__kernel void search(char8 starting_seed, long num_seeds, long filter_cutoff) {
    seed _seed = s_new_c8(starting_seed);
    if (get_global_id(0) != 0) {
        s_skip(&_seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        instance inst = i_new(_seed);
        long score = filter(&inst);
        if (score > filter_cutoff) filter_cutoff = score;
        // Known issue: filter_cutoff is not updating globally
        if (score == filter_cutoff) {
            text s_str = s_to_string(&_seed);
            printf("%c%c%c%c%c%c%c%c (%li)\n",s_str.str[0],s_str.str[1],s_str.str[2],s_str.str[3],s_str.str[4],s_str.str[5],s_str.str[6],s_str.str[7],score);
        }
        s_skip(&_seed,get_global_size(0));
    }
}