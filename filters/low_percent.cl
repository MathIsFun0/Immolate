// Searches for a seed that can be beaten with 6 hands and 0 discards
#include "lib/immolate.cl"
long filter(instance* inst) {
    init_locks(inst, 1, false, true);
    int passedFilters = 0;
    // Charm Tag Ante 1
    item tag1 = next_tag(inst, 1);
    item tag2 = next_tag(inst, 1);
    if (tag1 != Charm_Tag && tag2 != Charm_Tag) return passedFilters;
    passedFilters++;

    // Judgement (must be duplicated with Magic Deck Fools)
    item arcanaPack[5];
    arcana_pack(arcanaPack, 5, inst, 1);
    bool hasJudgement = false;
    for (int i = 0; i < 5; i++) {
        if (arcanaPack[i] == Judgement) {
            hasJudgement = true;
            break;
        }
    }
    if (!hasJudgement) return passedFilters;
    passedFilters++;

 
    // Good Jokers from Judgement
    bool hasBanner = false;
    bool hasPlusMult = false;
    bool hasXMult = false;
    for (int i = 0; i < 3; i++) {
        item jkr = next_joker(inst, S_Judgement, 1);
        if (jkr == Banner) hasBanner = true;
        if (jkr == Fibonacci) hasPlusMult = true;
        if (jkr == Gros_Michel) hasPlusMult = true;
        if (jkr == Misprint) hasPlusMult = true;
        if (jkr == Popcorn) hasPlusMult = true;
        if (jkr == Ramen) hasXMult = true;
        if (jkr == Baseball_Card) hasXMult = true;
        if (jkr == Throwback) hasXMult = true;
        if (jkr == Brainstorm) hasXMult = true;
        if (i == 2 && hasBanner && hasPlusMult && !hasXMult) {
            // We can take the XMult in ante 2
            jkr = next_joker(inst, S_Judgement, 2);
            if (jkr == Ramen) hasXMult = true;
            if (jkr == Baseball_Card) hasXMult = true;
            if (jkr == Throwback) hasXMult = true;
            if (jkr == Brainstorm) hasXMult = true;
        }
    }
    if (!hasBanner || !hasPlusMult || !hasXMult) return passedFilters;
    passedFilters++;

    // No Hook (accounting for rerolls)
    // To be implemented

    return 999;
}