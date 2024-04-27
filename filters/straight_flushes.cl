#include "lib/immolate.cl"
// Checks if the first two blinds of Ante 1 have straight flushes
long filter(instance* inst) {
    set_deck(inst, Red_Deck);
    int score = 0;
    int ante = 1;
    for (int i = 0; i < 2; i++) {
        item hand[10] = {RETRY};
        int handSize = inst->params.handSize;
        next_hand_drawn(inst, hand, ante);
        
        bool isStrush = false;
        // The strategy used here is to treat each card as the potential starting point of a Straight Flush and check that the rest of the held hand supports it.
        for (int i = 0; i < handSize; i++) {
            item cardRank = rank(hand[i]);
            if (cardRank == Jack || cardRank == Queen || cardRank == King) {
                continue;
            }

            item cardSuit = suit(hand[i]);
            item nextRank = cardRank;
            // Straight contains 5 cards, we need to find 4 cards with ranks that continue current one.
            for (int x = 1; x < 5; x++) {
                nextRank = next_rank(nextRank);
                item targetCard = from_rank_suit(nextRank, cardSuit);

                isStrush = false;
                for (int j = 0; j < handSize; j++) {
                    if (hand[j] == targetCard) {
                        isStrush = true;
                        break;
                    }
                }
                if (!isStrush) {
                    // No straight flush with this card as starting.
                    break;
                }
            }
            if (isStrush) {
                break;
            }
        }
        if (!isStrush) {
            break; // Only look for consecutive straight flushes draw.
        }

        score++;
    }
    return score;
}