########################################################################
# Project setup
########################################################################
cmake_minimum_required(VERSION 2.8.8)
project(PothosSDR NONE)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "build type")
endif()

include(InstallPrebuilt.cmake)
include(BuildHwDrivers.cmake)
