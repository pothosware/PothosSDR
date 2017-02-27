############################################################
## Pothos SDR environment build sub-script
##
## This script builds CubicSDR and dependencies
##
## * CubicSDR
############################################################

set(CUBIC_SDR_BRANCH master)

#only support msvc 2015 build to match dlls in CubicSDR/external
if (NOT MSVC14)
    message(STATUS "!Skipping CubicSDR - only supported on VC14")
    return()
endif()

############################################################
## Build CubicSDR
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
############################################################
MyExternalProject_Add(CubicSDR
    DEPENDS SoapySDR wxWidgets
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
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE
)

ExternalProject_Get_Property(CubicSDR SOURCE_DIR)

#install pre-built liquid dsp dll from external/
install(
    FILES ${SOURCE_DIR}/external/liquid-dsp/msvc/64/libliquid.dll
    DESTINATION bin
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "CubicSDR" "CubicSDR")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "CubicSDR")
