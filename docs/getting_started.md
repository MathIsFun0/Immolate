# Getting Started
## Setting up Immolate
Download the required files from the [Releases](https://github.com/MathIsFun0/Immolate/releases) page and unzip them into a directory of your choice.

With a command line, navigate to the directory where you placed Immolate.exe.

To check that Immolate works, run the command `immolate -h`. You should see a help dialog that lists all of the command-line arguments to pass into the searcher.

## Running an existing filter
To run an existing filter, open the file `search.cl`. The first line will look something like `#include "filters/red_poly_glass.cl"`. Replace the text in quotes with the path to a file that contains a filter.

To run the executable, there are a few command line arguments that may be important.
- `-s`: Sets the starting seed of the search.
- `-n`: Sets the number of seeds of the search.
- `-c`: Sets the score the filter needs to return for a seed to be printed. Useful when searching for streaks or seeds that must meet a variety of conditions.
- `-p` and `-d`: Sets the platform and device IDs of the device Immolate uses to search. Running Immolate with `--list_devices` will give you the platform ID and device ID of every detected OpenCL device, which is needed for these commands. If you are having issues running Immolate, please check the [Troubleshooting](troubleshooting.md) section of the documentation.
- `-g`: Sets the number of groups of threads used by the searcher. If your device is not being used with 100% utilization, you will want to increase this number from the default of 16. On GPUs, a value of 256 is recommended.

## Creating your own filter
This part of the documentation, as well as documentation of the functions available in Immolate, will be created at a later date.