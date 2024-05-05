#include <iostream>
#include "immolate.hpp"

#include <iostream>
#include <thread>
#include <vector>

void filter(int id, int nThreads, int max) {
    for (int i = id; i <= max; i += nThreads) {
        Instance inst(std::to_string(i));
        int legendaries = 0;
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
        if (legendaries >= 2) {
            printf("%i: %s, %s\n",i, itemToString(inst.nextJoker("sou", 1, false).joker), itemToString(inst.nextJoker("sou", 1, false).joker));
        }
    }
};


int main() {
    constexpr int N = 10000000;
    constexpr int nThreads = 12;
    std::vector<std::thread> threads;
    for (int i = 0; i < nThreads; ++i) {
        threads.emplace_back(filter, i, nThreads, N);
    }
    for (std::thread& t : threads) {
        t.join();
    }
    return 1;
}