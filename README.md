# Pothos SDR development environment

The Pothos SDR development environment makes it easy for windows users
to start exploring and developing with common SDR hardware and software
without the hassle of downloading a building dozens of software packages.
This project contains build scripts to create a package of windows binaries.
Links to the pre-built binaries will be available from the main wiki page:

* https://github.com/pothosware/PothosSDR/wiki

## Basic instructions

Instructions for downloading, installing,
and using the development environment
can be found on the getting started tutorial:

* https://github.com/pothosware/PothosSDR/wiki/Tutorial

## About the environment

The Pothos SDR environment includes:

* The Pothos data-flow software suite and graphical tools
* SoapySDR and pothos-sdr toolkit for hardware interfacing
* various vendor drivers for commonly used SDR hardware
* GNU Radio toolkit for signal processing support

For more details about the software used in the environment
and links to the actual source code, checkout this wiki page:

* https://github.com/pothosware/PothosSDR/wiki/Sources

## Required packages to install

**Visual studio 2019:** The free community installer is fine.
Install all of the C++ development tools.
https://visualstudio.microsoft.com/vs/community/

**Python environment:** Download the python3.9 x64 installer.
Python is used for bindings, generation, downloading tools.
https://www.python.org/downloads/

**Git:** Install msysgit, make sure git is in the command PATH.
https://msysgit.github.io/index.old.html

**CMake:** The build environment is cmake-based,
as are most projects built by this environment.
https://cmake.org/download/

## Optional packages to install

Some projects require pre-build packages from the internet.
These packages are optional, but need to be installed manually.
The current download URLs are maintained here for reference,
and can be used to replicate the complete build environment.

**Boost 1.75:** UHD and GNURadio projects require Boost development sources.
http://sourceforge.net/projects/boost/files/boost-binaries/1.75.0/

**CyAPI:** Limesuite (LimeSDR) uses the Cypress API for USB bindings.
https://www.cypress.com FX3SDKSetup_1.3.4.exe

**SDRplayAPIv3:** SoapySDRPlay3 and gr-sdrplay3 require the SDRPlayv3 API.
https://www.sdrplay.com/downloads/

**NSIS:** The installer packaging requires NSIS to make the final exe.
https://sourceforge.net/projects/nsis/files/NSIS%203/

## Building the environment

This repository contains build scripts for creating
the Pothos SDR environment on a Windows/MSVC target system.

We don't typically expect users to build the environment,
thats why we offer the pre-packaged windows installers.
However should someone be interested in building it,
all of the build scripts are located in this repository.

The build system obtains most of the software from git,
however several dependency libraries are obtained pre-built
and installed onto the development machine. Learn more about
these dependencies from the InstallPrebuilt.cmake script.

Building the environment with CMake:

```
mkdir build
cd build
cmake ../ -G "Visual Studio 16 2019" ^
    -DCMAKE_INSTALL_PREFIX=C:/PothosSDR ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo

#build everything + NSIS packaging
rebuild_all.bat

#--OR-- just build and install to CMAKE_INSTALL_PREFIX
cmake --build . --config RelWithDebInfo
cmake --build . --config RelWithDebInfo --target install

#repositories can be updated with
cmake --build . --config RelWithDebInfo --target update
```
