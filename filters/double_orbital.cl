// Searches for seeds with two of the same orbital skip tag in Ante 2
#include "lib/immolate.cl"
long filter(instance* inst) {
    item selectedHand = Straight;
    init_locks(inst, 2, false, true);
    // Two orbital tags
    if (next_tag(inst, 2) != Orbital_Tag || next_tag(inst, 2) != Orbital_Tag) return 0;
    for (int i = 0; i < 3; i++) {
        // Ante 1 Orbital rolls
        next_orbital_tag(inst);
    }
    if (next_orbital_tag(inst) != selectedHand || next_orbital_tag(inst) != selectedHand) return 1;
    return 2;
}