// Searches for a first shop with two packs that give legendary jokers
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int score = 0;
    for (int ante = 1; ante <= 2; ante++) {
        pack pack = pack_info(next_pack(inst, 1));
        if (pack.type == Arcana_Pack || pack.type == Spectral_Pack) {
            item cards[5];
            (pack.type == Arcana_Pack ? arcana_pack(cards, pack.size, inst, 1) : spectral_pack(cards, pack.size, inst, 1));
            for (int ante = 0; ante < pack.size; ante++) {
                if (cards[ante] == The_Soul) score++;
            }
        };
    }
    return score/2;
}