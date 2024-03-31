// Some important definitions
__constant char SEEDCHARS[] = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
__constant int NUM_CHARS = 35;

typedef struct Seed {
    ulong data[8];
    int len;
} seed;
seed s_new_empty() {
    seed seed;
    for (int i = 0; i < 8; i++) seed.data[i] = 0;
    seed.len = 0;
    return seed;
}


seed s_new_c8(char8 str_seed) {
    seed seed;
    char* s_seed = &str_seed;
    for (int i = 0; i < 8; i++) {
        if (s_seed[i] == '\0') {
            seed.len = i;
            return seed;
        }
        for (char j = 0; j < NUM_CHARS; j++) {
            if (SEEDCHARS[j] == s_seed[i]) {
                seed.data[i] = j;
            }
        }
    }
    seed.len = 8;
    return seed;
}

char s_char_at(seed* s, int c) {
    return SEEDCHARS[s->data[c]];
}
long s_tell(seed* s) {
    long loc = 0;
    long mult = 0;
    for (int i = 0; i < s->len; i++) {
        loc += s->data[i]*mult;
        mult *= NUM_CHARS;
    }
    return loc;
}
text s_to_string(seed* s) {
    text str;
    for (int i = 0; i < s->len; i++) {
        str.str[i]=s_char_at(s, i);
    }
    set_text_length(&str, s->len);
    return str;
}

void s_print(seed* s) {
    text s_str = s_to_string(s);
    printf("%s",s_str.str);
}
void s_print_rank(seed* s, long rank) {
    text s_str = s_to_string(s);
    printf("%s (%li)\n",s_str.str,rank);
}
void s_next(seed* s) {
    bool carry = true;
    while (carry) {
        for (int i = 1; i <= s->len; i++) {
            int j = s->len-i;
            if (carry) {
                s->data[j]++;
                if ((carry = (s->data[j]>=NUM_CHARS))) {
                    s->data[j] -= NUM_CHARS;
                }
            } else break;
        }
        if (carry) {
            if (s->len<8) {
                for (int i = 7; i > 0; i--) {
                    s->data[i] = 0;
                }
                s->data[0] = 0;
                s->len++;
            } else {
                s->len = 0;
            }
            carry = false;
        }
    }
}
void s_skip(seed* s, long n) {
    for (int i = 0; i < n; i++) s_next(s);
}