#ifndef FILTERS_HPP
#define FILTERS_HPP

#include "instance.hpp"
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
    int maxAnte;
    int amount;
};

//Possible optimizations for bigger searchList
//Generating all the items before searching
class Filter {
public:
    bool orderedSearch = true;
    bool preGenItems = false;
    int maxAnte = 1;

    std::vector<SearchObject> searchList;

    void parseJSON(std::string input);
    long generateObjects(Instance inst);
};

long searchWithFilter(Instance inst, Filter &filter);
long searchWithObject(Instance inst, SearchObject searchObject, int ante);
long searchForJoker(Instance inst, SearchObject searchObject, int ante);

#endif