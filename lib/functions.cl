typedef struct Card {
    item base;
    item enhancement;
    item edition;
    item seal;
} card;

bool is_voucher_active(instance* inst, item voucher) {
    return inst->params.vouchers[voucher - (V_BEGIN + 1)];
}

void activate_voucher(instance* inst, item voucher) {
    int voucherIndex = voucher - (V_BEGIN + 1);
    inst->params.vouchers[voucherIndex] = true;
    inst->locked[voucher] = true;

    // Upgraded version requires base voucher activated.
    if (voucherIndex % 2 == 1) {
        inst->params.vouchers[voucherIndex - 1] = true;
    } else {
        inst->locked[voucher + 1] = false;
    }
}

#if V_AT_MOST(1,0,0,10)
item standard_enhancement(instance* inst, int ante) {
    if (random_simple(inst, R_Standard_Has_Enhancement) <= 0.6) return No_Enhancement;
    return randchoice_common(inst, R_Enhancement, S_Standard, ante, ENHANCEMENTS);
}
#else
item standard_enhancement(instance* inst, int ante) {
    if (random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Standard_Has_Enhancement, ante}, 2) <= 0.6) return No_Enhancement;
    return randchoice_common(inst, R_Enhancement, S_Standard, ante, ENHANCEMENTS);
}
#endif
item standard_base(instance* inst, int ante) {
    return randchoice_common(inst, R_Card, S_Standard, ante, CARDS);
}
#if V_AT_MOST(0,9,3,14)
item standard_edition(instance* inst, int ante) {
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
#if V_AT_MOST(1,0,0,10)
item standard_seal(instance* inst, ante) {
    if (random_simple(inst, R_Standard_Has_Seal) <= 0.8) return No_Seal;
    double val = random_simple(inst, R_Standard_Seal);
    if (val > 0.75) return Red_Seal;
    if (val > 0.5) return Blue_Seal;
    if (val > 0.25) return Gold_Seal;
    return Purple_Seal;
}
#else
item standard_seal(instance* inst, int ante) {
    if (random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Standard_Has_Seal, ante}, 2) <= 0.8) return No_Seal;
    double val = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Standard_Seal, ante}, 2);
    if (val > 0.75) return Red_Seal;
    if (val > 0.5) return Blue_Seal;
    if (val > 0.25) return Gold_Seal;
    return Purple_Seal;
}
#endif
card standard_card(instance* inst, int ante) {
    card out;
    out.enhancement = standard_enhancement(inst, ante);
    out.base = standard_base(inst, ante);
    out.edition = standard_edition(inst, ante);
    out.seal = standard_seal(inst, ante);
    return out;
}

#ifdef DEMO
    #if V_AT_MOST(0,9,3,12)
    item next_pack(instance* inst, int ante) {
        return randweightedchoice(inst, (__private ntype[]){N_Type}, (__private int[]){R_Shop_Pack}, 1, PACKS);
    }
    #else
    // Becomes ante-based in 0.9.3n
    item next_pack(instance* inst, int ante) {
        return randweightedchoice(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Shop_Pack, ante}, 2, PACKS);
    }
    #endif
#else
    #if V_AT_MOST(1,0,0,2)
    // Not ante-based in first console release (1.0.0b)
    item next_pack(instance* inst, int ante) {
        return randweightedchoice(inst, (__private ntype[]){N_Type}, (__private int[]){R_Shop_Pack}, 1, PACKS);
    }
    #else
    item next_pack(instance* inst, int ante) {
        return randweightedchoice(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Shop_Pack, ante}, 2, PACKS);
    }
    #endif
#endif
#ifdef DEMO
item next_tarot(instance* inst, rsrc itemSource, int ante, bool soulable) {
    return randchoice_common(inst, R_Tarot, itemSource, ante, TAROTS);
}
item next_planet(instance* inst, rsrc itemSource, int ante, bool soulable) {
    return randchoice_common(inst, R_Planet, itemSource, ante, PLANETS);
}
item next_spectral(instance* inst, rsrc itemSource, int ante, bool soulable) {
    return randchoice_common(inst, R_Spectral, itemSource, ante, SPECTRALS);
}
#elif V_AT_MOST(1,0,0,10)
item next_tarot(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable && (inst->params.showman || !inst->locked[The_Soul]) && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Tarot}, 2) > 0.997) {
        return The_Soul;
    }
    return randchoice_common(inst, R_Tarot, itemSource, ante, TAROTS);
}
item next_planet(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable && (inst->params.showman || !inst->locked[Black_Hole]) && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Planet}, 2) > 0.997) {
        return Black_Hole;
    }
    return randchoice_common(inst, R_Planet, itemSource, ante, PLANETS);
}
item next_spectral(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable) {
        item forcedKey = RETRY;
        if ((inst->params.showman || !inst->locked[The_Soul]) && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Spectral}, 2) > 0.997) {
            forcedKey = The_Soul;
        }
        if ((inst->params.showman || !inst->locked[Black_Hole]) && random(inst, (__private ntype[]){N_Type, N_Type}, (__private int[]){R_Soul, R_Spectral}, 2) > 0.997) {
            forcedKey = Black_Hole;
        }
        if (forcedKey != RETRY) return forcedKey;
    }
    return randchoice_common(inst, R_Spectral, itemSource, ante, SPECTRALS);
}
#else
item next_tarot(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable && (inst->params.showman || !inst->locked[The_Soul]) && random(inst, (__private ntype[]){N_Type, N_Type, N_Ante}, (__private int[]){R_Soul, R_Tarot, ante}, 3) > 0.997) {
        return The_Soul;
    }
    return randchoice_common(inst, R_Tarot, itemSource, ante, TAROTS);
}
item next_planet(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable && (inst->params.showman || !inst->locked[Black_Hole]) && random(inst, (__private ntype[]){N_Type, N_Type, N_Ante}, (__private int[]){R_Soul, R_Planet, ante}, 3) > 0.997) {
        return Black_Hole;
    }
    return randchoice_common(inst, R_Planet, itemSource, ante, PLANETS);
}
item next_spectral(instance* inst, rsrc itemSource, int ante, bool soulable) {
    if (soulable) {
        item forcedKey = RETRY;
        if ((inst->params.showman || !inst->locked[The_Soul]) && random(inst, (__private ntype[]){N_Type, N_Type, N_Ante}, (__private int[]){R_Soul, R_Spectral, ante}, 3) > 0.997) {
            forcedKey = The_Soul;
        }
        if ((inst->params.showman || !inst->locked[Black_Hole]) && random(inst, (__private ntype[]){N_Type, N_Type, N_Ante}, (__private int[]){R_Soul, R_Spectral, ante}, 3) > 0.997) {
            forcedKey = Black_Hole;
        }
        if (forcedKey != RETRY) return forcedKey;
    }
    return randchoice_common(inst, R_Spectral, itemSource, ante, SPECTRALS);
}
#endif

// Get rarity of the next joker for the given source type. 
// Affects the random, unless source S_Soul is requested.
rarity next_joker_rarity(instance* inst, rsrc itemSource, int ante) {
    if (itemSource == S_Soul) {
        return Rarity_Legendary;
    }
    if (itemSource == S_Wraith) {
        return Rarity_Rare;
    }
    if (itemSource == S_Rare_Tag) {
        return Rarity_Rare;
    }
    if (itemSource == S_Uncommon_Tag) {
        return Rarity_Uncommon;
    }

    double randomNumber = random(inst, (__private ntype[]){N_Type, N_Ante, N_Source}, (__private int[]){R_Joker_Rarity, ante, itemSource}, 3);
    if (randomNumber > 0.95) {
        return Rarity_Rare;
    }
    if (randomNumber > 0.7) {
        return Rarity_Uncommon;
    }
    return Rarity_Common;
}

item next_joker_edition(instance* inst, rsrc itemSource, int ante) {
    double poll = random(inst, (__private ntype[]){N_Type, N_Source, N_Ante}, (__private int[]){R_Joker_Edition, itemSource, ante}, 3);
    if (poll > 0.997) return Negative;
    if (poll > 0.994) return Polychrome;
    if (poll > 0.98) return Holographic;
    if (poll > 0.96) return Foil;
    return No_Edition;
}

bool is_next_joker_eternal(instance* inst, int ante) {
    if (inst->params.stake < Black_Stake) return false;
    return random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Eternal, ante}, 2) > 0.7;
}

// Get an object which carries both joker item, its rarity, and its edition
jokerdata next_joker_with_info(instance* inst, rsrc itemSource, int ante) {
    rarity nextRarity = next_joker_rarity(inst, itemSource, ante);
    item nextJoker;

    if (nextRarity == Rarity_Legendary) {
        nextJoker = randchoice_common(inst, R_Joker_Legendary, itemSource, ante, LEGENDARY_JOKERS);
    } else if (nextRarity == Rarity_Rare) {
        nextJoker = randchoice_common(inst, R_Joker_Rare, itemSource, ante, RARE_JOKERS);
    } else if (nextRarity == Rarity_Uncommon) {
        nextJoker = randchoice_common(inst, R_Joker_Uncommon, itemSource, ante, UNCOMMON_JOKERS);
    } else {
        nextJoker = randchoice_common(inst, R_Joker_Common, itemSource, ante, COMMON_JOKERS);
    }

    jokerdata rarityJoker = {nextJoker, nextRarity, next_joker_edition(inst, itemSource, ante), is_next_joker_eternal(inst, ante)};
    return rarityJoker;
}

// Save calculations by doing the minimum needed
item next_joker(instance* inst, rsrc itemSource, int ante) {
    rarity nextRarity = next_joker_rarity(inst, itemSource, ante);

    if (nextRarity == Rarity_Legendary) {
       return randchoice_common(inst, R_Joker_Legendary, itemSource, ante, LEGENDARY_JOKERS);
    } else if (nextRarity == Rarity_Rare) {
       return randchoice_common(inst, R_Joker_Rare, itemSource, ante, RARE_JOKERS);
    } else if (nextRarity == Rarity_Uncommon) {
       return randchoice_common(inst, R_Joker_Uncommon, itemSource, ante, UNCOMMON_JOKERS);
    } else {
       return randchoice_common(inst, R_Joker_Common, itemSource, ante, COMMON_JOKERS);
    }
}


shop get_shop_instance(instance* inst) {
    double jokerRate = 20;
    double tarotRate = 4;
    double planetRate = 4;
    double playingCardRate = 0;
    double spectralRate = 0;

    if (inst->params.deck == Ghost_Deck) {
        spectralRate = 2;
    }

    if (is_voucher_active(inst, Tarot_Tycoon)) {
        tarotRate = 32;
    } else if (is_voucher_active(inst, Tarot_Merchant)) {
        tarotRate = 9.6;
    }

    if (is_voucher_active(inst, Planet_Tycoon)) {
        planetRate = 32;
    } else if (is_voucher_active(inst, Planet_Merchant)) {
        planetRate = 9.6;
    }

    if (is_voucher_active(inst, Magic_Trick)) {
        playingCardRate = 4;
    }

    shop _shop = {
        jokerRate, 
        tarotRate, 
        planetRate, 
        playingCardRate, 
        spectralRate
    };
    return _shop;
}

double get_total_rate(shop shopInstance) {
    return shopInstance.jokerRate + shopInstance.tarotRate + shopInstance.planetRate + shopInstance.playingCardRate + shopInstance.spectralRate;
}

itemtype get_item_type(shop shopInstance, double generatedValue) {
    // Jokers -> Tarots -> Planets -> Playing Cards -> Spectrals
    if (generatedValue < shopInstance.jokerRate) {
        return ItemType_Joker;
    }
    generatedValue -= shopInstance.jokerRate;

    if (generatedValue < shopInstance.tarotRate) {
        return ItemType_Tarot;
    }
    generatedValue -= shopInstance.tarotRate;
    
    if (generatedValue < shopInstance.planetRate) {
        return ItemType_Planet;
    }
    generatedValue -= shopInstance.planetRate;

    if (generatedValue < shopInstance.playingCardRate) {
        return ItemType_PlayingCard;
    }

    return ItemType_Spectral;
}

shopitem next_shop_item(instance* inst, int ante) {
    shop shopInstance = get_shop_instance(inst);

    double card_type = random(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Card_Type, ante}, 2) * get_total_rate(shopInstance);
    itemtype type = get_item_type(shopInstance, card_type);
    item shopItem;
    if (type == ItemType_Joker) {
        shopItem = next_joker(inst, S_Shop, ante);
    } else if (type == ItemType_Tarot) {
        shopItem = next_tarot(inst, S_Shop, ante, false);
    } else if (type == ItemType_Planet) {
        shopItem = next_planet(inst, S_Shop, ante, false);
    } else if (type == ItemType_Spectral) {
        shopItem = next_spectral(inst, S_Shop, ante, false);
    } else if (type == ItemType_PlayingCard) {
        // TODO: Playing card support.
        shopItem = RETRY;
    }

    shopitem nextShopItem = {type, shopItem};
    return nextShopItem;
}

//Todo: Update for vouchers, add a general one for any type of card
// Deprecated, use next_shop_item() ^
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

item next_tag(instance* inst, int ante) {
    return randchoice_common(inst, R_Tags, S_Null, ante, TAGS);
}

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
        if (!inst->params.showman) inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
void celestial_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_planet(inst, S_Celestial, ante, true);
        if (!inst->params.showman) inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
void spectral_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_spectral(inst, S_Spectral, ante, true);
        if (!inst->params.showman) inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
#endif
void buffoon_pack(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_joker(inst, S_Buffoon, ante);
        if (!inst->params.showman) inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
    }
}
void buffoon_pack_detailed(jokerdata out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_joker_with_info(inst, S_Buffoon, ante);
        if (!inst->params.showman) inst->locked[out[i].joker] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i].joker] = false;
    }
}

void buffoon_pack_editions(item out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = next_joker_edition(inst, S_Buffoon, ante);
    }
}

void standard_pack(card out[], int size, instance* inst, int ante) {
    for (int i = 0; i < size; i++) {
        out[i] = standard_card(inst, ante);
    }
}

// More specific RNG types
#ifdef DEMO
int misprint(instance* inst) {
    return (int)randint(inst, (__private ntype[]){N_Type}, (__private int[]){R_Misprint}, 1, 0, 20);
}
#else
int misprint(instance* inst) {
    return (int)randint(inst, (__private ntype[]){N_Type}, (__private int[]){R_Misprint}, 1, 0, 23);
}
#endif
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
#ifdef DEMO
bool gros_michel_extinct(instance* inst) {
    return random_simple(inst, R_Gros_Michel) < 1.0/15;
}
#else
bool gros_michel_extinct(instance* inst) {
    return random_simple(inst, R_Gros_Michel) < 1.0/4;
}
#endif
bool cavendish_extinct(instance* inst) {
    return random_simple(inst, R_Cavendish) < 1.0/1000;
}
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

item next_boss(instance* inst, int ante) {
    item boss_pool[28]; //set this length to BOSSES[0]
    int num_available_bosses = 0;
    for (int i = 1; i <= BOSSES[0]; i++) {
        if (!inst->locked[BOSSES[i]]) {
            if ((ante % 8 == 0 && BOSSES[i] > B_F_BEGIN) || (ante % 8 != 0 && BOSSES[i] < B_F_BEGIN)) {
                boss_pool[num_available_bosses] = BOSSES[i];
                num_available_bosses++;
            }
        }
    }
    if (num_available_bosses == 0) { //all bosses used up, reopen the pool
        if (ante % 8 == 0) {
            for (int i = B_F_BEGIN + 1; i < B_F_END; i++) {
                inst->locked[i] = false;
            }
        } else {
            for (int i = B_BEGIN + 1; i < B_F_BEGIN; i++) {
                inst->locked[i] = false;
            }
        }
        //OpenCL doesn't support recursion :(
        for (int i = 1; i <= BOSSES[0]; i++) {
            if (!inst->locked[BOSSES[i]]) {
                if ((ante % 8 == 0 && BOSSES[i] > B_F_BEGIN) || (ante % 8 != 0 && BOSSES[i] < B_F_BEGIN)) {
                    boss_pool[num_available_bosses] = BOSSES[i];
                    num_available_bosses++;
                }
            }
        }
    }
    //has to be implemented like this because of randchoice() restrictions
    inst->rng = randomseed(get_node_child(inst, (__private ntype[]){N_Type}, (__private int[]){R_Boss}, 1));
    item chosen_boss =boss_pool[l_randint(&(inst->rng), 0, num_available_bosses-1)];
    inst->locked[chosen_boss] = true;
    return chosen_boss;
}

// Bubble sort, feel free to change it to something faster that works
void sort_deck(item array[], int arrayLength) {
    for (int i = 0; i < arrayLength - 1; i++) {
        for (int j = 0; j < arrayLength - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                item tmp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = tmp;
            }
        }
    }
}

void init_erratic_deck(instance* inst) {
    for (int i = 0; i < 52; i++) {
        inst->params.deckCards[i] = randchoice_simple(inst, R_Erratic, CARDS);
    }

    sort_deck(inst->params.deckCards, inst->params.deckSize);
}

void copy_cards(item to[], __constant item from[]) {
    for (int i = 0; i < from[0]; i++) {
        to[i] = from[i+1];
    }
}

// Copy the base deck cards into separate array for shuffler
void init_deck(instance* inst, item out[]) {
    if (inst->params.deckCards[0] == RETRY) {
        if (inst->params.deck == Erratic_Deck) {
            init_erratic_deck(inst);
            inst->params.deckSize = 52;

        } else if (inst->params.deck == Abandoned_Deck) {
            copy_cards(inst->params.deckCards, ABANDONED_DECK_ORDER);
            inst->params.deckSize = ABANDONED_DECK_ORDER[0];

        } else if (inst->params.deck == Checkered_Deck) {
            copy_cards(inst->params.deckCards, CHECKERED_DECK_ORDER);
            inst->params.deckSize = CHECKERED_DECK_ORDER[0];

        } else {
            copy_cards(inst->params.deckCards, DECK_ORDER);
            inst->params.deckSize = DECK_ORDER[0];
        }

        if (inst->params.deck == Painted_Deck) {
            inst->params.handSize = 10;
        }
    }

    for (int index = 0; index < inst->params.deckSize; index++) {
        out[index] = inst->params.deckCards[index];
    }
}
void set_deck(instance* inst, item deck) {
    inst->params.deck = deck;
    if (deck == Zodiac_Deck) {
        activate_voucher(inst, Planet_Merchant);
        activate_voucher(inst, Tarot_Merchant);
    }
}

void set_stake(instance* inst, item stake) {
    inst->params.stake = stake;
}

void shuffle_deck(instance* inst, item deck[], int ante) {
    init_deck(inst, deck);
    inst->rng = randomseed(get_node_child(inst, (__private ntype[]){N_Type, N_Ante}, (__private int[]){R_Shuffle_New_Round, ante}, 2));
    for (int i = inst->params.deckSize - 1; i >= 1; i--) {
        int x = l_randint(&(inst->rng), 1, i+1)-1;
        item temp = deck[i];
        deck[i] = deck[x];
        deck[x] = temp;
    }
}

void next_hand_drawn(instance* inst, item hand[], int ante) {
    item deck[52];
    shuffle_deck(inst, deck, ante);

    int deckSize = inst->params.deckSize;
    int handSize = inst->params.handSize;

    for (int i = 0; i < handSize; i++) {
        int cardIndex = deckSize - (handSize - i);
        hand[i] = deck[cardIndex];
    }
}

// Note: This is generated once for every blind, regardless of whether it has an Orbital Tag (even Boss Blinds)
item next_orbital_tag(instance* inst) {
    int totalUnlockedHands = 0;
    item unlockedHands[13] = {RETRY};

    for (int i = 1; i <= POKER_HANDS[0]; i++) {
        if (!inst->locked[POKER_HANDS[i]]) {
            totalUnlockedHands++;
            unlockedHands[totalUnlockedHands] = POKER_HANDS[i];
        }
    }

    // First element always specifies the size of array, 
    // it does not matter if it's actually bigger.
    unlockedHands[0] = totalUnlockedHands; 

    item result = randchoice_simple_dynamic(inst, R_Orbital_Tag, unlockedHands);

    return result;
}