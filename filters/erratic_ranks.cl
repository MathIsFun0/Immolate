// Searches for an Erratic Deck seed with lots of a rank
#include "./lib/immolate.cl"
long filter(instance* inst) {
    set_deck(inst, Erratic_Deck);
    int16 scores;
    for (int i = 0; i < 13; i++) scores[i] = 0;
    item deck[52];
    init_deck(inst, deck);
    for (int i = 0; i < 52; i++) {
       scores[rank(deck[i])-_2]++;
    }
    int score = scores[0];
    for (int i = 1; i < 13; i++) {
        if (scores[i] > score) score = scores[i];
    }
    return score;
}