
// Instance
typedef struct GameInstance {
    seed seed;
    cache rngCache;
    double hashedSeed;
    lrandom rng;
} instance;
instance i_new(seed s) {
    instance inst;
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
    return random(inst, (ntype[]){N_Type}, (int[]){rt}, 1);
}
ulong randint(instance* inst, ntype nts[], int ids[], int num, ulong min, ulong max) {
    if (num > 0) {
        inst->rng = randomseed(get_node_child(inst, nts, ids, num));
    }
    return l_randint(&(inst->rng), min, max);
}

item randchoice(instance* inst, ntype nts[], int ids[], int num, __global item items[]) {//, size_t item_size) { not needed, we'll have element 1 give us the size
    if (num > 0) {
        inst->rng = randomseed(get_node_child(inst, nts, ids, num));
    }
    return items[l_randint(&(inst->rng), 1, items[0])];
}

// The most common form of randchoice
item randchoice_common(instance* inst, rtype rngType, rsrc src, int ante, __global item items[]) {
    return randchoice(inst, (ntype[]){N_Type, N_Source, N_Ante}, (int[]){rngType, src, ante}, 3, items);
}

item randweightedchoice(instance* inst, ntype nts[], int ids[], int num, __global weighteditem items[]) {
    double poll = random(inst, nts, ids, num)*items[0].weight;
    int idx = 1;
    double weight = 0;
    while (weight < poll) {
        weight += items[idx].weight;
        idx++;
    }
    return items[idx-1]._item;
}