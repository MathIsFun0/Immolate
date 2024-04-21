// Speedrunning seeds for Set Seed Skips
#include "lib/immolate.cl"

long filter(instance* inst) {
    // The primary strategy utilized is going to be a single Bull carrying the run.
    init_locks(inst, 1, false, true);

    // Check for Bull
    bool foundBull = false;
    for (int i = 0; i < 2; i++) {
        if (next_shop_item(inst, 2).value == Bull) foundBull = true;
    }
    if (!foundBull) return 0;

    long cash = 4;
    long doubles = 0;
    long skips = 0;
    //Scores needed to one-shot each ante with a 5x1 high card and Bull - ante 1 ignored
    long anteReqs[8] = {0, 54, 103, 152, 207, 280, 372, 445};
    while (skips < 16) {
        if (skips == 2) {
            init_unlocks(inst, 2, false);
            cash -= 6; //Buying Bull
        }
        item tag = next_tag(inst, 1+skips/2);
        //Filter bad tags (time loss)
        //Enabling the small ones for now
        //if (tag == Investment_Tag) return skips;
        //if (tag == Boss_Tag && doubles > 0) return skips;
        if (tag == Standard_Tag) return skips;
        if (tag == Charm_Tag) return skips;
        if (tag == Meteor_Tag) return skips;
        if (tag == Buffoon_Tag) return skips;
        if (tag == Ethereal_Tag) return skips;
        //if (tag == Top_up_Tag) return skips;
        //if (tag == Orbital_Tag) return skips;

        // The good tags
        if (tag == Double_Tag) doubles++; // This one can lose time, might want to return skips; if we get time loss
        else doubles = 0;
        if (tag == Speed_Tag) {
            for (int i = 0; i <= doubles; i++) {
                cash += 5 * (skips + 1);
            }
            doubles = 0;
        }
        if (tag == Economy_Tag) {
            for (int i = 0; i <= doubles; i++) {
                if (cash < 40) {
                    cash *= 2;
                } else {
                    cash += 40;
                }
            }
        }
        skips++;

        // End of ante stuff
        if (skips % 2 == 0) {
            if (cash < anteReqs[skips/2-1]) return skips;
            if (skips != 16) {
                cash += 12;
                if (skips > 2) cash++;
            }
        }
    }
    return cash;

}