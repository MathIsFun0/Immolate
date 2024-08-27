# Immolate (Development C++ Version)

This branch of Immolate hosts a C++ rewrite which makes use of the CPU only.

As of today, it is lacking many features (such as most filters and custom filter creation without a compiler).

However, in the long-term, this is planned to replace the current OpenCL version of Immolate.

## Building

### Windows

> [!IMPORTANT]
> Unless you are familiar with the command line, this is not the recommended way to get this software. Check the [Releases page](https://github.com/MathIsFun0/Immolate/releases) to get the latest binary release.

1. Install the prerequisites with [winget](https://winget.run):
```bat
winget install --id Kitware.CMake
winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"
```
2. Open the _x64 Native Tools Command Prompt for VS 2022_:
![](https://i.sstatic.net/6lSCI.png)

3. Navigate to the `Immolate` source folder and run:
```bat
.\build.bat
```

### Debian (derivates) Linux
Install the dependencies with:
```bash
sudo apt-get install cmake build-essential
```
Then, you can compile with cmake:
```bash
cmake -B build
cmake --build build --config Release
```

### Nix
If you are on Mac or on Linux and you are running [Nix](https://nixos.org/) with flake support enabled, you can get a shell with all the needed build dependencies by running in this folder:
```bash
nix develop
```

Then, you can compile as usual:
```bash
cmake -B build
cmake --build build --config Release
```

## Future Plans
- CLI
- custom filters with JSON
- add all unimplemented sources
- compatibility with modded items?
