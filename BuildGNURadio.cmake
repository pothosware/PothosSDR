############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * zeromq
## * cppzmq
## * volk
## * gnuradio
## * gr-osmosdr
## * gr-rds
## * gqrx
############################################################

set(ZEROMQ_BRANCH master)
set(CPPZMQ_BRANCH master)
set(VOLK_BRANCH v1.2)
set(GNURADIO_BRANCH v3.7.9)
set(GROSMOSDR_BRANCH master)
set(GRRDS_BRANCH master)
set(GQRX_BRANCH b424dd92a0e1e747038d86e16b92d3ddf011afab)

#Use Python27 for Cheetah templates support
set(PYTHON2_EXECUTABLE C:/Python27/python.exe)

############################################################
## Build ZeroMQ
############################################################
message(STATUS "Configuring ZeroMQ - ${ZEROMQ_BRANCH}")
ExternalProject_Add(ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/zeromq4-x.git
    GIT_TAG ${ZEROMQ_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DHAVE_WS2_32=ON
        -DHAVE_RPCRT4=ON
        -DHAVE_IPHLAPI=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(ZeroMQ SOURCE_DIR)
install(
    FILES
        ${SOURCE_DIR}/COPYING
        ${SOURCE_DIR}/COPYING.LESSER
    DESTINATION licenses/ZeroMQ
)

############################################################
## Build CppZMQ
############################################################
message(STATUS "Configuring CppZMQ - ${CPPZMQ_BRANCH}")
ExternalProject_Add(CppZMQ
    DEPENDS ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/cppzmq.git
    GIT_TAG ${CPPZMQ_BRANCH}
    CONFIGURE_COMMAND echo "Configured"
    BUILD_COMMAND echo "Built"
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/zmq.hpp ${CMAKE_INSTALL_PREFIX}/include
)

ExternalProject_Get_Property(CppZMQ SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE
    DESTINATION licenses/CppZMQ
)

############################################################
## Build Volk
############################################################
message(STATUS "Configuring volk - ${VOLK_BRANCH}")
ExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/volk_cpuid_count_for_msvc.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_config_math_vc11.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_skip_profile_app_vc11.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_fix_msvc14.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_qa_utils_config_h.diff
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
    DEPENDS volk uhd CppZMQ
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_use_swig.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_use_alloca.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_public_defs.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_fdmdv_round.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_pfb_clock_sync_fff.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_filter_truncation.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_portaudio_add_io_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_udp_source_linger.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_config_msvc_math.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_msvc14.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_dllr_factor.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_use_gr_aligned.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_ldpc_config_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_grc_windows_paths.diff
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
        -DENABLE_REDPITAYA=ON
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrOsmoSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrOsmoSDR
)

############################################################
## Build gr-rds
############################################################
message(STATUS "Configuring GrRDS - ${GRRDS_BRANCH}")
ExternalProject_Add(GrRDS
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/bastibl/gr-rds.git
    GIT_TAG ${GRRDS_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gr_rds_msvc_fixes.diff
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
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrRDS SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrRDS
)

############################################################
## Build GQRX
############################################################
message(STATUS "Configuring GQRX - ${GQRX_BRANCH}")
ExternalProject_Add(GQRX
    DEPENDS GNURadio GrOsmoSDR
    GIT_REPOSITORY https://github.com/csete/gqrx.git
    GIT_TAG ${GQRX_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GQRX SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GQRX
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gqrx" "GQRX SDR")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gqrx")
