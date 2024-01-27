// Based on C++ program by 00001H and MathIsFun_
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

// Pseudohash
struct Text {
    char str[256];
    int len;
};

inline struct Text init_text(__constant char* str, int len) {
    struct Text t;
    for (int i = 0; i < len; i++){
        t.str[i] = str[i];
    }
    t.len = len;
    return t;
}

struct Text text_concat(struct Text a, struct Text b) {
    struct Text temp = a;
    for (int j = 0; j < b.len; j++) {
        temp.str[a.len+j] = b.str[j];
    }
    temp.len += b.len;
    return temp;
}

double fract(double f) {
    return f-floor(f);
}

double pseudohash(struct Text s) {
    //resizeString(&s, 16, ' ');
    double num = 1;
    for (int i = s.len - 1; i >= 0; i--) {
        num = fract((1.1239285023/num)*s.str[i]*3.14159265358979323846);
    }
    return num;
}

double pseudohash8(char8 s) {
    //resizeString(&s, 16, ' ');
    double num = 1;
    for (int i = 7; i >= 0; i--) {
        num = fract((1.1239285023/num)*s[i]*3.14159265358979323846);
    }
    return num;
}

// Pseudohash Legacy
unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
double roundDigits(double f, int d) {
    double power = pow((double)10, d);
    return round(f*power)/power;
}

double pseudohash_legacy(__constant char* s, size_t stringLen) {
    //resizeString(&s, 16, ' ');
    int mask = 0;
    if (stringLen >= 16) {
        // Use first 16 chars
        for (int i = 15; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    } else {
        // Use space (32) for empty chars
        for (int i = 15; i >= stringLen; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+32);
        }
        for (int i = stringLen-1; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    }
    return roundDigits(fract(sqrt((double)(abs(mask)))),13);
}

double c16_pseudohash_legacy(char16 s) {
    //resizeString(&s, 16, ' ');
    int mask = 0;
    for (int i = 15; i >= 0; i--) {
        mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
    }
    return roundDigits(fract(sqrt((double)(abs(mask)))),13);
}

char16 c8_as_c16(char8 c8) {
    char16 c16 = ' ';
    for (int i = 0; i < 8; i++) {
        c16[i] = c8[i];
    }
    return c16;
}

// math.random

union DoubleLong {
    double d;
    ulong ul;
};

struct LuaRandom {
    ulong4 state;
    union DoubleLong out;
};

void _randint(struct LuaRandom* lr) {
    ulong z, r = 0;
    z = lr->state[0];
    z = (((z<<31)^z)>>45)^((z&((ulong)(long)-1<<1))<<18);
    r ^= z;
    lr->state[0] = z;
    z = lr->state[1];
    z = (((z<<19)^z)>>30)^((z&((ulong)(long)-1<<6))<<28);
    r ^= z;
    lr->state[1] = z;
    z = lr->state[2];
    z = (((z<<24)^z)>>48)^((z&((ulong)(long)-1<<9))<<7);
    r ^= z;
    lr->state[2] = z;
    z = lr->state[3];
    z = (((z<<21)^z)>>39)^((z&((ulong)(long)-1<<17))<<8);
    r ^= z;
    lr->state[3] = z;
    lr->out.ul = r;
}

void randdblmem(struct LuaRandom* lr) {
    _randint(lr);
    lr->out.ul = (lr->out.ul&4503599627370495)|4607182418800017408;
}

struct LuaRandom randomseed(double d) {
    struct LuaRandom lr;
    uint r = 0x11090601;
    size_t i;
    for (i = 0; i < 4; i++) {
        ulong u;
        uint m = 1 << (r&255);
        r >>= 8;
        d = d*3.14159265358979323846+2.7182818284590452354;
        lr.out.d = d;
        u = lr.out.ul;
        if (u<m) u+=m;
        lr.state[i] = u;
    }
    for (i = 0; i < 10; i++) {
        _randint(&lr);
    }
    return lr;
}
double random(struct LuaRandom* lr) {
    randdblmem(lr);
    lr->out.d -= 1.0;
    return lr->out.d;
}
ulong randint(struct LuaRandom* lr, ulong min, ulong max) {
    random(lr);
    return (ulong)(lr->out.d*(max-min+1))+min;
}

// SEEDS

// Some important definitions
__constant char SEEDCHARS[] = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
__constant int NUM_CHARS = 35;
__constant long NUM_SEEDS = 2251875390625; //35^8
__constant int MAX_RANKED_SEEDS = 1000;

struct Seed {
    ulong8 data;
};
struct Seed s_new_empty() {
    struct Seed seed;
    seed.data = 0; //fills with zeros
    return seed;
}
struct Seed s_new(char8 str_seed) {
    struct Seed seed;
    for (int i = 0; i < 8; i++) {
        for (char j = 0; j < NUM_CHARS; j++) {
            if (SEEDCHARS[j] == str_seed[i]) {
                seed.data[i] = j;
            }
        }
    }
    return seed;
}
void s_next(struct Seed* s) {
    bool carry = true;
    for (int i = 1; i <= 8; i++) {
        int j = 8-i;
        if (carry) {
            s->data[j]++;
            if ((carry = (s->data[j]>=NUM_CHARS))) {
                s->data[j] -= NUM_CHARS;
            }
        } else break;
    }
}
void s_skip(struct Seed* s, long n) {
    long carry = n;
    for (int i = 1; i <= 8; i++) {
        int j = 8-i;
        if (carry) {
            s->data[j] += carry;
            if ((carry = (s->data[j]/NUM_CHARS))) {
                s->data[j] %= NUM_CHARS;
            }
        } else break;
    }
}
char s_char_at(struct Seed* s, int c) {
    return SEEDCHARS[s->data[c]];
}
long s_tell(struct Seed* s) {
    long loc = 0;
    long mult = 0;
    for (int i = 0; i < 8; i++) {
        loc += s->data[i]*mult;
        mult *= NUM_CHARS;
    }
    return loc;
}
struct Text s_to_string(struct Seed* s) {
    struct Text str;
    for (int i = 0; i < 8; i++) {
        str.str[i]=s_char_at(s, i);
    }
    str.len = 8;
    return str;
}

void s_print(struct Seed* s) {
    struct Text s_str = s_to_string(s);
    printf("%c%c%c%c%c%c%c%c",s_str.str[0],s_str.str[1],s_str.str[2],s_str.str[3],s_str.str[4],s_str.str[5],s_str.str[6],s_str.str[7]);
}

struct RankedSeedList {
    long rank;
    int numSeeds;
    struct Seed seeds[MAX_RANKED_SEEDS]; //arbitrary max number of seeds, because OpenCL...
    bool lock;
};
struct RankedSeedList rs_new(long r) {
    struct RankedSeedList rs;
    rs.rank = r;
    rs.numSeeds = 0;
    return rs;
}
void rs_init(struct RankedSeedList* rs, long r) {
    rs->rank = r;
    rs->numSeeds = 0;
}
long rs_score(struct RankedSeedList* rs) {
    return rs->rank;
}
void rs_clear(struct RankedSeedList* rs, long rank) {
    rs->numSeeds = 0;
    rs->rank = rank;
}
void rs_add(struct RankedSeedList* rs, long rank, struct Seed seed) {
    if (rank<rs->rank) return;
    if (rank>rs->rank) rs_clear(rs, rank);
    if (rs->numSeeds >= MAX_RANKED_SEEDS) return;
    rs->seeds[rs->numSeeds] = seed;
    rs->numSeeds++;
    s_print(&seed);
    printf(" (%li)\n",rank);
}
void rs_merge(struct RankedSeedList* rs1, struct RankedSeedList* rs2) {
    if (rs1->rank < rs2->rank) {
        rs1 = rs2;
    } else if (rs1->rank > rs2->rank) {
        return;
    }
    for (int i = 0; i < rs2->numSeeds; i++) {
        rs_add(rs1, rs1->rank, rs2->seeds[i]);
    }
}


// Contains every kind of thing you could search for!
// Updated as of 0.9.3
enum Item {
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
    Spare_Trousers,
    Misprint,
    Green_Joker,
    Photograph,
    Fortune_Teller,
    Drunkard,
    Diet_Cola,
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
    Obelisk,
    Ramen,
    Reserved_Parking,
    Bull,
    Throwback,
    Flower_Pot,
    Trading_Card,
    J_U_END,

    J_R_BEGIN,
    Seance,
    Baseball_Card,
    Hit_the_Road,
    The_Trio,
    Invisible_Joker,
    Brainstorm,
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
    Skip_Tag,
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
    Spades,
    Clubs,
    Hearts,
    Diamonds,
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

    ITEMS_END
};

// The ordering of these matter - it is the game's internal order
enum Item RareJokers[] = {
    /*Blueprint,
    Smeared_Joker,
    DNA,
    Joker_Stencil*/
};

enum Item UncommonJokers[] = {
    /*Ceremonial_Dagger,
    Four_Fingers,
    Hiker,
    Burglar,
    Loyalty_Card,
    Astronomer,
    Runner,
    _8_Ball,
    Cartomancer,
    Banner,
    Constellation,
    Raised_Fist,
    Marble_Joker,
    Dusk,
    Blackboard,
    Fibonacci*/
};

enum Item CommonJokers[] = {
    /*Supernova,
    Droll_Joker,
    Golden_Joker,
    Delayed_Gratification,
    Scary_Face,
    Ride_the_Bus,
    Even_Steven,
    Half_Joker,
    Business_Card,
    Gros_Michel,
    Scholar,
    Egg,
    Ice_Cream,
    Mystic_Summit,
    Splash,
    Mad_Joker,
    Abstract_Joker,
    Odd_Todd,
    To_Do_List,
    Zany_Joker,
    Crazy_Joker,
    Joker,
    Juggler,
    Misprint,
    Superposition*/
};


// RNG Cache
enum RandomType {
    R_Joker_Common,
    R_Joker_Uncommon,
    R_Joker_Rare,
    R_END
};
enum RNGSource {
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
    S_Top_Up,
    S_Rare_Tag,
    S_Uncommon_Tag,
    SOURCE_END
};
enum NodeType {
    N_Root,
    N_Type,
    N_Source,
    N_Ante,
    N_Resample
};
struct Text int_to_str(int x) {
    // Get length
    int temp = x;
    int digits = 1;
    while (temp / 10 > 0) {
        digits++;
        temp /= 10;
    }
    struct Text out;
    for (int i = digits-1; i >= 0; i--) {
        out.str[i] = '0' + x%10;
        x/=10;
    }
    out.len = digits;
    return out;
}
// String values for each node
struct Text type_str(int x) {
    switch(x) {
        case R_Joker_Common:   return init_text("Joker1", 6);
        case R_Joker_Uncommon: return init_text("Joker2", 6);
        case R_Joker_Rare:     return init_text("Joker3", 6);
        default:               return init_text("", 0);
    }
}
struct Text source_str(int x) {
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
        case S_Seance:         return init_text("sea", 3);
        case S_Top_Up:         return init_text("top", 3);
        case S_Rare_Tag:       return init_text("rta", 3);
        case S_Uncommon_Tag:   return init_text("uta", 3);
        default:               return init_text("", 0);
    }
}
struct Text resample_str(int x) {
    if (x == 0) {
        return init_text("", 0);
    } else {
        struct Text str1 = init_text("_resample", 9);
        struct Text str2 = int_to_str(x+1);
        return text_concat(str1, str2);
    }
}

struct CNWrapper {
    struct CacheNode* node;
};
struct CacheNode {
    struct CNWrapper children[256];
    enum NodeType nodeType;
    double rngState;
};

struct Text node_str(enum NodeType nt, int x) {
    switch (nt) {
        case N_Root: return init_text("", 0);
        case N_Type: return type_str(x);
        case N_Source: return source_str(x);
        case N_Ante: return int_to_str(x);
        case N_Resample: return resample_str(x);
    }
}
struct CacheNode init_node(enum NodeType nodeType) {
    struct CacheNode cn;
    cn.nodeType = nodeType;
    return cn;
};
// NODE INITIALIZATION
// Returns true if that node wasn't made before - so we have to initialize the starting value
bool init_node_child(struct CacheNode* cn, enum NodeType nodeType, int idx) {
    if (cn->children[idx].node != NULL) {
        struct CacheNode newNode = init_node(nodeType);
        cn->children[idx].node = &newNode;
        return true;
    }
    return false;
}
bool init_node_child_2D(struct CacheNode* cn, enum NodeType nt1, int idx1, enum NodeType nt2, int idx2) {
    if (cn->children[idx1].node != NULL) {
        struct CacheNode newNode = init_node(nt1);
        cn->children[idx1].node = &newNode;
    }   
    return init_node_child(cn->children[idx1].node, nt2, idx2);
}
bool init_node_child_3D(struct CacheNode* cn, enum NodeType nt1, int idx1, enum NodeType nt2, int idx2, enum NodeType nt3, int idx3) {
    if (cn->children[idx1].node != NULL) {
        struct CacheNode newNode = init_node(nt1);
        cn->children[idx1].node = &newNode;
    }   
    return init_node_child_2D(cn->children[idx1].node, nt2, idx2, nt3, idx3);
}
bool init_node_child_4D(struct CacheNode* cn, enum NodeType nt1, int idx1, enum NodeType nt2, int idx2, enum NodeType nt3, int idx3, enum NodeType nt4, int idx4) {
    if (cn->children[idx1].node != NULL) {
        struct CacheNode newNode = init_node(nt1);
        cn->children[idx1].node = &newNode;
    }   
    return init_node_child_3D(cn->children[idx1].node, nt2, idx2, nt3, idx3, nt4, idx4);
}

// Instance
struct GameInstance {
    struct Seed seed;
    struct CacheNode rngCache;
    double hashedSeed;
    struct LuaRandom rng;
};
struct GameInstance i_new(struct Seed s) {
    struct GameInstance inst;
    inst.seed = s;
    for (int i = 0; i < R_END; i++) {
        inst.rngCache[i] = INFINITY;
    }
    inst.hashedSeed = pseudohash(s_to_string(&s));
    return inst;
}
double get_node_child(struct GameInstance* inst, enum NodeType nodeType, int idx) {
    if (init_node_child(inst->rngCache, nodeType, idx)) {
        inst->rngCache->children[idx].node->rngState = pseudohash(text_concat(s_to_string(&inst->seed), node_str(nodeType, idx)));
    }
    inst->rngCache->children[idx].node->rngState = roundDigits(fract(inst->rngCache->children[idx].node->rngState*1.72431234+2.134453429141),13);
}
/*double i_random(struct GameInstance* inst, enum RandomType r) {
    if (r != R_Nothing) {
        inst->rng = randomseed(i_get_seed(inst, r));
    }
    return random(&(inst->rng));
}
ulong i_randint(struct GameInstance* inst, enum RandomType r, ulong min, ulong max) {
    if (r != R_Nothing) {
        inst->rng = randomseed(i_get_seed(inst, r));
    }
    return randint(&(inst->rng), min, max);
}

enum Item i_randchoice(struct GameInstance* inst, enum RandomType r, __global enum Item items[], size_t item_size) {
    if (r != R_Nothing) {
        inst->rng = randomseed(i_get_seed(inst, r));
    }
    return items[randint(&(inst->rng), 0, item_size/sizeof(enum Item)-1)];
}

// Helper functions for common actions
enum Item i_random_joker(struct GameInstance* inst) {
    double rng = i_random(inst, R_JokerRarity);
    return i_randchoice(inst, R_Joker, (rng>0.97?RareJokers:(rng>0.82?UncommonJokers:CommonJokers)), (rng>0.97?sizeof(RareJokers):(rng>0.82?sizeof(UncommonJokers):sizeof(CommonJokers))));
}

enum Item i_random_edition(struct GameInstance* inst) {
    double rng = i_random(inst, R_Edition);
    if (rng > 0.997) return Negative;
    if (rng > 0.994) return Polychrome;
    if (rng > 0.98) return Holographic;
    if (rng > 0.96) return Foil;
    return No_Edition;
}*/