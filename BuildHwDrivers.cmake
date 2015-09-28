############################################################
## Pothos SDR environment build sub-script
##
## This script builds SoapySDR and vendor drivers
##
## * rtl-sdr
## * bladerf
## * hackrf
## * uhd/usrp
## * umtrx
## * SoapySDR
## * SoapyBladeRF
## * SoapyHackRF
## * SoapyUHD
## * SoapyOsmo
## * SoapyRTLSDR
## * SoapyRemote
############################################################

set(RTL_BRANCH master)
set(BLADERF_BRANCH 2015.07)
set(HACKRF_BRANCH v2015.07.2)
set(UHD_BRANCH release_003_009_001)
set(UMTRX_BRANCH 1.0.4)
set(SOAPY_SDR_BRANCH master)
set(SOAPY_BLADERF_BRANCH master)
set(SOAPY_HACKRF_BRANCH master)
set(SOAPY_UHD_BRANCH master)
set(SOAPY_OSMO_BRANCH master)
set(SOAPY_RTLSDR_BRANCH master)
set(SOAPY_REMOTE_BRANCH master)

############################################################
## Build SoapySDR
############################################################
message(STATUS "Configuring SoapySDR - ${SOAPY_SDR_BRANCH}")
ExternalProject_Add(SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDR.git
    GIT_TAG ${SOAPY_SDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DSOAPY_SDR_EXTVER=${EXTRA_VERSION_INFO}
        -DPYTHON_EXECUTABLE=C:/Python34/python.exe
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapySDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/SoapySDR
)

############################################################
## Build RTL SDR
############################################################
message(STATUS "Configuring rtl-sdr - ${RTL_BRANCH}")
ExternalProject_Add(rtl-sdr
    GIT_REPOSITORY git://git.osmocom.org/rtl-sdr.git
    GIT_TAG ${RTL_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(rtl-sdr SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/rtl-sdr
)

############################################################
## Build BladeRF
############################################################
message(STATUS "Configuring bladeRF - ${BLADERF_BRANCH}")
ExternalProject_Add(bladeRF
    GIT_REPOSITORY https://github.com/Nuand/bladeRF.git
    GIT_TAG ${BLADERF_BRANCH}
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/host
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DENABLE_BACKEND_USB=ON
        -DENABLE_BACKEND_LIBUSB=ON
        -DLIBUSB_HEADER_FILE=${LIBUSB_INCLUDE_DIR}/libusb.h
        -DLIBUSB_PATH=${LIBUSB_ROOT}
        -DLIBPTHREADSWIN32_HEADER_FILE=${THREADS_PTHREADS_INCLUDE_DIR}/pthread.h
        -DLIBPTHREADSWIN32_PATH=${THREADS_PTHREADS_ROOT}
        -DVERSION_INFO_OVERRIDE=${EXTRA_VERSION_INFO}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        #post install: move dll from lib into the runtime path directory
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/lib/bladeRF.dll ${CMAKE_INSTALL_PREFIX}/bin/bladeRF.dll
)

ExternalProject_Get_Property(bladeRF SOURCE_DIR)
install(
    DIRECTORY ${SOURCE_DIR}/legal/licenses/
    DESTINATION licenses/bladeRF
)

############################################################
## Build SoapyBladeRF
############################################################
message(STATUS "Configuring SoapyBladeRF - ${SOAPY_BLADERF_BRANCH}")
ExternalProject_Add(SoapyBladeRF
    DEPENDS SoapySDR bladeRF
    GIT_REPOSITORY https://github.com/pothosware/SoapyBladeRF.git
    GIT_TAG ${SOAPY_BLADERF_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyBladeRF SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.LGPLv2.1
    DESTINATION licenses/SoapyBladeRF
)

############################################################
## Build HackRF
############################################################
message(STATUS "Configuring hackRF - ${HACKRF_BRANCH}")
ExternalProject_Add(hackRF
    GIT_REPOSITORY https://github.com/mossmann/hackrf.git
    GIT_TAG ${HACKRF_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} checkout . &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/hackrf_fix_compat_c89_vc11.diff
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/host
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        #post install: move lib from bin into the library path directory
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/bin/hackrf.lib ${CMAKE_INSTALL_PREFIX}/lib/hackrf.lib
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/bin/hackrf_static.lib ${CMAKE_INSTALL_PREFIX}/lib/hackrf_static.lib
)

ExternalProject_Get_Property(hackRF SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/hackRF
)

############################################################
## Build SoapyHackRF
############################################################
message(STATUS "Configuring SoapyHackRF - ${SOAPY_HACKRF_BRANCH}")
ExternalProject_Add(SoapyHackRF
    DEPENDS SoapySDR hackRF
    GIT_REPOSITORY https://github.com/pothosware/SoapyHackRF.git
    GIT_TAG ${SOAPY_BLADERF_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DLIBHACKRF_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/libhackrf
        -DLIBHACKRF_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/hackrf.lib
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyHackRF SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE
    DESTINATION licenses/SoapyHackRF
)

############################################################
## Build SoapyOsmo
##
## * ENABLE_RFSPACE=OFF build errors
## * ENABLE_BLADERF=OFF see Soapy BladeRF
## * ENABLE_HACKRF=OFF see Soapy HackRF
## * ENABLE_RTL=OFF see Soapy RTL-SDR
############################################################
message(STATUS "Configuring SoapyOsmo - ${SOAPY_OSMO_BRANCH}")
ExternalProject_Add(SoapyOsmo
    DEPENDS SoapySDR #bladeRF hackRF rtl-sdr
    GIT_REPOSITORY https://github.com/pothosware/SoapyOsmo.git
    GIT_TAG ${SOAPY_OSMO_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DENABLE_RFSPACE=OFF
        -DENABLE_BLADERF=OFF
        -DENABLE_HACKRF=OFF
        -DENABLE_RTL=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyOsmo SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/SoapyOsmo
)

############################################################
## Build SoapyRTLSDR
############################################################
message(STATUS "Configuring SoapyRTLSDR - ${SOAPY_RTLSDR_BRANCH}")
ExternalProject_Add(SoapyRTLSDR
    DEPENDS SoapySDR rtl-sdr
    GIT_REPOSITORY https://github.com/pothosware/SoapyRTLSDR.git
    GIT_TAG ${SOAPY_RTLSDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyRTLSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.txt
    DESTINATION licenses/SoapyRTLSDR
)

############################################################
## Build SoapyRemote
############################################################
message(STATUS "Configuring SoapyRemote - ${SOAPY_REMOTE_BRANCH}")
ExternalProject_Add(SoapyRemote
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyRemote.git
    GIT_TAG ${SOAPY_REMOTE_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyRemote SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/SoapyRemote
)

############################################################
## Build UHD
############################################################
message(STATUS "Configuring uhd - ${UHD_BRANCH}")
ExternalProject_Add(uhd
    GIT_REPOSITORY https://github.com/EttusResearch/uhd.git
    GIT_TAG ${UHD_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} checkout . &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/uhd_fix_gain_group_floor_round.diff
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/host
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(uhd SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/host/LICENSE
    DESTINATION licenses/uhd
)

############################################################
## Build UmTRX
############################################################
message(STATUS "Configuring umtrx - ${UMTRX_BRANCH}")
ExternalProject_Add(umtrx
    DEPENDS uhd
    GIT_REPOSITORY https://github.com/fairwaves/UHD-Fairwaves.git
    GIT_TAG ${UMTRX_BRANCH}
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/host
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

############################################################
## Build SoapyUHD
############################################################
message(STATUS "Configuring SoapyUHD - ${SOAPY_UHD_BRANCH}")
ExternalProject_Add(SoapyUHD
    DEPENDS SoapySDR uhd
    GIT_REPOSITORY https://github.com/pothosware/SoapyUHD.git
    GIT_TAG ${SOAPY_UHD_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyUHD SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/SoapyUHD
)
