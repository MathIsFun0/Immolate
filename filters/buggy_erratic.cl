// Searches for seeds with glitched erratic decks
#include "./lib/immolate.cl"
long filter(instance* inst) {
    double node = get_node_child(inst, (__private ntype[]){N_Type}, (__private int[]){R_Erratic}, 1);
    if (node >= 0 && node <= 1) return 0;
    return 1;
}