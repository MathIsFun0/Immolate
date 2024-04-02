// Seeds with two eternal jokers in the first shop.
#include "lib/immolate.cl"

long filter(instance* inst) {
    return 
        is_next_joker_eternal(inst, 1) && is_next_joker_eternal(inst, 1) &&
        next_shop_item(inst, 1).type == ItemType_Joker && next_shop_item(inst, 1).type == ItemType_Joker;
}