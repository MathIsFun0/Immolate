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
// For now, it is just the 0.9.0 demo jokers since this will all change in 0.9.2 anyway.
// The names are designed so that they can be easily converted to their readable name with a regex or something...
enum Item {
    RETRY,

    // Jokers
    Joker,
    Zany_Joker,
    Mad_Joker,
    Crazy_Joker,
    Droll_Joker,
    Half_Joker,
    Ice_Cream,
    Juggler,
    Runner,
    Golden_Joker,
    Joker_Stencil,
    Four_Fingers,
    Ceremonial_Dagger,
    Banner,
    Marble_Joker,
    Loyalty_Card,
    _8_Ball,
    Misprint,
    Blueprint,
    Raised_Fist,
    Fibonacci,
    Cartomancer,
    Astronomer,
    Abstract_Joker,
    Delayed_Gratification,
    Gros_Michel,
    Even_Steven,
    Odd_Todd,
    Scholar,
    Business_Card,
    Supernova,
    Ride_the_Bus,
    Blackboard,
    Egg,
    Burglar,
    Scary_Face,
    Mystic_Summit,
    Dusk,
    DNA,
    Splash,
    Smeared_Joker,
    Constellation,
    Hiker,
    Superposition,
    To_Do_List,

    // Editions
    No_Edition,
    Foil,
    Holographic,
    Polychrome,
    Negative,

    I_END
};

// The ordering of these matter - it is the game's internal order
enum Item RareJokers[] = {
    Blueprint,
    Smeared_Joker,
    DNA,
    Joker_Stencil
};

enum Item UncommonJokers[] = {
    Ceremonial_Dagger,
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
    Fibonacci
};

enum Item CommonJokers[] = {
    Supernova,
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
    Superposition
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