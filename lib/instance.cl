// Contains settings used for different packs
// Level means level of the voucher, level 0 -> no voucher, level 1 -> base voucher, level 2 -> upgraded voucher
typedef struct InstanceParameters {
    item deck;
    item stake;
    bool vouchers[32];
    bool showman;
} instance_params;

// Instance
typedef struct GameInstance {
    seed seed;
    cache rngCache;
    double hashedSeed;
    lrandom rng;
    bool locked[ITEMS_END];
    instance_params params;
} instance;
instance i_new(seed s) {
    instance inst = {.locked = {true}};
    inst.seed = s;
    inst.hashedSeed = pseudohash(s_to_string(&s));
    inst.rngCache.nextFreeNode = 0;
    instance_params params = {
        .deck = Red_Deck, 
        .stake = White_Stake,
        .showman = false,
        .vouchers = {false}
    };
    inst.params = params;
    return inst;
}
double get_node_child(instance* inst, ntype nts[], int ids[], int num) {
    double temp = 0; // will store value set to node, which has some post-processing at the end
    int node_id = -1;
    // Check if node exists
    for (int i = 0; i < inst->rngCache.nextFreeNode; i++) {
        if (num != inst->rngCache.nodes[i].depth) continue;
        bool good = true;
        for (int n = 0; n < num; n++) {
            if (nts[n] != inst->rngCache.nodes[i].nodeTypes[n]) {
                good = false;
                break;
            }
            if (ids[n] != inst->rngCache.nodes[i].nodeValues[n]) {
                good = false;
                break;
            }
        }
        if (good) {
            node_id = i;
            break;
        }
    }
    if (node_id == -1) {
        node_id = init_node(&(inst->rngCache),nts,ids,num);
        text phvalue = node_str(nts[0],ids[0]);
        for (int i = 1; i < num; i++) {
            phvalue = text_concat(phvalue, node_str(nts[i],ids[i]));
        }
        phvalue = text_concat(phvalue,s_to_string(&inst->seed));
        inst->rngCache.nodes[node_id].rngState = pseudohash(phvalue);
    }
    inst->rngCache.nodes[node_id].rngState = roundDigits(fract(inst->rngCache.nodes[node_id].rngState*1.72431234+2.134453429141),13);
    return (inst->rngCache.nodes[node_id].rngState + inst->hashedSeed)/2;
}
double random(instance* inst, ntype nts[], int ids[], int num) {
    if (num > 0) {
        inst->rng = randomseed(get_node_child(inst, nts, ids, num));
    }
    return l_random(&(inst->rng));
}
double random_simple(instance* inst, rtype rt) {
    return random(inst, (__private ntype[]){N_Type}, (__private int[]){rt}, 1);
}
ulong randint(instance* inst, ntype nts[], int ids[], int num, ulong min, ulong max) {
    if (num > 0) {
        inst->rng = randomseed(get_node_child(inst, nts, ids, num));
    }
    return l_randint(&(inst->rng), min, max);
}

item randchoice(instance* inst, ntype nts[], int ids[], int num, __constant item items[]) {//, size_t item_size) { not needed, we'll have element 1 give us the size
    if (num > 0) {
        inst->rng = randomseed(get_node_child(inst, nts, ids, num));
    }
    return items[l_randint(&(inst->rng), 1, items[0])];
}

// The most common form of randchoice
// Now with rerolls!
item randchoice_common(instance* inst, rtype rngType, rsrc src, int ante, __constant item items[]) {
    item i = randchoice(inst, (__private ntype[]){N_Type, N_Source, N_Ante}, (__private int[]){rngType, src, ante}, 3, items);
    if (!inst->params.showman && inst->locked[i]) {
        int resampleNum = 1;
        while (inst->locked[i]) {
            i = randchoice(inst, (__private ntype[]){N_Type, N_Source, N_Ante, N_Resample}, (__private int[]){rngType, src, ante, resampleNum}, 4, items);
            resampleNum++;
        }
    }
    return i;
}
item randchoice_resample(instance* inst, rtype rngType, rsrc src, int ante, __constant item items[], int resampleNum) {
    return randchoice(inst, (__private ntype[]){N_Type, N_Source, N_Ante, N_Resample}, (__private int[]){rngType, src, ante, resampleNum}, 4, items);
}

item randchoice_simple(instance* inst, rtype rngType, __constant item items[]) {
    return randchoice(inst, (__private ntype[]){N_Type}, (__private int[]){rngType}, 1, items);
}

void randlist(item out[], int size, instance* inst, rtype rngType, rsrc src, int ante, __constant item items[]) {
    for (int i = 0; i < size; i++) {
        out[i] = randchoice_common(inst, rngType, src, ante, items);
        if (!inst->params.showman) inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        if (!inst->params.showman) inst->locked[out[i]] = false;
    }
}

item randweightedchoice(instance* inst, ntype nts[], int ids[], int num, __constant weighteditem items[]) {
    double poll = random(inst, nts, ids, num)*items[0].weight;
    int idx = 1;
    double weight = 0;
    while (weight < poll) {
        weight += items[idx].weight;
        idx++;
    }
    return items[idx-1]._item;
}

// Locks - NOT UPDATED FOR 1.0
void init_locks(instance* inst, int ante, bool fresh_profile, bool fresh_run) {
    // Locked behind antes
    if (ante < 2) {
        inst->locked[The_Mouth] = true;
        inst->locked[The_Fish] = true;
        inst->locked[The_Wall] = true;
        inst->locked[The_House] = true;
        inst->locked[The_Mark] = true;
        inst->locked[The_Wheel] = true;
        inst->locked[The_Arm] = true;
        inst->locked[The_Water] = true;
        inst->locked[The_Needle] = true;
        inst->locked[The_Flint] = true;
        inst->locked[Negative_Tag] = true;
        inst->locked[Standard_Tag] = true;
        inst->locked[Meteor_Tag] = true;
        inst->locked[Buffoon_Tag] = true;
        inst->locked[Handy_Tag] = true;
        inst->locked[Garbage_Tag] = true;
        inst->locked[Ethereal_Tag] = true;
        inst->locked[Top_up_Tag] = true;
        inst->locked[Orbital_Tag] = true;
    }
    if (ante < 3) {
        inst->locked[The_Tooth] = true;
        inst->locked[The_Eye] = true;
    }
    if (ante < 4) {
        inst->locked[The_Plant] = true;
    }
    if (ante < 5) {
        inst->locked[The_Serpent] = true;
    }
    if (ante < 6) {
        inst->locked[The_Ox] = true;
    }

    // Locked in a fresh profile
    if (fresh_profile) {
        // Tags
        inst->locked[Negative_Tag] = true;
        inst->locked[Foil_Tag] = true;
        inst->locked[Holographic_Tag] = true;
        inst->locked[Polychrome_Tag] = true;

        // Jokers
        inst->locked[Golden_Ticket] = true;
        inst->locked[Mr_Bones] = true;
        inst->locked[Acrobat] = true;
        inst->locked[Sock_and_Buskin] = true;
        inst->locked[Swashbuckler] = true;
        inst->locked[Troubadour] = true;
        inst->locked[Certificate] = true;
        inst->locked[Smeared_Joker] = true;
        inst->locked[Throwback] = true;
        inst->locked[Hanging_Chad] = true;
        inst->locked[Rough_Gem] = true;
        inst->locked[Bloodstone] = true;
        inst->locked[Arrowhead] = true;
        inst->locked[Onyx_Agate] = true;
        inst->locked[Glass_Joker] = true;
        inst->locked[Showman] = true;
        inst->locked[Flower_Pot] = true;
        inst->locked[Blueprint] = true;
        inst->locked[Wee_Joker] = true;
        inst->locked[Merry_Andy] = true;
        inst->locked[Oops_All_6s] = true;
        inst->locked[The_Idol] = true;
        inst->locked[Seeing_Double] = true;
        inst->locked[Matador] = true;
        inst->locked[Hit_the_Road] = true;
        inst->locked[The_Duo] = true;
        inst->locked[The_Trio] = true;
        inst->locked[The_Family] = true;
        inst->locked[The_Order] = true;
        inst->locked[The_Tribe] = true;
        inst->locked[Stuntman] = true;
        inst->locked[Invisible_Joker] = true;
        inst->locked[Brainstorm] = true;
        inst->locked[Satellite] = true;
        inst->locked[Shoot_the_Moon] = true;
        inst->locked[Drivers_License] = true;
        inst->locked[Cartomancer] = true;
        inst->locked[Astronomer] = true;
        inst->locked[Burnt_Joker] = true;
        inst->locked[Bootstraps] = true;

        // Vouchers
        inst->locked[Overstock_Plus] = true;
        inst->locked[Liquidation] = true;
        inst->locked[Glow_Up] = true;
        inst->locked[Reroll_Glut] = true;
        inst->locked[Omen_Globe] = true;
        inst->locked[Observatory] = true;
        inst->locked[Nacho_Tong] = true;
        inst->locked[Recyclomancy] = true;
        inst->locked[Tarot_Tycoon] = true;
        inst->locked[Planet_Tycoon] = true;
        inst->locked[Money_Tree] = true;
        inst->locked[Antimatter] = true;
        inst->locked[Illusion] = true;
        inst->locked[Petroglyph] = true;
        inst->locked[Retcon] = true;
        inst->locked[Palette] = true;
    }

    // Locked in start of run
    if (fresh_run) {
        //Require hand discoveries
        inst->locked[Planet_X] = true;
        inst->locked[Ceres] = true;
        inst->locked[Eris] = true;
        inst->locked[Five_of_a_Kind] = true;
        inst->locked[Flush_House] = true;
        inst->locked[Flush_Five] = true;

        //Requires specific card enhancement
        inst->locked[Stone_Joker] = true; //Stone
        inst->locked[Steel_Joker] = true; //Steel
        inst->locked[Glass_Joker] = true; //Glass
        inst->locked[Golden_Ticket] = true; //Gold
        inst->locked[Lucky_Cat] = true; //Lucky

        // Requires Gros Michel death
        inst->locked[Cavendish] = true;

        // Vouchers
        inst->locked[Overstock_Plus] = true;
        inst->locked[Liquidation] = true;
        inst->locked[Glow_Up] = true;
        inst->locked[Reroll_Glut] = true;
        inst->locked[Omen_Globe] = true;
        inst->locked[Observatory] = true;
        inst->locked[Nacho_Tong] = true;
        inst->locked[Recyclomancy] = true;
        inst->locked[Tarot_Tycoon] = true;
        inst->locked[Planet_Tycoon] = true;
        inst->locked[Money_Tree] = true;
        inst->locked[Antimatter] = true;
        inst->locked[Illusion] = true;
        inst->locked[Petroglyph] = true;
        inst->locked[Retcon] = true;
        inst->locked[Palette] = true;
    }
}

// Things that are unlocked when switching antes
void init_unlocks(instance* inst, int ante, bool fresh_profile) {
    if (ante == 2) {
        inst->locked[The_Mouth] = false;
        inst->locked[The_Fish] = false;
        inst->locked[The_Wall] = false;
        inst->locked[The_House] = false;
        inst->locked[The_Mark] = false;
        inst->locked[The_Wheel] = false;
        inst->locked[The_Arm] = false;
        inst->locked[The_Water] = false;
        inst->locked[The_Needle] = false;
        inst->locked[The_Flint] = false;
        if (!fresh_profile) inst->locked[Negative_Tag] = false;
        inst->locked[Standard_Tag] = false;
        inst->locked[Meteor_Tag] = false;
        inst->locked[Buffoon_Tag] = false;
        inst->locked[Handy_Tag] = false;
        inst->locked[Garbage_Tag] = false;
        inst->locked[Ethereal_Tag] = false;
        inst->locked[Top_up_Tag] = false;
        inst->locked[Orbital_Tag] = false;
    }
    if (ante == 3) {
        inst->locked[The_Tooth] = false;
        inst->locked[The_Eye] = false;
    }
    if (ante == 4) {
        inst->locked[The_Plant] = false;
    }
    if (ante == 5) {
        inst->locked[The_Serpent] = false;
    }
    if (ante == 6) {
        inst->locked[The_Ox] = false;
    }
}