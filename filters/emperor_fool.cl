// Emperor-Fool Chains
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int bestAnte = 0;
    long bestScore = 0;
    // Because of ante-based RNG, we check every ante and store the best ante as the result
    for (int ante = 1; ante <= 6; ante++) {
        long score = 0;
        while (true) {
            item tarot1 = next_tarot(inst, S_Emperor, ante, false);
            item tarot2 = next_tarot(inst, S_Emperor, ante, false);
            if (tarot1 == The_Fool || tarot2 == The_Fool) score++;
            else break;
        }
        if (score >= bestScore) {
            bestAnte = ante;
            bestScore = score;
        }
    }
    // The ante is returned to make it easier to find in-game. Later antes are better because it's easier to find Emperor and Fool.
    return bestScore*10+bestAnte;
}