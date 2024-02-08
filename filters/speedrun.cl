// Speedrunning seeds for Set Seed Skips
long filter(instance* inst) {
    long passedFilters = 0;

    // Banner and Popcorn in ante 2
    item jkr1 = shop_joker(inst, 2);
    item jkr2 = shop_joker(inst, 2);
    if ((jkr1 == Banner && jkr2 == Popcorn) || (jkr1 == Popcorn && jkr2 == Banner)) passedFilters++;
    else return passedFilters;

    // Throwback, Flower Pot, and Baseball Card in antes 3-5
    item jkrs[6] = {shop_joker(inst, 3),shop_joker(inst, 3),shop_joker(inst, 4),shop_joker(inst, 4),shop_joker(inst, 5),shop_joker(inst, 5)};
    bool hasThrowback = false;
    bool hasRamen = false;
    bool hasBaseball = false;
    for (int i = 0; i < 6; i++) {
        if (jkrs[i] == Throwback) hasThrowback = true;
        if (jkrs[i] == Ramen) hasRamen = true;
        if (jkrs[i] == Baseball_Card) hasBaseball = true;
    }
    if (hasBaseball && hasThrowback && hasRamen) passedFilters++;
    else return passedFilters;

    // Check for a Straight Flush. (There's been some bugs here, so this code might need to be looked at more later.)
    item deck[52];
    for (int i = 0; i < 52; i++) {
        deck[i] = DECK_ORDER[i];
    }
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
    if (isStrush) return 999;
    return passedFilters;
}