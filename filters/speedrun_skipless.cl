// Speedrunning seeds for Set Seed Skips
#include "lib/immolate.cl"
long filter(instance* inst) {
    long passedFilters = 0;
    /*
    Jokers that we want:
    Baseball Card xMult
    Bull +Chips
    Fibo +Mult
    Ramen Xmult
    Invisible Joker (duping)

    Combined From:
    First 3 shop jokers
    Jumbo Buffoon Pack in shop
    Immolate for money
    */

    item pack1 = next_pack(inst, 1);
    item pack2 = next_pack(inst, 1);
    int speclPack = 0;
    if (pack1 != Mega_Buffoon_Pack && pack2 != Mega_Buffoon_Pack) return passedFilters;
    passedFilters++;
    if (pack1 == Mega_Buffoon_Pack) speclPack = 1;
    pack speclInfo = pack_info((speclPack == 0 ? pack1 : pack2));
    if (speclInfo.type != Spectral_Pack) return passedFilters;
    passedFilters++;

    bool hasImmolate = false;
    item spectrals[4];
    spectral_pack(spectrals, speclInfo.size, inst, 1);
    for (int i = 0; i < speclInfo.size; i++) {
        if (spectrals[i] == Immolate) hasImmolate = true;
    }
    if (!hasImmolate) return passedFilters;
    passedFilters++;

    // Joker filters
    int hasBaseball = 0;
    int hasBull = 0;
    int hasFibo = 0;
    int hasRamen = 0;
    int hasInvis = 0;
    for (int i = 0; i < 4; i++) { // Ante 1 shop jokers
        item jkr = shop_joker(inst, 1);
        if (jkr == Baseball_Card) {  
            if (i < 2) {
                inst->locked[jkr] = true;
            }
            hasBaseball = 1;
        }
        if (jkr == Bull) {  
            if (i < 2) {
                inst->locked[jkr] = true;
            }
            hasBull = 1;
        }
        if (jkr == Fibonacci) {  
            if (i < 2) {
                inst->locked[jkr] = true;
            }
            hasFibo = 1;
        }
        if (jkr == Ramen) {  
            if (i < 2) {
                inst->locked[jkr] = true;
            }
            hasRamen = 1;
        }
        if (jkr == Invisible_Joker) {  
            if (i < 2) {
                inst->locked[jkr] = true;
            }
            hasInvis = 1;
        }
    }
    if (hasBaseball + hasBull + hasFibo + hasRamen + hasInvis < 3) return passedFilters;
    item jokers[4];
    buffoon_pack(jokers, 4, inst, 1);
    for (int i = 0; i < 4; i++) {
        if (jokers[i] == Baseball_Card) hasBaseball = 1;
        if (jokers[i] == Ramen) hasRamen = 1;
        if (jokers[i] == Bull) hasBull = 1;
        if (jokers[i] == Fibonacci) hasFibo = 1;
        if (jokers[i] == Invisible_Joker) hasInvis = 1;
    }
    if (hasBaseball + hasBull + hasFibo + hasRamen + hasInvis == 5) return 999;
    return 900 + hasBaseball + hasBull + hasFibo + hasRamen + hasInvis;
}