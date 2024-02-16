// Some important definitions
__constant char SEEDCHARS[] = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
__constant int NUM_CHARS = 35;
__constant long NUM_SEEDS = 2251875390625; //35^8
__constant int MAX_RANKED_SEEDS = 1000;

typedef struct Seed {
    ulong8 data;
} seed;
seed s_new_empty() {
    seed seed;
    seed.data = 0; //fills with zeros
    return seed;
}
seed s_new(__constant char* str_seed, int seed_size) {
    seed seed;
    for (int i = 0; i < seed_size; i++) {
        for (char j = 0; j < NUM_CHARS; j++) {
            if (SEEDCHARS[j] == str_seed[i]) {
                seed.data[i] = j;
            }
        }
    }
    return seed;
}

seed s_new_c8(char8 str_seed) {
    seed seed;
    for (int i = 0; i < 8; i++) {
        for (char j = 0; j < NUM_CHARS; j++) {
            if (SEEDCHARS[j] == str_seed[i]) {
                seed.data[i] = j;
            }
        }
    }
    return seed;
}
void s_next(seed* s) {
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
void s_skip(seed* s, long n) {
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
char s_char_at(seed* s, int c) {
    return SEEDCHARS[s->data[c]];
}
long s_tell(seed* s) {
    long loc = 0;
    long mult = 0;
    for (int i = 0; i < 8; i++) {
        loc += s->data[i]*mult;
        mult *= NUM_CHARS;
    }
    return loc;
}
text s_to_string(seed* s) {
    text str;
    for (int i = 0; i < 8; i++) {
        str.str[i]=s_char_at(s, i);
    }
    str.len = 8;
    return str;
}

void s_print(seed* s) {
    text s_str = s_to_string(s);
    printf("%c%c%c%c%c%c%c%c",s_str.str[0],s_str.str[1],s_str.str[2],s_str.str[3],s_str.str[4],s_str.str[5],s_str.str[6],s_str.str[7]);
}
void s_print_rank(seed* s, long rank) {
    text s_str = s_to_string(s);
    printf("%c%c%c%c%c%c%c%c (%li)\n",s_str.str[0],s_str.str[1],s_str.str[2],s_str.str[3],s_str.str[4],s_str.str[5],s_str.str[6],s_str.str[7],rank);
}

typedef struct RankedSeedList {
    long rank;
    int numSeeds;
    seed seeds[MAX_RANKED_SEEDS]; //arbitrary max number of seeds, because OpenCL...
    bool lock;
} rslist;
rslist rs_new(long r) {
    rslist rs;
    rs.rank = r;
    rs.numSeeds = 0;
    return rs;
}
void rs_init(rslist* rs, long r) {
    rs->rank = r;
    rs->numSeeds = 0;
}
long rs_score(rslist* rs) {
    return rs->rank;
}
void rs_clear(rslist* rs, long rank) {
    rs->numSeeds = 0;
    rs->rank = rank;
}
void rs_add(rslist* rs, long rank, seed seed) {
    if (rank<rs->rank) return;
    if (rank>rs->rank) rs_clear(rs, rank);
    if (rs->numSeeds >= MAX_RANKED_SEEDS) {
        s_print_rank(&seed,rank);
        return;
    }
    rs->seeds[rs->numSeeds] = seed;
    rs->numSeeds++;
    s_print_rank(&seed,rank);
}
void rs_merge(rslist* rs1, rslist* rs2) {
    if (rs1->rank < rs2->rank) {
        rs1 = rs2;
    } else if (rs1->rank > rs2->rank) {
        return;
    }
    for (int i = 0; i < rs2->numSeeds; i++) {
        rs_add(rs1, rs1->rank, rs2->seeds[i]);
    }
}


