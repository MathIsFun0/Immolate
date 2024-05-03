#define CACHE_SIZE 1000
#include "lib/immolate.cl"
// !! The name has nothing to do with searching Perkeo !!

// Print all consumable generators queues of a seed (Seals, Judgement, Wraith, etc.)
// It's highly recommended to run this with -n 1 to only look at a single seed:
// immolate -f perkeo_analyzer -s THESEED -n 1 -g 1

//==================
// Search parameters
//==================

// When changing maxAnte, make sure size of arrays below matches it.
__constant int maxAnte = 8;

// How many consumables to check per ante.
// add 100 (e.g. 103) to the number if you want to see 1 redraw queue
// add 200 (e.g. 204) to the number if you want to see 2 redraw queues
__constant int wraithPerAnte[] = {1, 1, 1, 1, 1, 1, 1, 1};
__constant int judgementPerAnte[] = {1, 2, 2, 2, 2, 2, 2, 2};

__constant int sixthSensePerAnte[] = {2, 3, 3, 3, 3, 3, 3, 3};
__constant int seancePerAnte[] = {2, 3, 3, 3, 3, 3, 3, 3};

// __constant int eightBallPerAnte[] = {0, 1, 2, 3, 4, 5, 5, 5};
__constant int vagabondPerAnte[] = {104, 6, 6, 4, 2, 1, 0, 0};
__constant int superpositionPerAnte[] = {0, 3, 2, 1, 0, 0, 0, 0};

__constant int purpleSealPerAnte[] = {0, 2, 3, 4, 5, 5, 5, 5};
__constant int _8BallPerAnte[] = {2, 2, 2, 2, 2, 2, 2, 2};

__constant int emperorPerAnte[] = {2, 2, 2, 2, 2, 2, 2, 2};
__constant int priestessPerAnte[] = {2, 2, 2, 2, 2, 2, 2, 2};

void print_jokers(instance* inst, rsrc source, int ante, int itemsToShow);

void print_tarots(instance* inst, rsrc source, int ante, int itemsToShow);

void print_planets(instance* inst, rsrc source, int ante, int itemsToShow);

void print_spectrals(instance* inst, rsrc source, int ante, int itemsToShow);

long filter(instance* inst) {
    
    bool ghostDeck = inst->params.deck == Ghost_Deck;
    for (int ante = 1; ante <= maxAnte; ante++) {
        init_unlocks(inst, ante, false);
        printf("\n==ANTE %i==\n", ante);

        print_jokers(inst, S_Wraith, ante, wraithPerAnte[ante-1]);
        print_jokers(inst, S_Judgement, ante, judgementPerAnte[ante-1]);

        print_spectrals(inst, S_Seance, ante, seancePerAnte[ante-1]);
        print_spectrals(inst, S_Sixth_Sense, ante, sixthSensePerAnte[ante-1]);

        // print_tarots(inst, S_8_Ball, ante, eightBallPerAnte[ante-1]);
        print_tarots(inst, S_Vagabond, ante, vagabondPerAnte[ante-1]);
        print_tarots(inst, S_Superposition, ante, superpositionPerAnte[ante-1]);

        print_tarots(inst, S_Purple_Seal, ante, purpleSealPerAnte[ante-1]);
        print_tarots(inst, S_8_Ball, ante, _8BallPerAnte[ante-1]);

        print_tarots(inst, S_Emperor, ante, emperorPerAnte[ante-1]);
        print_planets(inst, S_High_Priestess, ante, priestessPerAnte[ante-1]);        
    }

    return 0;
}

void print_source(rsrc source) {
    switch (source) {
        case S_Wraith:            printf("Wraith"); break;
        case S_Judgement:         printf("Judgement"); break;
        case S_Sixth_Sense:       printf("Sixth Sense"); break;
        case S_Seance:            printf("Seance"); break;
        case S_Emperor:           printf("Emperor"); break;
        case S_High_Priestess:    printf("High Priestess"); break;
        case S_Vagabond:          printf("Vagabond"); break;
        case S_Superposition:     printf("Superposition"); break;
        case S_Blue_Seal:         printf("Blue Seal"); break;
        case S_Purple_Seal:       printf("Purple Seal"); break;
        case S_8_Ball:            printf("8 Ball"); break;

        default: printf("null"); break;
    }
}

void print_jokers(instance* inst, rsrc source, int ante, int itemsToShow) {
    if (itemsToShow <= 0) {
        return;
    }

    print_source(source);
    printf(": \n");

    int rerollQueues = 0;
    if (itemsToShow > 100) {
        rerollQueues = itemsToShow / 100;
        itemsToShow -= rerollQueues * 100;
    }

    for (int i = 1; i <= itemsToShow; i++) {
        item nextJoker = next_joker(inst, source, ante);

        item edition = next_joker_edition(inst, source, ante);
        if (edition != No_Edition) {
            print_item(edition);
            printf(" ");
        }
        print_item(nextJoker);

        if (i != itemsToShow) printf(", ");
    }

    if (source == S_Wraith) {
        // Rerolls only supported for wraith, since we don't know rarity of joker/s from judgement

        for (int queueIndex = 1; queueIndex <= rerollQueues; queueIndex++) {
            printf("\nRerolls [%d]: ", queueIndex);

            int rerolls = itemsToShow > 2? itemsToShow / 2 : 1;
            for (int q = 1; q <= rerolls; q++) {
                print_item(randchoice_resample(inst, R_Joker_Rare, source, ante, RARE_JOKERS, queueIndex));
                if (q != itemsToShow) printf(", ");
            }
        }
    }
    printf("\n");
}

void print_tarots(instance* inst, rsrc source, int ante, int itemsToShow) {
    if (itemsToShow <= 0) {
        return;
    }

    print_source(source);
    printf(": \n");

    int rerollQueues = 0;
    if (itemsToShow > 100) {
        rerollQueues = itemsToShow / 100;
        itemsToShow -= rerollQueues * 100;
    }

    for (int i = 1; i <= itemsToShow; i++) {
        item nextCard = next_tarot(inst, source, ante, false);

        print_item(nextCard);

        if (i != itemsToShow) printf(", ");
    }
    
    for (int queueIndex = 1; queueIndex <= rerollQueues; queueIndex++) {
        printf("\nRerolls [%d]: ", queueIndex);

        int rerolls = itemsToShow > 2? itemsToShow / 2 : 1;
        for (int q = 1; q <= rerolls; q++) {
            print_item(randchoice_resample(inst, R_Tarot, source, ante, TAROTS, queueIndex));
            if (q != itemsToShow) printf(", ");
        }
    }
    printf("\n");
}

void print_planets(instance* inst, rsrc source, int ante, int itemsToShow) {
    if (itemsToShow <= 0) {
        return;
    }

    print_source(source);
    printf(": \n");

    int rerollQueues = 0;
    if (itemsToShow > 100) {
        rerollQueues = itemsToShow / 100;
        itemsToShow -= rerollQueues * 100;
    }

    for (int i = 1; i <= itemsToShow; i++) {
        item nextCard = next_planet(inst, source, ante, false);

        print_item(nextCard);

        if (i != itemsToShow) printf(", ");
    }

    for (int queueIndex = 1; queueIndex <= rerollQueues; queueIndex++) {
        printf("\nRerolls [%d]: ", queueIndex);

        int rerolls = itemsToShow > 2? itemsToShow / 2 : 1;
        for (int q = 1; q <= rerolls; q++) {
            print_item(randchoice_resample(inst, R_Planet, source, ante, PLANETS, queueIndex));
            if (q != itemsToShow) printf(", ");
        }
    }
    printf("\n");
}

void print_spectrals(instance* inst, rsrc source, int ante, int itemsToShow) {
    if (itemsToShow <= 0) {
        return;
    }
    
    print_source(source);
    printf(": \n");

    int rerollQueues = 0;
    if (itemsToShow > 100) {
        rerollQueues = itemsToShow / 100;
        itemsToShow -= rerollQueues * 100;
    }

    for (int i = 1; i <= itemsToShow; i++) {
        item nextCard = next_spectral(inst, source, ante, false);

        print_item(nextCard);

        if (i != itemsToShow) printf(", ");
    }
    
    for (int queueIndex = 1; queueIndex <= rerollQueues; queueIndex++) {
        printf("\nRerolls [%d]: ", queueIndex);

        int rerolls = itemsToShow > 2? itemsToShow / 2 : 1;
        for (int q = 1; q <= rerolls; q++) {
            print_item(randchoice_resample(inst, R_Spectral, source, ante, SPECTRALS, queueIndex));
            if (q != itemsToShow) printf(", ");
        }
    }
    printf("\n");
}

