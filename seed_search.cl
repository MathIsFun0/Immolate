#include "lib/immolate.cl"

__kernel void search() {
    printf("GPU Output: <%i>\n",add(1, 22));
}