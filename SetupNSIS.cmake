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

set(HLKM_ENV "\\\"SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Environment\\\"")

set(Q3 "$\\\\\\\"") #escape quotes within the NSIS command

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
WriteRegStr HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"POTHOS_ROOT\\\" \\\"$INSTDIR\\\"
WriteRegStr HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"SOAPY_SDR_ROOT\\\" \\\"$INSTDIR\\\"
WriteRegStr HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"UHD_PKG_PATH\\\" \\\"$INSTDIR\\\"
WriteRegStr HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"GRC_BLOCKS_PATH\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\grc\\\\blocks\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\".pth\\\" \\\"\\\" \\\"PothosSDR\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"PothosSDR\\\\DefaultIcon\\\" \\\"\\\" \\\"$INSTDIR\\\\share\\\\Pothos\\\\icons\\\\PothosGui.ico\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"PothosSDR\\\\Shell\\\\Open\\\\command\\\" \\\"\\\" \\\"${Q3}$INSTDIR\\\\bin\\\\PothosGui.exe${Q3} ${Q3}%1${Q3} %*\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
DeleteRegValue HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"POTHOS_ROOT\\\"
DeleteRegValue HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"SOAPY_SDR_ROOT\\\"
DeleteRegValue HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"UHD_PKG_PATH\\\"
DeleteRegValue HKEY_LOCAL_MACHINE ${HLKM_ENV} \\\"GRC_BLOCKS_PATH\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\".pth\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\"PothosSDR\\\"
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
