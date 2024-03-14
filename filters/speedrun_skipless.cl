// Speedrunning seeds for Set Seed Skips
#include "lib/immolate.cl"
long filter(instance* inst) {
    long passedFilters = 0;

    // Stuntman ante 1
    item jkr1 = shop_joker(inst, 1);
    item jkr2 = shop_joker(inst, 1);
    if (jkr1 == Stuntman || jkr2 == Stuntman) passedFilters++;
    else return passedFilters;

    // Rocket or To The Moon next shop
    jkr1 = shop_joker(inst, 1);
    jkr2 = shop_joker(inst, 1);
    if (jkr1 == Rocket || jkr2 == Rocket || jkr1 == To_the_Moon || jkr2 == To_the_Moon) passedFilters++;
    else return passedFilters;

    // Bull ante 5
    shop_joker(inst, 5); //This part is after the boss, which is too early
    shop_joker(inst, 5);
    jkr1 = shop_joker(inst, 5);
    jkr2 = shop_joker(inst, 5);
    if (jkr1 == Bull || jkr2 == Bull) passedFilters++;
    else return passedFilters;

    return 999;
}