#include <iostream>
#include <cstring>
#include "immolate.hpp"
#include <thread>
#include <vector>

Item BRAINSTORM_PACK = Item::RETRY;
Item BRAINSTORM_TAG = Item::Charm_Tag;
long BRAINSTORM_SOULS = 1;

long filter(Instance inst) {
    if (BRAINSTORM_PACK != Item::RETRY) {
        inst.cache.generatedFirstPack = true; //we don't care about Pack 1
        if (inst.nextPack(1) != BRAINSTORM_PACK) {
            return 0;
        }
    }
    if (BRAINSTORM_TAG != Item::RETRY) {
        if (inst.nextTag(1) != BRAINSTORM_TAG) {
            return 0;
        }
    }
    if (BRAINSTORM_SOULS > 0) {
        for (int i = 1; i <= BRAINSTORM_SOULS; i++) {
            auto tarots = inst.nextArcanaPack(5, 1); //Mega Arcana Pack, assumed from a Charm Tag
            bool found_soul = false;
            for (int t = 0; t < 5; t++) {
                if (tarots[t] == Item::The_Soul) {
                    found_soul = true;
                    break;
                }
            }
            if (!found_soul) {
                return 0;
            }
        }
    }
};

IMMOLATE_API std::string brainstorm_cpp(std::string seed, std::string pack, std::string tag, double souls) {
    BRAINSTORM_PACK = stringToItem(pack);
    BRAINSTORM_TAG = stringToItem(tag);
    BRAINSTORM_SOULS = souls;
    Search search(filter, seed, 1, 100000000);
    search.exitOnFind = true;
    return search.search();
}

extern "C" {
    IMMOLATE_API const char* brainstorm(const char* seed, const char* pack, const char* tag, double souls) {
        std::string cpp_seed(seed);
        std::string cpp_pack(pack);
        std::string cpp_tag(tag);
        std::string result = brainstorm_cpp(cpp_seed, cpp_pack, cpp_tag, souls);
        
        char* c_result = (char*)malloc(result.length() + 1);
        strcpy(c_result, result.c_str());
        
        return c_result;
    }

    IMMOLATE_API void free_result(const char* result) {
        free((void*)result);
    }
}