// Seeds with two eternal jokers in the first shop.
#include "lib/immolate.cl"

long filter(instance* inst) {
    set_stake(inst, Black_Stake);
    shopitem jkr1 = next_shop_item(inst, 1);
    shopitem jkr2 = next_shop_item(inst, 1);
    return 
        jkr1.type == ItemType_Joker && jkr2.type == ItemType_Joker &&
        jkr1.joker.stickers.eternal && jkr2.joker.stickers.eternal;
}