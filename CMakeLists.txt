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
if (MSVC11)
    set(PACKAGE_SUFFIX "vc11-x64")
endif ()
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

########################################################################
# Install helper scripts
########################################################################
set(GIT_PATCH_HELPER C:/python34/python.exe ${PROJECT_SOURCE_DIR}/Scripts/GitPatchHelper.py)

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
include(BuildHwDrivers.cmake)
include(BuildSoapySDR.cmake)
include(BuildPothos.cmake)
include(BuildToolkits.cmake)
include(BuildGNURadio.cmake)
include(BuildGrPothos.cmake)

########################################################################
# Package environment with NSIS
########################################################################
message(STATUS "Configuring NSIS")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${PACKAGE_SUFFIX}")
set(CPACK_PACKAGE_VENDOR "Pothosware")
set(CPACK_INSTALLED_DIRECTORIES "${CMAKE_INSTALL_PREFIX}" ".") #install entire directory from external projects
set(CPACK_PACKAGE_EXECUTABLES "PothosGui" "Pothos GUI")
set(CPACK_CREATE_DESKTOP_LINKS "PothosGui")

#general super license text file for complete license summary in installer
file(GLOB_RECURSE license_files RELATIVE
    "${CMAKE_INSTALL_PREFIX}/licenses"
    "${CMAKE_INSTALL_PREFIX}/licenses/*.*")
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_BINARY_DIR}/LICENSE_SUMMARY.txt)
file(WRITE ${CPACK_RESOURCE_FILE_LICENSE}
"###############################################\n"
"## Multi-package license summary\n"
"###############################################\n"
"The Pothos SDR development environment contains pre-built binaries\n"
"from multiple open-source software projects in the SDR ecosystem.\n"
"The license files included with each software package are included in the text below.\n"
"In addition, these licenses can be found in the licenses subdirectory once installed.\n"
"\n")
foreach (license_file ${license_files})
    file(READ "${CMAKE_INSTALL_PREFIX}/licenses/${license_file}" license_text)
    file(APPEND ${CPACK_RESOURCE_FILE_LICENSE}
"###############################################\n"
"## ${license_file}\n"
"###############################################\n"
"${license_text}\n")
endforeach(license_file)

file(TO_NATIVE_PATH share/gnuradio/grc/blocks GRC_BLOCKS_PATH)
string(REPLACE "\\" "\\\\" GRC_BLOCKS_PATH ${GRC_BLOCKS_PATH})

SET(HLKM_ENV
    "\\\"SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Environment\\\"")

SET(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
    WriteRegStr HKLM ${HLKM_ENV} \\\"POTHOS_ROOT\\\" \\\"$INSTDIR\\\"
    WriteRegStr HKLM ${HLKM_ENV} \\\"SOAPY_SDR_ROOT\\\" \\\"$INSTDIR\\\"
    WriteRegStr HKLM ${HLKM_ENV} \\\"UHD_PKG_PATH\\\" \\\"$INSTDIR\\\"
    WriteRegStr HKLM ${HLKM_ENV} \\\"GRC_BLOCKS_PATH\\\" \\\"$INSTDIR\\\\${GRC_BLOCKS_PATH}\\\"
")

SET(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
    DeleteRegValue HKLM ${HLKM_ENV} \\\"POTHOS_ROOT\\\"
    DeleteRegValue HKLM ${HLKM_ENV} \\\"SOAPY_SDR_ROOT\\\"
    DeleteRegValue HKLM ${HLKM_ENV} \\\"UHD_PKG_PATH\\\"
    DeleteRegValue HKLM ${HLKM_ENV} \\\"GRC_BLOCKS_PATH\\\"
")

set(CPACK_GENERATOR "NSIS")
set(CPACK_NSIS_INSTALL_ROOT "C:\\\\Program Files")
ExternalProject_Get_Property(PothosGui SOURCE_DIR)
set(CPACK_NSIS_MUI_ICON ${SOURCE_DIR}/icons/PothosGui.ico)
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_NSIS_DISPLAY_NAME "Pothos SDR environment (${PACKAGE_SUFFIX})") #add/remove control panel
set(CPACK_NSIS_PACKAGE_NAME "Pothos SDR environment (${PACKAGE_SUFFIX})") #installer package title
set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/pothosware/PothosSDR/wiki")
set(CPACK_NSIS_CONTACT "https://github.com/pothosware/pothos/wiki/Support")
set(CPACK_NSIS_HELP_LINK "https://github.com/pothosware/PothosSDR/wiki/Tutorial")

message(STATUS "CPACK_NSIS_DISPLAY_NAME: ${CPACK_NSIS_DISPLAY_NAME}")
message(STATUS "CPACK_PACKAGE_FILE_NAME: ${CPACK_PACKAGE_FILE_NAME}")

include(CPack)

########################################################################
# Generate script for complete rebuild
########################################################################
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
