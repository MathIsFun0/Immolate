// Seeds with a Polychrome Perishable Rental Delayed Gratification in the first shop.
#include "lib/immolate.cl"

long filter(instance* inst) {
    set_stake(inst, Gold_Stake);
    for (int i = 0; i < 2; i++) {
        shopitem jkr = next_shop_item(inst, 1);
        if (jkr.type == ItemType_Joker && jkr._item == Delayed_Gratification && jkr.joker.edition == Polychrome
         && jkr.joker.stickers.perishable && jkr.joker.stickers.rental) return 1;
    }
    return 0;
}