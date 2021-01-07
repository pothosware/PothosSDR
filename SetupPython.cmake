############################################################
## Pothos SDR environment build sub-script
##
## This script handles python config and registry paths.
##
## * python3.8
############################################################

set(PYTHON3_VERSION "3.8")
string(REPLACE "." "" PYTHON3_VERSION_NO_DOT "${PYTHON3_VERSION}")
get_filename_component(PYTHON3_ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\${PYTHON3_VERSION}\\InstallPath]" ABSOLUTE)
if (NOT EXISTS "${PYTHON3_ROOT}")
    message(FATAL_ERROR "Cant find python ${PYTHON3_VERSION} InstallPath")
endif()
set(PYTHON3_EXECUTABLE ${PYTHON3_ROOT}/python.exe)
set(PYTHON3_INCLUDE_DIR ${PYTHON3_ROOT}/include)
set(PYTHON3_LIBRARY ${PYTHON3_ROOT}/libs/python${PYTHON3_VERSION_NO_DOT}.lib)
set(PYTHON3_INSTALL_DIR lib/python${PYTHON3_VERSION}/site-packages)
message(STATUS "PYTHON3_ROOT: ${PYTHON3_ROOT}")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
SetRegView 64
WriteRegStr HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\${PYTHON3_VERSION}\\\\PythonPath\\\\${PROJECT_NAME}\\\" \\\"\\\" \\\"$INSTDIR\\\\lib\\\\python${PYTHON3_VERSION}\\\\site-packages\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
SetRegView 64
DeleteRegKey HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\${PYTHON3_VERSION}\\\\PythonPath\\\\${PROJECT_NAME}\\\"
")

set(GIT_PATCH_HELPER ${PYTHON3_EXECUTABLE} ${PROJECT_SOURCE_DIR}/Scripts/GitPatchHelper.py)
