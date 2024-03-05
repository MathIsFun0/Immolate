// Searches for a first shop with two packs that give legendary jokers
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int score = 0;
    for (int i = 1; i <= 2; i++) {
        pack pack = pack_info(next_pack(inst, 1));
        if (pack.type == Arcana_Pack || pack.type == Spectral_Pack) {
            item cards[5];
            (pack.type == Arcana_Pack ? arcana_pack(cards, pack.size, inst, 1) : spectral_pack(cards, pack.size, inst, 1));
            for (int i = 0; i < pack.size; i++) {
                if (cards[i] == The_Soul) score++;
            }
        };
    }
    return score/2;
}