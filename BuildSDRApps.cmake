############################################################
## Pothos SDR environment build sub-script
##
## This script builds SDR applications that take a variety
## of dependencies and didn't fit into the other Build* files.
##
## * CubicSDR
## * Inspectrum
## * LimeSuite
############################################################

set(CUBIC_SDR_BRANCH master)
set(INSPECTRUM_SDR_BRANCH master)
set(LIME_SUITE_BRANCH master)

############################################################
## Build CubicSDR
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
############################################################
MyExternalProject_Add(CubicSDR
    DEPENDS SoapySDR wxWidgets liquiddsp
    GIT_REPOSITORY https://github.com/cjcliffe/CubicSDR.git
    GIT_TAG ${CUBIC_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DWX_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
        -DFFTW_INCLUDES=${FFTW3F_INCLUDE_DIRS}
        -DFFTW_LIBRARIES=${FFTW3F_LIBRARIES}
        -DFFTW_DLL=${FFTW3F_LIBRARIES} #this gets installed to bin
        -DLIQUID_INCLUDES=${LIQUIDDSP_INCLUDE_DIR}
        -DLIQUID_LIBRARIES=${LIQUIDDSP_LIBRARY}
        -DLIQUID_DLL=${LIQUIDDSP_DLL}
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "CubicSDR" "CubicSDR")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "CubicSDR")

############################################################
## Build Inspectrum
############################################################
MyExternalProject_Add(Inspectrum
    DEPENDS mman liquiddsp
    GIT_REPOSITORY https://github.com/miek/inspectrum.git
    GIT_TAG ${INSPECTRUM_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
        -DMMAN=${CMAKE_INSTALL_PREFIX}/lib/mman.lib
        -DFFTW_INCLUDES=${FFTW3F_INCLUDE_DIRS}
        -DFFTW_LIBRARIES=${FFTW3F_LIBRARIES}
        -DLIQUID_INCLUDES=${LIQUIDDSP_INCLUDE_DIR}
        -DLIQUID_LIBRARIES=${LIQUIDDSP_LIBRARY}
    LICENSE_FILES LICENSE
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "inspectrum" "Inspectrum")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "inspectrum")

############################################################
## Build LimeSuite
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
##
## -DFX3_SDK_PATH specifies the USB support for LimeSuite
## If the SDK is not present, USB support will be disabled.
##
############################################################
MyExternalProject_Add(LimeSuite
    DEPENDS SoapySDR wxWidgets
    GIT_REPOSITORY https://github.com/myriadrf/LimeSuite.git
    GIT_TAG ${LIME_SUITE_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIME_SUITE_EXTVER=${EXTRA_VERSION_INFO}
        -DWX_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
        -DFX3_SDK_PATH=${FX3_SDK_PATH}
    LICENSE_FILES COPYING
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "LimeSuiteGUI" "Lime Suite")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "LimeSuiteGUI")
