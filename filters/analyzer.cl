#define CACHE_SIZE 1000
#include "lib/immolate.cl"
// Prints a full analysis of a seed. Vouchers and bosses to be implemented.
// It's highly recommended to run this with -n 1 to only look at a single seed.
// immolate -f analyzer -s THESEED -n 1 -g 1

//==================
// Search parameters
//==================

// When changing maxAnte, make sure size of array below matches it.
__constant int maxAnte = 2; 
__constant long cardsPerAnte[] = {10, 30, 50, 50, 50, 50, 50, 50};

// Change this to the deck and stake you want to use with this seed
__constant item deck = Red_Deck;
__constant item stake = White_Stake;

// Reroll queue is used for duplicates.
// e.g.: You have The Order, and there's another The Order in shop.
// The game will reroll it into another Rare joker (first queue). 
// If you also have that joker, the game will reroll it into another Rare joker (second queue).
// Set to 0 to disable.
__constant int firstRerollQueueItems = 6;
__constant int secondRerollQueueItems = 3;

__constant item bannedVouchers[] = {Magic_Trick, Illusion, Tarot_Tycoon, Tarot_Merchant, Planet_Tycoon, Planet_Merchant};

//==================
//  Implementation
//==================

void print_reroll_queue(instance* inst, int ante, bool ghostDeck, int itemsToShow, int queueIndex);

void print_consumable_info(instance* inst, int ante, item consumable);

void print_tag_info(instance* inst, int ante, item tag, bool isBigBlind);

void print_consumable_pack(instance* inst, int ante, pack packinfo, item cards[]);

bool do_activate_voucher(item voucher, int ante);

long filter(instance* inst) {
    // Perform required initializations
    set_deck(inst, deck); 
    set_stake(inst, stake);
    init_locks(inst, 1, false, true);

    // For simplicity, we'll assume every voucher is redeemed (but they all start out locked)
    inst->locked[Overstock_Plus] = true;
    inst->locked[Liquidation] = true;
    inst->locked[Glow_Up] = true;
    inst->locked[Reroll_Glut] = true;
    inst->locked[Omen_Globe] = true;
    inst->locked[Observatory] = true;
    inst->locked[Nacho_Tong] = true;
    inst->locked[Recyclomancy] = true;
    inst->locked[Tarot_Tycoon] = true;
    inst->locked[Planet_Tycoon] = true;
    inst->locked[Money_Tree] = true;
    inst->locked[Antimatter] = true;
    inst->locked[Illusion] = true;
    inst->locked[Petroglyph] = true;
    inst->locked[Retcon] = true;
    inst->locked[Palette] = true;

    bool ghostDeck = inst->params.deck == Ghost_Deck;
    for (int ante = 1; ante <= maxAnte; ante++) {
        init_unlocks(inst, ante, false);
        printf("\n==ANTE %i==\n", ante);
        printf("Boss: ");
        print_item(next_boss(inst, ante));
        printf("\n");
        printf("Voucher: ");
        item voucher = next_voucher(inst, ante);
        if (do_activate_voucher(voucher, ante)) {
            activate_voucher(inst, voucher);
        }
        print_item(voucher);
        printf("\n");

        printf("Tags: ");

        item nextTag = next_tag(inst, ante);
        print_item(nextTag);
        print_tag_info(inst, ante, nextTag, false);

        printf(", ");
        nextTag = next_tag(inst, ante);
        print_item(nextTag);
        print_tag_info(inst, ante, nextTag, true);

        printf("\n");
        printf("Shop Queue: \n");
        for (int q = 1; q <= cardsPerAnte[ante-1]; q++) {
            printf("%i) ", q);
            shopitem _item = next_shop_item(inst, ante);
            if (_item.type == ItemType_Joker) {
                if (is_next_joker_eternal(inst, ante)) {
                    printf("Eternal ");
                }

                item edition = next_joker_edition(inst, S_Shop, ante);
                if (edition != No_Edition) {
                    print_item(edition);
                    printf(" ");
                }
            }
            print_item(_item._item);

            if (_item.type != ItemType_PlayingCard && _item.type != ItemType_Joker) {
                print_consumable_info(inst, ante, _item._item);
            }
            printf("\n");
        }
        if (firstRerollQueueItems > 0) {
            printf("\nReroll Queues: \n");
            print_reroll_queue(inst, ante, ghostDeck, firstRerollQueueItems, 1);

            if (secondRerollQueueItems > 0) {
                print_reroll_queue(inst, ante, ghostDeck, secondRerollQueueItems, 2);
            }
        }

        printf("\n\nPacks: \n");
        int numPacks = 6;
        if (ante == 1) numPacks = 4;
        for (int p = 1; p <= numPacks; p++) {
            item _pack = next_pack(inst, ante);
            print_item(_pack);
            printf(": ");
            pack packinfo = pack_info(_pack);
            item cards[5];
            item editions[5];
            card stdcards[5];
            jokerdata jokers[5];
            switch (packinfo.type) {
                case Celestial_Pack: 
                    celestial_pack(cards, packinfo.size, inst, ante);
                    print_consumable_pack(inst, ante, packinfo, cards);
                    break;
                case Arcana_Pack:
                    arcana_pack(cards, packinfo.size, inst, ante);
                    print_consumable_pack(inst, ante, packinfo, cards);
                    break;
                case Spectral_Pack:
                    spectral_pack(cards, packinfo.size, inst, ante);
                    print_consumable_pack(inst, ante, packinfo, cards);
                    break;
                case Buffoon_Pack:
                    buffoon_pack_detailed(jokers, packinfo.size, inst, ante);

                    for (int i = 0; i < packinfo.size; i++) {
                        if (jokers[i].eternal) printf("Eternal ");
                        if (jokers[i].edition != No_Edition) {
                            print_item(jokers[i].edition);
                            printf(" ");
                        }
                        print_item(jokers[i].joker);
                        if (i != packinfo.size-1) printf(", ");
                    }
                    break;
                case Standard_Pack:
                    standard_pack(stdcards, packinfo.size, inst, ante);
                    for (int i = 0; i < packinfo.size; i++) {
                        if (stdcards[i].seal != No_Seal) {
                            print_item(stdcards[i].seal);
                            printf(" ");
                        }
                        if (stdcards[i].edition != No_Edition) {
                            print_item(stdcards[i].edition);
                            printf(" ");
                        }
                        if (stdcards[i].enhancement != No_Enhancement) {
                            print_item(stdcards[i].enhancement);
                            printf(" ");
                        }
                        print_item(stdcards[i].base);
                        if (i != packinfo.size-1) printf(", ");
                    }
                    break;
                default: break;
            }
            printf("\n");
        }
    }

    return 0;
}

bool do_activate_voucher(item voucher, int ante) {
    // Realistically ante 1 vouchers are pretty hard to activate without ruining econ.
    if (ante == 1) {
        return false;
    }

    int bannedVouchersAmount = sizeof(bannedVouchers);

    for (int i = 0; i < bannedVouchersAmount; i++) {
        if (bannedVouchers[i] == voucher) {
            return false;
        }
    }

    return true;
}

void print_reroll_queue(instance* inst, int ante, bool ghostDeck, int itemsToShow, int queueIndex) {
    printf("Shop Planets [%d]: ", queueIndex);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Planet, S_Shop, ante, PLANETS, queueIndex));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nShop Tarots [%d]: ", queueIndex);
    for (int q = 1; q <= itemsToShow; q++) {
        item nextConsumable = randchoice_resample(inst, R_Tarot, S_Shop, ante, TAROTS, queueIndex);
        print_item(nextConsumable);
        print_consumable_info(inst, ante, nextConsumable);
        if (q != itemsToShow) printf(", ");
    };
    if (ghostDeck) {
        printf("\nShop Spectrals [%d]: ", queueIndex);
        for (int q = 1; q <= itemsToShow / 2; q++) {
            item nextConsumable = randchoice_resample(inst, R_Spectral, S_Shop, ante, SPECTRALS, queueIndex);
            print_item(nextConsumable);
            print_consumable_info(inst, ante, nextConsumable);
            if (q != itemsToShow) printf(", ");
        };
    }
    printf("\nCommon Shop Jokers [%d]: ", queueIndex);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Common, S_Shop, ante, COMMON_JOKERS, queueIndex));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nUncommon Shop Jokers [%d]: ", queueIndex);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Uncommon, S_Shop, ante, UNCOMMON_JOKERS, queueIndex));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nRare Shop Jokers [%d]: ", queueIndex);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Rare, S_Shop, ante, RARE_JOKERS, queueIndex));
        if (q != itemsToShow) printf(", ");
    };
}

void print_tag_info(instance* inst, int ante, item tag, bool isBigBlind) {
    item generatedItem;

    switch (tag) {
        case Orbital_Tag: {
            generatedItem = next_orbital_tag(inst, ante);
            break;
        }
        case Voucher_Tag: {
            generatedItem = next_voucher_from_tag(inst, ante);
            break;
        }
        case Rare_Tag: {
            if (isBigBlind) {
                ante++;
            }
            generatedItem = next_joker(inst, S_Rare_Tag, ante);
            break;
        }
        case Uncommon_Tag: {
            if (isBigBlind) {
                ante++;
            }
            generatedItem = next_joker(inst, S_Uncommon_Tag, ante);
            break;
        }
        default: {
            return;
        }
    }

    printf(" (");
    print_item(generatedItem);
    printf(")");
}

void print_consumable_info(instance* inst, int ante, item consumable) {
    rsrc itemSource;

    switch(consumable) {
        case The_Soul: {
            itemSource = S_Soul;
            break;
        }
        case Judgement: {
            itemSource = S_Judgement;
            break;
        }
        case Wraith: {
            itemSource = S_Wraith;
            break;
        }

        default: return;
    }

    printf(" (");

    item edition = next_joker_edition(inst, itemSource, ante);
    if (edition != No_Edition) {
        print_item(edition);
        printf(" ");
    }
    
    print_item(next_joker(inst, itemSource, ante));
    printf(")");
}

void print_consumable_pack(instance* inst, int ante, pack packinfo, item cards[]) {
    for (int i = 0; i < packinfo.size; i++) {
        print_item(cards[i]);
        print_consumable_info(inst, ante, cards[i]);

        if (i != packinfo.size-1) printf(", ");
    }
}