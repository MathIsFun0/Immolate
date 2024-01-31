#include "immolate.cl"


// Red Poly Glass Hack-Compatible Cards
/*long filter(struct GameInstance* inst) {
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
}*/

// Emperor-Fool Chains
/*long filter(struct GameInstance* inst) {
    int bestAnte = 0;
    long bestScore = 0;
    for (int ante = 1; ante <= 6; ante++) {
        long score = 0;
        while (true) {
            enum Item tarot1 = i_next_tarot(inst, S_Emperor, ante);
            enum Item tarot2 = i_next_tarot(inst, S_Emperor, ante);
            if (tarot1 == The_Fool || tarot2 == The_Fool) score++;
            else break;
        }
        if (score >= bestScore) {
            bestAnte = ante;
            bestScore = score;
        }
    }
    return bestScore*10+bestAnte;
}*/

long filter(struct GameInstance* inst) {
    // Buffoon Pack
    enum Item pack1 = i_next_pack(inst);
    enum Item pack2 = i_next_pack(inst);
    if (pack1 != Mega_Buffoon_Pack && pack2 != Mega_Buffoon_Pack) return 0;

    // Diet Cola and Invisible Joker
    bool foundCola = false;
    bool foundInvis = false;
    for (int i = 0; i < 4; i++) {
        enum Item jkr = i_next_joker(inst, S_Buffoon, 1);
        if (jkr == Diet_Cola) foundCola = true;
        if (jkr == Invisible_Joker) foundInvis = true;
    }
    if (foundCola && foundInvis) return 1;
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