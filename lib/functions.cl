void shuffle_deck(instance* inst, item deck[], int ante) {
    inst->rng = randomseed(get_node_child(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Shuffle_New_Round, ante}, 2));
    for (int i = 51; i >= 1; i--) {
        int x = l_randint(&(inst->rng), 0, i);
        item temp = deck[i];
        deck[i] = deck[x];
        deck[x] = temp;
    }
}

typedef struct Card {
    item base;
    item enhancement;
    item edition;
    item seal;
} card;

item standard_enhancement(instance* inst, int ante) {
    if (random_simple(inst, R_Standard_Has_Enhancement) <= 0.6) return No_Enhancement;
    return randchoice_common(inst, R_Enhancement, S_Standard, ante, ENHANCEMENTS);
}
item standard_base(instance* inst, int ante) {
    return randchoice_common(inst, R_Card, S_Standard, ante, CARDS);
}
#if V_AT_MOST(0,9,3,14)
item standard_edition(instance* inst) {
    double val = random_simple(inst, R_Standard_Edition);
    if (val > 0.988) return Polychrome;
    if (val > 0.96) return Holographic;
    if (val > 0.92) return Foil;
    return No_Edition;
}
#else
item standard_edition(instance* inst, int ante) {
    double val = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Standard_Edition, ante}, 2);
    if (val > 0.988) return Polychrome;
    if (val > 0.96) return Holographic;
    if (val > 0.92) return Foil;
    return No_Edition;
}
#endif
item standard_seal(instance* inst) {
    if (random_simple(inst, R_Standard_Has_Seal) <= 0.8) return No_Seal;
    double val = random_simple(inst, R_Standard_Seal);
    if (val > 0.75) return Red_Seal;
    if (val > 0.5) return Blue_Seal;
    if (val > 0.25) return Gold_Seal;
    return Purple_Seal;
}
card standard_card(instance* inst, int ante) {
    card out;
    out.enhancement = standard_enhancement(inst, ante);
    out.base = standard_base(inst, ante);
    #if V_AT_MOST(0,9,3,14)
    out.edition = standard_edition(inst);
    #else
    out.edition = standard_edition(inst, ante);
    #endif
    out.seal = standard_seal(inst);
    return out;
}

#if V_AT_MOST(0,9,3,12)
item next_pack(instance* inst) {
    return randweightedchoice(inst, (__private ntype[]){N_Type}, (__private int[]){R_Shop_Pack}, 1, PACKS);
}
#else
// Becomes ante-based in 0.9.3n
item next_pack(instance* inst, int ante) {
    return randweightedchoice(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Shop_Pack, ante}, 2, PACKS);
}
#endif

#ifdef DEMO
item next_tarot(instance* inst, rsrc src, int ante) {
    return randchoice_common(inst, R_Tarot, src, ante, TAROTS);
}
item next_planet(instance* inst, rsrc src, int ante) {
    return randchoice_common(inst, R_Planet, src, ante, PLANETS);
}
item next_spectral(instance* inst, rsrc src, int ante) {
    return randchoice_common(inst, R_Spectral, src, ante, SPECTRALS);
}
#else
item next_tarot(instance* inst, rsrc src, int ante, bool soulable) {
    if (soulable && !inst->locked[The_Soul] && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Tarot}, 2) > 0.997) {
        return The_Soul;
    }
    return randchoice_common(inst, R_Tarot, src, ante, TAROTS);
}
item next_planet(instance* inst, rsrc src, int ante, bool soulable) {
    if (soulable && !inst->locked[Black_Hole] && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Planet}, 2) > 0.997) {
        return Black_Hole;
    }
    return randchoice_common(inst, R_Planet, src, ante, PLANETS);
}
item next_spectral(instance* inst, rsrc src, int ante, bool soulable) {
    if (soulable) {
        item forcedKey = RETRY;
        if (!inst->locked[The_Soul] && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Spectral}, 2) > 0.997) {
            forcedKey = The_Soul;
        }
        if (!inst->locked[Black_Hole] && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Spectral}, 2) > 0.997) {
            forcedKey = Black_Hole;
        }
        if (forcedKey != RETRY) return forcedKey;
    }
    return randchoice_common(inst, R_Spectral, src, ante, SPECTRALS);
}
#endif

item next_joker(instance* inst, rsrc src, int ante) {
    if (src == S_Soul) return randchoice_common(inst, R_Joker_Legendary, src, ante, LEGENDARY_JOKERS);
    double rarity = random(inst, (__private ntype[]){N_Type, N_Ante, N_Source}, (__private int[]){R_Joker_Rarity, ante, src}, 3);
    if (rarity > 0.95) return randchoice_common(inst, R_Joker_Rare, src, ante, RARE_JOKERS);
    if (rarity > 0.7) return randchoice_common(inst, R_Joker_Uncommon, src, ante, UNCOMMON_JOKERS);
    return randchoice_common(inst, R_Joker_Common, src, ante, COMMON_JOKERS);
}

item next_joker_edition(instance* inst, rsrc src, int ante) {
    double poll = random(inst, (__private ntype[]){N_Type, N_Source, N_Ante}, (__private int[]){R_Joker_Edition, src, ante}, 3);
    if (poll > 0.997) return Negative;
    if (poll > 0.994) return Polychrome;
    if (poll > 0.98) return Holographic;
    if (poll > 0.96) return Foil;
    return No_Edition;
}

// Accounts for shop not giving jokers sometimes
#ifdef DEMO
item shop_joker(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type <= 20) return next_joker(inst, S_Shop, ante);
    return RETRY;
}
item shop_tarot(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type > 20 && card_type <= 24) return next_tarot(inst, S_Shop, ante);
    return RETRY;
}
item shop_planet(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type > 24) return next_tarot(inst, S_Shop, ante);
    return RETRY;
}
#else
//Todo: Update for vouchers, add a general one for any type of card
item shop_joker(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type <= 20) return next_joker(inst, S_Shop, ante);
    return RETRY;
}
item shop_tarot(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type > 20 && card_type <= 24) return next_tarot(inst, S_Shop, ante, false);
    return RETRY;
}
item shop_planet(instance* inst, int ante) {
    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type > 24) return next_planet(inst, S_Shop, ante, false);
    return RETRY;
}
#endif

item next_tag(instance* inst, int ante) {
    return randchoice_common(inst, R_Tags, S_Null, ante, TAGS);
}

//Todo: account for Black Hole and Soul spawn mechanics
//Checked separately for each card spawned, both can appear in spectrals
#ifdef DEMO
void arcana_pack(item out[], int size, instance* inst, int ante) {
    randlist(out, size, inst, R_Tarot, S_Arcana, ante, TAROTS);
}
void celestial_pack(item out[], int size, instance* inst, int ante) {
    randlist(out, size, inst, R_Planet, S_Celestial, ante, PLANETS);
}
void spectral_pack(item out[], int size, instance* inst, int ante) {
    randlist(out, size, inst, R_Spectral, S_Spectral, ante, SPECTRALS);
}
#else
void arcana_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_tarot(inst, S_Arcana, ante, true);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
void celestial_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_planet(inst, S_Celestial, ante, true);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
void spectral_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_spectral(inst, S_Spectral, ante, true);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
#endif
void buffoon_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_joker(inst, S_Buffoon, ante);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}

void buffoon_pack_editions(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_joker_edition(inst, S_Buffoon, ante);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}

// More specific RNG types

int misprint(instance* inst) {
    return (int)randint(inst, (__private ntype[]){N_Type}, (__private int[]){R_Misprint}, 1, 0, 20);
}
bool lucky_mult(instance* inst) {
    return random_simple(inst, R_Lucky_Mult) < 1.0/5;
}
bool lucky_money(instance* inst) {
    return random_simple(inst, R_Lucky_Money) < 1.0/15;
}
item sigil_suit(instance* inst) {
    return randchoice_simple(inst, R_Sigil, SUITS);
}
item ouija_rank(instance* inst) {
    return randchoice_simple(inst, R_Ouija, RANKS);
}
#if V_AT_MOST(0,9,3,12)
item wheel_of_fortune_edition(instance* inst) {
    if (random_simple(inst, R_Wheel_of_Fortune) < 1.0/5) {
        random_simple(inst, R_Wheel_of_Fortune); //Burn function call
        double poll = random_simple(inst, R_Wheel_of_Fortune);
        if (poll > 0.85) return Polychrome;
        if (poll > 0.5) return Holographic;
        return Foil;
    } else return No_Edition;
}
#else
//Wheel of Fortune buffed in 0.9.3n
item wheel_of_fortune_edition(instance* inst) {
    if (random_simple(inst, R_Wheel_of_Fortune) < 1.0/4) {
        random_simple(inst, R_Wheel_of_Fortune); //Burn function call
        double poll = random_simple(inst, R_Wheel_of_Fortune);
        if (poll > 0.85) return Polychrome;
        if (poll > 0.5) return Holographic;
        return Foil;
    } else return No_Edition;
}
#endif
bool gros_michel_extinct(instance* inst) {
    return random_simple(inst, R_Gros_Michel) < 1.0/15;
}
#ifdef DEMO
item next_voucher(instance* inst, int ante) {
    item i = randchoice(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Voucher, ante}, 2, VOUCHERS);
    if (inst->locked[i]) {
        int resampleNum = 1;
        while (inst->locked[i]) {
            i = randchoice(inst, (__private ntype[]){N_Type, N_Ante, N_Resample}, (__private int[]){R_Voucher, ante, resampleNum}, 3, VOUCHERS);
            resampleNum++;
        }
    }
    return i;
}
item next_voucher_from_tag(instance* inst, int ante) {
    item i = randchoice_simple(inst, R_Voucher_Tag, VOUCHERS);
    if (inst->locked[i]) {
        int resampleNum = 1;
        while (inst->locked[i]) {
            i = randchoice(inst, (__private ntype[]){N_Type, N_Resample}, (__private int[]){R_Voucher_Tag, resampleNum}, 2, VOUCHERS);
            resampleNum++;
        }
    }
    return i;
}
#endif