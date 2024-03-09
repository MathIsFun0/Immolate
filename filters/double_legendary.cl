// Searches for a first shop with two packs that give legendary jokers
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int score = 0;
    for (int packIndex = 1; packIndex <= 2; packIndex++) {
        pack pack = pack_info(next_pack(inst, 1));
        item cards[5];
        if (pack.type == Arcana_Pack) {
            arcana_pack(cards, pack.size, inst, 1);
        } else if (pack.type == Spectral_Pack) {
            spectral_pack(cards, pack.size, inst, 1);
        } else {
            return 0; // No arcana/spectral pack -> can just ignore this seed.
        }
        
        for (int i = 0; i < pack.size; i++) {
            if (cards[i] == The_Soul) {
                score++;
            }
        }
    }
    return score/2;
}