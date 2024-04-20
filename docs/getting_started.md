# Getting Started
## Setting up Immolate
Download the required files from the [Releases](https://github.com/MathIsFun0/Immolate/releases) page and unzip them into a directory of your choice.

Open the Immolate CLI in the directory you extracted Immolate to.

To check that Immolate works, run the command `immolate -h`. You should see a help dialog that lists all of the command-line arguments to pass into the searcher.

## Running an existing filter
To run an existing filter, type the name of the filter after the `-f` option, e.g. `immolate -f double_legendary`.

To run the executable, there are a few command line arguments that may be important.
- `-f`: Sets the filter used by the search.
- `-s`: Sets the starting seed of the search.
- `-n`: Sets the number of seeds of the search.
- `-c`: Sets the score the filter needs to return for a seed to be printed. Useful when searching for streaks or seeds that must meet a variety of conditions.
- `-p` and `-d`: Sets the platform and device IDs of the device Immolate uses to search. Running Immolate with `--list_devices` will give you the platform ID and device ID of every detected OpenCL device, which is needed for these commands. If you are having issues running Immolate, please check the [Troubleshooting](troubleshooting.md) section of the documentation.
- `-g`: Sets the number of groups of threads used by the searcher. If your device is not being used with 100% utilization, you will want to increase this number from the default of 16. On GPUs, a value of 256 is recommended.

All of the [Existing Filters](existingfilters.md) are housed in the /filters folder. Explanations and usage guides are in the comments of each filter file.

## Creating your own filter
As of now the only way to create your own filter is to program it yourself.
It is highly recommended to look through /lib/items.cl and /lib/functions.cl for items and functions.
