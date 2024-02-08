// Contains every kind of thing you could search for!
// Updated as of 0.9.3
typedef enum Item {
    RETRY,

    //Jokers
    J_BEGIN,

    J_C_BEGIN,
    Joker,
    Greedy_Joker,
    Lusty_Joker,
    Wrathful_Joker,
    Gluttonous_Joker,
    Sly_Joker,
    Wily_Joker,
    Devious_Joker,
    Crafty_Joker,
    Gift_Card,
    Gros_Michel,
    Even_Steven,
    Odd_Todd,
    Misprint,
    Green_Joker,
    Photograph,
    Fortune_Teller,
    Drunkard,
    Popcorn,
    Swashbuckler,
    Credit_Card,
    Superposition,
    Raised_Fist,
    J_C_END,

    J_U_BEGIN,
    Four_Fingers,
    Banner,
    Fibonacci,
    Hack,
    Shortcut,
    Hologram,
    Vagabond,
    Ramen,
    Reserved_Parking,
    Bull,
    Throwback,
    Flower_Pot,
    Trading_Card,
    Diet_Cola,
    Spare_Trousers,
    J_U_END,

    J_R_BEGIN,
    Seance,
    Baseball_Card,
    Hit_the_Road,
    The_Trio,
    Invisible_Joker,
    Brainstorm,
    Obelisk,
    J_R_END,

    J_END,

    // Vouchers
    V_BEGIN,
    Overstock,
    Hone,
    Crystal_Ball,
    Grabber,
    Tarot_Merchant,
    Planet_Merchant,
    Seed_Money,
    Paint_Brush,
    V_END,

    // Tarots
    T_BEGIN,
    The_Fool,
    The_Magician,
    The_High_Priestess,
    The_Empress,
    The_Emperor,
    The_Hierophant,
    The_Lovers,
    The_Chariot,
    Justice,
    The_Hermit,
    The_Wheel_of_Fortune,
    Strength,
    The_Hanged_Man,
    Death,
    Temperance,
    The_Devil,
    The_Tower,
    The_Star,
    The_Moon,
    The_Sun,
    Judgement,
    The_World,
    T_END,

    // Planets
    P_BEGIN,
    Mercury,
    Venus,
    Earth,
    Mars,
    Jupiter,
    Saturn,
    Uranus,
    Neptune,
    Pluto,
    Planet_X,
    Ceres,
    Eris,
    P_END,

    // Hands
    H_BEGIN,
    Pair,
    Three_of_a_Kind,
    Full_House,
    Four_of_a_Kind,
    Flush,
    Straight,
    Two_Pair,
    Straight_Flush,
    High_Card,
    Five_of_a_Kind,
    Flush_House,
    Flush_Five,
    H_END,

    // Spectrals
    S_BEGIN,
    Familiar,
    Grim,
    Incantation,
    Talisman,
    Aura,
    Wraith,
    Sigil,
    Ouija,
    Ectoplasm,
    Immolate,
    Ankh,
    Deja_Vu,
    Hex,
    Trance,
    Medium,
    Cryptid,
    S_END,

    // Enhancements
    ENHANCEMENT_BEGIN,
    No_Enhancement,
    Bonus_Card,
    Mult_Card,
    Wild_Card,
    Glass_Card,
    Steel_Card,
    Stone_Card,
    Gold_Card,
    Lucky_Card,
    ENHANCEMENT_END,

    // Seals
    SEAL_BEGIN,
    No_Seal,
    Gold_Seal,
    Red_Seal,
    Blue_Seal,
    Purple_Seal,
    SEAL_END,

    // Editions
    E_BEGIN,
    No_Edition,
    Foil,
    Holographic,
    Polychrome,
    Negative,
    E_END,

    // Booster Packs
    PACK_BEGIN,
    Arcana_Pack,
    Jumbo_Arcana_Pack,
    Mega_Arcana_Pack,
    Celestial_Pack,
    Jumbo_Celestial_Pack,
    Mega_Celestial_Pack,
    Standard_Pack,
    Jumbo_Standard_Pack,
    Mega_Standard_Pack,
    Buffoon_Pack,
    Jumbo_Buffoon_Pack,
    Mega_Buffoon_Pack,
    Spectral_Pack,
    Jumbo_Spectral_Pack,
    Mega_Spectral_Pack,
    PACK_END,

    // Tags
    TAG_BEGIN,
    Uncommon_Tag,
    Rare_Tag,
    Negative_Tag,
    Foil_Tag,
    Holographic_Tag,
    Polychrome_Tag,
    Investment_Tag,
    Voucher_Tag,
    Boss_Tag,
    Standard_Tag,
    Charm_Tag,
    Meteor_Tag,
    Buffoon_Tag,
    Handy_Tag,
    Garbage_Tag,
    Ethereal_Tag,
    Coupon_Tag,
    Double_Tag,
    Juggle_Tag,
    D6_Tag,
    Top_up_Tag,
    Speed_Tag,
    Orbital_Tag,
    Economy_Tag,
    TAG_END,

    // Blinds
    B_START,
    Small_Blind,
    Big_Blind,
    The_Hook,
    The_Ox,
    The_House,
    The_Wall,
    The_Club,
    The_Fish,
    The_Manacle,
    The_Mouth,
    The_Tooth,
    The_Mark,
    Cerulean_Bell,
    B_END,

    // Suits
    SUIT_BEGIN,
    Hearts,
    Clubs,
    Diamonds,
    Spades,
    SUIT_END,

    // Ranks
    RANK_BEGIN,
    _2,
    _3,
    _4,
    _5,
    _6,
    _7,
    _8,
    _9,
    _10,
    Jack,
    Queen,
    King,
    Ace,
    RANK_END,

    // Cards
    C_BEGIN,
    C_2,
    C_3,
    C_4,
    C_5,
    C_6,
    C_7,
    C_8,
    C_9,
    C_A,
    C_J,
    C_K,
    C_Q,
    C_T,
    D_2,
    D_3,
    D_4,
    D_5,
    D_6,
    D_7,
    D_8,
    D_9,
    D_A,
    D_J,
    D_K,
    D_Q,
    D_T,
    H_2,
    H_3,
    H_4,
    H_5,
    H_6,
    H_7,
    H_8,
    H_9,
    H_A,
    H_J,
    H_K,
    H_Q,
    H_T,
    S_2,
    S_3,
    S_4,
    S_5,
    S_6,
    S_7,
    S_8,
    S_9,
    S_A,
    S_J,
    S_K,
    S_Q,
    S_T,
    C_END,

    ITEMS_END
} item;

typedef struct WeightedItem {
    item _item;
    double weight;
} weighteditem;
typedef struct Pack {
    item type;
    int size;
    int choices;
} pack;

// Lists
item ENHANCEMENTS[] = {
    8,
    Bonus_Card,
    Mult_Card,
    Wild_Card,
    Glass_Card,
    Steel_Card,
    Stone_Card,
    Gold_Card,
    Lucky_Card
};
item CARDS[] = {
    52,
    C_2,
    C_3,
    C_4,
    C_5,
    C_6,
    C_7,
    C_8,
    C_9,
    C_A,
    C_J,
    C_K,
    C_Q,
    C_T,
    D_2,
    D_3,
    D_4,
    D_5,
    D_6,
    D_7,
    D_8,
    D_9,
    D_A,
    D_J,
    D_K,
    D_Q,
    D_T,
    H_2,
    H_3,
    H_4,
    H_5,
    H_6,
    H_7,
    H_8,
    H_9,
    H_A,
    H_J,
    H_K,
    H_Q,
    H_T,
    S_2,
    S_3,
    S_4,
    S_5,
    S_6,
    S_7,
    S_8,
    S_9,
    S_A,
    S_J,
    S_K,
    S_Q,
    S_T
};
// This list will probably have to be updated, I didn't check
item DECK_ORDER[] = {
    D_4,
    C_4,
    C_J,
    H_Q,
    H_A,
    H_9,
    D_Q,
    D_A,
    D_5,
    C_Q,
    C_A,
    C_9,
    S_6,
    S_2,
    S_A,
    D_7,
    S_K,
    H_6,
    H_2,
    S_Q,
    S_J,
    D_6,
    D_2,
    D_9,
    S_7,
    S_3,
    C_6,
    C_2,
    S_9,
    S_5,
    S_8,
    S_4,
    D_8,
    D_J,
    C_7,
    S_T,
    H_3,
    D_K,
    C_K,
    C_5,
    D_3,
    C_3,
    H_K,
    H_4,
    H_5,
    H_T,
    C_8,
    H_J,
    H_7,
    H_8,
    D_T,
    C_T
};
weighteditem PACKS[] = {
    {RETRY, 22.42}, //total
    {Arcana_Pack, 4},
    {Jumbo_Arcana_Pack, 2},
    {Mega_Arcana_Pack, 0.5},
    {Celestial_Pack, 4},
    {Jumbo_Celestial_Pack, 2},
    {Mega_Celestial_Pack, 0.5},
    {Standard_Pack, 4},
    {Jumbo_Standard_Pack, 2},
    {Mega_Standard_Pack, 0.5},
    {Buffoon_Pack, 1.2},
    {Jumbo_Buffoon_Pack, 0.6},
    {Mega_Buffoon_Pack, 0.15},
    {Spectral_Pack, 0.6},
    {Jumbo_Spectral_Pack, 0.3},
    {Mega_Spectral_Pack, 0.07}
};
pack PACK_INFO[] = {
    {Arcana_Pack, 3, 1},
    {Arcana_Pack, 5, 1},
    {Arcana_Pack, 5, 2},
    {Celestial_Pack, 3, 1},
    {Celestial_Pack, 5, 1},
    {Celestial_Pack, 5, 2},
    {Standard_Pack, 3, 1},
    {Standard_Pack, 5, 1},
    {Standard_Pack, 5, 2},
    {Buffoon_Pack, 2, 1},
    {Buffoon_Pack, 4, 1},
    {Buffoon_Pack, 4, 2},
    {Spectral_Pack, 2, 1},
    {Spectral_Pack, 4, 1},
    {Spectral_Pack, 4, 2}
};
pack pack_info(item pack) {
    return PACK_INFO[pack-Arcana_Pack];
}
item TAROTS[] = {
    22,
    The_Fool,
    The_Magician,
    The_High_Priestess,
    The_Empress,
    The_Emperor,
    The_Hierophant,
    The_Lovers,
    The_Chariot,
    Justice,
    The_Hermit,
    The_Wheel_of_Fortune,
    Strength,
    The_Hanged_Man,
    Death,
    Temperance,
    The_Devil,
    The_Tower,
    The_Star,
    The_Moon,
    The_Sun,
    Judgement,
    The_World
};
item COMMON_JOKERS[] = {
    22,
    Joker,
    Greedy_Joker,
    Lusty_Joker,
    Wrathful_Joker,
    Gluttonous_Joker,
    Sly_Joker,
    Wily_Joker,
    Devious_Joker,
    Crafty_Joker,
    Gros_Michel,
    Even_Steven,
    Odd_Todd,
    Misprint,
    Green_Joker,
    Photograph,
    Fortune_Teller,
    Drunkard,
    Popcorn,
    Swashbuckler,
    Credit_Card,
    Superposition,
    Raised_Fist
};
item UNCOMMON_JOKERS[] = {
    16,
    Four_Fingers,
    Banner,
    Fibonacci,
    Hack,
    Gift_Card,
    Spare_Trousers,
    Shortcut,
    Hologram,
    Vagabond,
    Ramen,
    Reserved_Parking,
    Bull,
    Diet_Cola,
    Throwback,
    Flower_Pot,
    Trading_Card
};
item RARE_JOKERS[] = {
    7,
    Seance,
    Obelisk,
    Baseball_Card,
    Hit_the_Road,
    The_Trio,
    Invisible_Joker,
    Brainstorm
};
item SPECTRALS[] = {
    18,
    Familiar,
    Grim,
    Incantation,
    Talisman,
    Aura,
    Wraith,
    Sigil,
    Ouija,
    Ectoplasm,
    Immolate,
    Ankh,
    Deja_Vu,
    Hex,
    Trance,
    Medium,
    Cryptid,
    RETRY, //Soul
    RETRY //Black_Hole
};
item TAGS[] = {
    24,
    Uncommon_Tag,
    Rare_Tag,
    Negative_Tag,
    Foil_Tag,
    Holographic_Tag,
    Polychrome_Tag,
    Investment_Tag,
    Voucher_Tag,
    Boss_Tag,
    Standard_Tag,
    Charm_Tag,
    Meteor_Tag,
    Buffoon_Tag,
    Handy_Tag,
    Garbage_Tag,
    Ethereal_Tag,
    Coupon_Tag,
    Double_Tag,
    Juggle_Tag,
    D6_Tag,
    Top_up_Tag,
    Speed_Tag,
    Orbital_Tag,
    Economy_Tag
};

// Helper functions
item suit(item card) {
    if (card <= C_T) return Clubs;
    if (card <= D_T) return Diamonds;
    if (card <= H_T) return Hearts;
    return Spades;
}
item rank(item card) {
    if (card % 13 == C_2 % 13) return _2;
    if (card % 13 == C_3 % 13) return _3;
    if (card % 13 == C_4 % 13) return _4;
    if (card % 13 == C_5 % 13) return _5;
    if (card % 13 == C_6 % 13) return _6;
    if (card % 13 == C_7 % 13) return _7;
    if (card % 13 == C_8 % 13) return _8;
    if (card % 13 == C_9 % 13) return _9;
    if (card % 13 == C_T % 13) return _10;
    if (card % 13 == C_J % 13) return Jack;
    if (card % 13 == C_Q % 13) return Queen;
    if (card % 13 == C_K % 13) return King;
    return Ace;
}
item next_rank(item rank) {
    if (rank == Ace) return _2;
    return (int)rank+1;
}
item suit_repr(item suit) {
    if (suit == Clubs) return C_2;
    if (suit == Diamonds) return D_2;
    if (suit == Hearts) return H_2;
    return S_2;
}
item rank_repr(item rank) {
    if (rank == _2) return C_2;
    if (rank == _3) return C_3;
    if (rank == _4) return C_4;
    if (rank == _5) return C_5;
    if (rank == _6) return C_6;
    if (rank == _7) return C_7;
    if (rank == _8) return C_8;
    if (rank == _9) return C_9;
    if (rank == _10) return C_T;
    if (rank == Jack) return C_J;
    if (rank == Queen) return C_Q;
    if (rank == King) return C_K;
    return C_A;
}

item from_rank_suit(item rank, item suit) {
    return suit_repr(suit) + rank_repr(rank) - C_2;
}