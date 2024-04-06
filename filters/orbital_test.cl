#include "lib/immolate.cl"

long filter(instance* inst) {
    init_locks(inst, 2, false, true);
    
    return next_tag(inst, 2) == Orbital_Tag && next_orbital_tag(inst, 2) == Straight;
}