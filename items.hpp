#include <string>
#include <vector>

enum class Item {
    RETRY,

    //Jokers
    J_BEGIN,

    J_C_BEGIN,
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
    _8_Ball,
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
    Shoot_the_Moon,
    J_C_END,

    J_U_BEGIN,
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
    Bootstraps,
    J_U_END,

    J_R_BEGIN,
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
    Burnt_Joker,
    J_R_END,

    J_L_BEGIN,
    Canio,
    Triboulet,
    Yorick,
    Chicot,
    Perkeo,
    J_L_END,

    J_END,

    // Vouchers
    V_BEGIN,
    Overstock,
    Overstock_Plus,
    Clearance_Sale,
    Liquidation,
    Hone,
    Glow_Up,
    Reroll_Surplus,
    Reroll_Glut,
    Crystal_Ball,
    Omen_Globe,
    Telescope,
    Observatory,
    Grabber,
    Nacho_Tong,
    Wasteful,
    Recyclomancy,
    Tarot_Merchant,
    Tarot_Tycoon,
    Planet_Merchant,
    Planet_Tycoon,
    Seed_Money,
    Money_Tree,
    Blank,
    Antimatter,
    Magic_Trick,
    Illusion,
    Hieroglyph,
    Petroglyph,
    Directors_Cut,
    Retcon,
    Paint_Brush,
    Palette,
    V_END,

    // Tarots
    T_BEGIN,
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
    The_World,
    T_END,

    // Planets
    P_BEGIN,
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
    Eris,
    P_END,

    // Hands
    H_BEGIN,
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
    Flush_Five,
    H_END,

    // Spectrals
    S_BEGIN,
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
    Black_Hole,
    S_END,

    // Enhancements
    ENHANCEMENT_BEGIN,
    No_Enhancement,
    Bonus_Card,
    Mult_Card,
    Wild_Card,
    Glass_Card,
    Steel_Card,
    Stone_Card,
    Gold_Card,
    Lucky_Card,
    ENHANCEMENT_END,

    // Seals
    SEAL_BEGIN,
    No_Seal,
    Gold_Seal,
    Red_Seal,
    Blue_Seal,
    Purple_Seal,
    SEAL_END,

    // Editions
    E_BEGIN,
    No_Edition,
    Foil,
    Holographic,
    Polychrome,
    Negative,
    E_END,

    // Booster Packs
    PACK_BEGIN,
    Arcana_Pack,
    Jumbo_Arcana_Pack,
    Mega_Arcana_Pack,
    Celestial_Pack,
    Jumbo_Celestial_Pack,
    Mega_Celestial_Pack,
    Standard_Pack,
    Jumbo_Standard_Pack,
    Mega_Standard_Pack,
    Buffoon_Pack,
    Jumbo_Buffoon_Pack,
    Mega_Buffoon_Pack,
    Spectral_Pack,
    Jumbo_Spectral_Pack,
    Mega_Spectral_Pack,
    PACK_END,

    // Tags
    TAG_BEGIN,
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
    Economy_Tag,
    TAG_END,

    // Blinds
    B_BEGIN,
    Small_Blind,
    Big_Blind,
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
    The_Mark,
    B_F_BEGIN,
    Amber_Acorn,
    Verdant_Leaf,
    Violet_Vessel,
    Crimson_Heart,
    Cerulean_Bell,
    B_F_END,
    B_END,

    // Suits
    SUIT_BEGIN,
    Hearts,
    Clubs,
    Diamonds,
    Spades,
    SUIT_END,

    // Ranks
    RANK_BEGIN,
    _2,
    _3,
    _4,
    _5,
    _6,
    _7,
    _8,
    _9,
    _10,
    Jack,
    Queen,
    King,
    Ace,
    RANK_END,

    // Cards
    C_BEGIN,
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
    C_T,
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
    D_T,
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
    H_T,
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
    S_T,
    C_END,

    // Decks
    D_BEGIN,
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
    Challenge_Deck,
    D_END,

    // Challenges
    CHAL_BEGIN,
    The_Omelette,
    _15_Minute_City,
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
    Jokerless,
    CHAL_END,

    //Stakes
    STAKE_BEGIN,
    White_Stake,
    Red_Stake,
    Green_Stake,
    Black_Stake,
    Blue_Stake,
    Purple_Stake,
    Orange_Stake,
    Gold_Stake,
    STAKE_END,

    RARITY_BEGIN,
    Common,
    Uncommon,
    Rare,
    Legendary,
    RARITY_END,

    TYPE_BEGIN,
    T_Joker,
    T_Tarot,
    T_Planet,
    T_Spectral,
    T_Playing_Card,
    TYPE_END,

    ITEMS_END
};
std::string itemToString(Item i) {
    switch(i) {
        case Item::RETRY: return "RETRY";
        case Item::J_BEGIN: return "J BEGIN";
        case Item::J_C_BEGIN: return "J C BEGIN";
        case Item::Joker: return "Joker";
        case Item::Greedy_Joker: return "Greedy Joker";
        case Item::Lusty_Joker: return "Lusty Joker";
        case Item::Wrathful_Joker: return "Wrathful Joker";
        case Item::Gluttonous_Joker: return "Gluttonous Joker";
        case Item::Jolly_Joker: return "Jolly Joker";
        case Item::Zany_Joker: return "Zany Joker";
        case Item::Mad_Joker: return "Mad Joker";
        case Item::Crazy_Joker: return "Crazy Joker";
        case Item::Droll_Joker: return "Droll Joker";
        case Item::Sly_Joker: return "Sly Joker";
        case Item::Wily_Joker: return "Wily Joker";
        case Item::Clever_Joker: return "Clever Joker";
        case Item::Devious_Joker: return "Devious Joker";
        case Item::Crafty_Joker: return "Crafty Joker";
        case Item::Half_Joker: return "Half Joker";
        case Item::Credit_Card: return "Credit Card";
        case Item::Banner: return "Banner";
        case Item::Mystic_Summit: return "Mystic Summit";
        case Item::_8_Ball: return "8 Ball";
        case Item::Misprint: return "Misprint";
        case Item::Raised_Fist: return "Raised Fist";
        case Item::Chaos_the_Clown: return "Chaos the Clown";
        case Item::Scary_Face: return "Scary Face";
        case Item::Abstract_Joker: return "Abstract Joker";
        case Item::Delayed_Gratification: return "Delayed Gratification";
        case Item::Gros_Michel: return "Gros Michel";
        case Item::Even_Steven: return "Even Steven";
        case Item::Odd_Todd: return "Odd Todd";
        case Item::Scholar: return "Scholar";
        case Item::Business_Card: return "Business Card";
        case Item::Supernova: return "Supernova";
        case Item::Ride_the_Bus: return "Ride the Bus";
        case Item::Egg: return "Egg";
        case Item::Runner: return "Runner";
        case Item::Ice_Cream: return "Ice Cream";
        case Item::Splash: return "Splash";
        case Item::Blue_Joker: return "Blue Joker";
        case Item::Faceless_Joker: return "Faceless Joker";
        case Item::Green_Joker: return "Green Joker";
        case Item::Superposition: return "Superposition";
        case Item::To_Do_List: return "To Do List";
        case Item::Cavendish: return "Cavendish";
        case Item::Red_Card: return "Red Card";
        case Item::Square_Joker: return "Square Joker";
        case Item::Riff_raff: return "Riff-raff";
        case Item::Photograph: return "Photograph";
        case Item::Reserved_Parking: return "Reserved Parking";
        case Item::Mail_In_Rebate: return "Mail-In Rebate";
        case Item::Hallucination: return "Hallucination";
        case Item::Fortune_Teller: return "Fortune Teller";
        case Item::Juggler: return "Juggler";
        case Item::Drunkard: return "Drunkard";
        case Item::Golden_Joker: return "Golden Joker";
        case Item::Popcorn: return "Popcorn";
        case Item::Walkie_Talkie: return "Walkie Talkie";
        case Item::Smiley_Face: return "Smiley Face";
        case Item::Golden_Ticket: return "Golden Ticket";
        case Item::Swashbuckler: return "Swashbuckler";
        case Item::Hanging_Chad: return "Hanging Chad";
        case Item::Shoot_the_Moon: return "Shoot the Moon";
        case Item::J_C_END: return "J C END";
        case Item::J_U_BEGIN: return "J U BEGIN";
        case Item::Joker_Stencil: return "Joker Stencil";
        case Item::Four_Fingers: return "Four Fingers";
        case Item::Mime: return "Mime";
        case Item::Ceremonial_Dagger: return "Ceremonial Dagger";
        case Item::Marble_Joker: return "Marble Joker";
        case Item::Loyalty_Card: return "Loyalty Card";
        case Item::Dusk: return "Dusk";
        case Item::Fibonacci: return "Fibonacci";
        case Item::Steel_Joker: return "Steel Joker";
        case Item::Hack: return "Hack";
        case Item::Pareidolia: return "Pareidolia";
        case Item::Space_Joker: return "Space Joker";
        case Item::Burglar: return "Burglar";
        case Item::Blackboard: return "Blackboard";
        case Item::Sixth_Sense: return "Sixth Sense";
        case Item::Constellation: return "Constellation";
        case Item::Hiker: return "Hiker";
        case Item::Card_Sharp: return "Card Sharp";
        case Item::Madness: return "Madness";
        case Item::Seance: return "SΘance";
        case Item::Shortcut: return "Shortcut";
        case Item::Hologram: return "Hologram";
        case Item::Cloud_9: return "Cloud 9";
        case Item::Rocket: return "Rocket";
        case Item::Midas_Mask: return "Midas Mask";
        case Item::Luchador: return "Luchador";
        case Item::Gift_Card: return "Gift Card";
        case Item::Turtle_Bean: return "Turtle Bean";
        case Item::Erosion: return "Erosion";
        case Item::To_the_Moon: return "To the Moon";
        case Item::Stone_Joker: return "Stone Joker";
        case Item::Lucky_Cat: return "Lucky Cat";
        case Item::Bull: return "Bull";
        case Item::Diet_Cola: return "Diet Cola";
        case Item::Trading_Card: return "Trading Card";
        case Item::Flash_Card: return "Flash Card";
        case Item::Spare_Trousers: return "Spare Trousers";
        case Item::Ramen: return "Ramen";
        case Item::Seltzer: return "Seltzer";
        case Item::Castle: return "Castle";
        case Item::Mr_Bones: return "Mr. Bones";
        case Item::Acrobat: return "Acrobat";
        case Item::Sock_and_Buskin: return "Sock and Buskin";
        case Item::Troubadour: return "Troubadour";
        case Item::Certificate: return "Certificate";
        case Item::Smeared_Joker: return "Smeared Joker";
        case Item::Throwback: return "Throwback";
        case Item::Rough_Gem: return "Rough Gem";
        case Item::Bloodstone: return "Bloodstone";
        case Item::Arrowhead: return "Arrowhead";
        case Item::Onyx_Agate: return "Onyx Agate";
        case Item::Glass_Joker: return "Glass Joker";
        case Item::Showman: return "Showman";
        case Item::Flower_Pot: return "Flower Pot";
        case Item::Merry_Andy: return "Merry Andy";
        case Item::Oops_All_6s: return "Oops! All 6s";
        case Item::The_Idol: return "The Idol";
        case Item::Seeing_Double: return "Seeing Double";
        case Item::Matador: return "Matador";
        case Item::Stuntman: return "Stuntman";
        case Item::Satellite: return "Satellite";
        case Item::Cartomancer: return "Cartomancer";
        case Item::Astronomer: return "Astronomer";
        case Item::Bootstraps: return "Bootstraps";
        case Item::J_U_END: return "J U END";
        case Item::J_R_BEGIN: return "J R BEGIN";
        case Item::DNA: return "DNA";
        case Item::Vampire: return "Vampire";
        case Item::Vagabond: return "Vagabond";
        case Item::Baron: return "Baron";
        case Item::Obelisk: return "Obelisk";
        case Item::Baseball_Card: return "Baseball Card";
        case Item::Ancient_Joker: return "Ancient Joker";
        case Item::Campfire: return "Campfire";
        case Item::Blueprint: return "Blueprint";
        case Item::Wee_Joker: return "Wee Joker";
        case Item::Hit_the_Road: return "Hit the Road";
        case Item::The_Duo: return "The Duo";
        case Item::The_Trio: return "The Trio";
        case Item::The_Family: return "The Family";
        case Item::The_Order: return "The Order";
        case Item::The_Tribe: return "The Tribe";
        case Item::Invisible_Joker: return "Invisible Joker";
        case Item::Brainstorm: return "Brainstorm";
        case Item::Drivers_License: return "Driver's License";
        case Item::Burnt_Joker: return "Burnt Joker";
        case Item::J_R_END: return "J R END";
        case Item::J_L_BEGIN: return "J L BEGIN";
        case Item::Canio: return "Canio";
        case Item::Triboulet: return "Triboulet";
        case Item::Yorick: return "Yorick";
        case Item::Chicot: return "Chicot";
        case Item::Perkeo: return "Perkeo";
        case Item::J_L_END: return "J L END";
        case Item::J_END: return "J END";
        case Item::V_BEGIN: return "V BEGIN";
        case Item::Overstock: return "Overstock";
        case Item::Overstock_Plus: return "Overstock Plus";
        case Item::Clearance_Sale: return "Clearance Sale";
        case Item::Liquidation: return "Liquidation";
        case Item::Hone: return "Hone";
        case Item::Glow_Up: return "Glow Up";
        case Item::Reroll_Surplus: return "Reroll Surplus";
        case Item::Reroll_Glut: return "Reroll Glut";
        case Item::Crystal_Ball: return "Crystal Ball";
        case Item::Omen_Globe: return "Omen Globe";
        case Item::Telescope: return "Telescope";
        case Item::Observatory: return "Observatory";
        case Item::Grabber: return "Grabber";
        case Item::Nacho_Tong: return "Nacho Tong";
        case Item::Wasteful: return "Wasteful";
        case Item::Recyclomancy: return "Recyclomancy";
        case Item::Tarot_Merchant: return "Tarot Merchant";
        case Item::Tarot_Tycoon: return "Tarot Tycoon";
        case Item::Planet_Merchant: return "Planet Merchant";
        case Item::Planet_Tycoon: return "Planet Tycoon";
        case Item::Seed_Money: return "Seed Money";
        case Item::Money_Tree: return "Money Tree";
        case Item::Blank: return "Blank";
        case Item::Antimatter: return "Antimatter";
        case Item::Magic_Trick: return "Magic Trick";
        case Item::Illusion: return "Illusion";
        case Item::Hieroglyph: return "Hieroglyph";
        case Item::Petroglyph: return "Petroglyph";
        case Item::Directors_Cut: return "Director's Cut";
        case Item::Retcon: return "Retcon";
        case Item::Paint_Brush: return "Paint Brush";
        case Item::Palette: return "Palette";
        case Item::V_END: return "V END";
        case Item::T_BEGIN: return "T BEGIN";
        case Item::The_Fool: return "The Fool";
        case Item::The_Magician: return "The Magician";
        case Item::The_High_Priestess: return "The High Priestess";
        case Item::The_Empress: return "The Empress";
        case Item::The_Emperor: return "The Emperor";
        case Item::The_Hierophant: return "The Hierophant";
        case Item::The_Lovers: return "The Lovers";
        case Item::The_Chariot: return "The Chariot";
        case Item::Justice: return "Justice";
        case Item::The_Hermit: return "The Hermit";
        case Item::The_Wheel_of_Fortune: return "The Wheel of Fortune";
        case Item::Strength: return "Strength";
        case Item::The_Hanged_Man: return "The Hanged Man";
        case Item::Death: return "Death";
        case Item::Temperance: return "Temperance";
        case Item::The_Devil: return "The Devil";
        case Item::The_Tower: return "The Tower";
        case Item::The_Star: return "The Star";
        case Item::The_Moon: return "The Moon";
        case Item::The_Sun: return "The Sun";
        case Item::Judgement: return "Judgement";
        case Item::The_World: return "The World";
        case Item::T_END: return "T END";
        case Item::P_BEGIN: return "P BEGIN";
        case Item::Mercury: return "Mercury";
        case Item::Venus: return "Venus";
        case Item::Earth: return "Earth";
        case Item::Mars: return "Mars";
        case Item::Jupiter: return "Jupiter";
        case Item::Saturn: return "Saturn";
        case Item::Uranus: return "Uranus";
        case Item::Neptune: return "Neptune";
        case Item::Pluto: return "Pluto";
        case Item::Planet_X: return "Planet X";
        case Item::Ceres: return "Ceres";
        case Item::Eris: return "Eris";
        case Item::P_END: return "P END";
        case Item::H_BEGIN: return "H BEGIN";
        case Item::Pair: return "Pair";
        case Item::Three_of_a_Kind: return "Three of a Kind";
        case Item::Full_House: return "Full House";
        case Item::Four_of_a_Kind: return "Four of a Kind";
        case Item::Flush: return "Flush";
        case Item::Straight: return "Straight";
        case Item::Two_Pair: return "Two Pair";
        case Item::Straight_Flush: return "Straight Flush";
        case Item::High_Card: return "High Card";
        case Item::Five_of_a_Kind: return "Five of a Kind";
        case Item::Flush_House: return "Flush House";
        case Item::Flush_Five: return "Flush Five";
        case Item::H_END: return "H END";
        case Item::S_BEGIN: return "S BEGIN";
        case Item::Familiar: return "Familiar";
        case Item::Grim: return "Grim";
        case Item::Incantation: return "Incantation";
        case Item::Talisman: return "Talisman";
        case Item::Aura: return "Aura";
        case Item::Wraith: return "Wraith";
        case Item::Sigil: return "Sigil";
        case Item::Ouija: return "Ouija";
        case Item::Ectoplasm: return "Ectoplasm";
        case Item::Immolate: return "Immolate";
        case Item::Ankh: return "Ankh";
        case Item::Deja_Vu: return "Deja Vu";
        case Item::Hex: return "Hex";
        case Item::Trance: return "Trance";
        case Item::Medium: return "Medium";
        case Item::Cryptid: return "Cryptid";
        case Item::The_Soul: return "The Soul";
        case Item::Black_Hole: return "Black Hole";
        case Item::S_END: return "S END";
        case Item::ENHANCEMENT_BEGIN: return "ENHANCEMENT BEGIN";
        case Item::No_Enhancement: return "No Enhancement";
        case Item::Bonus_Card: return "Bonus Card";
        case Item::Mult_Card: return "Mult Card";
        case Item::Wild_Card: return "Wild Card";
        case Item::Glass_Card: return "Glass Card";
        case Item::Steel_Card: return "Steel Card";
        case Item::Stone_Card: return "Stone Card";
        case Item::Gold_Card: return "Gold Card";
        case Item::Lucky_Card: return "Lucky Card";
        case Item::ENHANCEMENT_END: return "ENHANCEMENT END";
        case Item::SEAL_BEGIN: return "SEAL BEGIN";
        case Item::No_Seal: return "No Seal";
        case Item::Gold_Seal: return "Gold Seal";
        case Item::Red_Seal: return "Red Seal";
        case Item::Blue_Seal: return "Blue Seal";
        case Item::Purple_Seal: return "Purple Seal";
        case Item::SEAL_END: return "SEAL END";
        case Item::E_BEGIN: return "E BEGIN";
        case Item::No_Edition: return "No Edition";
        case Item::Foil: return "Foil";
        case Item::Holographic: return "Holographic";
        case Item::Polychrome: return "Polychrome";
        case Item::Negative: return "Negative";
        case Item::E_END: return "E END";
        case Item::PACK_BEGIN: return "PACK BEGIN";
        case Item::Arcana_Pack: return "Arcana Pack";
        case Item::Jumbo_Arcana_Pack: return "Jumbo Arcana Pack";
        case Item::Mega_Arcana_Pack: return "Mega Arcana Pack";
        case Item::Celestial_Pack: return "Celestial Pack";
        case Item::Jumbo_Celestial_Pack: return "Jumbo Celestial Pack";
        case Item::Mega_Celestial_Pack: return "Mega Celestial Pack";
        case Item::Standard_Pack: return "Standard Pack";
        case Item::Jumbo_Standard_Pack: return "Jumbo Standard Pack";
        case Item::Mega_Standard_Pack: return "Mega Standard Pack";
        case Item::Buffoon_Pack: return "Buffoon Pack";
        case Item::Jumbo_Buffoon_Pack: return "Jumbo Buffoon Pack";
        case Item::Mega_Buffoon_Pack: return "Mega Buffoon Pack";
        case Item::Spectral_Pack: return "Spectral Pack";
        case Item::Jumbo_Spectral_Pack: return "Jumbo Spectral Pack";
        case Item::Mega_Spectral_Pack: return "Mega Spectral Pack";
        case Item::PACK_END: return "PACK END";
        case Item::TAG_BEGIN: return "TAG BEGIN";
        case Item::Uncommon_Tag: return "Uncommon Tag";
        case Item::Rare_Tag: return "Rare Tag";
        case Item::Negative_Tag: return "Negative Tag";
        case Item::Foil_Tag: return "Foil Tag";
        case Item::Holographic_Tag: return "Holographic Tag";
        case Item::Polychrome_Tag: return "Polychrome Tag";
        case Item::Investment_Tag: return "Investment Tag";
        case Item::Voucher_Tag: return "Voucher Tag";
        case Item::Boss_Tag: return "Boss Tag";
        case Item::Standard_Tag: return "Standard Tag";
        case Item::Charm_Tag: return "Charm Tag";
        case Item::Meteor_Tag: return "Meteor Tag";
        case Item::Buffoon_Tag: return "Buffoon Tag";
        case Item::Handy_Tag: return "Handy Tag";
        case Item::Garbage_Tag: return "Garbage Tag";
        case Item::Ethereal_Tag: return "Ethereal Tag";
        case Item::Coupon_Tag: return "Coupon Tag";
        case Item::Double_Tag: return "Double Tag";
        case Item::Juggle_Tag: return "Juggle Tag";
        case Item::D6_Tag: return "D6 Tag";
        case Item::Top_up_Tag: return "Top-up Tag";
        case Item::Speed_Tag: return "Speed Tag";
        case Item::Orbital_Tag: return "Orbital Tag";
        case Item::Economy_Tag: return "Economy Tag";
        case Item::TAG_END: return "TAG END";
        case Item::B_BEGIN: return "B BEGIN";
        case Item::Small_Blind: return "Small Blind";
        case Item::Big_Blind: return "Big Blind";
        case Item::The_Hook: return "The Hook";
        case Item::The_Ox: return "The Ox";
        case Item::The_House: return "The House";
        case Item::The_Wall: return "The Wall";
        case Item::The_Wheel: return "The Wheel";
        case Item::The_Arm: return "The Arm";
        case Item::The_Club: return "The Club";
        case Item::The_Fish: return "The Fish";
        case Item::The_Psychic: return "The Psychic";
        case Item::The_Goad: return "The Goad";
        case Item::The_Water: return "The Water";
        case Item::The_Window: return "The Window";
        case Item::The_Manacle: return "The Manacle";
        case Item::The_Eye: return "The Eye";
        case Item::The_Mouth: return "The Mouth";
        case Item::The_Plant: return "The Plant";
        case Item::The_Serpent: return "The Serpent";
        case Item::The_Pillar: return "The Pillar";
        case Item::The_Needle: return "The Needle";
        case Item::The_Head: return "The Head";
        case Item::The_Tooth: return "The Tooth";
        case Item::The_Flint: return "The Flint";
        case Item::The_Mark: return "The Mark";
        case Item::B_F_BEGIN: return "B F BEGIN";
        case Item::Amber_Acorn: return "Amber Acorn";
        case Item::Verdant_Leaf: return "Verdant Leaf";
        case Item::Violet_Vessel: return "Violet Vessel";
        case Item::Crimson_Heart: return "Crimson Heart";
        case Item::Cerulean_Bell: return "Cerulean Bell";
        case Item::B_F_END: return "B F END";
        case Item::B_END: return "B END";
        case Item::SUIT_BEGIN: return "SUIT BEGIN";
        case Item::Hearts: return "Hearts";
        case Item::Clubs: return "Clubs";
        case Item::Diamonds: return "Diamonds";
        case Item::Spades: return "Spades";
        case Item::SUIT_END: return "SUIT END";
        case Item::RANK_BEGIN: return "RANK BEGIN";
        case Item::_2: return "2";
        case Item::_3: return "3";
        case Item::_4: return "4";
        case Item::_5: return "5";
        case Item::_6: return "6";
        case Item::_7: return "7";
        case Item::_8: return "8";
        case Item::_9: return "9";
        case Item::_10: return "10";
        case Item::Jack: return "Jack";
        case Item::Queen: return "Queen";
        case Item::King: return "King";
        case Item::Ace: return "Ace";
        case Item::RANK_END: return "RANK END";
        case Item::C_BEGIN: return "C BEGIN";
        case Item::C_2: return "C 2";
        case Item::C_3: return "C 3";
        case Item::C_4: return "C 4";
        case Item::C_5: return "C 5";
        case Item::C_6: return "C 6";
        case Item::C_7: return "C 7";
        case Item::C_8: return "C 8";
        case Item::C_9: return "C 9";
        case Item::C_A: return "C A";
        case Item::C_J: return "C J";
        case Item::C_K: return "C K";
        case Item::C_Q: return "C Q";
        case Item::C_T: return "C T";
        case Item::D_2: return "D 2";
        case Item::D_3: return "D 3";
        case Item::D_4: return "D 4";
        case Item::D_5: return "D 5";
        case Item::D_6: return "D 6";
        case Item::D_7: return "D 7";
        case Item::D_8: return "D 8";
        case Item::D_9: return "D 9";
        case Item::D_A: return "D A";
        case Item::D_J: return "D J";
        case Item::D_K: return "D K";
        case Item::D_Q: return "D Q";
        case Item::D_T: return "D T";
        case Item::H_2: return "H 2";
        case Item::H_3: return "H 3";
        case Item::H_4: return "H 4";
        case Item::H_5: return "H 5";
        case Item::H_6: return "H 6";
        case Item::H_7: return "H 7";
        case Item::H_8: return "H 8";
        case Item::H_9: return "H 9";
        case Item::H_A: return "H A";
        case Item::H_J: return "H J";
        case Item::H_K: return "H K";
        case Item::H_Q: return "H Q";
        case Item::H_T: return "H T";
        case Item::S_2: return "S 2";
        case Item::S_3: return "S 3";
        case Item::S_4: return "S 4";
        case Item::S_5: return "S 5";
        case Item::S_6: return "S 6";
        case Item::S_7: return "S 7";
        case Item::S_8: return "S 8";
        case Item::S_9: return "S 9";
        case Item::S_A: return "S A";
        case Item::S_J: return "S J";
        case Item::S_K: return "S K";
        case Item::S_Q: return "S Q";
        case Item::S_T: return "S T";
        case Item::C_END: return "C END";
        case Item::D_BEGIN: return "D BEGIN";
        case Item::Red_Deck: return "Red Deck";
        case Item::Blue_Deck: return "Blue Deck";
        case Item::Yellow_Deck: return "Yellow Deck";
        case Item::Green_Deck: return "Green Deck";
        case Item::Black_Deck: return "Black Deck";
        case Item::Magic_Deck: return "Magic Deck";
        case Item::Nebula_Deck: return "Nebula Deck";
        case Item::Ghost_Deck: return "Ghost Deck";
        case Item::Abandoned_Deck: return "Abandoned Deck";
        case Item::Checkered_Deck: return "Checkered Deck";
        case Item::Zodiac_Deck: return "Zodiac Deck";
        case Item::Painted_Deck: return "Painted Deck";
        case Item::Anaglyph_Deck: return "Anaglyph Deck";
        case Item::Plasma_Deck: return "Plasma Deck";
        case Item::Erratic_Deck: return "Erratic Deck";
        case Item::Challenge_Deck: return "Challenge Deck";
        case Item::D_END: return "D END";
        case Item::CHAL_BEGIN: return "CHAL BEGIN";
        case Item::The_Omelette: return "The Omelette";
        case Item::_15_Minute_City: return "15 Minute City";
        case Item::Rich_get_Richer: return "Rich get Richer";
        case Item::On_a_Knifes_Edge: return "On a Knife's Edge";
        case Item::X_ray_Vision: return "X-ray Vision";
        case Item::Mad_World: return "Mad World";
        case Item::Luxury_Tax: return "Luxury Tax";
        case Item::Non_Perishable: return "Non-Perishable";
        case Item::Medusa: return "Medusa";
        case Item::Double_or_Nothing: return "Double or Nothing";
        case Item::Typecast: return "Typecast";
        case Item::Inflation: return "Inflation";
        case Item::Bram_Poker: return "Bram Poker";
        case Item::Fragile: return "Fragile";
        case Item::Monolith: return "Monolith";
        case Item::Blast_Off: return "Blast Off";
        case Item::Five_Card_Draw: return "Five-Card Draw";
        case Item::Golden_Needle: return "Golden Needle";
        case Item::Cruelty: return "Cruelty";
        case Item::Jokerless: return "Jokerless";
        case Item::CHAL_END: return "CHAL END";
        case Item::STAKE_BEGIN: return "STAKE BEGIN";
        case Item::White_Stake: return "White Stake";
        case Item::Red_Stake: return "Red Stake";
        case Item::Green_Stake: return "Green Stake";
        case Item::Black_Stake: return "Black Stake";
        case Item::Blue_Stake: return "Blue Stake";
        case Item::Purple_Stake: return "Purple Stake";
        case Item::Orange_Stake: return "Orange Stake";
        case Item::Gold_Stake: return "Gold Stake";
        case Item::STAKE_END: return "STAKE END";
        case Item::RARITY_BEGIN: return "RARITY BEGIN";
        case Item::Common: return "Common";
        case Item::Uncommon: return "Uncommon";
        case Item::Rare: return "Rare";
        case Item::Legendary: return "Legendary";
        case Item::RARITY_END: return "RARITY END";
        case Item::TYPE_BEGIN: return "TYPE BEGIN";
        case Item::T_Joker: return "T Joker";
        case Item::T_Tarot: return "T Tarot";
        case Item::T_Planet: return "T Planet";
        case Item::T_Spectral: return "T Spectral";
        case Item::T_Playing_Card: return "T Playing Card";
        case Item::TYPE_END: return "TYPE END";
    }
}
Item stringToItem(std::string i) {
if (i == "RETRY") {return Item::RETRY;};
if (i == "J BEGIN") {return Item::J_BEGIN;};
if (i == "J C BEGIN") {return Item::J_C_BEGIN;};
if (i == "Joker") {return Item::Joker;};
if (i == "Greedy Joker") {return Item::Greedy_Joker;};
if (i == "Lusty Joker") {return Item::Lusty_Joker;};
if (i == "Wrathful Joker") {return Item::Wrathful_Joker;};
if (i == "Gluttonous Joker") {return Item::Gluttonous_Joker;};
if (i == "Jolly Joker") {return Item::Jolly_Joker;};
if (i == "Zany Joker") {return Item::Zany_Joker;};
if (i == "Mad Joker") {return Item::Mad_Joker;};
if (i == "Crazy Joker") {return Item::Crazy_Joker;};
if (i == "Droll Joker") {return Item::Droll_Joker;};
if (i == "Sly Joker") {return Item::Sly_Joker;};
if (i == "Wily Joker") {return Item::Wily_Joker;};
if (i == "Clever Joker") {return Item::Clever_Joker;};
if (i == "Devious Joker") {return Item::Devious_Joker;};
if (i == "Crafty Joker") {return Item::Crafty_Joker;};
if (i == "Half Joker") {return Item::Half_Joker;};
if (i == "Credit Card") {return Item::Credit_Card;};
if (i == "Banner") {return Item::Banner;};
if (i == "Mystic Summit") {return Item::Mystic_Summit;};
if (i == "8 Ball") {return Item::_8_Ball;};
if (i == "Misprint") {return Item::Misprint;};
if (i == "Raised Fist") {return Item::Raised_Fist;};
if (i == "Chaos the Clown") {return Item::Chaos_the_Clown;};
if (i == "Scary Face") {return Item::Scary_Face;};
if (i == "Abstract Joker") {return Item::Abstract_Joker;};
if (i == "Delayed Gratification") {return Item::Delayed_Gratification;};
if (i == "Gros Michel") {return Item::Gros_Michel;};
if (i == "Even Steven") {return Item::Even_Steven;};
if (i == "Odd Todd") {return Item::Odd_Todd;};
if (i == "Scholar") {return Item::Scholar;};
if (i == "Business Card") {return Item::Business_Card;};
if (i == "Supernova") {return Item::Supernova;};
if (i == "Ride the Bus") {return Item::Ride_the_Bus;};
if (i == "Egg") {return Item::Egg;};
if (i == "Runner") {return Item::Runner;};
if (i == "Ice Cream") {return Item::Ice_Cream;};
if (i == "Splash") {return Item::Splash;};
if (i == "Blue Joker") {return Item::Blue_Joker;};
if (i == "Faceless Joker") {return Item::Faceless_Joker;};
if (i == "Green Joker") {return Item::Green_Joker;};
if (i == "Superposition") {return Item::Superposition;};
if (i == "To Do List") {return Item::To_Do_List;};
if (i == "Cavendish") {return Item::Cavendish;};
if (i == "Red Card") {return Item::Red_Card;};
if (i == "Square Joker") {return Item::Square_Joker;};
if (i == "Riff-raff") {return Item::Riff_raff;};
if (i == "Photograph") {return Item::Photograph;};
if (i == "Reserved Parking") {return Item::Reserved_Parking;};
if (i == "Mail-In Rebate") {return Item::Mail_In_Rebate;};
if (i == "Hallucination") {return Item::Hallucination;};
if (i == "Fortune Teller") {return Item::Fortune_Teller;};
if (i == "Juggler") {return Item::Juggler;};
if (i == "Drunkard") {return Item::Drunkard;};
if (i == "Golden Joker") {return Item::Golden_Joker;};
if (i == "Popcorn") {return Item::Popcorn;};
if (i == "Walkie Talkie") {return Item::Walkie_Talkie;};
if (i == "Smiley Face") {return Item::Smiley_Face;};
if (i == "Golden Ticket") {return Item::Golden_Ticket;};
if (i == "Swashbuckler") {return Item::Swashbuckler;};
if (i == "Hanging Chad") {return Item::Hanging_Chad;};
if (i == "Shoot the Moon") {return Item::Shoot_the_Moon;};
if (i == "J C END") {return Item::J_C_END;};
if (i == "J U BEGIN") {return Item::J_U_BEGIN;};
if (i == "Joker Stencil") {return Item::Joker_Stencil;};
if (i == "Four Fingers") {return Item::Four_Fingers;};
if (i == "Mime") {return Item::Mime;};
if (i == "Ceremonial Dagger") {return Item::Ceremonial_Dagger;};
if (i == "Marble Joker") {return Item::Marble_Joker;};
if (i == "Loyalty Card") {return Item::Loyalty_Card;};
if (i == "Dusk") {return Item::Dusk;};
if (i == "Fibonacci") {return Item::Fibonacci;};
if (i == "Steel Joker") {return Item::Steel_Joker;};
if (i == "Hack") {return Item::Hack;};
if (i == "Pareidolia") {return Item::Pareidolia;};
if (i == "Space Joker") {return Item::Space_Joker;};
if (i == "Burglar") {return Item::Burglar;};
if (i == "Blackboard") {return Item::Blackboard;};
if (i == "Sixth Sense") {return Item::Sixth_Sense;};
if (i == "Constellation") {return Item::Constellation;};
if (i == "Hiker") {return Item::Hiker;};
if (i == "Card Sharp") {return Item::Card_Sharp;};
if (i == "Madness") {return Item::Madness;};
if (i == "SΘance") {return Item::Seance;};
if (i == "Shortcut") {return Item::Shortcut;};
if (i == "Hologram") {return Item::Hologram;};
if (i == "Cloud 9") {return Item::Cloud_9;};
if (i == "Rocket") {return Item::Rocket;};
if (i == "Midas Mask") {return Item::Midas_Mask;};
if (i == "Luchador") {return Item::Luchador;};
if (i == "Gift Card") {return Item::Gift_Card;};
if (i == "Turtle Bean") {return Item::Turtle_Bean;};
if (i == "Erosion") {return Item::Erosion;};
if (i == "To the Moon") {return Item::To_the_Moon;};
if (i == "Stone Joker") {return Item::Stone_Joker;};
if (i == "Lucky Cat") {return Item::Lucky_Cat;};
if (i == "Bull") {return Item::Bull;};
if (i == "Diet Cola") {return Item::Diet_Cola;};
if (i == "Trading Card") {return Item::Trading_Card;};
if (i == "Flash Card") {return Item::Flash_Card;};
if (i == "Spare Trousers") {return Item::Spare_Trousers;};
if (i == "Ramen") {return Item::Ramen;};
if (i == "Seltzer") {return Item::Seltzer;};
if (i == "Castle") {return Item::Castle;};
if (i == "Mr. Bones") {return Item::Mr_Bones;};
if (i == "Acrobat") {return Item::Acrobat;};
if (i == "Sock and Buskin") {return Item::Sock_and_Buskin;};
if (i == "Troubadour") {return Item::Troubadour;};
if (i == "Certificate") {return Item::Certificate;};
if (i == "Smeared Joker") {return Item::Smeared_Joker;};
if (i == "Throwback") {return Item::Throwback;};
if (i == "Rough Gem") {return Item::Rough_Gem;};
if (i == "Bloodstone") {return Item::Bloodstone;};
if (i == "Arrowhead") {return Item::Arrowhead;};
if (i == "Onyx Agate") {return Item::Onyx_Agate;};
if (i == "Glass Joker") {return Item::Glass_Joker;};
if (i == "Showman") {return Item::Showman;};
if (i == "Flower Pot") {return Item::Flower_Pot;};
if (i == "Merry Andy") {return Item::Merry_Andy;};
if (i == "Oops! All 6s") {return Item::Oops_All_6s;};
if (i == "The Idol") {return Item::The_Idol;};
if (i == "Seeing Double") {return Item::Seeing_Double;};
if (i == "Matador") {return Item::Matador;};
if (i == "Stuntman") {return Item::Stuntman;};
if (i == "Satellite") {return Item::Satellite;};
if (i == "Cartomancer") {return Item::Cartomancer;};
if (i == "Astronomer") {return Item::Astronomer;};
if (i == "Bootstraps") {return Item::Bootstraps;};
if (i == "J U END") {return Item::J_U_END;};
if (i == "J R BEGIN") {return Item::J_R_BEGIN;};
if (i == "DNA") {return Item::DNA;};
if (i == "Vampire") {return Item::Vampire;};
if (i == "Vagabond") {return Item::Vagabond;};
if (i == "Baron") {return Item::Baron;};
if (i == "Obelisk") {return Item::Obelisk;};
if (i == "Baseball Card") {return Item::Baseball_Card;};
if (i == "Ancient Joker") {return Item::Ancient_Joker;};
if (i == "Campfire") {return Item::Campfire;};
if (i == "Blueprint") {return Item::Blueprint;};
if (i == "Wee Joker") {return Item::Wee_Joker;};
if (i == "Hit the Road") {return Item::Hit_the_Road;};
if (i == "The Duo") {return Item::The_Duo;};
if (i == "The Trio") {return Item::The_Trio;};
if (i == "The Family") {return Item::The_Family;};
if (i == "The Order") {return Item::The_Order;};
if (i == "The Tribe") {return Item::The_Tribe;};
if (i == "Invisible Joker") {return Item::Invisible_Joker;};
if (i == "Brainstorm") {return Item::Brainstorm;};
if (i == "Driver's License") {return Item::Drivers_License;};
if (i == "Burnt Joker") {return Item::Burnt_Joker;};
if (i == "J R END") {return Item::J_R_END;};
if (i == "J L BEGIN") {return Item::J_L_BEGIN;};
if (i == "Canio") {return Item::Canio;};
if (i == "Triboulet") {return Item::Triboulet;};
if (i == "Yorick") {return Item::Yorick;};
if (i == "Chicot") {return Item::Chicot;};
if (i == "Perkeo") {return Item::Perkeo;};
if (i == "J L END") {return Item::J_L_END;};
if (i == "J END") {return Item::J_END;};
if (i == "V BEGIN") {return Item::V_BEGIN;};
if (i == "Overstock") {return Item::Overstock;};
if (i == "Overstock Plus") {return Item::Overstock_Plus;};
if (i == "Clearance Sale") {return Item::Clearance_Sale;};
if (i == "Liquidation") {return Item::Liquidation;};
if (i == "Hone") {return Item::Hone;};
if (i == "Glow Up") {return Item::Glow_Up;};
if (i == "Reroll Surplus") {return Item::Reroll_Surplus;};
if (i == "Reroll Glut") {return Item::Reroll_Glut;};
if (i == "Crystal Ball") {return Item::Crystal_Ball;};
if (i == "Omen Globe") {return Item::Omen_Globe;};
if (i == "Telescope") {return Item::Telescope;};
if (i == "Observatory") {return Item::Observatory;};
if (i == "Grabber") {return Item::Grabber;};
if (i == "Nacho Tong") {return Item::Nacho_Tong;};
if (i == "Wasteful") {return Item::Wasteful;};
if (i == "Recyclomancy") {return Item::Recyclomancy;};
if (i == "Tarot Merchant") {return Item::Tarot_Merchant;};
if (i == "Tarot Tycoon") {return Item::Tarot_Tycoon;};
if (i == "Planet Merchant") {return Item::Planet_Merchant;};
if (i == "Planet Tycoon") {return Item::Planet_Tycoon;};
if (i == "Seed Money") {return Item::Seed_Money;};
if (i == "Money Tree") {return Item::Money_Tree;};
if (i == "Blank") {return Item::Blank;};
if (i == "Antimatter") {return Item::Antimatter;};
if (i == "Magic Trick") {return Item::Magic_Trick;};
if (i == "Illusion") {return Item::Illusion;};
if (i == "Hieroglyph") {return Item::Hieroglyph;};
if (i == "Petroglyph") {return Item::Petroglyph;};
if (i == "Director's Cut") {return Item::Directors_Cut;};
if (i == "Retcon") {return Item::Retcon;};
if (i == "Paint Brush") {return Item::Paint_Brush;};
if (i == "Palette") {return Item::Palette;};
if (i == "V END") {return Item::V_END;};
if (i == "T BEGIN") {return Item::T_BEGIN;};
if (i == "The Fool") {return Item::The_Fool;};
if (i == "The Magician") {return Item::The_Magician;};
if (i == "The High Priestess") {return Item::The_High_Priestess;};
if (i == "The Empress") {return Item::The_Empress;};
if (i == "The Emperor") {return Item::The_Emperor;};
if (i == "The Hierophant") {return Item::The_Hierophant;};
if (i == "The Lovers") {return Item::The_Lovers;};
if (i == "The Chariot") {return Item::The_Chariot;};
if (i == "Justice") {return Item::Justice;};
if (i == "The Hermit") {return Item::The_Hermit;};
if (i == "The Wheel of Fortune") {return Item::The_Wheel_of_Fortune;};
if (i == "Strength") {return Item::Strength;};
if (i == "The Hanged Man") {return Item::The_Hanged_Man;};
if (i == "Death") {return Item::Death;};
if (i == "Temperance") {return Item::Temperance;};
if (i == "The Devil") {return Item::The_Devil;};
if (i == "The Tower") {return Item::The_Tower;};
if (i == "The Star") {return Item::The_Star;};
if (i == "The Moon") {return Item::The_Moon;};
if (i == "The Sun") {return Item::The_Sun;};
if (i == "Judgement") {return Item::Judgement;};
if (i == "The World") {return Item::The_World;};
if (i == "T END") {return Item::T_END;};
if (i == "P BEGIN") {return Item::P_BEGIN;};
if (i == "Mercury") {return Item::Mercury;};
if (i == "Venus") {return Item::Venus;};
if (i == "Earth") {return Item::Earth;};
if (i == "Mars") {return Item::Mars;};
if (i == "Jupiter") {return Item::Jupiter;};
if (i == "Saturn") {return Item::Saturn;};
if (i == "Uranus") {return Item::Uranus;};
if (i == "Neptune") {return Item::Neptune;};
if (i == "Pluto") {return Item::Pluto;};
if (i == "Planet X") {return Item::Planet_X;};
if (i == "Ceres") {return Item::Ceres;};
if (i == "Eris") {return Item::Eris;};
if (i == "P END") {return Item::P_END;};
if (i == "H BEGIN") {return Item::H_BEGIN;};
if (i == "Pair") {return Item::Pair;};
if (i == "Three of a Kind") {return Item::Three_of_a_Kind;};
if (i == "Full House") {return Item::Full_House;};
if (i == "Four of a Kind") {return Item::Four_of_a_Kind;};
if (i == "Flush") {return Item::Flush;};
if (i == "Straight") {return Item::Straight;};
if (i == "Two Pair") {return Item::Two_Pair;};
if (i == "Straight Flush") {return Item::Straight_Flush;};
if (i == "High Card") {return Item::High_Card;};
if (i == "Five of a Kind") {return Item::Five_of_a_Kind;};
if (i == "Flush House") {return Item::Flush_House;};
if (i == "Flush Five") {return Item::Flush_Five;};
if (i == "H END") {return Item::H_END;};
if (i == "S BEGIN") {return Item::S_BEGIN;};
if (i == "Familiar") {return Item::Familiar;};
if (i == "Grim") {return Item::Grim;};
if (i == "Incantation") {return Item::Incantation;};
if (i == "Talisman") {return Item::Talisman;};
if (i == "Aura") {return Item::Aura;};
if (i == "Wraith") {return Item::Wraith;};
if (i == "Sigil") {return Item::Sigil;};
if (i == "Ouija") {return Item::Ouija;};
if (i == "Ectoplasm") {return Item::Ectoplasm;};
if (i == "Immolate") {return Item::Immolate;};
if (i == "Ankh") {return Item::Ankh;};
if (i == "Deja Vu") {return Item::Deja_Vu;};
if (i == "Hex") {return Item::Hex;};
if (i == "Trance") {return Item::Trance;};
if (i == "Medium") {return Item::Medium;};
if (i == "Cryptid") {return Item::Cryptid;};
if (i == "The Soul") {return Item::The_Soul;};
if (i == "Black Hole") {return Item::Black_Hole;};
if (i == "S END") {return Item::S_END;};
if (i == "ENHANCEMENT BEGIN") {return Item::ENHANCEMENT_BEGIN;};
if (i == "No Enhancement") {return Item::No_Enhancement;};
if (i == "Bonus Card") {return Item::Bonus_Card;};
if (i == "Mult Card") {return Item::Mult_Card;};
if (i == "Wild Card") {return Item::Wild_Card;};
if (i == "Glass Card") {return Item::Glass_Card;};
if (i == "Steel Card") {return Item::Steel_Card;};
if (i == "Stone Card") {return Item::Stone_Card;};
if (i == "Gold Card") {return Item::Gold_Card;};
if (i == "Lucky Card") {return Item::Lucky_Card;};
if (i == "ENHANCEMENT END") {return Item::ENHANCEMENT_END;};
if (i == "SEAL BEGIN") {return Item::SEAL_BEGIN;};
if (i == "No Seal") {return Item::No_Seal;};
if (i == "Gold Seal") {return Item::Gold_Seal;};
if (i == "Red Seal") {return Item::Red_Seal;};
if (i == "Blue Seal") {return Item::Blue_Seal;};
if (i == "Purple Seal") {return Item::Purple_Seal;};
if (i == "SEAL END") {return Item::SEAL_END;};
if (i == "E BEGIN") {return Item::E_BEGIN;};
if (i == "No Edition") {return Item::No_Edition;};
if (i == "Foil") {return Item::Foil;};
if (i == "Holographic") {return Item::Holographic;};
if (i == "Polychrome") {return Item::Polychrome;};
if (i == "Negative") {return Item::Negative;};
if (i == "E END") {return Item::E_END;};
if (i == "PACK BEGIN") {return Item::PACK_BEGIN;};
if (i == "Arcana Pack") {return Item::Arcana_Pack;};
if (i == "Jumbo Arcana Pack") {return Item::Jumbo_Arcana_Pack;};
if (i == "Mega Arcana Pack") {return Item::Mega_Arcana_Pack;};
if (i == "Celestial Pack") {return Item::Celestial_Pack;};
if (i == "Jumbo Celestial Pack") {return Item::Jumbo_Celestial_Pack;};
if (i == "Mega Celestial Pack") {return Item::Mega_Celestial_Pack;};
if (i == "Standard Pack") {return Item::Standard_Pack;};
if (i == "Jumbo Standard Pack") {return Item::Jumbo_Standard_Pack;};
if (i == "Mega Standard Pack") {return Item::Mega_Standard_Pack;};
if (i == "Buffoon Pack") {return Item::Buffoon_Pack;};
if (i == "Jumbo Buffoon Pack") {return Item::Jumbo_Buffoon_Pack;};
if (i == "Mega Buffoon Pack") {return Item::Mega_Buffoon_Pack;};
if (i == "Spectral Pack") {return Item::Spectral_Pack;};
if (i == "Jumbo Spectral Pack") {return Item::Jumbo_Spectral_Pack;};
if (i == "Mega Spectral Pack") {return Item::Mega_Spectral_Pack;};
if (i == "PACK END") {return Item::PACK_END;};
if (i == "TAG BEGIN") {return Item::TAG_BEGIN;};
if (i == "Uncommon Tag") {return Item::Uncommon_Tag;};
if (i == "Rare Tag") {return Item::Rare_Tag;};
if (i == "Negative Tag") {return Item::Negative_Tag;};
if (i == "Foil Tag") {return Item::Foil_Tag;};
if (i == "Holographic Tag") {return Item::Holographic_Tag;};
if (i == "Polychrome Tag") {return Item::Polychrome_Tag;};
if (i == "Investment Tag") {return Item::Investment_Tag;};
if (i == "Voucher Tag") {return Item::Voucher_Tag;};
if (i == "Boss Tag") {return Item::Boss_Tag;};
if (i == "Standard Tag") {return Item::Standard_Tag;};
if (i == "Charm Tag") {return Item::Charm_Tag;};
if (i == "Meteor Tag") {return Item::Meteor_Tag;};
if (i == "Buffoon Tag") {return Item::Buffoon_Tag;};
if (i == "Handy Tag") {return Item::Handy_Tag;};
if (i == "Garbage Tag") {return Item::Garbage_Tag;};
if (i == "Ethereal Tag") {return Item::Ethereal_Tag;};
if (i == "Coupon Tag") {return Item::Coupon_Tag;};
if (i == "Double Tag") {return Item::Double_Tag;};
if (i == "Juggle Tag") {return Item::Juggle_Tag;};
if (i == "D6 Tag") {return Item::D6_Tag;};
if (i == "Top-up Tag") {return Item::Top_up_Tag;};
if (i == "Speed Tag") {return Item::Speed_Tag;};
if (i == "Orbital Tag") {return Item::Orbital_Tag;};
if (i == "Economy Tag") {return Item::Economy_Tag;};
if (i == "TAG END") {return Item::TAG_END;};
if (i == "B BEGIN") {return Item::B_BEGIN;};
if (i == "Small Blind") {return Item::Small_Blind;};
if (i == "Big Blind") {return Item::Big_Blind;};
if (i == "The Hook") {return Item::The_Hook;};
if (i == "The Ox") {return Item::The_Ox;};
if (i == "The House") {return Item::The_House;};
if (i == "The Wall") {return Item::The_Wall;};
if (i == "The Wheel") {return Item::The_Wheel;};
if (i == "The Arm") {return Item::The_Arm;};
if (i == "The Club") {return Item::The_Club;};
if (i == "The Fish") {return Item::The_Fish;};
if (i == "The Psychic") {return Item::The_Psychic;};
if (i == "The Goad") {return Item::The_Goad;};
if (i == "The Water") {return Item::The_Water;};
if (i == "The Window") {return Item::The_Window;};
if (i == "The Manacle") {return Item::The_Manacle;};
if (i == "The Eye") {return Item::The_Eye;};
if (i == "The Mouth") {return Item::The_Mouth;};
if (i == "The Plant") {return Item::The_Plant;};
if (i == "The Serpent") {return Item::The_Serpent;};
if (i == "The Pillar") {return Item::The_Pillar;};
if (i == "The Needle") {return Item::The_Needle;};
if (i == "The Head") {return Item::The_Head;};
if (i == "The Tooth") {return Item::The_Tooth;};
if (i == "The Flint") {return Item::The_Flint;};
if (i == "The Mark") {return Item::The_Mark;};
if (i == "B F BEGIN") {return Item::B_F_BEGIN;};
if (i == "Amber Acorn") {return Item::Amber_Acorn;};
if (i == "Verdant Leaf") {return Item::Verdant_Leaf;};
if (i == "Violet Vessel") {return Item::Violet_Vessel;};
if (i == "Crimson Heart") {return Item::Crimson_Heart;};
if (i == "Cerulean Bell") {return Item::Cerulean_Bell;};
if (i == "B F END") {return Item::B_F_END;};
if (i == "B END") {return Item::B_END;};
if (i == "SUIT BEGIN") {return Item::SUIT_BEGIN;};
if (i == "Hearts") {return Item::Hearts;};
if (i == "Clubs") {return Item::Clubs;};
if (i == "Diamonds") {return Item::Diamonds;};
if (i == "Spades") {return Item::Spades;};
if (i == "SUIT END") {return Item::SUIT_END;};
if (i == "RANK BEGIN") {return Item::RANK_BEGIN;};
if (i == "2") {return Item::_2;};
if (i == "3") {return Item::_3;};
if (i == "4") {return Item::_4;};
if (i == "5") {return Item::_5;};
if (i == "6") {return Item::_6;};
if (i == "7") {return Item::_7;};
if (i == "8") {return Item::_8;};
if (i == "9") {return Item::_9;};
if (i == "10") {return Item::_10;};
if (i == "Jack") {return Item::Jack;};
if (i == "Queen") {return Item::Queen;};
if (i == "King") {return Item::King;};
if (i == "Ace") {return Item::Ace;};
if (i == "RANK END") {return Item::RANK_END;};
if (i == "C BEGIN") {return Item::C_BEGIN;};
if (i == "C 2") {return Item::C_2;};
if (i == "C 3") {return Item::C_3;};
if (i == "C 4") {return Item::C_4;};
if (i == "C 5") {return Item::C_5;};
if (i == "C 6") {return Item::C_6;};
if (i == "C 7") {return Item::C_7;};
if (i == "C 8") {return Item::C_8;};
if (i == "C 9") {return Item::C_9;};
if (i == "C A") {return Item::C_A;};
if (i == "C J") {return Item::C_J;};
if (i == "C K") {return Item::C_K;};
if (i == "C Q") {return Item::C_Q;};
if (i == "C T") {return Item::C_T;};
if (i == "D 2") {return Item::D_2;};
if (i == "D 3") {return Item::D_3;};
if (i == "D 4") {return Item::D_4;};
if (i == "D 5") {return Item::D_5;};
if (i == "D 6") {return Item::D_6;};
if (i == "D 7") {return Item::D_7;};
if (i == "D 8") {return Item::D_8;};
if (i == "D 9") {return Item::D_9;};
if (i == "D A") {return Item::D_A;};
if (i == "D J") {return Item::D_J;};
if (i == "D K") {return Item::D_K;};
if (i == "D Q") {return Item::D_Q;};
if (i == "D T") {return Item::D_T;};
if (i == "H 2") {return Item::H_2;};
if (i == "H 3") {return Item::H_3;};
if (i == "H 4") {return Item::H_4;};
if (i == "H 5") {return Item::H_5;};
if (i == "H 6") {return Item::H_6;};
if (i == "H 7") {return Item::H_7;};
if (i == "H 8") {return Item::H_8;};
if (i == "H 9") {return Item::H_9;};
if (i == "H A") {return Item::H_A;};
if (i == "H J") {return Item::H_J;};
if (i == "H K") {return Item::H_K;};
if (i == "H Q") {return Item::H_Q;};
if (i == "H T") {return Item::H_T;};
if (i == "S 2") {return Item::S_2;};
if (i == "S 3") {return Item::S_3;};
if (i == "S 4") {return Item::S_4;};
if (i == "S 5") {return Item::S_5;};
if (i == "S 6") {return Item::S_6;};
if (i == "S 7") {return Item::S_7;};
if (i == "S 8") {return Item::S_8;};
if (i == "S 9") {return Item::S_9;};
if (i == "S A") {return Item::S_A;};
if (i == "S J") {return Item::S_J;};
if (i == "S K") {return Item::S_K;};
if (i == "S Q") {return Item::S_Q;};
if (i == "S T") {return Item::S_T;};
if (i == "C END") {return Item::C_END;};
if (i == "D BEGIN") {return Item::D_BEGIN;};
if (i == "Red Deck") {return Item::Red_Deck;};
if (i == "Blue Deck") {return Item::Blue_Deck;};
if (i == "Yellow Deck") {return Item::Yellow_Deck;};
if (i == "Green Deck") {return Item::Green_Deck;};
if (i == "Black Deck") {return Item::Black_Deck;};
if (i == "Magic Deck") {return Item::Magic_Deck;};
if (i == "Nebula Deck") {return Item::Nebula_Deck;};
if (i == "Ghost Deck") {return Item::Ghost_Deck;};
if (i == "Abandoned Deck") {return Item::Abandoned_Deck;};
if (i == "Checkered Deck") {return Item::Checkered_Deck;};
if (i == "Zodiac Deck") {return Item::Zodiac_Deck;};
if (i == "Painted Deck") {return Item::Painted_Deck;};
if (i == "Anaglyph Deck") {return Item::Anaglyph_Deck;};
if (i == "Plasma Deck") {return Item::Plasma_Deck;};
if (i == "Erratic Deck") {return Item::Erratic_Deck;};
if (i == "Challenge Deck") {return Item::Challenge_Deck;};
if (i == "D END") {return Item::D_END;};
if (i == "CHAL BEGIN") {return Item::CHAL_BEGIN;};
if (i == "The Omelette") {return Item::The_Omelette;};
if (i == "15 Minute City") {return Item::_15_Minute_City;};
if (i == "Rich get Richer") {return Item::Rich_get_Richer;};
if (i == "On a Knife's Edge") {return Item::On_a_Knifes_Edge;};
if (i == "X-ray Vision") {return Item::X_ray_Vision;};
if (i == "Mad World") {return Item::Mad_World;};
if (i == "Luxury Tax") {return Item::Luxury_Tax;};
if (i == "Non-Perishable") {return Item::Non_Perishable;};
if (i == "Medusa") {return Item::Medusa;};
if (i == "Double or Nothing") {return Item::Double_or_Nothing;};
if (i == "Typecast") {return Item::Typecast;};
if (i == "Inflation") {return Item::Inflation;};
if (i == "Bram Poker") {return Item::Bram_Poker;};
if (i == "Fragile") {return Item::Fragile;};
if (i == "Monolith") {return Item::Monolith;};
if (i == "Blast Off") {return Item::Blast_Off;};
if (i == "Five-Card Draw") {return Item::Five_Card_Draw;};
if (i == "Golden Needle") {return Item::Golden_Needle;};
if (i == "Cruelty") {return Item::Cruelty;};
if (i == "Jokerless") {return Item::Jokerless;};
if (i == "CHAL END") {return Item::CHAL_END;};
if (i == "STAKE BEGIN") {return Item::STAKE_BEGIN;};
if (i == "White Stake") {return Item::White_Stake;};
if (i == "Red Stake") {return Item::Red_Stake;};
if (i == "Green Stake") {return Item::Green_Stake;};
if (i == "Black Stake") {return Item::Black_Stake;};
if (i == "Blue Stake") {return Item::Blue_Stake;};
if (i == "Purple Stake") {return Item::Purple_Stake;};
if (i == "Orange Stake") {return Item::Orange_Stake;};
if (i == "Gold Stake") {return Item::Gold_Stake;};
if (i == "STAKE END") {return Item::STAKE_END;};
if (i == "RARITY BEGIN") {return Item::RARITY_BEGIN;};
if (i == "Common") {return Item::Common;};
if (i == "Uncommon") {return Item::Uncommon;};
if (i == "Rare") {return Item::Rare;};
if (i == "Legendary") {return Item::Legendary;};
if (i == "RARITY END") {return Item::RARITY_END;};
if (i == "TYPE BEGIN") {return Item::TYPE_BEGIN;};
if (i == "T Joker") {return Item::T_Joker;};
if (i == "T Tarot") {return Item::T_Tarot;};
if (i == "T Planet") {return Item::T_Planet;};
if (i == "T Spectral") {return Item::T_Spectral;};
if (i == "T Playing Card") {return Item::T_Playing_Card;};
if (i == "TYPE END") {return Item::TYPE_END;};
return Item::RETRY;
}

// Structs for storing information
struct ShopInstance {
    double jokerRate;
    double tarotRate;
    double planetRate;
    double playingCardRate;
    double spectralRate;
    ShopInstance() {
        jokerRate = 20;
        tarotRate = 4;
        planetRate = 4;
        playingCardRate = 0;
        spectralRate = 0;
    };
    ShopInstance(double j, double t, double p, double c, double s) {
        jokerRate = j;
        tarotRate = t;
        planetRate = p;
        playingCardRate = c;
        spectralRate = s;
    }
    double getTotalRate() {
        return jokerRate + tarotRate + planetRate + playingCardRate + spectralRate;
    }
};

struct JokerStickers {
    bool eternal;
    bool perishable;
    bool rental;
    JokerStickers() {
        eternal = false;
        perishable = false;
        rental = false;
    };
    JokerStickers(bool e, bool p, bool r) {
        eternal = e;
        perishable = p;
        rental = r;
    }
};

struct JokerData {
    Item joker;
    Item rarity;
    Item edition;
    JokerStickers stickers;
    JokerData() {
        joker = Item::Joker;
        rarity = Item::Common;
        edition = Item::No_Edition;
        stickers = JokerStickers();
    };
    JokerData(Item j, Item r, Item e, JokerStickers s) {
        joker = j;
        rarity = r;
        edition = e;
        stickers = s;
    };
};

struct ShopItem {
    Item type;
    Item item;
    JokerData jokerData;
    ShopItem() {
        type = Item::T_Tarot;
        item = Item::The_Fool;
    };
    ShopItem(Item t, Item i) {
        type = t;
        item = i;
    };
    ShopItem(Item t, Item i, JokerData j) {
        type = t;
        item = i;
        jokerData = j;
    };
};

struct WeightedItem {
    Item item;
    double weight;
    WeightedItem(Item i, double w) {
        item = i;
        weight = w;
    };
};

struct Pack {
    Item type;
    int size;
    int choices;
    Pack(Item t, int s, int c) {
        type = t;
        size = s;
        choices = c;
    }
};

struct Card {
    Item base;
    Item enhancement;
    Item edition;
    Item seal;
    Card(Item b, Item n, Item e, Item s) {
        base = b;
        enhancement = n;
        edition = e;
        seal = s;
    }
};

std::vector<Item> ENHANCEMENTS = {
    Item::Bonus_Card,
    Item::Mult_Card,
    Item::Wild_Card,
    Item::Glass_Card,
    Item::Steel_Card,
    Item::Stone_Card,
    Item::Gold_Card,
    Item::Lucky_Card
};

std::vector<Item> CARDS = { 
    Item::C_2,
    Item::C_3,
    Item::C_4,
    Item::C_5,
    Item::C_6,
    Item::C_7,
    Item::C_8,
    Item::C_9,
    Item::C_A,
    Item::C_J,
    Item::C_K,
    Item::C_Q,
    Item::C_T,
    Item::D_2,
    Item::D_3,
    Item::D_4,
    Item::D_5,
    Item::D_6,
    Item::D_7,
    Item::D_8,
    Item::D_9,
    Item::D_A,
    Item::D_J,
    Item::D_K,
    Item::D_Q,
    Item::D_T,
    Item::H_2,
    Item::H_3,
    Item::H_4,
    Item::H_5,
    Item::H_6,
    Item::H_7,
    Item::H_8,
    Item::H_9,
    Item::H_A,
    Item::H_J,
    Item::H_K,
    Item::H_Q,
    Item::H_T,
    Item::S_2,
    Item::S_3,
    Item::S_4,
    Item::S_5,
    Item::S_6,
    Item::S_7,
    Item::S_8,
    Item::S_9,
    Item::S_A,
    Item::S_J,
    Item::S_K,
    Item::S_Q,
    Item::S_T
};

std::vector<Item> SUITS = {
    Item::Spades,
    Item::Hearts,
    Item::Clubs,
    Item::Diamonds
};

std::vector<Item> RANKS = {
    Item::_2,
    Item::_3,
    Item::_4,
    Item::_5,
    Item::_6,
    Item::_7,
    Item::_8,
    Item::_9,
    Item::_10,
    Item::Jack,
    Item::Queen,
    Item::King,
    Item::Ace
};

std::vector<WeightedItem> PACKS = {
    WeightedItem(Item::RETRY, 22.42), //total
    WeightedItem(Item::Arcana_Pack, 4),
    WeightedItem(Item::Jumbo_Arcana_Pack, 2),
    WeightedItem(Item::Mega_Arcana_Pack, 0.5),
    WeightedItem(Item::Celestial_Pack, 4),
    WeightedItem(Item::Jumbo_Celestial_Pack, 2),
    WeightedItem(Item::Mega_Celestial_Pack, 0.5),
    WeightedItem(Item::Standard_Pack, 4),
    WeightedItem(Item::Jumbo_Standard_Pack, 2),
    WeightedItem(Item::Mega_Standard_Pack, 0.5),
    WeightedItem(Item::Buffoon_Pack, 1.2),
    WeightedItem(Item::Jumbo_Buffoon_Pack, 0.6),
    WeightedItem(Item::Mega_Buffoon_Pack, 0.15),
    WeightedItem(Item::Spectral_Pack, 0.6),
    WeightedItem(Item::Jumbo_Spectral_Pack, 0.3),
    WeightedItem(Item::Mega_Spectral_Pack, 0.07)
};

std::vector<Item> TAROTS = {
    Item::The_Fool,
    Item::The_Magician,
    Item::The_High_Priestess,
    Item::The_Empress,
    Item::The_Emperor,
    Item::The_Hierophant,
    Item::The_Lovers,
    Item::The_Chariot,
    Item::Justice,
    Item::The_Hermit,
    Item::The_Wheel_of_Fortune,
    Item::Strength,
    Item::The_Hanged_Man,
    Item::Death,
    Item::Temperance,
    Item::The_Devil,
    Item::The_Tower,
    Item::The_Star,
    Item::The_Moon,
    Item::The_Sun,
    Item::Judgement,
    Item::The_World
};

std::vector<Item> PLANETS = {
    Item::Mercury,
    Item::Venus,
    Item::Earth,
    Item::Mars,
    Item::Jupiter,
    Item::Saturn,
    Item::Uranus,
    Item::Neptune,
    Item::Pluto,
    Item::Planet_X,
    Item::Ceres,
    Item::Eris
};

std::vector<Item> COMMON_JOKERS_100 = {
    Item::Joker,
    Item::Greedy_Joker,
    Item::Lusty_Joker,
    Item::Wrathful_Joker,
    Item::Gluttonous_Joker,
    Item::Jolly_Joker,
    Item::Zany_Joker,
    Item::Mad_Joker,
    Item::Crazy_Joker,
    Item::Droll_Joker,
    Item::Sly_Joker,
    Item::Wily_Joker,
    Item::Clever_Joker,
    Item::Devious_Joker,
    Item::Crafty_Joker,
    Item::Half_Joker,
    Item::Credit_Card,
    Item::Banner,
    Item::Mystic_Summit,
    Item::_8_Ball,
    Item::Misprint,
    Item::Raised_Fist,
    Item::Chaos_the_Clown,
    Item::Scary_Face,
    Item::Abstract_Joker,
    Item::Delayed_Gratification,
    Item::Gros_Michel,
    Item::Even_Steven,
    Item::Odd_Todd,
    Item::Scholar,
    Item::Business_Card,
    Item::Supernova,
    Item::Ride_the_Bus,
    Item::Egg,
    Item::Runner,
    Item::Ice_Cream,
    Item::Splash,
    Item::Blue_Joker,
    Item::Faceless_Joker,
    Item::Green_Joker,
    Item::Superposition,
    Item::To_Do_List,
    Item::Cavendish,
    Item::Red_Card,
    Item::Square_Joker,
    Item::Riff_raff,
    Item::Photograph,
    Item::Mail_In_Rebate,
    Item::Hallucination,
    Item::Fortune_Teller,
    Item::Juggler,
    Item::Drunkard,
    Item::Golden_Joker,
    Item::Popcorn,
    Item::Walkie_Talkie,
    Item::Smiley_Face,
    Item::Golden_Ticket,
    Item::Swashbuckler,
    Item::Hanging_Chad,
    Item::Shoot_the_Moon
};

std::vector<Item> COMMON_JOKERS = {
    Item::Joker,
    Item::Greedy_Joker,
    Item::Lusty_Joker,
    Item::Wrathful_Joker,
    Item::Gluttonous_Joker,
    Item::Jolly_Joker,
    Item::Zany_Joker,
    Item::Mad_Joker,
    Item::Crazy_Joker,
    Item::Droll_Joker,
    Item::Sly_Joker,
    Item::Wily_Joker,
    Item::Clever_Joker,
    Item::Devious_Joker,
    Item::Crafty_Joker,
    Item::Half_Joker,
    Item::Credit_Card,
    Item::Banner,
    Item::Mystic_Summit,
    Item::_8_Ball,
    Item::Misprint,
    Item::Raised_Fist,
    Item::Chaos_the_Clown,
    Item::Scary_Face,
    Item::Abstract_Joker,
    Item::Delayed_Gratification,
    Item::Gros_Michel,
    Item::Even_Steven,
    Item::Odd_Todd,
    Item::Scholar,
    Item::Business_Card,
    Item::Supernova,
    Item::Ride_the_Bus,
    Item::Egg,
    Item::Runner,
    Item::Ice_Cream,
    Item::Splash,
    Item::Blue_Joker,
    Item::Faceless_Joker,
    Item::Green_Joker,
    Item::Superposition,
    Item::To_Do_List,
    Item::Cavendish,
    Item::Red_Card,
    Item::Square_Joker,
    Item::Riff_raff,
    Item::Photograph,
    Item::Reserved_Parking,
    Item::Mail_In_Rebate,
    Item::Hallucination,
    Item::Fortune_Teller,
    Item::Juggler,
    Item::Drunkard,
    Item::Golden_Joker,
    Item::Popcorn,
    Item::Walkie_Talkie,
    Item::Smiley_Face,
    Item::Golden_Ticket,
    Item::Swashbuckler,
    Item::Hanging_Chad,
    Item::Shoot_the_Moon,
};

std::vector<Item> UNCOMMON_JOKERS_100 = {
    Item::Joker_Stencil,
    Item::Four_Fingers,
    Item::Mime,
    Item::Ceremonial_Dagger,
    Item::Marble_Joker,
    Item::Loyalty_Card,
    Item::Dusk,
    Item::Fibonacci,
    Item::Steel_Joker,
    Item::Hack,
    Item::Pareidolia,
    Item::Space_Joker,
    Item::Burglar,
    Item::Blackboard,
    Item::Constellation,
    Item::Hiker,
    Item::Card_Sharp,
    Item::Madness,
    Item::Vampire,
    Item::Shortcut,
    Item::Hologram,
    Item::Vagabond,
    Item::Cloud_9,
    Item::Rocket,
    Item::Midas_Mask,
    Item::Luchador,
    Item::Gift_Card,
    Item::Turtle_Bean,
    Item::Erosion,
    Item::Reserved_Parking,
    Item::To_the_Moon,
    Item::Stone_Joker,
    Item::Lucky_Cat,
    Item::Bull,
    Item::Diet_Cola,
    Item::Trading_Card,
    Item::Flash_Card,
    Item::Spare_Trousers,
    Item::Ramen,
    Item::Seltzer,
    Item::Castle,
    Item::Mr_Bones,
    Item::Acrobat,
    Item::Sock_and_Buskin,
    Item::Troubadour,
    Item::Certificate,
    Item::Smeared_Joker,
    Item::Throwback,
    Item::Rough_Gem,
    Item::Bloodstone,
    Item::Arrowhead,
    Item::Onyx_Agate,
    Item::Glass_Joker,
    Item::Showman,
    Item::Flower_Pot,
    Item::Merry_Andy,
    Item::Oops_All_6s,
    Item::The_Idol,
    Item::Seeing_Double,
    Item::Matador,
    Item::Stuntman,
    Item::Satellite,
    Item::Cartomancer,
    Item::Astronomer,
    Item::Burnt_Joker,
    Item::Bootstraps
};

std::vector<Item> UNCOMMON_JOKERS = {
    Item::Joker_Stencil,
    Item::Four_Fingers,
    Item::Mime,
    Item::Ceremonial_Dagger,
    Item::Marble_Joker,
    Item::Loyalty_Card,
    Item::Dusk,
    Item::Fibonacci,
    Item::Steel_Joker,
    Item::Hack,
    Item::Pareidolia,
    Item::Space_Joker,
    Item::Burglar,
    Item::Blackboard,
    Item::Sixth_Sense,
    Item::Constellation,
    Item::Hiker,
    Item::Card_Sharp,
    Item::Madness,
    Item::Seance,
    Item::Vampire,
    Item::Shortcut,
    Item::Hologram,
    Item::Cloud_9,
    Item::Rocket,
    Item::Midas_Mask,
    Item::Luchador,
    Item::Gift_Card,
    Item::Turtle_Bean,
    Item::Erosion,
    Item::To_the_Moon,
    Item::Stone_Joker,
    Item::Lucky_Cat,
    Item::Bull,
    Item::Diet_Cola,
    Item::Trading_Card,
    Item::Flash_Card,
    Item::Spare_Trousers,
    Item::Ramen,
    Item::Seltzer,
    Item::Castle,
    Item::Mr_Bones,
    Item::Acrobat,
    Item::Sock_and_Buskin,
    Item::Troubadour,
    Item::Certificate,
    Item::Smeared_Joker,
    Item::Throwback,
    Item::Rough_Gem,
    Item::Bloodstone,
    Item::Arrowhead,
    Item::Onyx_Agate,
    Item::Glass_Joker,
    Item::Showman,
    Item::Flower_Pot,
    Item::Merry_Andy,
    Item::Oops_All_6s,
    Item::The_Idol,
    Item::Seeing_Double,
    Item::Matador,
    Item::Satellite,
    Item::Cartomancer,
    Item::Astronomer,
    Item::Bootstraps,
};

std::vector<Item> RARE_JOKERS_100 = {
    Item::DNA,
    Item::Sixth_Sense,
    Item::Seance,
    Item::Baron,
    Item::Obelisk,
    Item::Baseball_Card,
    Item::Ancient_Joker,
    Item::Campfire,
    Item::Blueprint,
    Item::Wee_Joker,
    Item::Hit_the_Road,
    Item::The_Duo,
    Item::The_Trio,
    Item::The_Family,
    Item::The_Order,
    Item::The_Tribe,
    Item::Invisible_Joker,
    Item::Brainstorm,
    Item::Drivers_License
};


std::vector<Item> RARE_JOKERS = {
    Item::DNA,
    Item::Vagabond,
    Item::Baron,
    Item::Obelisk,
    Item::Baseball_Card,
    Item::Ancient_Joker,
    Item::Campfire,
    Item::Blueprint,
    Item::Wee_Joker,
    Item::Hit_the_Road,
    Item::The_Duo,
    Item::The_Trio,
    Item::The_Family,
    Item::The_Order,
    Item::The_Tribe,
    Item::Stuntman,
    Item::Invisible_Joker,
    Item::Brainstorm,
    Item::Drivers_License,
    Item::Burnt_Joker,
};

std::vector<Item> LEGENDARY_JOKERS = {
    Item::Canio,
    Item::Triboulet,
    Item::Yorick,
    Item::Chicot,
    Item::Perkeo
};

std::vector<Item> VOUCHERS = {
    Item::Overstock,
    Item::Overstock_Plus,
    Item::Clearance_Sale,
    Item::Liquidation,
    Item::Hone,
    Item::Glow_Up,
    Item::Reroll_Surplus,
    Item::Reroll_Glut,
    Item::Crystal_Ball,
    Item::Omen_Globe,
    Item::Telescope,
    Item::Observatory,
    Item::Grabber,
    Item::Nacho_Tong,
    Item::Wasteful,
    Item::Recyclomancy,
    Item::Tarot_Merchant,
    Item::Tarot_Tycoon,
    Item::Planet_Merchant,
    Item::Planet_Tycoon,
    Item::Seed_Money,
    Item::Money_Tree,
    Item::Blank,
    Item::Antimatter,
    Item::Magic_Trick,
    Item::Illusion,
    Item::Hieroglyph,
    Item::Petroglyph,
    Item::Directors_Cut,
    Item::Retcon,
    Item::Paint_Brush,
    Item::Palette
};

std::vector<Item> SPECTRALS = {
    Item::Familiar,
    Item::Grim,
    Item::Incantation,
    Item::Talisman,
    Item::Aura,
    Item::Wraith,
    Item::Sigil,
    Item::Ouija,
    Item::Ectoplasm,
    Item::Immolate,
    Item::Ankh,
    Item::Deja_Vu,
    Item::Hex,
    Item::Trance,
    Item::Medium,
    Item::Cryptid,
    Item::RETRY, //Soul
    Item::RETRY //Black_Hole
};

std::vector<Item> TAGS = {
    Item::Uncommon_Tag,
    Item::Rare_Tag,
    Item::Negative_Tag,
    Item::Foil_Tag,
    Item::Holographic_Tag,
    Item::Polychrome_Tag,
    Item::Investment_Tag,
    Item::Voucher_Tag,
    Item::Boss_Tag,
    Item::Standard_Tag,
    Item::Charm_Tag,
    Item::Meteor_Tag,
    Item::Buffoon_Tag,
    Item::Handy_Tag,
    Item::Garbage_Tag,
    Item::Ethereal_Tag,
    Item::Coupon_Tag,
    Item::Double_Tag,
    Item::Juggle_Tag,
    Item::D6_Tag,
    Item::Top_up_Tag,
    Item::Speed_Tag,
    Item::Orbital_Tag,
    Item::Economy_Tag
};

std::vector<Item> BOSSES = {
    Item::The_Arm,
    Item::The_Club,
    Item::The_Eye,
    Item::Amber_Acorn,
    Item::Cerulean_Bell,
    Item::Crimson_Heart,
    Item::Verdant_Leaf,
    Item::Violet_Vessel,
    Item::The_Fish,
    Item::The_Flint,
    Item::The_Goad,
    Item::The_Head,
    Item::The_Hook,
    Item::The_House,
    Item::The_Manacle,
    Item::The_Mark,
    Item::The_Mouth,
    Item::The_Needle,
    Item::The_Ox,
    Item::The_Pillar,
    Item::The_Plant,
    Item::The_Psychic,
    Item::The_Serpent,
    Item::The_Tooth,
    Item::The_Wall,
    Item::The_Water,
    Item::The_Wheel,
    Item::The_Window
};
