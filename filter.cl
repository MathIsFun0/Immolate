#include "immolate.cl"
#include "examples/red_poly_glass.cl"

// Search
// Note that when embedding the files into the C code, this part will have to be included after filter.cl is loaded.

__global rslist rs;

__kernel void search(char8 starting_seed, long num_seeds, long filter_cutoff) {
    // Initialize global vars
    if (get_global_id(0) == 0) {
        rs_init(&rs, filter_cutoff);
    }
    barrier(CLK_GLOBAL_MEM_FENCE);

    seed _seed = s_new_c8(starting_seed);
    if (get_global_id(0) != 0) {
        s_skip(&_seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        instance inst = i_new(_seed);
        rs_add(&rs, filter(&inst), _seed);
        s_skip(&_seed,get_global_size(0));
    }
}

// Filter for fixing shuffler
/*long filter(instance* inst) {
    int start_id = 1;
    // Code for fixing shuffler
    item deck[52];
    for (int i = 1; i <= 52; i++) {
        deck[i-1] = i;
    }
    i_shuffle_deck(inst, deck, 1);
    if (deck[43] == start_id && deck[42] == start_id+1 && deck[41] == start_id+2 && deck[40] == start_id+3 && deck[39] == start_id+4) {
        return 1;
    }
    return 0;
}*/