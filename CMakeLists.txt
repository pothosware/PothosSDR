########################################################################
# Pothos SDR development environment
########################################################################
cmake_minimum_required(VERSION 2.8.8)
project(PothosSDR NONE)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "build type")
endif()

enable_language(CXX) #defines MSVCxx variables
message(STATUS "MSVC_VERSION: ${MSVC_VERSION}")
message(STATUS "CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
if (MSVC12)
    set(PACKAGE_SUFFIX "vc12-x64")
endif ()
if (MSVC14)
    set(PACKAGE_SUFFIX "vc14-x64")
endif ()

#version tracking based on the day of the build
string(TIMESTAMP PROJECT_VERSION "%Y.%m.%d")

#some projects can be build with extra info to identify the build
set(EXTRA_VERSION_INFO "${PROJECT_NAME}-${PROJECT_VERSION}-${PACKAGE_SUFFIX}")

add_compile_options(/MP) #multi-core build

#NSIS escaped registry path for environment variables
set(NSIS_ENV "SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Environment")

#NSIS escaped quote - gives us an escaped quote \" in an NSIS command
set(NEQ "$\\\\\\\"")

########################################################################
# Install helper scripts
########################################################################
install(DIRECTORY Scripts DESTINATION ".")
install(DIRECTORY patches DESTINATION ".")

########################################################################
# Setup the external projects for a flat structure
########################################################################
set_property(DIRECTORY PROPERTY "EP_BASE" ${CMAKE_BINARY_DIR})
include(ExternalProject)

########################################################################
# Build and install external software projects
########################################################################
include(InstallPrebuilt.cmake)
include(SetupPython.cmake)
include(BuildCommon.cmake)
include(BuildHwDrivers.cmake)
include(BuildSoapySDR.cmake)
include(BuildLimeSuite.cmake)
include(BuildPothos.cmake)
include(BuildGNURadio.cmake)
include(BuildCubicSDR.cmake)

########################################################################
# Package environment with NSIS
########################################################################
include(SetupNSIS.cmake)

########################################################################
# Generate script for complete rebuild
########################################################################
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
file(WRITE ${PROJECT_BINARY_DIR}/rebuild_all.bat
    "\"${CMAKE_COMMAND}\" -E remove_directory \"${CMAKE_INSTALL_PREFIX}\"\n"
    "\"${CMAKE_COMMAND}\" -E make_directory \"${CMAKE_INSTALL_PREFIX}\"\n"
    "\"${CMAKE_COMMAND}\" \"${PROJECT_SOURCE_DIR}\"\n" #rerun the configuration with latest settings
    "\"${CMAKE_COMMAND}\" --build ${PROJECT_BINARY_DIR} --config ${CMAKE_BUILD_TYPE} --target clean\n"
    "\"${CMAKE_COMMAND}\" --build ${PROJECT_BINARY_DIR} --config ${CMAKE_BUILD_TYPE}\n"
    "\"${CMAKE_COMMAND}\" --build ${PROJECT_BINARY_DIR} --config ${CMAKE_BUILD_TYPE} --target install\n"
    "\"${CMAKE_COMMAND}\" \"${PROJECT_SOURCE_DIR}\"\n" #needed to regenerate license summary after install
    "\"${CMAKE_COMMAND}\" --build ${PROJECT_BINARY_DIR} --config ${CMAKE_BUILD_TYPE} --target package\n"
)
