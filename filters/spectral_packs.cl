// Searches for NUMBER_OF_CONSECUTIVE_SHOPS that each give 2 copies of desired Spectral_Card
#include "lib/immolate.cl"

int NUMBER_OF_CONSECUTIVE_SHOPS = 2;

//Choose one of the following Spectrals
//Ankh, Aura, Black_Hole, Cryptid, Deja_Vu, Ectoplasm, Familiar, Grim, Hex, Immolate, Incantation, Medium, Ouija, Sigil, Talisman, The_Soul, Trance, Wraith

item Spectral_Card = Ankh;

long filter(instance* inst) {
    int score = 0;
    for (int packIndex = 1; packIndex <= 2 * NUMBER_OF_CONSECUTIVE_SHOPS; packIndex++) {
        pack _pack = pack_info(next_pack(inst, 1));
        item cards[5];
        if (_pack.type == Spectral_Pack) {
            spectral_pack(cards, _pack.size, inst, 1);
        } else {
            return 0; // No spectral pack -> can just ignore this seed.
        }
        for (int i = 0; i < _pack.size; i++) {
            if (cards[i] == Spectral_Card ) {
                score++;
            }
        }
    }
    return score/2;
}