// Searches for glitched seeds
#include "./lib/immolate.cl"
long filter(instance* inst) {
    double node = inst->hashedSeed;
    if (node >= 0 && node <= 1) return 0;
    return 1;
}