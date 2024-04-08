// Searches for a first shop with showman and a pack that gives 2 legendary jokers, coupon tag included
#include "lib/immolate.cl"
long filter(instance* inst) {
    int ante = 1;
    inst->params.showman = true;

    if (next_tag(inst, 1) != Coupon_Tag) {
        return 0;
    }

    if (next_shop_item(inst, ante).value != Showman && next_shop_item(inst, ante).value != Showman) {
        return 0;
    }

    for (int packIndex = 1; packIndex <= 2; packIndex++) {
        pack _pack = pack_info(next_pack(inst, 1));
        item cards[5];
        if (_pack.choices != 2) {
            continue;
        }

        if (_pack.type == Arcana_Pack) {
            arcana_pack(cards, _pack.size, inst, 1);
        } else if (_pack.type == Spectral_Pack) {
            spectral_pack(cards, _pack.size, inst, 1);
        } else {
            continue;
        }
        
        int score = 0;
        for (int i = 0; i < _pack.size; i++) {
            if (cards[i] == The_Soul) {
                score++;
            }
        }

        if (score >= 2) {
            return score;
        }
    }

    return 0;
}