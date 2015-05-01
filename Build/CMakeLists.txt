########################################################################
# Pothos SDR development environment
########################################################################
cmake_minimum_required(VERSION 2.8.8)
project(PothosSDR NONE)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "build type")
endif()

add_compile_options(/MP) #multi-core build

########################################################################
# Build and install external software projects
########################################################################
include(ExternalProject)
include(InstallPrebuilt.cmake)
include(BuildHwDrivers.cmake)
include(BuildPothos.cmake)
include(BuildGNURadio.cmake)

########################################################################
# Package environment with NSIS
########################################################################
set(CPACK_PACKAGE_INSTALL_DIRECTORY "PothosSDR")
set(CPACK_PACKAGE_FILE_NAME "PothosSDR")
set(CPACK_PACKAGE_VENDOR "Pothosware")
set(CPACK_INSTALLED_DIRECTORIES "${CMAKE_INSTALL_PREFIX}" ".") #install entire directory from external projects

set(CPACK_PACKAGE_EXECUTABLES "PothosGui" "Pothos GUI")

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

set(CPACK_GENERATOR "NSIS")
set(CPACK_NSIS_INSTALL_ROOT "C:\\\\Program Files")
ExternalProject_Get_Property(Pothos SOURCE_DIR)
set(CPACK_NSIS_MUI_ICON ${SOURCE_DIR}/pothos-gui/icons/PothosGui.ico)
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_NSIS_DISPLAY_NAME "Pothos SDR dev environment") #add/remove control panel
set(CPACK_NSIS_PACKAGE_NAME "Pothos SDR dev environment") #installer package title
set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/pothosware/PothosSDR/wiki")
set(CPACK_NSIS_CONTACT "https://github.com/pothosware/pothos/wiki/Support")
include(CPack)
