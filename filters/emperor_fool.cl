// Emperor-Fool Chains
#include "./lib/immolate.cl"
  
bool matches(bool hasShowman, item tarot) {
    return tarot == The_Fool || hasShowman && tarot == The_Emperor;
}

long filter(instance* inst) {
    int bestAnte = 0;
    long bestScore = 0;

    // Because of ante-based RNG, we check every ante and store the best ante as the result
    for (int ante = 1; ante <= 6; ante++) {
        bool hasShowman = false;
        bool hasEmperor = true;

        shopitem firstShopItem = next_shop_item(inst, ante, false, 0, 0);
        shopitem secondShopItem = next_shop_item(inst, ante, false, 0, 0);

        if (firstShopItem == Showman || secondShopItem == Showman) {
            hasShowman = true;
        }
        if (firstShopItem == The_Emperor || secondShopItem == The_Emperor) {
            hasEmperor = true;
        }

        if (!hasEmperor) {
            continue;
        }

        long score = 0;
        while (true) {
            item firstTarot = next_tarot(inst, S_Emperor, ante, false);
            item secondTarot = next_tarot(inst, S_Emperor, ante, false);
            if (matches(hasShowman, firstTarot) || matches(hasShowman, secondTarot)) {
                score++;
            } else {
                break;
            }
        }

        if (score >= bestScore) {
            bestAnte = ante;
            bestScore = score;
        }
    }

    // The ante is returned to make it easier to find in-game. Later antes are better because it's easier to find Emperor and Fool.
    return bestScore * 10 + bestAnte;
}
