// RNG Cache
typedef enum RandomType {
    R_Joker_Common,
    R_Joker_Uncommon,
    R_Joker_Rare,
    R_Joker_Legendary,
    R_Joker_Rarity,
    R_Joker_Edition,
    R_Misprint,
    R_Standard_Has_Enhancement,
    R_Enhancement,
    R_Card,
    R_Standard_Edition,
    R_Standard_Has_Seal,
    R_Standard_Seal,
    R_Shop_Pack,
    R_Tarot,
    R_Spectral,
    R_Tags,
    R_Shuffle_New_Round,
    R_Card_Type,
    R_Planet,
    R_Lucky_Mult,
    R_Lucky_Money,
    R_Sigil,
    R_Ouija,
    R_Wheel_of_Fortune,
    R_Gros_Michel,
    R_Cavendish,
    R_Voucher,
    R_Voucher_Tag,
    R_Soul,
    R_Erratic,
    R_Eternal,
    R_Boss,
    R_END
} rtype;

typedef enum RNGSource {
    S_Shop,
    S_Emperor,
    S_High_Priestess,
    S_Judgement,
    S_Wraith,
    S_Arcana,
    S_Celestial,
    S_Spectral,
    S_Standard,
    S_Buffoon,
    S_Vagabond,
    S_Superposition,
    S_Seance,
    S_Sixth_Sense,
    S_Top_Up,
    S_Rare_Tag,
    S_Uncommon_Tag,
    S_Blue_Seal,
    S_Purple_Seal,
    S_8_Ball,
    S_Soul,
    S_Null,
    SOURCE_END
} rsrc;

typedef enum NodeType {
    N_Type,
    N_Source,
    N_Ante,
    N_Resample
} ntype;

// String values for each node
text type_str(int x) {
    switch(x) {
        case R_Joker_Common:             return init_text("Joker1", 6);
        case R_Joker_Uncommon:           return init_text("Joker2", 6);
        case R_Joker_Rare:               return init_text("Joker3", 6);
        case R_Joker_Legendary:          return init_text("Joker4", 6);
        case R_Joker_Rarity:             return init_text("rarity", 6);
        case R_Joker_Edition:            return init_text("edi", 3);
        case R_Misprint:                 return init_text("misprint", 8);
        case R_Standard_Has_Enhancement: return init_text("stdset", 6);
        case R_Enhancement:              return init_text("Enhanced", 8);
        case R_Card:                     return init_text("front", 5);
        case R_Standard_Edition:         return init_text("standard_edition", 16);
        case R_Standard_Has_Seal:        return init_text("stdseal", 7);
        case R_Standard_Seal:            return init_text("stdsealtype", 11);
        case R_Shop_Pack:                return init_text("shop_pack", 9);
        case R_Tarot:                    return init_text("Tarot", 5);
        case R_Spectral:                 return init_text("Spectral", 8);
        case R_Tags:                     return init_text("Tag", 3);
        case R_Shuffle_New_Round:        return init_text("nr", 2);
        case R_Card_Type:                return init_text("cdt", 3);
        case R_Planet:                   return init_text("Planet", 6);
        case R_Lucky_Mult:               return init_text("lucky_mult", 10);
        case R_Lucky_Money:              return init_text("lucky_money", 11);
        case R_Sigil:                    return init_text("sigil", 5);
        case R_Ouija:                    return init_text("ouija", 5);
        case R_Wheel_of_Fortune:         return init_text("wheel_of_fortune", 16);
        case R_Gros_Michel:              return init_text("gros_michel", 11);
        case R_Cavendish:                return init_text("cavendish", 9);
        case R_Voucher:                  return init_text("Voucher", 7);
        case R_Voucher_Tag:              return init_text("Voucher_fromtag", 15);
        case R_Soul:                     return init_text("soul_", 5);
        case R_Erratic:                  return init_text("erratic", 7);
        case R_Eternal:                  return init_text("stake_shop_joker_eternal", 24);
        case R_Boss:                     return init_text("boss", 4);
        default:                         return init_text("", 0);
    }
}
text source_str(int x) {
    switch(x) {
        case S_Shop:           return init_text("sho", 3);
        case S_Emperor:        return init_text("emp", 3);
        case S_High_Priestess: return init_text("pri", 3);
        case S_Judgement:      return init_text("jud", 3);
        case S_Wraith:         return init_text("wra", 3);
        case S_Arcana:         return init_text("ar1", 3);
        case S_Celestial:      return init_text("pl1", 3);
        case S_Spectral:       return init_text("spe", 3);
        case S_Standard:       return init_text("sta", 3);
        case S_Buffoon:        return init_text("buf", 3);
        case S_Vagabond:       return init_text("vag", 3);
        case S_Superposition:  return init_text("sup", 3);
        case S_8_Ball:         return init_text("8ba", 3);
        case S_Seance:         return init_text("sea", 3);
        case S_Sixth_Sense:    return init_text("sixth", 5);
        case S_Top_Up:         return init_text("top", 3);
        case S_Rare_Tag:       return init_text("rta", 3);
        case S_Uncommon_Tag:   return init_text("uta", 3);
        case S_Blue_Seal:      return init_text("blusl", 5);
        case S_Purple_Seal:    return init_text("8ba", 3); // TODO : update this after 8 ball change !!!
        case S_Soul:           return init_text("sou", 3);
        default:               return init_text("", 0);
    }
}
text resample_str(int x) {
    if (x == 0) {
        return init_text("", 0);
    } else {
        text str1 = init_text("_resample", 9);
        text str2 = int_to_str(x+1);
        return text_concat(str1, str2);
    }
}

typedef struct RNGInfo {
    ntype nodeTypes[4];
    int nodeValues[4];
    int depth;
    double rngState;
} rnginfo;

typedef struct Cache {
    #ifdef CACHE_SIZE
    rnginfo nodes[CACHE_SIZE];
    #else
    rnginfo nodes[64];
    #endif
    int nextFreeNode;
} cache;

text node_str(ntype nt, int x) {
    switch (nt) {
        case N_Type: return type_str(x);
        case N_Source: return source_str(x);
        case N_Ante: return int_to_str(x);
        case N_Resample: return resample_str(x);
    }
}
int init_node(cache* c, ntype nodeTypes[], int nodeValues[], int depth) {
    for (int i = 0; i < depth; i++) {
        c->nodes[c->nextFreeNode].nodeTypes[i] = nodeTypes[i];
        c->nodes[c->nextFreeNode].nodeValues[i] = nodeValues[i];
    }
    c->nodes[c->nextFreeNode].depth = depth;
    c->nextFreeNode++;
    return c->nextFreeNode-1;
};