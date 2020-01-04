############################################################
## Pothos SDR environment build sub-script
##
## This script handles python config and registry paths.
##
## * python2.7
## * python3.8
############################################################

get_filename_component(PYTHON2_ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.7\\InstallPath]" ABSOLUTE)
if (NOT EXISTS "${PYTHON2_ROOT}")
    message(FATAL_ERROR "Cant find python 2.7 InstallPath")
endif()
set(PYTHON2_EXECUTABLE ${PYTHON2_ROOT}/python.exe)
set(PYTHON2_INCLUDE_DIR ${PYTHON2_ROOT}/include)
set(PYTHON2_LIBRARY ${PYTHON2_ROOT}/libs/python27.lib)
set(PYTHON2_INSTALL_DIR lib/python2.7/site-packages)
message(STATUS "PYTHON2_ROOT: ${PYTHON2_ROOT}")

get_filename_component(PYTHON3_ROOT "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.8\\InstallPath]" ABSOLUTE)
if (NOT EXISTS "${PYTHON3_ROOT}")
    message(FATAL_ERROR "Cant find python 3.8 InstallPath")
endif()
set(PYTHON3_EXECUTABLE ${PYTHON3_ROOT}/python.exe)
set(PYTHON3_INCLUDE_DIR ${PYTHON3_ROOT}/include)
set(PYTHON3_LIBRARY ${PYTHON3_ROOT}/libs/python38.lib)
set(PYTHON3_INSTALL_DIR lib/python3.8/site-packages)
message(STATUS "PYTHON3_ROOT: ${PYTHON3_ROOT}")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
SetRegView 64
WriteRegStr HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\2.7\\\\PythonPath\\\\${PROJECT_NAME}\\\" \\\"\\\" \\\"$INSTDIR\\\\lib\\\\python2.7\\\\site-packages\\\"
WriteRegStr HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\3.8\\\\PythonPath\\\\${PROJECT_NAME}\\\" \\\"\\\" \\\"$INSTDIR\\\\lib\\\\python3.8\\\\site-packages\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
SetRegView 64
DeleteRegKey HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\2.7\\\\PythonPath\\\\${PROJECT_NAME}\\\"
DeleteRegKey HKEY_LOCAL_MACHINE \\\"SOFTWARE\\\\Python\\\\PythonCore\\\\3.8\\\\PythonPath\\\\${PROJECT_NAME}\\\"
")

set(GIT_PATCH_HELPER ${PYTHON3_EXECUTABLE} ${PROJECT_SOURCE_DIR}/Scripts/GitPatchHelper.py)
