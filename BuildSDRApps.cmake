############################################################
## Pothos SDR environment build sub-script
##
## This script builds SDR applications that take a variety
## of dependencies and didn't fit into the other Build* files.
##
## * CubicSDR
## * Inspectrum
############################################################

set(CUBIC_SDR_BRANCH e0d1e2b6ff0ce006c37d7007e0c34ec25d20e944) #before rgb narrowing error
set(INSPECTRUM_SDR_BRANCH master)

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
    DEPENDS liquiddsp
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
