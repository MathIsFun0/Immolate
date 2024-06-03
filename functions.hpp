#include <string>
#include <algorithm>
#include "instance.hpp"

// Helper functions
void Instance::lock(Item item) {
    locked[(int)item] = true;
}
void Instance::unlock(Item item) {
    locked[(int)item] = false;
}
bool Instance::isLocked(Item item) {
    return locked[(int)item];
}

// Lock initializers
void Instance::initLocks(int ante, bool freshProfile, bool freshRun) {
    if (ante < 2) {
        lock(Item::The_Mouth);
        lock(Item::The_Fish);
        lock(Item::The_Wall);
        lock(Item::The_House);
        lock(Item::The_Mark);
        lock(Item::The_Wheel);
        lock(Item::The_Arm);
        lock(Item::The_Water);
        lock(Item::The_Needle);
        lock(Item::The_Flint);
        lock(Item::Negative_Tag);
        lock(Item::Standard_Tag);
        lock(Item::Meteor_Tag);
        lock(Item::Buffoon_Tag);
        lock(Item::Handy_Tag);
        lock(Item::Garbage_Tag);
        lock(Item::Ethereal_Tag);
        lock(Item::Top_up_Tag);
        lock(Item::Orbital_Tag);
    }
    if (ante < 3) {
        lock(Item::The_Tooth);
        lock(Item::The_Eye);
    }
    if (ante < 4) {
        lock(Item::The_Plant);
    }
    if (ante < 5) {
        lock(Item::The_Serpent);
    }
    if (ante < 6) {
        lock(Item::The_Ox);
    }
    if (freshProfile) {
        // Tags
        lock(Item::Negative_Tag);
        lock(Item::Foil_Tag);
        lock(Item::Holographic_Tag);
        lock(Item::Polychrome_Tag);
        lock(Item::Rare_Tag);

        // Jokers
        lock(Item::Golden_Ticket);
        lock(Item::Mr_Bones);
        lock(Item::Acrobat);
        lock(Item::Sock_and_Buskin);
        lock(Item::Swashbuckler);
        lock(Item::Troubadour);
        lock(Item::Certificate);
        lock(Item::Smeared_Joker);
        lock(Item::Throwback);
        lock(Item::Hanging_Chad);
        lock(Item::Rough_Gem);
        lock(Item::Bloodstone);
        lock(Item::Arrowhead);
        lock(Item::Onyx_Agate);
        lock(Item::Glass_Joker);
        lock(Item::Showman);
        lock(Item::Flower_Pot);
        lock(Item::Blueprint);
        lock(Item::Wee_Joker);
        lock(Item::Merry_Andy);
        lock(Item::Oops_All_6s);
        lock(Item::The_Idol);
        lock(Item::Seeing_Double);
        lock(Item::Matador);
        lock(Item::Hit_the_Road);
        lock(Item::The_Duo);
        lock(Item::The_Trio);
        lock(Item::The_Family);
        lock(Item::The_Order);
        lock(Item::The_Tribe);
        lock(Item::Stuntman);
        lock(Item::Invisible_Joker);
        lock(Item::Brainstorm);
        lock(Item::Satellite);
        lock(Item::Shoot_the_Moon);
        lock(Item::Drivers_License);
        lock(Item::Cartomancer);
        lock(Item::Astronomer);
        lock(Item::Burnt_Joker);
        lock(Item::Bootstraps);

        // Vouchers
        lock(Item::Overstock_Plus);
        lock(Item::Liquidation);
        lock(Item::Glow_Up);
        lock(Item::Reroll_Glut);
        lock(Item::Omen_Globe);
        lock(Item::Observatory);
        lock(Item::Nacho_Tong);
        lock(Item::Recyclomancy);
        lock(Item::Tarot_Tycoon);
        lock(Item::Planet_Tycoon);
        lock(Item::Money_Tree);
        lock(Item::Antimatter);
        lock(Item::Illusion);
        lock(Item::Petroglyph);
        lock(Item::Retcon);
        lock(Item::Palette);
    }

    // Locked in start of run
    if (freshRun) {
        //Require hand discoveries
        lock(Item::Planet_X);
        lock(Item::Ceres);
        lock(Item::Eris);
        lock(Item::Five_of_a_Kind);
        lock(Item::Flush_House);
        lock(Item::Flush_Five);

        //Requires specific card enhancement
        lock(Item::Stone_Joker); //Stone
        lock(Item::Steel_Joker); //Steel
        lock(Item::Glass_Joker); //Glass
        lock(Item::Golden_Ticket); //Gold
        lock(Item::Lucky_Cat); //Lucky

        // Requires Gros Michel death
        lock(Item::Cavendish);

        // Vouchers
        lock(Item::Overstock_Plus);
        lock(Item::Liquidation);
        lock(Item::Glow_Up);
        lock(Item::Reroll_Glut);
        lock(Item::Omen_Globe);
        lock(Item::Observatory);
        lock(Item::Nacho_Tong);
        lock(Item::Recyclomancy);
        lock(Item::Tarot_Tycoon);
        lock(Item::Planet_Tycoon);
        lock(Item::Money_Tree);
        lock(Item::Antimatter);
        lock(Item::Illusion);
        lock(Item::Petroglyph);
        lock(Item::Retcon);
        lock(Item::Palette);
    }
}
void Instance::initUnlocks(int ante, bool freshProfile) {
    if (ante == 2) {
        unlock(Item::The_Mouth);
        unlock(Item::The_Fish);
        unlock(Item::The_Wall);
        unlock(Item::The_House);
        unlock(Item::The_Mark);
        unlock(Item::The_Wheel);
        unlock(Item::The_Arm);
        unlock(Item::The_Water);
        unlock(Item::The_Needle);
        unlock(Item::The_Flint);
        if (!freshProfile) unlock(Item::Negative_Tag);
        unlock(Item::Standard_Tag);
        unlock(Item::Meteor_Tag);
        unlock(Item::Buffoon_Tag);
        unlock(Item::Handy_Tag);
        unlock(Item::Garbage_Tag);
        unlock(Item::Ethereal_Tag);
        unlock(Item::Top_up_Tag);
        unlock(Item::Orbital_Tag);
    }
    if (ante == 3) {
        unlock(Item::The_Tooth);
        unlock(Item::The_Eye);
    }
    if (ante == 4) {
        unlock(Item::The_Plant);
    }
    if (ante == 5) {
        unlock(Item::The_Serpent);
    }
    if (ante == 6) {
        unlock(Item::The_Ox);
    }
}

// Card Generators
Item Instance::nextTarot(std::string source, int ante, bool soulable) {
    std::string anteStr = anteToString(ante);
    if (soulable && (params.showman || !isLocked(Item::The_Soul)) && random(RandomType::Soul + RandomType::Tarot + anteStr) > 0.997) {
        return Item::The_Soul;
    }
    return randchoice(RandomType::Tarot + source + anteStr, TAROTS);
}

Item Instance::nextPlanet(std::string source, int ante, bool soulable) {
    std::string anteStr = anteToString(ante);
    if (soulable && (params.showman || !isLocked(Item::Black_Hole)) && random(RandomType::Soul + RandomType::Planet + anteStr) > 0.997) {
        return Item::Black_Hole;
    }
    return randchoice(RandomType::Planet + source + anteStr, PLANETS);
}

Item Instance::nextSpectral(std::string source, int ante, bool soulable) {
    std::string anteStr = anteToString(ante);
    if (soulable) {
        Item forcedKey = Item::RETRY;
        if ((params.showman || !isLocked(Item::The_Soul)) && random(RandomType::Soul + RandomType::Spectral + anteStr) > 0.997) forcedKey = Item::The_Soul;
        if ((params.showman || !isLocked(Item::Black_Hole)) && random(RandomType::Soul + RandomType::Spectral + anteStr) > 0.997) forcedKey = Item::Black_Hole;
        if (forcedKey != Item::RETRY) return forcedKey;
    }
    return randchoice(RandomType::Spectral + source + anteStr, SPECTRALS);
}

JokerData Instance::nextJoker(std::string source, int ante, bool hasStickers) {
    std::string anteStr = anteToString(ante);

    // Get rarity
    Item rarity;
    if (source == ItemSource::Soul) rarity = Item::Legendary;
    else if (source == ItemSource::Wraith) rarity = Item::Rare;
    else if (source == ItemSource::Rare_Tag) rarity = Item::Rare;
    else if (source == ItemSource::Uncommon_Tag) rarity = Item::Uncommon;
    else {
        double rarityPoll = random(RandomType::Joker_Rarity + anteStr + source);
        if (rarityPoll > 0.95) rarity = Item::Rare;
        else if (rarityPoll > 0.7) rarity = Item::Uncommon;
        else rarity = Item::Common;
    }

    // Get edition
    int editionRate = 1;
    if (isVoucherActive(Item::Glow_Up)) editionRate = 4;
    else if (isVoucherActive(Item::Hone)) editionRate = 2;
    Item edition;
    double editionPoll = random(RandomType::Joker_Edition + source + anteStr);
    if (editionPoll > 0.997) edition = Item::Negative;
    else if (editionPoll > 1 - 0.006 * editionRate) edition = Item::Polychrome;
    else if (editionPoll > 1 - 0.02 * editionRate) edition = Item::Holographic;
    else if (editionPoll > 1 - 0.04 * editionRate) edition = Item::Foil;
    else edition = Item::No_Edition;

    // Get next joker
    Item joker;
    if (rarity == Item::Legendary) {
        if (params.version > 10099) joker = randchoice(RandomType::Joker_Legendary, LEGENDARY_JOKERS);
        else joker = randchoice(RandomType::Joker_Legendary + source + anteStr, LEGENDARY_JOKERS);
    }
    else if (rarity == Item::Rare) joker = randchoice(RandomType::Joker_Rare + source + anteStr, (params.version > 10099) ? RARE_JOKERS : RARE_JOKERS_100);
    else if (rarity == Item::Uncommon) joker = randchoice(RandomType::Joker_Uncommon + source + anteStr, (params.version > 10099) ? UNCOMMON_JOKERS : UNCOMMON_JOKERS_100);
    else if (rarity == Item::Common) joker = randchoice(RandomType::Joker_Common + source + anteStr, (params.version > 10099) ? COMMON_JOKERS: COMMON_JOKERS_100);

    // Get next joker stickers
    JokerStickers stickers = JokerStickers();
    if (hasStickers) {
        if (params.version > 10099) {
            double stickerPoll = random(((source == ItemSource::Buffoon_Pack) ? RandomType::Eternal_Perishable_Pack : RandomType::Eternal_Perishable) + anteStr);
            if (stickerPoll > 0.7 && params.stake >= Item::Black_Stake) {
                if (joker != Item::Gros_Michel && joker != Item::Ice_Cream && joker != Item::Cavendish && joker != Item::Luchador
                && joker != Item::Turtle_Bean && joker != Item::Diet_Cola && joker != Item::Popcorn   && joker != Item::Ramen
                && joker != Item::Seltzer     && joker != Item::Mr_Bones  && joker != Item::Invisible_Joker) {
                    stickers.eternal = true;
                }
            }
            if (stickerPoll > 0.4 && stickerPoll <= 0.7 && params.stake >= Item::Orange_Stake &&
                joker != Item::Ceremonial_Dagger && joker != Item::Ride_the_Bus   && joker != Item::Runner  && joker != Item::Constellation
                && joker != Item::Green_Joker    && joker != Item::Red_Card       && joker != Item::Madness && joker != Item::Square_Joker
                && joker != Item::Vampire        && joker != Item::Rocket         && joker != Item::Obelisk && joker != Item::Lucky_Cat
                && joker != Item::Flash_Card     && joker != Item::Spare_Trousers && joker != Item::Castle  && joker != Item::Wee_Joker) {
                stickers.perishable = true;
            }
            if (params.stake >= Item::Gold_Stake) {
                stickers.rental = random(((source == ItemSource::Buffoon_Pack) ? RandomType::Rental_Pack : RandomType::Rental) + anteStr) > 0.7;
            }
        } else {
            if (params.stake >= Item::Black_Stake) {
                if (joker != Item::Gros_Michel && joker != Item::Ice_Cream && joker != Item::Cavendish && joker != Item::Luchador
                && joker != Item::Turtle_Bean && joker != Item::Diet_Cola && joker != Item::Popcorn   && joker != Item::Ramen
                && joker != Item::Seltzer     && joker != Item::Mr_Bones  && joker != Item::Invisible_Joker) {
                    stickers.eternal = random(RandomType::Eternal + anteStr) > 0.7;
                }
            }
        }
    }

    return JokerData(joker, rarity, edition, stickers);
}

// Shop Logic
ShopInstance Instance::getShopInstance() {
    double tarotRate = 4;
    double planetRate = 4;
    double playingCardRate = 0;
    double spectralRate = 0;
    if (params.deck == Item::Ghost_Deck) {
        spectralRate = 2;
    }
    if (isVoucherActive(Item::Tarot_Tycoon)) {
        tarotRate = 32;
    } else if (isVoucherActive(Item::Tarot_Merchant)) {
        tarotRate = 9.6;
    }
    if (isVoucherActive(Item::Planet_Tycoon)) {
        planetRate = 32;
    } else if (isVoucherActive(Item::Planet_Merchant)) {
        planetRate = 9.6;
    }
    if (isVoucherActive(Item::Magic_Trick)) {
        playingCardRate = 4;
    }

    return ShopInstance(20, tarotRate, planetRate, playingCardRate, spectralRate);
};

ShopItem Instance::nextShopItem(int ante) {
    std::string anteStr = anteToString(ante);

    ShopInstance shop = getShopInstance();
    double cdtPoll = random(RandomType::Card_Type + anteStr) * shop.getTotalRate();
    Item type;
    if (cdtPoll < shop.jokerRate) type = Item::T_Joker;
    else {cdtPoll -= shop.jokerRate;
    if (cdtPoll < shop.tarotRate) type = Item::T_Tarot;
    else {cdtPoll -= shop.tarotRate;
    if (cdtPoll < shop.planetRate) type = Item::T_Planet;
    else {cdtPoll -= shop.planetRate;
    if (cdtPoll < shop.playingCardRate) type = Item::T_Playing_Card;
    else type = Item::T_Spectral;}}}

    if (type == Item::T_Joker) {
        JokerData jkr = nextJoker(ItemSource::Shop, ante, true);
        return ShopItem(type, jkr.joker, jkr);
    } else if (type == Item::T_Tarot) {
        return ShopItem(type, nextTarot(ItemSource::Shop, ante, false));
    } else if (type == Item::T_Planet) {
        return ShopItem(type, nextPlanet(ItemSource::Shop, ante, false));
    } else if (type == Item::T_Spectral) {
        return ShopItem(type, nextSpectral(ItemSource::Shop, ante, false));
    }
    // Todo: Magic Trick support
    return ShopItem();
}

// Packs and Pack Contents
Item Instance::nextPack(int ante) {
    if (ante <= 2 && !cache.generatedFirstPack && params.version > 10099) {
        cache.generatedFirstPack = true;
        return Item::Buffoon_Pack;
    }
    std::string anteStr = anteToString(ante);
    return randweightedchoice(RandomType::Shop_Pack + anteStr, PACKS);
}
std::vector<Pack> PACK_INFO = {
    Pack(Item::Arcana_Pack, 3, 1),
    Pack(Item::Arcana_Pack, 5, 1),
    Pack(Item::Arcana_Pack, 5, 2),
    Pack(Item::Celestial_Pack, 3, 1),
    Pack(Item::Celestial_Pack, 5, 1),
    Pack(Item::Celestial_Pack, 5, 2),
    Pack(Item::Standard_Pack, 3, 1),
    Pack(Item::Standard_Pack, 5, 1),
    Pack(Item::Standard_Pack, 5, 2),
    Pack(Item::Buffoon_Pack, 2, 1),
    Pack(Item::Buffoon_Pack, 4, 1),
    Pack(Item::Buffoon_Pack, 4, 2),
    Pack(Item::Spectral_Pack, 2, 1),
    Pack(Item::Spectral_Pack, 4, 1),
    Pack(Item::Spectral_Pack, 4, 2)
};
Pack packInfo(Item pack) {
    return PACK_INFO[(int)pack-(int)Item::Arcana_Pack];
}
Card Instance::nextStandardCard(int ante) {
    std::string anteStr = anteToString(ante);

    // Enhancement
    Item enhancement;
    if (random(RandomType::Standard_Has_Enhancement + anteStr) <= 0.6) {
        enhancement = Item::No_Enhancement;
    } else {
        enhancement = randchoice(RandomType::Enhancement + ItemSource::Standard_Pack + anteStr, ENHANCEMENTS);
    } 

    // Base
    Item base = randchoice("frontsta" + anteStr, CARDS);

    // Edition
    Item edition;
    double editionPoll = random("standard_edition" + anteStr);
    if (editionPoll > 0.988) edition = Item::Polychrome;
    else if (editionPoll > 0.96) edition = Item::Holographic;
    else if (editionPoll > 0.92) edition = Item::Foil;
    else edition = Item::No_Edition;

    // Seal
    Item seal;
    if (random("stdseal"+anteStr) <= 0.8) seal = Item::No_Seal;
    else {
        double sealPoll = random("stdsealtype"+anteStr);
        if (sealPoll > 0.75) seal = Item::Red_Seal;
        else if (sealPoll > 0.5) seal = Item::Blue_Seal;
        else if (sealPoll > 0.25) seal = Item::Gold_Seal;
        else seal = Item::Purple_Seal;
    }

    return Card(base, enhancement, edition, seal);
};
std::vector<Item> Instance::nextArcanaPack(int size, int ante) {
    std::vector<Item> pack;
    for (int i = 0; i < size; i++) {
        if (isVoucherActive(Item::Omen_Globe) && random(RandomType::Omen_Globe) > 0.8) {
            pack.push_back(nextSpectral(ItemSource::Omen_Globe, ante, true));
        } else pack.push_back(nextTarot(ItemSource::Arcana_Pack, ante, true));
        if (!params.showman) lock(pack[i]);
    }
    for (int i = 0; i < size; i++) unlock(pack[i]);
    return pack;
};
std::vector<Item> Instance::nextCelestialPack(int size, int ante) {
    std::vector<Item> pack;
    for (int i = 0; i < size; i++) {
        pack.push_back(nextPlanet(ItemSource::Celestial_Pack, ante, true));
        if (!params.showman) lock(pack[i]);
    }
    for (int i = 0; i < size; i++) unlock(pack[i]);
    return pack;
};
std::vector<Item> Instance::nextSpectralPack(int size, int ante) {
    std::vector<Item> pack;
    for (int i = 0; i < size; i++) {
        pack.push_back(nextSpectral("spe", ante, true));
        if (!params.showman) lock(pack[i]);
    }
    for (int i = 0; i < size; i++) unlock(pack[i]);
    return pack;
};
std::vector<Card> Instance::nextStandardPack(int size, int ante) {
    std::vector<Card> pack;
    for (int i = 0; i < size; i++) {
        pack.push_back(nextStandardCard(ante));
    }
    return pack;
};
std::vector<JokerData> Instance::nextBuffoonPack(int size, int ante) {
    std::vector<JokerData> pack;
    for (int i = 0; i < size; i++) {
        pack.push_back(nextJoker("buf", ante, true));
        if (!params.showman) lock(pack[i].joker);
    }
    for (int i = 0; i < size; i++) unlock(pack[i].joker);
    return pack;
};
// Misc
bool Instance::isVoucherActive(Item voucher) {
    return params.vouchers[(int)voucher-(int)Item::Overstock];
}
void Instance::activateVoucher(Item voucher) {
    params.vouchers[(int)voucher-(int)Item::Overstock] = true;
    lock(voucher);
    // Unlock next level voucher
    for (int i = 0; i < VOUCHERS.size(); i+=2) {
        if (VOUCHERS[i] == voucher) {
            unlock(VOUCHERS[i+1]);
        };
    };
};

Item Instance::nextVoucher(int ante) {
    return randchoice("Voucher"+anteToString(ante), VOUCHERS);
}

void Instance::setDeck(Item deck) {
    params.deck = deck;
    if (deck == Item::Magic_Deck) {
        activateVoucher(Item::Crystal_Ball);
    }
    if (deck == Item::Nebula_Deck) {
        activateVoucher(Item::Telescope);
    }
    if (deck == Item::Zodiac_Deck) {
        activateVoucher(Item::Tarot_Merchant);
        activateVoucher(Item::Planet_Merchant);
        activateVoucher(Item::Overstock);
    }
}

void Instance::setStake(Item stake) {
    params.stake = stake;
}

Item Instance::nextTag(int ante) {
    return randchoice("Tag"+anteToString(ante), TAGS);
}

Item Instance::nextBoss(int ante) {
    std::vector<Item> bossPool;
    int numBosses = 0;
    for (int i = 0; i < BOSSES.size(); i++) {
        if (!isLocked(BOSSES[i])) {
            if ((ante % 8 == 0 && BOSSES[i] > Item::B_F_BEGIN) || (ante % 8 != 0 && BOSSES[i] < Item::B_F_BEGIN)) {
                bossPool.push_back(BOSSES[i]);
                numBosses++;
            }
        }
    }
    if (numBosses == 0) {
        for (int i = 0; i < BOSSES.size(); i++) {
            if ((ante % 8 == 0 && BOSSES[i] > Item::B_F_BEGIN) || (ante % 8 != 0 && BOSSES[i] < Item::B_F_BEGIN)) {
                unlock(BOSSES[i]);
            }
        }
        return nextBoss(ante);
    }
    Item chosenBoss = randchoice("boss", bossPool);
    lock(chosenBoss);
    return chosenBoss;
}