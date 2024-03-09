// Emperor-Fool Chains
#include "./lib/immolate.cl"
  
bool matches(bool hasShowman, item tarot) {
    return tarot == The_Fool || (hasShowman && tarot == The_Emperor);
}

void check_next_item(instance* inst, int ante, bool *hasShowman, bool *hasEmperor) {
        shopitem shopItem = next_shop_item(inst, ante, false, 0, 0);

        if (shopItem._item == Showman) {
            *hasShowman = true;
        }
        if (shopItem._item == The_Emperor) {
            *hasEmperor = true;
        }
}

long filter(instance* inst) {
    int bestAnte = 0;
    long bestScore = 0;

    // Because of ante-based RNG, we check every ante and store the best ante as the result
    for (int ante = 1; ante <= 2; ante++) {
        bool hasShowman = false;
        bool hasEmperor = false;
        
        for (int shopItemIndex = 1; shopItemIndex <= 4; shopItemIndex++) {
            check_next_item(inst, ante, &hasShowman, &hasEmperor);
        }

        if (!hasShowman) {
            continue;
        }

        if (hasShowman) {
            return 111;
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

    if (bestScore == 0) {
        return 0;
    }

    // The ante is returned to make it easier to find in-game. Later antes are better because it's easier to find Emperor and Fool.
    return bestScore * 1000 + bestAnte;
}
