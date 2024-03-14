// Legendary joker from arcana pack skip ante 1.
#include "./lib/immolate.cl"

long filter(instance* inst) {
    // Charm Tag Ante 1
    item firstTag = next_tag(inst, 1);
    item secondTag = next_tag(inst, 1);
    if (firstTag != Charm_Tag && secondTag != Charm_Tag) {
        return 0;
    }

    item arcanaPack[5];
    arcana_pack(arcanaPack, 5, inst, true);
    for (int i = 0; i < 5; i++) {
        if (arcanaPack[i] == The_Soul) {
            return 1;
        }
    }

    return 0;
}