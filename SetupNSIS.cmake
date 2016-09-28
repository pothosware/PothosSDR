########################################################################
# Package environment with NSIS
########################################################################
message(STATUS "Configuring NSIS")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${PACKAGE_SUFFIX}")
set(CPACK_PACKAGE_VENDOR "Pothosware")
set(CPACK_INSTALLED_DIRECTORIES "${CMAKE_INSTALL_PREFIX}" ".") #install entire directory from external projects

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
set(CPACK_NSIS_MUI_ICON ${CMAKE_SOURCE_DIR}/icons/PothosSDR.ico)
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_NSIS_DISPLAY_NAME "Pothos SDR environment (${PACKAGE_SUFFIX})") #add/remove control panel
set(CPACK_NSIS_PACKAGE_NAME "Pothos SDR environment (${PACKAGE_SUFFIX})") #installer package title
set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/pothosware/PothosSDR/wiki")
set(CPACK_NSIS_CONTACT "https://github.com/pothosware/pothos/wiki/Support")
set(CPACK_NSIS_HELP_LINK "https://github.com/pothosware/PothosSDR/wiki/Tutorial")

message(STATUS "CPACK_NSIS_DISPLAY_NAME: ${CPACK_NSIS_DISPLAY_NAME}")
message(STATUS "CPACK_PACKAGE_FILE_NAME: ${CPACK_PACKAGE_FILE_NAME}")

#######################################################################
## SetOutPath to the bin directory with template customization:
##
## Setting the start-in to be the bin directory avoids PATH issues,
## at least when using the shortcuts. This is a messy work around
## and CMake should probably provide a variable for SetOutPath.
#######################################################################
file(READ "${CMAKE_ROOT}/Modules/NSIS.template.in" NSIS_template)
set(CREATE_ICONS_REPLACE "
  SetOutPath \"$INSTDIR\\bin\"
@CPACK_NSIS_CREATE_ICONS@
  SetOutPath \"$INSTDIR\"")
string(REPLACE "@CPACK_NSIS_CREATE_ICONS@" "${CREATE_ICONS_REPLACE}" NSIS_template "${NSIS_template}")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/NSIS.template.in" "${NSIS_template}")
set(CPACK_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}")

include(CPack)
