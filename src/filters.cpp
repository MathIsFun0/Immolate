#include "filters.hpp"
#include "functions.hpp"
#include <vector>
#include <numeric>

void Filter::parseJSON(std::string input) {
    //Populate Lists with variables from the Json
    return;
}


long searchWithFilter(Instance inst, Filter &filter) {
    std::vector<int> amountFoundList;
    amountFoundList.resize(filter.searchList.size());
    std:fill(amountFoundList.begin(), amountFoundList.end(), 0);

    for (int ante = 1; ante <= filter.maxAnte; ante++) {
        for (int i = 0; i < filter.searchList.size(); i++) {
            if (ante > filter.searchList[i].maxAnte) { continue; }
            amountFoundList[i] += searchWithObject(inst, filter.searchList[i], ante);
        }
    }

    //Check if you have found all the items in a list
    int correct_amounts = 0;
    for (int i = 0; i < filter.searchList.size(); i++) {
        if (amountFoundList[i] >= filter.searchList[i].amount) {
            correct_amounts++;
        }
    }
    if (correct_amounts == filter.searchList.size()) {
        return 1;
    }
    return 0;

}

long searchWithObject(Instance inst, SearchObject searchObject, int ante){
    switch (searchObject.searchType) {
        case SearchableType::Joker:
            return searchForJoker(inst, searchObject, ante);
        default:
            return 0;
    }
}

long searchForJoker(Instance inst, SearchObject searchObject, int ante) {
    int amount_found = 0;
    int max_packs = 4;
        if (ante > 1) max_packs = 6;
    int max_store_items = 10;
        if (ante > 1) max_store_items = 50;

    //Check packs
    for (int p = 1; p <= max_packs; p++) {
        Pack pack = packInfo(inst.nextPack(ante));
        if (pack.type == Item::Buffoon_Pack || 
            pack.type == Item::Jumbo_Buffoon_Pack || 
            pack.type == Item::Mega_Buffoon_Pack) {
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