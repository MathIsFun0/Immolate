#!/bin/bash

# Create the build directory if it doesn't exist
mkdir -p build

# Run CMake to configure the project
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build the project
cmake --build build --config Release --target all


