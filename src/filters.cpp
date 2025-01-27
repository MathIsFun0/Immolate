#include "filters.hpp"
#include <vector>
#include <numeric>

void Filter::parseJSON(std::string input) {
    //Populate Lists with variables from the Json
    return;
}


long searchWithFilter(Instance inst, Filter &filter) {
    int searchSize = filter.searchList.size();
    int modSize = filter.instanceModList.size();
    int amountFoundList[MAX_SEARCH_LIST_SIZE] = {0};

    for (int ante = 1; ante <= filter.maxAnte; ante++) {
        for(int m = 1; m <= modSize; m++) {
            if(m >= filter.instanceModList[m-1].startAnte && m <= filter.instanceModList[m-1].endAnte) {
                inst.unlock(filter.instanceModList[m].modifier);
            }
        }
        for (int i = 0; i < searchSize; i++) {
            if (ante > filter.searchList[i].maxAnte) { continue; }
            amountFoundList[i] += searchWithObject(inst, filter.searchList[i], ante);
        }
    }

    //Check if you have found all the items in a list
    int correct_amounts = 0;
    for (int i = 0; i < searchSize; i++) {
        if (amountFoundList[i] >= filter.searchList[i].amount) {
            correct_amounts++;
        }
    }
    if (correct_amounts == searchSize) {
        return 1;
    }

    return 0;

}

inline long searchWithObject(Instance inst, SearchObject &searchObject, int ante){
    switch (searchObject.searchType) {
        case SearchableType::Joker:
            return searchForJoker(inst, searchObject, ante);
        case SearchableType::Tarot:
            return searchForTarot(inst, searchObject, ante);
        case SearchableType::Planet:
            return searchForPlanet(inst, searchObject, ante);
        case SearchableType::Spectral:
            return searchForSpectral(inst, searchObject, ante);
        case SearchableType::Card:
            return searchForCard(inst, searchObject, ante);   
        case SearchableType::Tag:
            return searchForTag(inst, searchObject, ante);
        case SearchableType::Voucher:
            return searchForVoucher(inst, searchObject, ante); 
        default:
            return 0;
    }
}

long searchForJoker(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;

    //I created nextJokerOnly to save on mem
    //for now we'll just use storedepth given

    for(int s = 1; s <= searchObject.storeDepth; s++) {
        if (inst.nextJokerOnly(ItemSource::Shop, ante) == searchObject.item) {
            amount_found++;
        }
    }

    for (int p = 1; p <= max_packs; p++) {
        if (inst.nextJokerOnly(ItemSource::Buffoon_Pack, ante) == searchObject.item) {
            amount_found++;
        }
    }

    return amount_found;
}

long searchForTarot(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;
    int max_store_items = 10;
        if (ante > 1) max_store_items = 50;

    //Check packs
    for (int p = 1; p <= max_packs; p++) {
        Pack pack = packInfo(inst.nextPack(ante));
        if (pack.type == Item::Arcana_Pack || 
            pack.type == Item::Jumbo_Arcana_Pack || 
            pack.type == Item::Mega_Arcana_Pack) {
                auto packContents = inst.nextArcanaPack(pack.size, 1);
                for (int x = 0; x < pack.size; x++) {
                    if (packContents[x] == searchObject.item) {
                        amount_found++;
                    }
                }
        }
        continue;
    }

    //Check shop
    for (int s = 1; s <= max_store_items; s++) {
        ShopItem shop_item = inst.nextShopItem(ante);
        if (shop_item.item == searchObject.item) {
            amount_found++;
        }
    }

    return amount_found;
}

long searchForPlanet(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;
    int max_store_items = 10;
        if (ante > 1) max_store_items = 50;

    //Check packs
    for (int p = 1; p <= max_packs; p++) {
        Pack pack = packInfo(inst.nextPack(ante));
        if (pack.type == Item::Celestial_Pack || 
            pack.type == Item::Jumbo_Celestial_Pack || 
            pack.type == Item::Mega_Celestial_Pack) {
                auto packContents = inst.nextArcanaPack(pack.size, 1);
                for (int x = 0; x < pack.size; x++) {
                    if (packContents[x] == searchObject.item) {
                        amount_found++;
                    }
                }
        }
        continue;
    }

    //Check shop
    for (int s = 1; s <= max_store_items; s++) {
        ShopItem shop_item = inst.nextShopItem(ante);
        if (shop_item.item == searchObject.item) {
            amount_found++;
        }
    }

    return amount_found;
}

long searchForSpectral(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;
    // int max_store_items = 10;
    //     if (ante > 1) max_store_items = 50;

    //Check packs
    for (int p = 1; p <= max_packs; p++) {
        Pack pack = packInfo(inst.nextPack(ante));
        if (pack.type == Item::Spectral_Pack || 
            pack.type == Item::Jumbo_Spectral_Pack || 
            pack.type == Item::Mega_Spectral_Pack) {
                auto packContents = inst.nextArcanaPack(pack.size, 1);
                for (int x = 0; x < pack.size; x++) {
                    if (packContents[x] == searchObject.item) {
                        amount_found++;
                    }
                }
        }
        continue;
    }

    //Check shop TODO: Setup instance
    /*for (int s = 1; s <= max_store_items; s++) {
        ShopItem shop_item = inst.nextShopItem(ante);
        if (shop_item.item == &searchObject.item) {
            amount_found++;
        }
    }*/

    return amount_found;
}

long searchForCard(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;
    // int max_store_items = 10;
    //     if (ante > 1) max_store_items = 50;

    //Check packs
    for (int p = 1; p <= max_packs; p++) {
        Pack pack = packInfo(inst.nextPack(ante));
        if (pack.type == Item::Standard_Pack || 
            pack.type == Item::Jumbo_Standard_Pack || 
            pack.type == Item::Mega_Standard_Pack) {
                auto packContents = inst.nextArcanaPack(pack.size, 1);
                for (int x = 0; x < pack.size; x++) {
                    if (packContents[x] == searchObject.item) {
                        amount_found++;
                    }
                }
        }
        continue;
    }

    //Check shop TODO: Setup instance
    /*for (int s = 1; s <= max_store_items; s++) {
        ShopItem shop_item = inst.nextShopItem(ante);
        if (shop_item.item == &searchObject.item) {
            amount_found++;
        }
    }*/

    return amount_found;
}


long searchForTag(Instance inst, SearchObject &searchObject, int ante) {
    int amount_found = 0;

    for(int i = 1; i <=2; i++) {
        if(inst.nextTag(ante) == searchObject.item) {
            amount_found++;
        }
    }

    return amount_found;
}

//TODO: Setup instance prior to calling this
// May want to seperate ante 1 loop for examples like perkeo_observatory
long searchForVoucher(Instance inst, SearchObject &searchObject, int ante) {
    if(inst.nextVoucher(ante) == searchObject.item) {
        return 1;
    }
    return 0;
}