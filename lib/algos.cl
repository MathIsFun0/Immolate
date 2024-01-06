// Credits to 00001H for porting these algorithms to C++, which was the basis of my C and OpenCL ports
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
double fract(double f) {
    return f-floor(f);
}
double roundDigits(double f, int d) {
    double power = pow((float)10, d);
    return round(f*power)/power;
}

double pseudohash(__constant char* s, size_t stringLen) {
    //resizeString(&s, 16, ' ');
    int mask = 0;
    if (stringLen >= 16) {
        // Use first 16 chars
        for (int i = 15; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    } else {
        // Use space (32) for empty chars
        for (int i = 15; i >= stringLen; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+32);
        }
        for (int i = stringLen-1; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    }
    return roundDigits(fract(sqrt((double)(abs(mask)))),13);
}

int add(int x, int y) {
    return x+y;
}