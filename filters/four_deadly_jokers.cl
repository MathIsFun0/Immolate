// Searches for a first shop buffoon pack with the four jokers that give increased mult to suits.
#include "./lib/immolate.cl"
long filter(instance* inst) {
    // Buffoon Pack of Size 4
    bool suitablePack = false;
    for (int i = 1; i <= 2; i++) {
        pack pack = pack_info(next_pack(inst, 1));
        if (pack.type == Buffoon_Pack && pack.size == 4) suitablePack = true;
        if (suitablePack) break;
    }
    if (!suitablePack) return 0;
    int hasGreedy = 0;
    int hasLusty = 0;
    int hasWrathful = 0;
    int hasGluttonous = 0;
    // Generate pack
    item jokers[4];
    buffoon_pack(jokers, 4, inst, 1);
    for (int i = 0; i < 4; i++) {
        if (jokers[i] == Greedy_Joker) hasGreedy = 1;
        if (jokers[i] == Lusty_Joker) hasLusty = 1;
        if (jokers[i] == Wrathful_Joker) hasWrathful = 1;
        if (jokers[i] == Gluttonous_Joker) hasGluttonous = 1;
    }
    return 1 + hasGreedy + hasLusty + hasWrathful + hasGluttonous;
}