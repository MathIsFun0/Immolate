#include "immolate.cl"


/*// Poly Blueprint+Dusk as first 2 jokers
long filter(struct GameInstance* inst) {
    enum Item jkr1 = i_random_joker(inst);
    enum Item jkr2 = i_random_joker(inst);
    if (!((jkr1 == Blueprint && jkr2 == Dusk) || (jkr1 == Dusk && jkr2 == Blueprint))) {
        return 0;
    }
    if (i_random_edition(inst) == Polychrome && i_random_edition(inst) == Polychrome) {
        return 1;
    }
    return 0;
}*/
// Search
// Note that when embedding the files into the C code, this part will have to be included after filter.cl is loaded.

__global struct RankedSeedList rs;

__kernel void search(char8 starting_seed, long num_seeds, long filter_cutoff) {
    /*// Initialize global vars
    if (get_global_id(0) == 0) {
        rs_init(&rs, filter_cutoff);
    }
    barrier(CLK_GLOBAL_MEM_FENCE);

    struct Seed seed = s_new(starting_seed);
    if (get_global_id(0) != 0) {
        s_skip(&seed, get_global_id(0));
    }
    for (long i = get_global_id(0); i < num_seeds; i+=get_global_size(0)) {
        struct GameInstance inst = i_new(seed);
        rs_add(&rs, filter(&inst), seed);
        s_skip(&seed,get_global_size(0));
    }*/
    
    // Testing code
    if (get_global_id(0) == 0) {
        struct Text str1 = init_text("IMMOLATE", 8);
        struct Text str2 = init_text("BALATRO", 7);
        text_concat(&str1, &str2);
        for (int i = 0; i < 15; i++) {
            printf("%c",str1.str[i]);
        }
    }
}