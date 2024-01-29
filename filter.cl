#include "immolate.cl"


// Poly Blueprint+Dusk as first 2 jokers
long filter(struct GameInstance* inst) {
    if (i_standard_enhancement(inst, 1) != Glass_Card) return 0;
    if (i_standard_edition(inst) != Polychrome) return 0;
    if (i_standard_seal(inst) != Red_Seal) return 0;
    return 1;
}
// Search
// Note that when embedding the files into the C code, this part will have to be included after filter.cl is loaded.

__global struct RankedSeedList rs;

__kernel void search(char8 starting_seed, long num_seeds, long filter_cutoff) {
    // Initialize global vars
    if (get_global_id(0) == 0) {
        rs_init(&rs, filter_cutoff);
    }
    barrier(CLK_GLOBAL_MEM_FENCE);

    struct Seed seed = s_new_c8(starting_seed);
    if (get_global_id(0) != 0) {
        s_skip(&seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        struct GameInstance inst = i_new(seed);
        rs_add(&rs, filter(&inst), seed);
        s_skip(&seed,get_global_size(0));
    }
}