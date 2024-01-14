#include "lib/immolate.cl"
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void search() {
    char8 in_seed = (char8)('B','F','3','G','U','I','X','H');
    struct Seed seed = s_new(in_seed);
    struct GameInstance inst = i_new(seed);
    printf("GPU Output: <");
    printf("%lu>\n",i_randint(&inst, Misprint, 0, 20));
    printf("<%lu>\n",i_randint(&inst, Misprint, 0, 20));
    printf("<%lu>\n",i_randint(&inst, Misprint, 0, 20));
    printf("<%lu>\n",i_randint(&inst, Misprint, 0, 20));
    printf("<%lu>\n",i_randint(&inst, Misprint, 0, 20));
}