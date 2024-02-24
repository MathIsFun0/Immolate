// Searches for a seed with a good setup for high score world record runs
#include "./lib/immolate.cl"
long filter(instance* inst) {
    int passedFilters = 0;

    // Start with a Coupon Tag
    if (next_tag(inst, 1) != Coupon_Tag) return passedFilters;
    passedFilters++;

    // Standard Pack and Spectral Pack in the shop (store information for searching pack contents)
    int standardCards = 0;
    int spectralCards = 0;
    bool isMegaSpectral = false;
    pack pack1 = pack_info(next_pack(inst, 1));
    pack pack2 = pack_info(next_pack(inst, 1));
    if (pack1.type != Standard_Pack) {
        // Assume we have both the packs we want. Pack 1 will always be the Standard Pack now, and Pack 2 will be the Spectral Pack.
        pack temp = pack1;
        pack1 = pack2;
        pack2 = temp;
    }
    if (pack1.type == Standard_Pack) standardCards = pack1.size;
    else return passedFilters;
    if (pack2.type == Spectral_Pack) spectralCards = pack2.size;
    else return passedFilters;
    if (pack2.choices == 2) isMegaSpectral = true;
    passedFilters++;

    // Red Seal Polychrome Hack-Compatible Card
    bool hasRedPoly = 0;
    for (int c = 1; c <= standardCards; c++) {
        item edi = standard_edition(inst, 1);
        item seal = standard_seal(inst, 1);
        item _rank = rank(standard_base(inst, 1));
        if (edi == Polychrome && seal == Red_Seal && _rank <= _5) {
            hasRedPoly = true;
            break;
        }
    }
    if (!hasRedPoly) return passedFilters;
    passedFilters++;

    // Ankh in queue
    // Ectoplasm also being obtainable is a bonus filter that is also checked here
    bool hasAnkh = false;
    bool hasEcto = false;
    bool extraFilterPassed = false;
    for (int i = 0; i < spectralCards; i++) {
        item spectral = next_spectral(inst, S_Spectral, 1, true);
        if (spectral == Ankh) hasAnkh = true;
        if (spectral == Ectoplasm) hasEcto = true;
    }
    if (!hasAnkh) return passedFilters;
    if (hasEcto && isMegaSpectral) extraFilterPassed = true;
    passedFilters++;

    // Invisible Joker and Brainstorm in the first shop
    item jkr1 = shop_joker(inst, 1);
    item jkr2 = shop_joker(inst, 1);
    if (jkr1 == Brainstorm || jkr2 == Brainstorm) passedFilters++; // Extra stepping stone if there's only Brainstorm
    if ((jkr1 == Invisible_Joker && jkr2 == Brainstorm)||(jkr1 == Brainstorm && jkr2 == Invisible_Joker)) {
        if (extraFilterPassed) return 1000;
        return 999;
    }
    return passedFilters;
}