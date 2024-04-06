// Maximum cash out possible in Ante 1
#include "lib/immolate.cl"
long filter(instance* inst) {
    long passedFilters = 0;
    
    // The tags we need
    if (next_tag(inst, 1) != Charm_Tag) return passedFilters;
    if (next_tag(inst, 1) != Economy_Tag) return passedFilters;
    passedFilters++;

    int hasHermit = 0;
    int hasEmperor = 0;
    // Generate pack
    item tarots[5];
    arcana_pack(tarots, 5, inst, 1);
    for (int i = 0; i < 5; i++) {
        if (tarots[i] == The_Hermit) hasHermit = 1;
        else if (tarots[i] == The_Emperor) hasEmperor = 1;
        else inst->locked[tarots[i]] = true; // Locked for emperor generation
    }
    if (hasHermit + hasEmperor != 2) return passedFilters;
    passedFilters++;
    item empTarot1 = next_tarot(inst, S_Emperor, 1, false);
    item empTarot2 = next_tarot(inst, S_Emperor, 1, false);
    if (empTarot1 != The_Hermit && empTarot2 != The_Hermit) return passedFilters;
    passedFilters++;
    bool bonusPoints = false;
    if (empTarot1 == Judgement || empTarot2 == Judgement) {
        if (next_joker(inst, S_Judgement, 1) == Diet_Cola) bonusPoints = true;
    };
    // Check for a Straight Flush.
    item deck[52];
    shuffle_deck(inst, deck, 1);
    item hand[8] = {deck[44], deck[45], deck[46], deck[47], deck[48], deck[49], deck[50], deck[51]};
    bool isStrush = false;
    // The strategy used here is to treat each card as the potential starting point of a Straight Flush and check that the rest of the held hand supports it.
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
    if (isStrush) {
        if (bonusPoints) return 1000;
        return 999;
    }
    return 900+(bonusPoints?1:0);
}
