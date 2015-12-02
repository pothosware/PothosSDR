############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * volk
## * gnuradio
## * gr-osmosdr
############################################################

set(VOLK_BRANCH v1.1.1)
set(GNURADIO_BRANCH v3.7.8.1)
set(GROSMOSDR_BRANCH master)

#Use Python27 for Cheetah templates support
set(PYTHON2_EXECUTABLE C:/Python27/python.exe)

############################################################
## Build Volk
############################################################
message(STATUS "Configuring volk - ${VOLK_BRANCH}")
ExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/volk_cpuid_count_for_msvc.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_config_log2_vc11.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_skip_profile_app_vc11.diff
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
############################################################
message(STATUS "Configuring GNURadio - ${GNURADIO_BRANCH}")
ExternalProject_Add(GNURadio
    DEPENDS volk uhd
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_use_swig.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_use_alloca.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_vc11_log2.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_public_defs.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_fdmdv_round.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_pfb_clock_sync_fff.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_filter_truncation.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_portaudio_add_io_h.diff
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
        -DPORTAUDIO_INCLUDE_DIRS=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARIES=${PORTAUDIO_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GNURadio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GNURadio
)

############################################################
## Build GrOsmoSDR
##
## * ENABLE_RFSPACE=OFF build errors
############################################################
message(STATUS "Configuring GrOsmoSDR - ${GROSMOSDR_BRANCH}")
ExternalProject_Add(GrOsmoSDR
    DEPENDS GNURadio SoapySDR bladeRF uhd hackRF rtl-sdr osmo-sdr miri-sdr airspy
    GIT_REPOSITORY git://git.osmocom.org/gr-osmosdr
    GIT_TAG ${GROSMOSDR_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/osmo_soapy_fix_iq_bal_mode.diff
        ${PROJECT_SOURCE_DIR}/patches/grosmosdr_provide_vc11_nan.diff
        ${PROJECT_SOURCE_DIR}/patches/rtl_tcp_source_fix_ssize_t.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DENABLE_RFSPACE=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrOsmoSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrOsmoSDR
)
