#include "immolate.cl"


// Red Poly Glass Hack-Compatible Cards
long filter(struct GameInstance* inst) {
    int num_cards = 0;
    enum Item pack1 = i_next_pack(inst);
    enum Item pack2 = i_next_pack(inst);
    if (pack1 >= Standard_Pack && pack1 <= Mega_Standard_Pack) {
        if (pack1 == Standard_Pack) {
            num_cards = 3;
        } else {
            num_cards = 5;
        }
    }
    if (pack2 >= Standard_Pack && pack2 <= Mega_Standard_Pack) {
        if (pack2 == Standard_Pack && num_cards < 3) {
            num_cards = 3;
        } else {
            num_cards = 5;
        }
    }
    if (num_cards == 0) return 0;
    bool found = false;
    for (int i = 0; i < num_cards; i++) {
        found = true;
        struct Card card = i_standard_card(inst, 1);
        if (card.enhancement != Glass_Card) found = false;
        if (card.edition != Polychrome) found = false;
        if (card.seal != Red_Seal) found = false;
        if (c_rank(card.base) > _5) found = false;
        if (found) return 1;
    }
    return 0;
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