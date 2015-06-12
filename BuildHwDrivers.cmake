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
## * SoapyUHD
## * SoapyOsmo
############################################################

set(RTL_BRANCH master)
set(BLADERF_BRANCH libbladeRF_v1.2.1)
set(HACKRF_BRANCH 755a9f67aeb96d7aa6993c4eb96f7b47963593d7)
set(UHD_BRANCH release_003_008_004)
set(UMTRX_BRANCH 1.0.3)
set(SOAPY_BRANCH master)

############################################################
## Build SoapySDR
##
## * GPLOK=OFF disable submodules - build separately
############################################################
message(STATUS "Configuring SoapySDR")
ExternalProject_Add(SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDR.git
    GIT_TAG ${SOAPY_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=C:/Python34/python.exe
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DGPLOK=OFF
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
message(STATUS "Configuring rtl-sdr")
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
message(STATUS "Configuring bladeRF")
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
## Build HackRF
############################################################
message(STATUS "Configuring hackRF")
ExternalProject_Add(hackRF
    GIT_REPOSITORY https://github.com/mossmann/hackrf.git
    GIT_TAG ${HACKRF_BRANCH}
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
)

ExternalProject_Get_Property(hackRF SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/hackRF
)

############################################################
## Build SoapyOsmo
##
## * ENABLE_RFSPACE=OFF build errors
############################################################
message(STATUS "Configuring SoapyOsmo")
ExternalProject_Add(SoapyOsmo
    DEPENDS SoapySDR bladeRF hackRF rtl-sdr
    GIT_REPOSITORY https://github.com/pothosware/SoapyOsmo.git
    GIT_TAG ${SOAPY_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DENABLE_RFSPACE=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyOsmo SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/SoapyOsmo
)


############################################################
## Build UHD
############################################################
message(STATUS "Configuring uhd")
ExternalProject_Add(uhd
    GIT_REPOSITORY https://github.com/EttusResearch/uhd.git
    GIT_TAG ${UHD_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} checkout . &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/uhd_fix_cbx_bind_boost_1_58.diff
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
        -DPYTHON_EXECUTABLE=C:/Python27/python.exe
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
message(STATUS "Configuring umtrx")
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
message(STATUS "Configuring SoapyUHD")
ExternalProject_Add(SoapyUHD
    DEPENDS SoapySDR uhd
    GIT_REPOSITORY https://github.com/pothosware/SoapyUHD.git
    GIT_TAG ${SOAPY_BRANCH}
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
