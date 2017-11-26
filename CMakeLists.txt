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
    set(MSVC_VERSION_YEAR 2013)
    set(MSVC_VERSION_XX 12)
endif ()
if (MSVC14)
    set(MSVC_VERSION_YEAR 2015)
    set(MSVC_VERSION_XX 14)
endif ()

set(PACKAGE_SUFFIX "vc${MSVC_VERSION_XX}-x64")

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
set_property(DIRECTORY PROPERTY "EP_UPDATE_DISCONNECTED" TRUE) #no auto update
set_property(DIRECTORY PROPERTY "EP_INDEPENDENT_STEP_TARGETS" update)
include(ExternalProject)
include(CMakeParseArguments)

function(MyExternalProject_Add name)
    CMAKE_PARSE_ARGUMENTS(MYEPA "" "CMAKE_DEFAULTS;GIT_TAG" "LICENSE_FILES" ${ARGN})

    #use master branch if not specified
    if (MYEPA_GIT_TAG)
        message(STATUS "Configuring ${name} - ${MYEPA_GIT_TAG}")
    else()
        message(STATUS "Configuring ${name}")
        set(MYEPA_GIT_TAG "master")
    endif()

    #defaults for cmake builds
    if (${MYEPA_CMAKE_DEFAULTS})
        set(ARGN "${ARGN} CMAKE_GENERATOR ${CMAKE_GENERATOR}")
        set(ARGN "${ARGN} BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}")
        set(ARGN "${ARGN} INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install")
    endif()

    #create the actual external project
    ExternalProject_Add(${name}
        GIT_TAG ${MYEPA_GIT_TAG}
        GIT_SHALLOW 1
        ${MYEPA_UNPARSED_ARGUMENTS})

    #install license files when listed (relative to source dir)
    ExternalProject_Get_Property(${name} SOURCE_DIR)
    foreach (license ${MYEPA_LICENSE_FILES})
        if(IS_DIRECTORY "${SOURCE_DIR}/${license}")
            install(DIRECTORY "${SOURCE_DIR}/${license}" DESTINATION "licenses/${name}")
        else()
            install(FILES "${SOURCE_DIR}/${license}" DESTINATION "licenses/${name}")
        endif()
    endforeach(license)

    if (NOT MYEPA_LICENSE_FILES)
        message(WARNING "Missing LICENSE_FILES for ${name}")
    endif()

    list(APPEND MYEPA_UPDATE_TARGETS "${name}-update")
    set(MYEPA_UPDATE_TARGETS "${MYEPA_UPDATE_TARGETS}" PARENT_SCOPE)
endfunction(MyExternalProject_Add)

########################################################################
# Build and install external software projects
########################################################################
include(InstallPrebuilt.cmake)
include(SetupPython.cmake)
include(BuildCommon.cmake)
include(BuildHwDrivers.cmake)
include(BuildSoapySDR.cmake)
include(BuildPothos.cmake)
include(BuildGNURadio.cmake)
include(BuildSDRApps.cmake)

########################################################################
# Target to manually update cloned repos
########################################################################
add_custom_target(update DEPENDS ${MYEPA_UPDATE_TARGETS})

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
