############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * gnuradio
## * gr-pothos (toolkit bindings project)
############################################################

set(GNURADIO_BRANCH master)
set(GR_POTHOS_BRANCH master)

#Use Python27 for Cheetah templates support
set(PYTHON2_EXECUTABLE C:/Python27/python.exe)

#commands for patching volk for msvc 2012 support
#patching the submodule adds additional complexity
if (MSVC11)
set(VOLK_PATCH_COMMAND
    ${GIT_EXECUTABLE} checkout ${GNURADIO_BRANCH} &&
    ${GIT_EXECUTABLE} pull origin ${GNURADIO_BRANCH} &&
    ${GIT_EXECUTABLE} submodule update && cd volk &&
    ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/volk_skip_profile_app_vc11.diff &&
    ${GIT_EXECUTABLE} commit -am "commit patches" && cd .. &&
    ${GIT_EXECUTABLE} checkout --detach &&
    ${GIT_EXECUTABLE} commit -am "commit submodules"
)
else (MSVC11)
set(VOLK_PATCH_COMMAND cd .) #other versions -> do nothing
endif (MSVC11)

############################################################
## Build GNU Radio
##
## * ENABLE_GR_UHD=OFF replaced by SoapySDR
## * NOSWIG=ON to reduce size and build time
############################################################
message(STATUS "Configuring GNURadio")
ExternalProject_Add(GNURadio
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${VOLK_PATCH_COMMAND}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DFFTW3F_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3F_LIBRARIES=${FFTW3F_LIBRARIES}
        -DENABLE_GR_UHD=OFF
        -DENABLE_TESTING=OFF
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
message(STATUS "Configuring gr-pothos")
ExternalProject_Add(GrPothos
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/pothosware/gr-pothos.git
    GIT_TAG ${GR_POTHOS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)
