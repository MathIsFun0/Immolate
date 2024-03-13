// Find seeds with Perkeo, Ankh and Ecto as consumables from shop. Used for most jokers WR (with eternal jokers)
// !! Requires Ghost deck !!
// How to read the result number: 30401
// 3 -> which pack has perkeo (ante 1, from left to right, 3 means 2nd shop, first pack)
// 4 -> ante that has ankh (within first 8 items in shop)
// 1 -> ante that has ectoplasm (within first 8 items in shop)
#include "./lib/immolate.cl"

// In which pack ante 1 you get soul (if all packs are opened one after another from left to right)
int get_soul_index(instance* inst, int ante) {
    for (int packIndex = 1; packIndex <= 4; packIndex++) {
        pack pack = pack_info(next_pack(inst, ante));
        item cards[5];
        
        if (pack.type == Arcana_Pack) {
            arcana_pack(cards, pack.size, inst, ante);
        } else if (pack.type == Spectral_Pack) {
            spectral_pack(cards, pack.size, inst, ante);
        } else {
            continue;
        }
        
        for (int i = 0; i < pack.size; i++) {
            if (cards[i] == The_Soul) {
                return packIndex;
            }
        }
    }

    return -1;
}

void find_ankh_and_ecto(instance* inst, int *ankhAnte, int *ectoAnte) {
    int maxAnte = 4;
    int itemsPerAnte = 8;

    for (int ante = 1; ante <= maxAnte; ante++) {

        for (int itemIndex = 1; itemIndex < itemsPerAnte; itemIndex++) {
            if (*ankhAnte > 0 && *ectoAnte > 0) {
                return;
            }

            shopitem shopItem = next_shop_item(inst, ante, true, 0, 0);

            if (*ankhAnte <= 0 && shopItem._item == Ankh) {
                *ankhAnte = ante;
            } else if (*ectoAnte <= 0 && shopItem._item == Ectoplasm) {
                *ectoAnte = ante;
            }
        }
    }
}

long filter(instance* inst) {
    int ante = 1;

    item jokerFromSoul = next_joker(inst, S_Soul, ante);
    if (jokerFromSoul != Perkeo) {
        return 0; // No need to check the rest if soul does not even give perkeo.
    }

    int soulPackIndex = get_soul_index(inst, ante);
    int ankhAnte = -1;
    int ectoAnte = -1;

    if (soulPackIndex <= 0) {
        return 0;
    }

    find_ankh_and_ecto(inst, &ankhAnte, &ectoAnte);

    if (ankhAnte <= 0 || ectoAnte <= 0) {
        return 0;
    }

    return soulPackIndex * 10000 + ankhAnte * 100 + ectoAnte * 1;
}
