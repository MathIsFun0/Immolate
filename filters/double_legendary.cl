// Searches for a first ante with two packs that give legendary jokers
#include "lib/immolate.cl"
long filter(instance* inst) {
    int score = 0;
    next_pack(inst, 1); //the first pack will always be a Buffoon Pack
    for (int packIndex = 1; packIndex <= 3; packIndex++) {
        pack _pack = pack_info(next_pack(inst, 1));
        item cards[5];
        if (_pack.type == Arcana_Pack) {
            arcana_pack(cards, _pack.size, inst, 1);
        } else if (_pack.type == Spectral_Pack) {
            spectral_pack(cards, _pack.size, inst, 1);
        } else continue;
        
        for (int i = 0; i < _pack.size; i++) {
            if (cards[i] == The_Soul) {
                score++;
            }
        }
    }
    return score/2;
}