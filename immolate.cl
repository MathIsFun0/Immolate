// Based on C++ program by 00001H and MathIsFun_
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

// Pseudohash
unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
double fract(double f) {
    return f-floor(f);
}
double roundDigits(double f, int d) {
    double power = pow((double)10, d);
    return round(f*power)/power;
}

double pseudohash(__constant char* s, size_t stringLen) {
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

double c16_pseudohash(char16 s) {
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
char8 s_to_string(struct Seed* s) {
    char8 str;
    for (int i = 0; i < 8; i++) {
        str[i]=s_char_at(s, i);
    }
    return str;
}

void s_print(struct Seed* s) {
    char8 s_str = s_to_string(s);
    printf("%c%c%c%c%c%c%c%c",s_str[0],s_str[1],s_str[2],s_str[3],s_str[4],s_str[5],s_str[6],s_str[7]);
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

// Enums, helpers, and lists
enum RandomType {
    R_Joker,
    R_Edition,
    R_JokerRarity,
    R_Tarot,
    R_Spectral,
    R_Aura,
    R_Tags,
    R_Misprint,
    R_Lucky,
    R_Nothing,
    R_END
};

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
    Gold_Seal,
    Red_Seal,
    Blue_Seal,
    Purple_Seal,
    SEAL_END,

    // Editions
    E_BEGIN,
    Base,
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

// Note: These functions assume string contains 16 chars, uses null as end of string

char16 rt_to_string(enum RandomType rt) {
    switch (rt) {
        // char16 literals are no joker...
        case R_Joker:       return (char16)('j','o','k','e','r',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Edition:     return (char16)('e','d','i','t','i','o','n',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_JokerRarity: return (char16)('r','a','r','i','t','y',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Tarot:       return (char16)('t','a','r','o','t',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Spectral:    return (char16)('s','p','e','c','t','r','a','l',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Aura:        return (char16)('a','u','r','a',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Tags:        return (char16)('t','a','g','s',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Misprint:    return (char16)('m','i','s','p','r','i','n','t',' ',' ',' ',' ',' ',' ',' ',' ');
        case R_Lucky:       return (char16)('p','a','y','o','u','t','_','c','h','i','p',' ',' ',' ',' ',' ');
        default:          return (char16)(' ');
    }
}

char16 char_repr(enum RandomType rt, struct Seed seed) {
    char16 rt_str = rt_to_string(rt);
    char8 s_str = s_to_string(&seed);
    char16 result;
    int i = 0;
    while (i < 16) {
        if (rt_str[i] == ' ') {
            break;
        }
        result[i] = rt_str[i];
        i++;
    }
    for (int x = i; x < 16; x++) {
        if (x-i<8) {
            result[x] = s_str[x-i];
        } else {
            result[x] = ' ';
        }
    }
    return result;
}

// Instance
struct GameInstance {
    struct Seed seed;
    double rngCache[R_END];
    double hashedSeed;
    struct LuaRandom rng;
};
struct GameInstance i_new(struct Seed s) {
    struct GameInstance inst;
    inst.seed = s;
    for (int i = 0; i < R_END; i++) {
        inst.rngCache[i] = INFINITY;
    }
    inst.hashedSeed = c16_pseudohash(c8_as_c16(s_to_string(&s)));
    return inst;
}
double i_get_seed(struct GameInstance* inst, enum RandomType r) {
    if (inst->rngCache[r] == INFINITY) {
        inst->rngCache[r] = c16_pseudohash(char_repr(r, inst->seed));
    }
    inst->rngCache[r] = roundDigits(fract(inst->rngCache[r]*124.72431234+532.134453421),13);
    return (inst->rngCache[r]+inst->hashedSeed)/2.0;
}
double i_random(struct GameInstance* inst, enum RandomType r) {
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
}