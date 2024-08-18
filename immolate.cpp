#include <iostream>
#include "immolate.hpp"
#include <thread>
#include <vector>

long filter(Instance inst) {
    long legendaries = 0;
    inst.nextPack(1);
    for (int p = 1; p <= 2; p++) {
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

IMMOLATE_API std::string findseed(std::string seed) {
    Search search(filter, seed, 12, 100000000);
    return search.search();
}

extern "C" {
    IMMOLATE_API const char* findseed_c(const char* seed) {
        std::string cpp_seed(seed);
        std::string result = findseed(cpp_seed);
        
        char* c_result = (char*)malloc(result.length() + 1);
        strcpy(c_result, result.c_str());
        
        return c_result;
    }

    IMMOLATE_API void free_result(const char* result) {
        free((void*)result);
    }
}
