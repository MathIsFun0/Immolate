// Searches for a seed that has a Gros Michel in the first shop (or in the buffoon packs)
// Followed by a Cavendish in the second shop (or in the buffoon packs)
#include "lib/immolate.cl"

bool check_next_pack(instance* inst, int ante, item searching) {
    pack pack = pack_info(next_pack(inst, ante));

    if (pack.type != Buffoon_Pack) {
        return 0;
    }

    // Generate next x jokers that will be in the pack
    item jokers[4];
    buffoon_pack(jokers, pack.size, inst, ante);

    for (int index = 0; index < pack.size; index++) {
        if (jokers[index] == searching) {
          return 1;
        }
    }
    return 0;
}

bool check_next_shopitem(instance* inst, int ante, item searching) {
  if (next_shop_item(inst, ante)._item == searching) {
    return 1;
  }
  return 0;
}

long filter(instance* inst) {
  bool hasGrosMichel = false;

  // Always check all 4 possibilities, no short circuit evaluation!
  if (check_next_shopitem(inst, 1, Gros_Michel)) {
    hasGrosMichel = true;
  }

  if (check_next_shopitem(inst, 1, Gros_Michel)) {
    hasGrosMichel = true;
  }

  if (check_next_pack(inst, 1, Gros_Michel)) {
    hasGrosMichel = true;
  }

  if (check_next_pack(inst, 1, Gros_Michel)) {
    hasGrosMichel = true;
  }

  // if there is no gros michel or it does not go extinct, we do not care
  if (!hasGrosMichel || !gros_michel_extinct(inst)) {
    return 0;
  }

  bool hasCavendish = false;

  // Always check all 4 possibilities, no short circuit evaluation!
  if (check_next_shopitem(inst, 1, Cavendish)) {
    hasCavendish = true;
  }

  if (check_next_shopitem(inst, 1, Cavendish)) {
    hasCavendish = true;
  }

  if (check_next_pack(inst, 1, Cavendish)) {
    hasCavendish = true;
  }

  if (check_next_pack(inst, 1, Cavendish)) {
    hasCavendish = true;
  }

  if (hasCavendish) {
    return 1;
  }
  return 0;
}
