########################################################################
# Package environment with NSIS
########################################################################
message(STATUS "Configuring NSIS")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${PACKAGE_SUFFIX}")
set(CPACK_PACKAGE_VENDOR "Pothosware")

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
set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/icons\\\\wide_logo_pothosware.bmp")
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

########################################################################
# Setup components (only works after install + reconfigure)
########################################################################
file(GLOB_RECURSE ALL_FILES RELATIVE "${CMAKE_INSTALL_PREFIX}" "${CMAKE_INSTALL_PREFIX}/*")
foreach(install_file ${ALL_FILES})
    string(REGEX MATCH "^include/.+$" include_match ${install_file})
    string(REGEX MATCH "^.*cmake/.+$" cmake_match ${install_file})
    string(REGEX MATCH "^lib/.+\\.lib$" lib_match ${install_file})
    string(REGEX MATCH "^lib/python.+/.+$" python_match ${install_file})
    string(REGEX MATCH "^(.+/gnuradio/.+)|(bin/gnuradio.+)|(bin/gr.+)$" gr_match ${install_file})

    #other matches can be greedy, so the order here matters
    if (gr_match)
        set(MYCOMPONENT gnuradio)
    elseif (include_match)
        set(MYCOMPONENT includes)
    elseif (cmake_match)
        set(MYCOMPONENT cmake)
    elseif (lib_match)
        set(MYCOMPONENT libdevel)
    elseif (python_match)
        set(MYCOMPONENT python)
    else ()
        set(MYCOMPONENT runtime)
    endif()

    #install file to itself with the component name
    get_filename_component(MYDESTINATION "${install_file}" DIRECTORY)
    install(
        FILES "${CMAKE_INSTALL_PREFIX}/${install_file}"
        DESTINATION "${MYDESTINATION}"
        COMPONENT "${MYCOMPONENT}")
endforeach()

include(CPackComponent)
cpack_add_component(includes
    DISPLAY_NAME "C/C++ headers"
    GROUP development
    INSTALL_TYPES full)

cpack_add_component(cmake
    DISPLAY_NAME "CMake modules"
    GROUP development
    INSTALL_TYPES full)

cpack_add_component(libdevel
    DISPLAY_NAME "Import libraries"
    GROUP development
    INSTALL_TYPES full)

cpack_add_component(python
    DISPLAY_NAME "Python modules"
    GROUP application
    INSTALL_TYPES apps full)

cpack_add_component(runtime
    DISPLAY_NAME "Application runtime"
    GROUP application
    INSTALL_TYPES apps full)

cpack_add_component(gnuradio
    DISPLAY_NAME "GNU Radio support"
    GROUP application
    INSTALL_TYPES apps full)

cpack_add_component_group(application DISPLAY_NAME "Application" EXPANDED)
cpack_add_component_group(development DISPLAY_NAME "Development" EXPANDED)

cpack_add_install_type(apps DISPLAY_NAME "Applications only")
cpack_add_install_type(full DISPLAY_NAME "Full installation")

include(CPack)
