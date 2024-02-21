
// Instance
typedef struct GameInstance {
    seed seed;
    cache rngCache;
    double hashedSeed;
    lrandom rng;
    bool locked[ITEMS_END];
} instance;
instance i_new(seed s) {
    instance inst = {.locked = {true}};
    inst.seed = s;
    inst.hashedSeed = pseudohash(s_to_string(&s));
    inst.rngCache.nextFreeNode = 0;
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
    if (inst->locked[i]) {
        int resampleNum = 1;
        while (inst->locked[i]) {
            i = randchoice(inst, (__private ntype[]){N_Type, N_Source, N_Ante, N_Resample}, (__private int[]){rngType, src, ante, resampleNum}, 4, items);
            resampleNum++;
        }
    }
    return i;
}

item randchoice_simple(instance* inst, rtype rngType, __constant item items[]) {
    return randchoice(inst, (__private ntype[]){N_Type}, (__private int[]){rngType}, 1, items);
}

void randlist(item out[], int size, instance* inst, rtype rngType, rsrc src, int ante, __constant item items[]) {
    for (int i = 0; i < size; i++) {
        out[i] = randchoice_common(inst, rngType, src, ante, items);
        inst->locked[out[i]] = true; // temporary reroll for locked items
    }
    for (int i = 0; i < size; i++) {
        inst->locked[out[i]] = false;
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
    // Impossible to obtain in 0.9.3
    inst->locked[Rare_Tag] = true;
    inst->locked[The_Ox] = true;
    
    // Locked behind antes
    if (ante < 2) {
        inst->locked[The_Mouth] = true;
        inst->locked[The_Fish] = true;
        inst->locked[The_Wall] = true;
        inst->locked[The_House] = true;
        inst->locked[The_Mark] = true;
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
    }

    // Locked in a fresh profile
    if (fresh_profile) {
        inst->locked[Negative_Tag] = true;
        inst->locked[Foil_Tag] = true;
        inst->locked[Holographic_Tag] = true;
        inst->locked[Polychrome_Tag] = true;
    }

    // Locked in start of run
    if (fresh_run) {
        inst->locked[Planet_X] = true;
        inst->locked[Ceres] = true;
        inst->locked[Eris] = true;
        inst->locked[Five_of_a_Kind] = true;
        inst->locked[Flush_House] = true;
        inst->locked[Flush_Five] = true;
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
    }
}