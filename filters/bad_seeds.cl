// Seeds with very little rare / uncommon jokers in first 4 ante
#include "lib/immolate.cl"

int find_non_common_jokers(instance* inst, rsrc jokerSource, int ante, int amountToCheck) {
    int totalNonCommonJokers = 0;

    for (int i = 0; i < amountToCheck; i++) {
        // This can be used to filter out specific common jokers, too
        //jokerdata result = next_joker_with_info(inst, jokerSource, ante); 
        //rarity nextRarity = result._rarity; 
        //item nextJoker = result._item; 

        rarity nextRarity = next_joker_rarity(inst, jokerSource, ante);
        if (nextRarity != Rarity_Common) {
            totalNonCommonJokers++;
        }
    }

    return totalNonCommonJokers;
}

long filter(instance* inst) {
    int score = 10; // Max amount of uncommon jokers

    for (int ante = 1; ante <= 4; ante++) {
        score -= find_non_common_jokers(inst, S_Shop, ante, (ante == 1? 6 : 12));
        score -= find_non_common_jokers(inst, S_Buffoon, ante, 4);
        score -= find_non_common_jokers(inst, S_Judgement, ante, 1);

        if (score <= 0) {
            return 0;
        }
    }

    return score;
}