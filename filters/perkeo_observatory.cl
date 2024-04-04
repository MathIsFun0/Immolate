// Searches for seeds with Observatory in ante 2 and Perkeo in ante 1 or 2
#include "lib/immolate.cl"
long filter(instance* inst) {
    init_locks(inst, 1, false, false);
    if (next_voucher(inst, 1) == Telescope) {
        activate_voucher(inst, Telescope);
        if (next_voucher(inst, 2) != Observatory) return 0;
    } else return 0;

    // Search for Perkeo now
    int antes[5] = {1, 1, 2, 2, 2};
    for (int i = 0; i < 5; i++) {
        pack _pack = pack_info(next_pack(inst, antes[i]));
        item cards[5];
        if (_pack.type == Arcana_Pack) {
            arcana_pack(cards, _pack.size, inst, antes[i]);
        } else if (_pack.type == Spectral_Pack) {
            spectral_pack(cards, _pack.size, inst, antes[i]);
        } else continue;
        for (int c = 0; c < _pack.size; c++) {
            if (cards[c] == The_Soul) {
                if (next_joker(inst, S_Soul, antes[i]) == Perkeo) return 1;
            }
        }
    }
    return 0;
}