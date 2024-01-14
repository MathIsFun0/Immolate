enum RandomType {
    Joker,
    Edition,
    JokerRarity,
    Tarot,
    Spectral,
    Aura,
    Tags,
    Misprint,
    Nothing,
    RT_END
};

// Note: These functions assume string contains 16 chars, uses null as end of string

char16 rt_to_string(enum RandomType rt) {
    switch (rt) {
        // char16 literals are no joker...
        case Joker:       return (char16)('j','o','k','e','r',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case Edition:     return (char16)('e','d','i','t','i','o','n',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case JokerRarity: return (char16)('r','a','r','i','t','y',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case Tarot:       return (char16)('t','a','r','o','t',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case Spectral:    return (char16)('s','p','e','c','t','r','a','l',' ',' ',' ',' ',' ',' ',' ',' ');
        case Aura:        return (char16)('a','u','r','a',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case Tags:        return (char16)('t','a','g','s',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
        case Misprint:    return (char16)('m','i','s','p','r','i','n','t',' ',' ',' ',' ',' ',' ',' ',' ');
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

struct GameInstance {
    struct Seed seed;
    double rngCache[RT_END];
    double hashedSeed;
    struct LuaRandom rng;
};
struct GameInstance i_new(struct Seed s) {
    struct GameInstance inst;
    inst.seed = s;
    for (int i = 0; i < RT_END; i++) {
        inst.rngCache[i] = INFINITY;
    }
    inst.hashedSeed = c16_pseudohash(c8_as_c16(s_to_string(&s)));
    return inst;
}
double i_get_seed(struct GameInstance* inst, enum RandomType r) {
    if (inst->rngCache[r] == INFINITY) {
        inst->rngCache[r] = c16_pseudohash(char_repr(r, inst->seed));
    }
    printf("%.13lf\n",inst->rngCache[r]*124.72431234);
    inst->rngCache[r] = roundDigits(fract(532.134453421+inst->rngCache[r]*124.72431234),13);
    return (inst->rngCache[r]+inst->hashedSeed)/2.0;
}
double i_random(struct GameInstance* inst, enum RandomType r) {
    if (r != Nothing) {
        inst->rng = randomseed(i_get_seed(inst, r));
    }
    return random(&(inst->rng));
}
ulong i_randint(struct GameInstance* inst, enum RandomType r, ulong min, ulong max) {
    if (r != Nothing) {
        double x = i_get_seed(inst, r);
        inst->rng = randomseed(x);
    }
    return randint(&(inst->rng), min, max);
}