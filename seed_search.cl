#include "lib/immolate.cl"

__kernel void search() {
    __constant char* in = "WHATISHAPPENING";
    double hash = pseudohash(in, 15);
    printf("GPU Output: <%.13lf>\n",hash);
}