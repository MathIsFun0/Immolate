# Documentation

A guide to all the functions, structs, and items available in Immolate.

Written by PacManMVC

## Getting Started

This program is written entirely in C++ and this doc is not intended to teach you the language, there are other tools for that purpose. The intent is to give insight on what functions serve which purpose, which parameters they require, and what they return, as well as the different structs along with their attributes. A list of all items will also be included.

## Functions

### lock

`lock(Item item)`

Locks a given item from being rolled.

### unlock

`unlock(Item item)`

Unlocks a given item to be rolled.

### isLocked

`isLocked(Item item)`

Returns a `bool` to check if a given item is locked.

### initLocks

`initLocks(int ante, bool freshProfile, bool freshRun)`

Locks items according to the given ante.

_This impacts bosses, tags, jokers, vouchers, and hidden hand planets._

### initUnlocks

`initUnlocks(int ante, bool freshProfile)`

Unlocks items according to the given ante.

_This impacts bosses and tags._

### nextTarot

`nextTarot(std::string source, int ante, bool soulable)`

Returns an `Item` representing the next tarot card generated from a given random source in a given ante.

### nextPlanet

`nextPlanet(std::string source, int ante, bool soulable)`

Returns an `Item` representing the next planet card generated from a given random source in a given ante.

### nextSpectral

`nextSpectral(std::string source, int ante, bool soulable)`

Returns an `Item` representing the next spectral card generated from a given random source in a given ante.

### nextJoker

`nextJoker(std::string source, int ante, bool hasStickers)`

Returns a `JokerData` representing the next joker generated from a given random source in a given ante.

_This has the joker, rarity, edition, and stickers._

### getShopInstance

`getShopInstance()`

Returns a `ShopInstance` that has the weights for the different items in the shop.

_This takes deck and active vouchers into account._

### nextShopItem

`nextShopItem(int ante)`

Returns a `ShopItem` representing the next item generated from the shop in a given ante.

_This does not support playing cards._

### nextPack

`nextPack(int ante)`

Returns an `Item` representing the next booster pack generated from the shop in a given ante.

### packInfo

`packInfo(Item pack)`

Returns a `Pack` containing a given pack's generic type, size, and choices.

_Generic pack types are Arcana, Celestial, Standard, Buffoon, and Spectral._

### nextStandardCard

`nextStandardCard(int ante)`

Returns a `Card` representing the next playing card generated from the shop in a given ante.

_This has the base, enhancement, edition, and seal._

### nextArcanaPack

`nextArcanaPack(int size, int ante)`

Returns a `vector<Item>` containing the next `size` tarot cards from booster packs in a given ante.

_This takes Omen Globe into account._

### nextCelestialPack

`nextCelestialPack(int size, int ante)`

Returns a `vector<Item>` containing the next `size` planet cards from booster packs in a given ante.

### nextSpectralPack

`nextSpectralPack(int size, int ante)`

Returns a `vector<Item>` containing the next `size` spectral cards from booster packs in a given ante.

### nextStandardPack

`nextStandardPack(int size, int ante)`

Returns a `vector<Item>` containing the next `size` playing cards from booster packs in a given ante.

### nextBuffoonPack

`nextBuffoonPack(int size, int ante)`

Returns a `vector<Item>` containing the next `size` jokers from booster packs in a given ante.

### isVoucherActive

`isVoucherActive(Item voucher)`

Returns a `bool` representing if a given voucher is active.

### activateVoucher

`activateVoucher(Item voucher)`

Activates a given voucher.

### nextVoucher

`nextVoucher(int ante)`

Returns an `Item` representing the next voucher generated in a given ante.

### setDeck

`setDeck(Item deck)`

Sets the instance's deck to the given one.

_This activates the respective vouchers for the Magic, Nebula, and Zodiac Deck._

### setStake

`setStake(Item stake)`

Sets the instance's stake to the given one.

### nextTag

`nextTag(int ante)`

Returns an `Item` representing the next tag generated in a given ante.

### nextBoss

`nextBoss(int ante)`

Returns an `Item` representing the next boss generated in a given ante.

## Structs

### ShopInstance

`double` jokerRate - default 20

`double` tarotRate - default 4

`double` planetRate - default 4

`double` playingCardRate - default 0

`double` spectralRate - default 0

### JokerStickers

`bool` eternal - default `false`

`bool` perishable - default `false`

`bool` rental - default `false`

### JokerData

`Item` joker - default Joker

`Item` rarity - default Common

`Item` edition - default No_Edition

`Item` stickers - default `JokerStickers`

### ShopItem

`Item` type - default T_Tarot

`Item` item - default The_Fool

`JokerData` jokerData - default `null`

### WeightedItem

`Item` item - default `null`

`double` weight - default `null`

### Pack

`Item` type - default `null`

`int` size - default 0

`int` choices - default 0

### Card

`Item` base - default `null`

`Item` enhancement - default `null`

`Item` edition - default `null`

`Item` seal - default `null`

## Items

### Jokers

Common:

Joker,
Greedy_Joker,
Lusty_Joker,
Wrathful_Joker,
Gluttonous_Joker,
Jolly_Joker,
Zany_Joker,
Mad_Joker,
Crazy_Joker,
Droll_Joker,
Sly_Joker,
Wily_Joker,
Clever_Joker,
Devious_Joker,
Crafty_Joker,
Half_Joker,
Credit_Card,
Banner,
Mystic_Summit,
\_8_Ball,
Misprint,
Raised_Fist,
Chaos_the_Clown,
Scary_Face,
Abstract_Joker,
Delayed_Gratification,
Gros_Michel,
Even_Steven,
Odd_Todd,
Scholar,
Business_Card,
Supernova,
Ride_the_Bus,
Egg,
Runner,
Ice_Cream,
Splash,
Blue_Joker,
Faceless_Joker,
Green_Joker,
Superposition,
To_Do_List,
Cavendish,
Red_Card,
Square_Joker,
Riff_raff,
Photograph,
Reserved_Parking,
Mail_In_Rebate,
Hallucination,
Fortune_Teller,
Juggler,
Drunkard,
Golden_Joker,
Popcorn,
Walkie_Talkie,
Smiley_Face,
Golden_Ticket,
Swashbuckler,
Hanging_Chad,
Shoot_the_Moon

Uncommon:

Joker_Stencil,
Four_Fingers,
Mime,
Ceremonial_Dagger,
Marble_Joker,
Loyalty_Card,
Dusk,
Fibonacci,
Steel_Joker,
Hack,
Pareidolia,
Space_Joker,
Burglar,
Blackboard,
Sixth_Sense,
Constellation,
Hiker,
Card_Sharp,
Madness,
Seance,
Shortcut,
Hologram,
Cloud_9,
Rocket,
Midas_Mask,
Luchador,
Gift_Card,
Turtle_Bean,
Erosion,
To_the_Moon,
Stone_Joker,
Lucky_Cat,
Bull,
Diet_Cola,
Trading_Card,
Flash_Card,
Spare_Trousers,
Ramen,
Seltzer,
Castle,
Mr_Bones,
Acrobat,
Sock_and_Buskin,
Troubadour,
Certificate,
Smeared_Joker,
Throwback,
Rough_Gem,
Bloodstone,
Arrowhead,
Onyx_Agate,
Glass_Joker,
Showman,
Flower_Pot,
Merry_Andy,
Oops_All_6s,
The_Idol,
Seeing_Double,
Matador,
Stuntman,
Satellite,
Cartomancer,
Astronomer,
Bootstraps

Rare:

DNA,
Vampire,
Vagabond,
Baron,
Obelisk,
Baseball_Card,
Ancient_Joker,
Campfire,
Blueprint,
Wee_Joker,
Hit_the_Road,
The_Duo,
The_Trio,
The_Family,
The_Order,
The_Tribe,
Invisible_Joker,
Brainstorm,
Drivers_License,
Burnt_Joker

Legendary:

Canio,
Triboulet,
Yorick,
Chicot,
Perkeo

### Vouchers

Overstock,
Overstock_Plus

Clearance_Sale,
Liquidation

Hone,
Glow_Up

Reroll_Surplus,
Reroll_Glut

Crystal_Ball,
Omen_Globe

Telescope,
Observatory

Grabber,
Nacho_Tong

Wasteful,
Recyclomancy

Tarot_Merchant,
Tarot_Tycoon

Planet_Merchant,
Planet_Tycoon

Seed_Money,
Money_Tree

Blank,
Antimatter

Magic_Trick,
Illusion

Hieroglyph,
Petroglyph

Directors_Cut,
Retcon

Paint_Brush,
Palette

### Tarots

The_Fool,
The_Magician,
The_High_Priestess,
The_Empress,
The_Emperor,
The_Hierophant,
The_Lovers,
The_Chariot,
Justice,
The_Hermit,
The_Wheel_of_Fortune,
Strength,
The_Hanged_Man,
Death,
Temperance,
The_Devil,
The_Tower,
The_Star,
The_Moon,
The_Sun,
Judgement,
The_World

### Planets

Mercury,
Venus,
Earth,
Mars,
Jupiter,
Saturn,
Uranus,
Neptune,
Pluto,
Planet_X,
Ceres,
Eris

### Hands

Pair,
Three_of_a_Kind,
Full_House,
Four_of_a_Kind,
Flush,
Straight,
Two_Pair,
Straight_Flush,
High_Card,
Five_of_a_Kind,
Flush_House,
Flush_Five

### Spectrals

Familiar,
Grim,
Incantation,
Talisman,
Aura,
Wraith,
Sigil,
Ouija,
Ectoplasm,
Immolate,
Ankh,
Deja_Vu,
Hex,
Trance,
Medium,
Cryptid,
The_Soul,
Black_Hole

### Enhancements

No_Enhancement,
Bonus_Card,
Mult_Card,
Wild_Card,
Glass_Card,
Steel_Card,
Stone_Card,
Gold_Card,
Lucky_Card

### Seals

No_Seal,
Gold_Seal,
Red_Seal,
Blue_Seal,
Purple_Seal

### Editions

No_Edition,
Foil,
Holographic,
Polychrome,
Negative

### Booster Packs

Arcana_Pack,
Jumbo_Arcana_Pack,
Mega_Arcana_Pack

Celestial_Pack,
Jumbo_Celestial_Pack,
Mega_Celestial_Pack

Standard_Pack,
Jumbo_Standard_Pack,
Mega_Standard_Pack

Buffoon_Pack,
Jumbo_Buffoon_Pack,
Mega_Buffoon_Pack

Spectral_Pack,
Jumbo_Spectral_Pack,
Mega_Spectral_Pack

### Tags

Uncommon_Tag,
Rare_Tag,
Negative_Tag,
Foil_Tag,
Holographic_Tag,
Polychrome_Tag,
Investment_Tag,
Voucher_Tag,
Boss_Tag,
Standard_Tag,
Charm_Tag,
Meteor_Tag,
Buffoon_Tag,
Handy_Tag,
Garbage_Tag,
Ethereal_Tag,
Coupon_Tag,
Double_Tag,
Juggle_Tag,
D6_Tag,
Top_up_Tag,
Speed_Tag,
Orbital_Tag,
Economy_Tag

### Blinds

Small_Blind,
Big_Blind

The_Hook,
The_Ox,
The_House,
The_Wall,
The_Wheel,
The_Arm,
The_Club,
The_Fish,
The_Psychic,
The_Goad,
The_Water,
The_Window,
The_Manacle,
The_Eye,
The_Mouth,
The_Plant,
The_Serpent,
The_Pillar,
The_Needle,
The_Head,
The_Tooth,
The_Flint,
The_Mark

Amber_Acorn,
Verdant_Leaf,
Violet_Vessel,
Crimson_Heart,
Cerulean_Bell

### Suits

Hearts,
Clubs,
Diamonds,
Spades

### Ranks

\_2,
\_3,
\_4,
\_5,
\_6,
\_7,
\_8,
\_9,
\_10,
Jack,
Queen,
King,
Ace

### Cards

C_2,
C_3,
C_4,
C_5,
C_6,
C_7,
C_8,
C_9,
C_A,
C_J,
C_K,
C_Q,
C_T

D_2,
D_3,
D_4,
D_5,
D_6,
D_7,
D_8,
D_9,
D_A,
D_J,
D_K,
D_Q,
D_T

H_2,
H_3,
H_4,
H_5,
H_6,
H_7,
H_8,
H_9,
H_A,
H_J,
H_K,
H_Q,
H_T

S_2,
S_3,
S_4,
S_5,
S_6,
S_7,
S_8,
S_9,
S_A,
S_J,
S_K,
S_Q,
S_T

### Decks

Red_Deck,
Blue_Deck,
Yellow_Deck,
Green_Deck,
Black_Deck,
Magic_Deck,
Nebula_Deck,
Ghost_Deck,
Abandoned_Deck,
Checkered_Deck,
Zodiac_Deck,
Painted_Deck,
Anaglyph_Deck,
Plasma_Deck,
Erratic_Deck,
Challenge_Deck

### Challenges

The_Omelette,
\_15_Minute_City,
Rich_get_Richer,
On_a_Knifes_Edge,
X_ray_Vision,
Mad_World,
Luxury_Tax,
Non_Perishable,
Medusa,
Double_or_Nothing,
Typecast,
Inflation,
Bram_Poker,
Fragile,
Monolith,
Blast_Off,
Five_Card_Draw,
Golden_Needle,
Cruelty,
Jokerless

### Stakes

White_Stake,
Red_Stake,
Green_Stake,
Black_Stake,
Blue_Stake,
Purple_Stake,
Orange_Stake,
Gold_Stake

### Rarity

Common,
Uncommon,
Rare,
Legendary

### Type

T_Joker,
T_Tarot,
T_Planet,
T_Spectral,
T_Playing_Card
