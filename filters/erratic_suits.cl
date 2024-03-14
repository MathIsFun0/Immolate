// Searches for an Erratic Deck seed with lots of a type of suit
#include "./lib/immolate.cl"
long filter(instance* inst) {
    set_deck(inst, Erratic_Deck);
    int4 scores;
    for (int i = 0; i < 4; i++) scores[i] = 0;
    item deck[52];
    init_deck(inst, deck);
    for (int i = 0; i < 52; i++) {
        if (suit(deck[i]) == Spades) scores[0]++;
        if (suit(deck[i]) == Diamonds) scores[1]++;
        if (suit(deck[i]) == Clubs) scores[2]++;
        if (suit(deck[i]) == Hearts) scores[3]++;
    }
    int score = scores[0];
    if (scores[1] > score) score = scores[1];
    if (scores[2] > score) score = scores[2];
    if (scores[3] > score) score = scores[3];
    return score;
}