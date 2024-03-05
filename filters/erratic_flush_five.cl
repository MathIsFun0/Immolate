// Searches for an Erratic Deck seed with lots of an exact card
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int scores[52];
    for (int i = 0; i < 52; i++) scores[i] = 0;
    item deck[52];
    init_erratic_deck(inst, deck);
    for (int i = 0; i < 52; i++) {
       scores[deck[i]-C_2]++;
    }
    int score = scores[0];
    for (int i = 1; i < 52; i++) {
        if (scores[i] > score) score = scores[i];
    }
    return score;
}