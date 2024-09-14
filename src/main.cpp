#include <iostream>
#include "immolate.hpp"
#include <thread>
#include <vector>

long filter(Instance inst) {
    long legendaries = 0;
    inst.nextPack(1);
    for (int p = 1; p <= 3; p++) {
        Pack pack = packInfo(inst.nextPack(1));
        if (pack.type == Item::Arcana_Pack) {
            auto packContents = inst.nextArcanaPack(pack.size, 1);
            for (int x = 0; x < pack.size; x++) {
                if (packContents[x] == Item::The_Soul) legendaries++;
            }
        }
        if (pack.type == Item::Spectral_Pack) {
            auto packContents = inst.nextSpectralPack(pack.size, 1);
            for (int x = 0; x < pack.size; x++) {
                if (packContents[x] == Item::The_Soul) legendaries++;
            }
        }
    }
    return legendaries;
};

long filter_perkeo_observatory(Instance inst) {
    if (inst.nextVoucher(1) == Item::Telescope) {
        inst.activateVoucher(Item::Telescope);
        if (inst.nextVoucher(2) != Item::Observatory) return 0;
    } else return 0;
    int antes[5] = {1, 1, 2, 2, 2};
    for (int i = 0; i < 5; i++) {
        Pack pack = packInfo(inst.nextPack(antes[i]));
        std::vector<Item> packContents;
        if (pack.type == Item::Arcana_Pack) {
            packContents = inst.nextArcanaPack(pack.size, antes[i]);
        } else if (pack.type == Item::Spectral_Pack) {
            packContents = inst.nextSpectralPack(pack.size, antes[i]);
        } else continue;
        for (int x = 0; x < pack.size; x++) {
            if (packContents[x] == Item::The_Soul && inst.nextJoker(ItemSource::Soul, antes[i], true).joker == Item::Perkeo) return 1;
        }
    }
    return 0;
}

long filter_negative_tag(Instance inst) {
    //Note: If the score cutoff was passed as a variable, this code could be significantly optimized
    int maxAnte = 20;
    int score = 0;
    for (int i = 2; i <= maxAnte; i++) {
        if (inst.nextTag(i) == Item::Negative_Tag) score++;
    }
    return score;
}


int main() {
    Search search(filter_negative_tag, "", 12, 100000000000);
    search.printDelay = 2147483647;
    search.highScore = 8;
    search.search();
    return 1;
}