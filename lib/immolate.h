#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#ifdef _WIN32
    #include <windows.h>
    #define PATH_SEPARATOR "\\"
#else
    // Define undefined MAX_PATH in Linux
    #define MAX_PATH (1024)
    #define PATH_SEPARATOR "/"

    #include <unistd.h>
    #include <libgen.h>

    /* Use unsafe not _s functions
     * An alternative is using safeclib implementation with the following:
     *
     * #define __STDC_WANT_LIB_EXT1__ 1
     * #include <safeclib/safe_str_lib.h>
     * 
     * Unfortunately, the strcat_s and strcpy_s do not work for malloced strings
     */
    #define strcat_s(a,b,c) strcat(a,c)
    #define strcpy_s(a,b,c) strcpy(a,c)
    #define printf_s(...) printf(__VA_ARGS__)
    #define fprintf_s(...) fprintf(__VA_ARGS__)
#endif
#include <limits.h>
#include <string.h>
#include <CL/cl.h>
#define MAX_CODE_SIZE (1000000)

void clErrCheck(cl_int err, char* msg) {
    if (err != CL_SUCCESS) {
        printf_s("Fatal CL Error %d when trying to execute %s\n", err, msg);
        exit(EXIT_FAILURE);
    }
}

void getExecutableDir(char *dir) {
    #ifdef _WIN32
        // Windows specific code
         if (GetModuleFileName(NULL, dir, MAX_PATH) != 0) {
            char* last_slash = strrchr(dir, '\\');
            if (last_slash != NULL) {
                *last_slash = '\0';
            }
        } else {
            fprintf(stderr, "Error: Unable to get the current working directory\n");
        }
    #elif __linux__
        // Linux specific code
        ssize_t len = readlink("/proc/self/exe", dir, (size_t)(MAX_PATH - 1));
        if (len != -1) {
            dir[len] = '\0';
            char* last_slash = strrchr(dir, '/');
            if (last_slash != NULL) {
                *last_slash = '\0';
            }
        } else {
            fprintf(stderr, "Error: Unable to get the current working directory\n");
            // exit(EXIT_FAILURE);
        }
    #else
        #error Platform not supported
    #endif
}