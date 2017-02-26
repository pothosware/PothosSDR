# Pothos SDR development environment

The Pothos SDR development environment makes it easy for windows users
to start exploring and developing with common SDR hardware and software
without the hassle of downloading a building dozens of software packages.
This project contains build scripts to create a package of windows binaries.
Links to the pre-built binaries will be available from the main wiki page:

* https://github.com/pothosware/PothosSDR/wiki

##Basic instructions

Instructions for downloading, installing,
and using the development environment
can be found on the getting started tutorial:

* https://github.com/pothosware/PothosSDR/wiki/Tutorial

##About the environment

The Pothos SDR environment includes:

* The Pothos data-flow software suite and graphical tools
* SoapySDR and pothos-sdr toolkit for hardware interfacing
* various vendor drivers for commonly used SDR hardware
* GNU Radio toolkit for signal processing support

For more details about the software used in the environment
and links to the actual source code, checkout this wiki page:

* https://github.com/pothosware/PothosSDR/wiki/Sources

##Prebuilt binaries manifest

Pothos SDR relies on a number of pre-build package from the internet.
The current download URLs are maintained here for reference,
and can be to replicate the complete build environment.

* Boost: http://sourceforge.net/projects/boost/files/boost-binaries/1.63.0/
* Qt: https://download.qt.io/archive/qt/5.7/5.7.1/
* SWIG: http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip
* FFTW: ftp://ftp.fftw.org/pub/fftw/fftw-3.3.5-dll64.zip
* NSIS: https://sourceforge.net/projects/nsis/files/NSIS%203/

Python environments needed for the build:

* Python3.6 for python3 bindings
* Python2.7 for python2 bindings

Python2.7 modules needed for GNU Radio build:

* Use pip to install: Cheetah, mako, ply
* Download prebuilt wheels and install with pip
  * http://www.lfd.uci.edu/~gohlke/pythonlibs
  * pygtk, wxpython, numpy, lxml, pyopengl

##Building the environment

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
cmake ../ -G "Visual Studio 14 2015 Win64" ^
    -DCMAKE_INSTALL_PREFIX=C:/PothosSDR ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
rebuild_all.bat
```

For full compilation instructions, see README.build.
