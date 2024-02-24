// Purchaseless runs
#include "./lib/immolate.cl"
long filter(instance* inst) {
    long passedFilters = 0;
    init_locks(inst, 2, false, true);
    // Start with an Ante 2 Top-up Tag
    if (next_tag(inst, 2) != Top_up_Tag) return passedFilters;
    passedFilters++;
    item jkrt1 = next_joker(inst, S_Top_Up, 2);
    inst->locked[jkrt1] = true;
    item jkrt2 = next_joker(inst, S_Top_Up, 2);
    inst->locked[jkrt2] = true;
    if (jkrt1 != Superposition && jkrt2 != Superposition) return passedFilters;
    passedFilters++;
    if (next_tarot(inst, S_Superposition, 2) != Judgement) return passedFilters;
    int hasBull = 0;
    int hasGreen = 0;
    int hasFist = 0;
    for (int i = 0; i < 3; i++) {
        item jkr = next_joker(inst, S_Judgement, 2);
        inst->locked[jkr] = true;
        if (jkr == Bull) hasBull = 1;
        if (jkr == Green_Joker) hasGreen = 1;
        if (jkr == Raised_Fist) hasFist = 1;
    }
    if (hasBull + hasGreen + hasFist == 3) return 999;
    return 900+hasBull+hasGreen+hasFist;
}