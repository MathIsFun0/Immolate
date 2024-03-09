#include "./lib/immolate.cl"
// Checks if the first two blinds of Ante 1 have straight flushes
long filter(instance* inst) {
    item deck[52];
    int score = 0;
    for (int i = 0; i < 2; i++) {
        shuffle_deck(inst, deck, 1);
        item hand[8] = {deck[44], deck[45], deck[46], deck[47], deck[48], deck[49], deck[50], deck[51]};
        bool isStrush = false;
        // The strategy used here is to treat each card as the potential starting point of a Straight Flush and chack that the rest of the held hand supports it.
        for (int i = 0; i < 8; i++) {
            item c_rank = rank(hand[i]);
            if (c_rank == Jack || c_rank == Queen || c_rank == King) continue;
            item targetRank = rank(hand[i]);
            for (int x = 1; x < 5; x++) {
                targetRank = next_rank(targetRank);
                item targetCard = from_rank_suit(targetRank, suit(hand[i]));
                isStrush = false;
                for (int j = 0; j < 8; j++) {
                    if (hand[j] == targetCard) {
                        isStrush = true;
                    }
                }
                if (!isStrush) break;
            }
            if (isStrush) break;
        }
        if (isStrush) score += 1;
    }
    return score;
}