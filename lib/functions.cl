

void shuffle_deck(instance* inst, item deck[], int ante) {
    inst->rng = randomseed(get_node_child(inst, (ntype[]){N_Type, N_Ante}, (int[]){R_Shuffle_New_Round, ante}, 2));
    for (int i = 51; i >= 1; i--) {
        int x = l_randint(&(inst->rng), 0, i);
        item temp = deck[i];
        deck[i] = deck[x];
        deck[x] = temp;
    }
}

// Helper functions for common actions
int misprint(instance* inst) {
    return (int)randint(inst, (ntype[]){N_Type}, (int[]){R_Misprint}, 1, 0, 20);
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
item standard_edition(instance* inst) {
    double val = random_simple(inst, R_Standard_Edition);
    if (val > 0.988) return Polychrome;
    if (val > 0.96) return Holographic;
    if (val > 0.92) return Foil;
    return No_Edition;
}
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
    out.edition = standard_edition(inst);
    out.seal = standard_seal(inst);
    return out;
}

item next_pack(instance* inst) {
    return randweightedchoice(inst, (ntype[]){N_Type}, (int[]){R_Shop_Pack}, 1, PACKS);
}

// These functions can probably be used to encompass a lot of packs
item next_tarot(instance* inst, rsrc src, int ante) {
    // Note: assumes no redraws
    return randchoice_common(inst, R_Tarot, src, ante, TAROTS);
}

item next_spectral(instance* inst, rsrc src, int ante) {
    return randchoice_common(inst, R_Spectral, src, ante, SPECTRALS);
}

item next_tarot_resample(instance* inst, rsrc src, int ante, int iter) {
    return randchoice(inst, (ntype[]){N_Type, N_Source, N_Ante, N_Resample}, (int[]){R_Tarot, src, ante, iter}, 4, TAROTS);
}

item next_joker(instance* inst, rsrc src, int ante) {
    double rarity = random(inst, (ntype[]){N_Type, N_Ante, N_Source}, (int[]){R_Joker_Rarity, ante, src}, 3);
    if (rarity > 0.95) return randchoice_common(inst, R_Joker_Rare, src, ante, RARE_JOKERS);
    if (rarity > 0.7) return randchoice_common(inst, R_Joker_Uncommon, src, ante, UNCOMMON_JOKERS);
    return randchoice_common(inst, R_Joker_Common, src, ante, COMMON_JOKERS);
}

item next_joker_edition(instance* inst, rsrc src, int ante) {
    double poll = random(inst, (ntype[]){N_Type, N_Source, N_Ante}, (int[]){R_Joker_Edition, src, ante}, 3);
    if (poll > 0.997) return Negative;
    if (poll > 0.994) return Polychrome;
    if (poll > 0.98) return Holographic;
    if (poll > 0.96) return Foil;
    return No_Edition;
}

// Accounts for shop not giving jokers sometimes
item shop_joker(instance* inst, int ante) {
    double card_type = random(inst, (ntype[]){N_Type, N_Ante}, (int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type <= 20) return next_joker(inst, S_Shop, ante);
    return RETRY;
}
item shop_tarot(instance* inst, int ante) {
    double card_type = random(inst, (ntype[]){N_Type, N_Ante}, (int[]){R_Card_Type, ante}, 2) * 28;
    if (card_type > 20 && card_type <= 24) return next_tarot(inst, S_Shop, ante);
    return RETRY;
}

item next_tag(instance* inst, int ante) {
    if (ante == 1) {
        item _item = randchoice_common(inst, R_Tags, S_Null, ante, TAGS);
        int r = 1;
        item banlist[] = {Negative_Tag, Standard_Tag, Meteor_Tag, Buffoon_Tag, Ethereal_Tag, Top_up_Tag, Orbital_Tag, Handy_Tag, Garbage_Tag};
        for (int i = 0; i < 9; i++) {
            if (banlist[i] == _item) {
                _item = randchoice(inst, (ntype[]){N_Type, N_Source, N_Ante, N_Resample}, (int[]){R_Tags, S_Null, ante, r}, 4, TAGS);
                r++;
                i = 0;
            }
        }
        return _item;
    } else {
        return randchoice_common(inst, R_Tags, S_Null, ante, TAGS);
    }
}

// Don't use this right now, it's relatively slow for some reason. Still figuring out resampling...
void tarot_pack(item out[], instance* inst, rsrc src, int ante, int size) {
    for (int n = 0; n < size; n++) {
        item tarot = next_tarot(inst, src, ante);
        int resampleID = 1;
        for (int i = 0; i < n; i++) {
            if (out[i] == tarot) {
                tarot = next_tarot_resample(inst, src, ante, resampleID);
                resampleID++;
                i = -1;
            }
        }
        out[n] = tarot;
    }
}