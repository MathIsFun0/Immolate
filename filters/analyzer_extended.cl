#define CACHE_SIZE 1000
#include "lib/immolate.cl"
// Prints a full analysis of a seed. Vouchers and bosses to be implemented.
// It's highly recommended to run this with -n 1 to only look at a single seed.
// immolate -f analyzer_extended -s THESEED -n 1 -g 1

//==================
// Search parameters
//==================

// When changing maxAnte, make sure size of array below matches it.
const int maxAnte = 8; 
const long cardsPerAnte[] = {15, 50, 50, 50, 50, 50, 50, 50};

// Change this to the deck you want to use with this seed
const item deck = Red_Deck;

// Mark shop jokers with * if they're eternal (on black stake difficulty).
const bool showEternalJokers = true;

// Reroll queue is used for duplicates.
// e.g.: You have The Order, and there's another The Order in shop.
// The game will reroll it into another Rare joker (first queue). 
// If you also have that joker, the game will reroll it into another Rare joker (second queue).
// Set to 0 to disable.
const int firstRerollQueueItems = 6;
const int secondRerollQueueItems = 3;

//==================
//  Implementation
//==================

void print_reroll_queue(instance* inst, int ante, bool ghostDeck, int itemsToShow, int queueDepth);

void print_consumable_info(instance* inst, int ante, item consumable);

void print_consumable_pack(instance* inst, int ante, pack packinfo, item cards[]);


long filter(instance* inst) {
    // Perform required initializations
    set_deck(inst, deck); 
    init_locks(inst, 1, false, false);

    bool ghostDeck = inst->params.deck == Ghost_Deck;
    for (int ante = 1; ante <= maxAnte; ante++) {
        init_unlocks(inst, ante, false);
        printf("\n==ANTE %i==\n", ante);
        printf("Tags: ");

        // TODO : maybe show joker(s) from tag, orbital tag and potentially voucher
        // Does not make sense to show pack contents since it's going to scuff the shop, and the rest is not RNG.
        item nextTag = next_tag(inst, ante);
        print_item(nextTag);
        printf(", ");
        // Keep in mind that for second tag, if it's a shop joker tag - it would activate in the next ante.
        print_item(next_tag(inst, ante));
        printf("\n");
        printf("Shop Queue: \n");
        for (int q = 1; q <= cardsPerAnte[ante-1]; q++) {
            printf("%i) ", q);
            shopitem _item = next_shop_item(inst, ante);
            if (_item.type == ItemType_Joker) {
                item edition = next_joker_edition(inst, S_Shop, ante);
                if (edition != No_Edition) {
                    print_item(edition);
                    printf(" ");
                }

                if (showEternalJokers && is_next_joker_eternal(inst, ante)) {
                    printf("*");
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
        }
        if (secondRerollQueueItems > 0) {
            print_reroll_queue(inst, ante, ghostDeck, secondRerollQueueItems, 2);
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
                    buffoon_pack(cards, packinfo.size, inst, ante);
                    buffoon_pack_editions(editions, packinfo.size, inst, ante);
                    for (int i = 0; i < packinfo.size; i++) {
                        if (editions[i] != No_Edition) {
                            print_item(editions[i]);
                            printf(" ");
                        }
                        print_item(cards[i]);
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

void print_reroll_queue(instance* inst, int ante, bool ghostDeck, int itemsToShow, int queueDepth) {
    printf("Shop Planets [%d]: ", queueDepth);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Planet, S_Shop, ante, PLANETS, queueDepth));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nShop Tarots [%d]: ", queueDepth);
    for (int q = 1; q <= itemsToShow; q++) {
        item nextConsumable = randchoice_resample(inst, R_Tarot, S_Shop, ante, TAROTS, queueDepth);
        print_item(nextConsumable);
        print_consumable_info(inst, ante, nextConsumable);
        if (q != itemsToShow) printf(", ");
    };
    if (ghostDeck) {
        printf("\nShop Spectrals [%d]: ", queueDepth);
        for (int q = 1; q <= itemsToShow / 2; q++) {
            item nextConsumable = randchoice_resample(inst, R_Spectral, S_Shop, ante, SPECTRALS, queueDepth);
            print_item(nextConsumable);
            print_consumable_info(inst, ante, nextConsumable);
            if (q != itemsToShow) printf(", ");
        };
    }
    printf("\nCommon Shop Jokers [%d]: ", queueDepth);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Common, S_Shop, ante, COMMON_JOKERS, queueDepth));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nUncommon Shop Jokers [%d]: ", queueDepth);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Uncommon, S_Shop, ante, UNCOMMON_JOKERS, queueDepth));
        if (q != itemsToShow) printf(", ");
    };
    printf("\nRare Shop Jokers [%d]: ", queueDepth);
    for (int q = 1; q <= itemsToShow; q++) {
        print_item(randchoice_resample(inst, R_Joker_Rare, S_Shop, ante, RARE_JOKERS, queueDepth));
        if (q != itemsToShow) printf(", ");
    };
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