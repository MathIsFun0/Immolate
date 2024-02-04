#include "immolate.cl"


// Red Poly Glass Hack-Compatible Cards
/*long filter(instance* inst) {
    int num_cards = 0;
    item pack1 = i_next_pack(inst);
    item pack2 = i_next_pack(inst);
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
        card _card = i_standard_card(inst, 1);
        if (_card.enhancement != Glass_Card) found = false;
        if (_card.edition != Polychrome) found = false;
        if (_card.seal != Red_Seal) found = false;
        if (c_rank(_card.base) > _5) found = false;
        if (found) return 1;
    }
    return 0;
}*/

// Emperor-Fool Chains
/*long filter(instance* inst) {
    int bestAnte = 0;
    long bestScore = 0;
    for (int ante = 1; ante <= 6; ante++) {
        long score = 0;
        while (true) {
            item tarot1 = i_next_tarot(inst, S_Emperor, ante);
            item tarot2 = i_next_tarot(inst, S_Emperor, ante);
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

// High Score Filter (Older Demo Version)
/*long filter(instance* inst) {
    // Spectral Pack Shop 1
    int num_cards = 0;
    int spectral_target = 0;
    int passed_filters = 0;
    bool is_mega = false;
    item p1 = i_next_pack(inst);
    item p2 = i_next_pack(inst);
    if (p1 >= Spectral_Pack && p1 <= Mega_Spectral_Pack) {
        spectral_target = 1;
        if (p1 == Spectral_Pack) {
            num_cards = 2;
        } else {
            num_cards = 4;
        }
        if (p1 == Mega_Spectral_Pack) is_mega = true;
    }
    if (p2 >= Spectral_Pack && p2 <= Mega_Spectral_Pack) {
        if (p2 == Spectral_Pack) {
            if (num_cards == 0) {
                spectral_target = 2;
                num_cards = 2;
            }
        } else {
            spectral_target = 2;
            num_cards = 4;
        }
        if (p2 == Mega_Spectral_Pack) is_mega = true;
    }
    if (num_cards == 0) return passed_filters;
    passed_filters++;

    // Ankh, optionally Wraith
    bool hasAnkh = false;
    bool hasWraith = false;
    for (int i = 0; i < num_cards; i++) {
        item spec = i_next_spectral(inst, S_Spectral, 1);
        if (spec == Wraith) hasWraith = true;
        if (spec == Ankh) hasAnkh = true;
    }
    if (!hasAnkh) return passed_filters;
    passed_filters++;

    // Invisible Joker, either from Buffoon Pack or Wraith
    bool hasInvis = false;
    // Wraith
    if (is_mega && hasWraith) {
        if (i_randchoice_simple(inst, R_Joker_Rare, S_Wraith, 1, RARE_JOKERS) == Invisible_Joker) hasInvis = true;
    }
    // Buffoon
    if (!hasInvis) {
        item pack = (spectral_target==1 ? p2 : p1);
        if (pack >= Buffoon_Pack && pack <= Mega_Buffoon_Pack) {
            if (pack == Buffoon_Pack) {
                num_cards = 2;
            } else {
                num_cards = 4;
            }
        } else return passed_filters;
        for (int i = 0; i < num_cards; i++) {
            if (i_next_joker(inst, S_Buffoon, 1) == Invisible_Joker) {
                hasInvis = true;
            }
        }
    }
    if (!hasInvis) return passed_filters;
    passed_filters++;

    // RPG card in queue
    int RP = 0;
    for (int c = 1; c <= 5; c++) {
        item edi = i_standard_edition(inst);
        item seal = i_standard_seal(inst);
        if (edi == Polychrome && seal == Red_Seal) {
            RP = c;
            break;
        }
    }
    if (RP == 0) return passed_filters;
    passed_filters++;

    // Negative Hack in the first 50 jokers
    // Burn two calls
    i_next_joker(inst, S_Shop, 2);
    i_next_joker(inst, S_Shop, 2);
    i_next_joker_edition(inst, S_Shop, 2);
    i_next_joker_edition(inst, S_Shop, 2);
    for (int i = 3; i <= 50; i++) {
        item jkr = i_next_joker(inst, S_Shop, 2);
        item edi = i_next_joker_edition(inst, S_Shop, 2);
        if (jkr == Hack && edi == Negative) return 999; // God Seed Found
    }
    return passed_filters;

}*/

// SPEEDRUN
/*long filter(instance* inst) {
    long passed_filters = 0;

    // Banner, Popcorn in ante 2
    item jkr1 = i_shop_joker(inst, 2);
    item jkr2 = i_shop_joker(inst, 2);
    if ((jkr1 == Banner && jkr2 == Popcorn) || (jkr1 == Popcorn && jkr2 == Banner)) passed_filters++;
    else return passed_filters;

    // Throwback, Flower Pot, Baseball Card in antes 3-5
    item jkrs[6] = {i_shop_joker(inst, 3),i_shop_joker(inst, 3),i_shop_joker(inst, 4),i_shop_joker(inst, 4),i_shop_joker(inst, 5),i_shop_joker(inst, 5)};
    bool hasThrowback = false;
    bool hasRamen = false;
    bool hasBaseball = false;
    for (int i = 0; i < 6; i++) {
        if (jkrs[i] == Throwback) hasThrowback = true;
        if (jkrs[i] == Ramen) hasRamen = true;
        if (jkrs[i] == Baseball_Card) hasBaseball = true;
    }
    if (hasBaseball && hasThrowback && hasRamen) passed_filters++;
    else return passed_filters;

    // Check for straight flush
    item deck[52];
    for (int i = 0; i < 52; i++) {
        deck[i] = DECK_ORDER[i];
    }
    i_shuffle_deck(inst, deck, 1);
    item hand[8] = {deck[44], deck[45], deck[46], deck[47], deck[48], deck[49], deck[50], deck[51]};
    bool isStrush = false;
    for (int i = 0; i < 8; i++) {
        item rank = c_rank(hand[i]);
        if (rank == Jack || rank == Queen || rank == King) continue; // can't start from there
        item target_rank = c_rank(hand[i]);
        for (int x = 1; x < 5; x++) {
            target_rank = c_next_rank(target_rank);
            item target_card = c_from_rank_suit(target_rank, c_suit(hand[i]));
            isStrush = false;
            for (int j = 0; j < 8; j++) {
                if (hand[j] == target_card) {
                    isStrush = true;
                }
            }
            if (!isStrush) break;
        }
        if (isStrush) break;
    }
    if (isStrush) return 999;
    return passed_filters;
}*/

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