// Based on C++ program by 00001H and MathIsFun_

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