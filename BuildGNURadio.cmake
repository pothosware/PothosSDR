############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * gnuradio
## * gr-pothos (toolkit bindings project)
############################################################

set(GR_BRANCH master)

#Use Python27 for Cheetah templates support
set(PYTHON2_EXECUTABLE C:/Python27/python.exe)

############################################################
## Build GNU Radio
##
## * ENABLE_GR_DTV=OFF because of compiler error
## * ENABLE_GR_UHD=OFF replaced by SoapySDR
## * NOSWIG=ON to reduce size and build time
############################################################
ExternalProject_Add(GNURadio
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/gnuradio.git
    GIT_TAG ${GR_BRANCH}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARY_DIR=${BOOST_LIBRARY_DIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DFFTW3F_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3F_LIBRARIES=${FFTW3F_LIBRARIES}
        -DENABLE_GR_DTV=OFF
        -DENABLE_GR_UHD=OFF
        -DNOSWIG=ON
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GNURadio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GNURadio
)

############################################################
## GR Pothos bindings
############################################################
ExternalProject_Add(GrPothos
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/pothosware/gr-pothos.git
    GIT_TAG ${GR_BRANCH}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARY_DIR=${BOOST_LIBRARY_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)
