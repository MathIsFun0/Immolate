#ifndef FILTERS_HPP
#define FILTERS_HPP

#include "functions.hpp"
#include <string>
#include <vector>

//Defining searchable types here
enum class SearchableType {
//Objects
    Joker,
    Voucher,
    Tag,
    Tarot,
    Planet,
    Spectral,
    Card,
    Booster_Pack,
//Modifiers
    Suit,
    Rank,
    Enhancement,
    Seal,
    Edition,
//Other
    Deck,
    Hand,
    Blind

};

struct SearchObject {
    Item item;
    SearchableType searchType;
    int8_t storeDepth;
    int8_t maxAnte;
    int8_t amount;
};

struct InstanceModifier {
    Item modifier;
    int8_t startAnte;
    int8_t maxAnte;
};

//Possible optimizations for bigger searchList
//Generating all the items before searching
class Filter {
public:
    bool orderedSearch = true;
    bool preGenItems = false;
    int maxAnte = 1;

    std::vector<SearchObject> searchList;
    std::vector<InstanceModifier> instanceModList;

    void parseJSON(std::string input);
    long generateObjects(Instance inst);
};

long searchWithFilter(Instance inst, Filter &filter);
long searchWithObject(Instance inst, SearchObject &searchObject, int ante);

//Appear in shop & packs 
//TODO: Possibly combine some of these functions (They use similar code)
long searchForJoker(Instance inst, SearchObject &searchObject, int ante);
long searchForTarot(Instance inst, SearchObject &searchObject, int ante);
long searchForPlanet(Instance inst, SearchObject &searchObject, int ante);

//Appear in packs (mostly)
long searchForSpectral(Instance inst, SearchObject &searchObject, int ante);
long searchForCard(Instance inst, SearchObject &searchObject, int ante);

//Appears on ante
long searchForTag(Instance inst, SearchObject &searchObject, int ante);
long searchForVoucher(Instance inst, SearchObject &searchObject, int ante);

#endif