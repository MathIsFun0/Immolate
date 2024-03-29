#define CACHE_SIZE 1000
#include "lib/immolate.cl"
// Prints a full analysis of a seed. Vouchers and bosses to be implemented.
// It's highly recommended to run this with -n 1 to only look at a single seed.
long filter(instance* inst) {
    int maxAnte = 8;
    long cardsPerAnte[] = {15, 50, 50, 50, 50, 50, 50, 50};
    // These pull from Resample and Resample2 pools
    int numRerolls = 10;
    int numRerolls2 = 3;
    // Perform required initializations
    set_deck(inst, Red_Deck); //Change this to the deck you want to use with this seed
    init_locks(inst, 1, false, false);
    for (int ante = 1; ante <= maxAnte; ante++) {
        init_unlocks(inst, ante, false);
        printf("\n==ANTE %i==\n", ante);
        printf("Tags: ");
        print_item(next_tag(inst, ante));
        printf(", ");
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
            }
            print_item(_item._item);
            printf("\n");
        }
        if (numRerolls > 0) {
            printf("\nReroll Queues: \n");
            printf("Shop Planets: ");
            for (int q = 1; q <= numRerolls; q++) {
                print_item(randchoice_resample(inst, R_Planet, S_Shop, ante, PLANETS, 1));
                if (q != numRerolls) printf(", ");
            };
            printf("\nShop Tarots: ");
            for (int q = 1; q <= numRerolls; q++) {
                print_item(randchoice_resample(inst, R_Tarot, S_Shop, ante, TAROTS, 1));
                if (q != numRerolls) printf(", ");
            };
            printf("\nCommon Shop Jokers: ");
            for (int q = 1; q <= numRerolls; q++) {
                print_item(randchoice_resample(inst, R_Joker_Common, S_Shop, ante, COMMON_JOKERS, 1));
                if (q != numRerolls) printf(", ");
            };
            printf("\nUncommon Shop Jokers: ");
            for (int q = 1; q <= numRerolls; q++) {
                print_item(randchoice_resample(inst, R_Joker_Uncommon, S_Shop, ante, UNCOMMON_JOKERS, 1));
                if (q != numRerolls) printf(", ");
            };
            printf("\nRare Shop Jokers: ");
            for (int q = 1; q <= numRerolls; q++) {
                print_item(randchoice_resample(inst, R_Joker_Rare, S_Shop, ante, RARE_JOKERS, 1));
                if (q != numRerolls) printf(", ");
            };
        }
        if (numRerolls2 > 0) {
            printf("\nShop Planets [2]: ");
            for (int q = 1; q <= numRerolls2; q++) {
                print_item(randchoice_resample(inst, R_Planet, S_Shop, ante, PLANETS, 2));
                if (q != numRerolls2) printf(", ");
            };
            printf("\nShop Tarots [2]: ");
            for (int q = 1; q <= numRerolls2; q++) {
                print_item(randchoice_resample(inst, R_Tarot, S_Shop, ante, TAROTS, 2));
                if (q != numRerolls) printf(", ");
            };
            printf("\nCommon Shop Jokers [2]: ");
            for (int q = 1; q <= numRerolls2; q++) {
                print_item(randchoice_resample(inst, R_Joker_Common, S_Shop, ante, COMMON_JOKERS, 2));
                if (q != numRerolls2) printf(", ");
            };
            printf("\nUncommon Shop Jokers [2]: ");
            for (int q = 1; q <= numRerolls2; q++) {
                print_item(randchoice_resample(inst, R_Joker_Uncommon, S_Shop, ante, UNCOMMON_JOKERS, 2));
                if (q != numRerolls2) printf(", ");
            };
            printf("\nRare Shop Jokers [2]: ");
            for (int q = 1; q <= numRerolls2; q++) {
                print_item(randchoice_resample(inst, R_Joker_Rare, S_Shop, ante, RARE_JOKERS, 2));
                if (q != numRerolls2) printf(", ");
            };
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
                    for (int i = 0; i < packinfo.size; i++) {
                        print_item(cards[i]);
                        if (i != packinfo.size-1) printf(", ");
                    }
                    break;
                case Arcana_Pack:
                    arcana_pack(cards, packinfo.size, inst, ante);
                    for (int i = 0; i < packinfo.size; i++) {
                        print_item(cards[i]);
                        if (i != packinfo.size-1) printf(", ");
                    }
                    break;
                case Spectral_Pack:
                    spectral_pack(cards, packinfo.size, inst, ante);
                    for (int i = 0; i < packinfo.size; i++) {
                        print_item(cards[i]);
                        if (i != packinfo.size-1) printf(", ");
                    }
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