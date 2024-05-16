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


int main() {
    Search search(filter, "IMMOLATE", 12, 1000000);
    search.search();
    return 1;
}