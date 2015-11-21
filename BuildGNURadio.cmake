############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * volk
## * gnuradio
## * gr-pothos (toolkit bindings project)
############################################################

set(VOLK_BRANCH v1.1.1)
set(GNURADIO_BRANCH v3.7.8.1)

#Use Python27 for Cheetah templates support
set(PYTHON2_EXECUTABLE C:/Python27/python.exe)

############################################################
## Build Volk
############################################################
message(STATUS "Configuring volk - ${VOLK_BRANCH}")
ExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} checkout . &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/volk_cpuid_count_for_msvc.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/volk_config_log2_vc11.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/volk_skip_profile_app_vc11.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(volk SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/volk
)

############################################################
## Build GNU Radio
##
## -DENABLE_GR_DTV=OFF - build errors
############################################################
message(STATUS "Configuring GNURadio - ${GNURADIO_BRANCH}")
ExternalProject_Add(GNURadio
    DEPENDS volk uhd
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} checkout . &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_use_swig.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_public_defs.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_fdmdv_round.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_pfb_clock_sync_fff.diff &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_filter_truncation.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DENABLE_INTERNAL_VOLK=OFF
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DFFTW3F_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3F_LIBRARIES=${FFTW3F_LIBRARIES}
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
        -DENABLE_TESTING=OFF
        -DENABLE_GR_DTV=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GNURadio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GNURadio
)
