// Contains the RNG algorithms that Balatro uses.
#include <string.h>
#include <math.h>

// ChatGPT implementation
void resizeString(char **str, size_t newSize, char fillChar) {
    size_t currentSize = strlen(*str);
    
    if (newSize < currentSize) {
        (*str)[newSize] = '\0'; // Truncate the string
    } else if (newSize > currentSize) {
        *str = realloc(*str, newSize + 1); // Allocate memory for the new size
        if (*str == NULL) {
            // Handle allocation failure
            printf("Memory allocation failed\n");
            exit(EXIT_FAILURE);
        }
        memset(*str + currentSize, fillChar, newSize - currentSize); // Fill the added space with the specified character
        (*str)[newSize] = '\0'; // Null-terminate the string
    }
}

// Credits to 00001H for porting these algorithms to C++, which was the basis of my C and OpenCL ports
unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
long double fract(long double f) {
    return f-floor(f);
}
long double roundDigits(long double f, int d) {
    long double power = pow((float)10, d);
    return round(f*power)/power;
}

long double pseudohash(char* s) {
    resizeString(&s, 16, ' ');
    int mask = 0;
    for (int i = 15; i >= 0; i--) {
        mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
    }
    return roundDigits(fract(sqrt((long double)(abs(mask)))),13);
}

// Other implementations:

/* Lua
function pseudohash(arg_175_0)
	arg_175_0 = string.sub(string.format("%-16s", arg_175_0), 1, 16)

	local var_175_0 = 0

	for iter_175_0 = #arg_175_0, 1, -1 do
		var_175_0 = bit.bxor(var_175_0, bit.lshift(var_175_0, 7) + bit.rshift(var_175_0, 3) + string.byte(arg_175_0, iter_175_0))
	end

	return tonumber(string.format("%.13f", math.sqrt(math.abs(var_175_0)) % 1))
end

Baseed
fl balahash(str s){
    s.resize(16uz,u8' ');
    bsn mask{0_bs};
    for(auto it=s.crbegin();it!=s.crend();++it){
        mask = b32_xor(mask,b32_lsh(mask,7uz)+b32_rsh(mask,3uz)+static_cast<sn>(*it));
    }
    return round_to_digits(fract(std::sqrt(static_cast<fl>(std::abs(mask)))),13_i);
}
*/