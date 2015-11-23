############################################################
## Pothos SDR environment build sub-script
##
## This script builds SoapySDR and support modules
##
## * SoapySDR
## * SoapyBladeRF
## * SoapyHackRF
## * SoapyUHD
## * SoapyOsmo
## * SoapyRTLSDR
## * SoapyRemote
############################################################

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
        -DPYTHON_EXECUTABLE=C:/Python27/python.exe
        -DPYTHON3_EXECUTABLE=C:/Python34/python.exe
        -DPYTHON3_LIBRARY=C:/Python34/libs/python34.lib
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
## Build SoapyHackRF
############################################################
message(STATUS "Configuring SoapyHackRF - ${SOAPY_HACKRF_BRANCH}")
ExternalProject_Add(SoapyHackRF
    DEPENDS SoapySDR hackRF
    GIT_REPOSITORY https://github.com/pothosware/SoapyHackRF.git
    GIT_TAG ${SOAPY_HACKRF_BRANCH}
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
    DEPENDS SoapySDR osmo-sdr miri-sdr airspy #bladeRF hackRF rtl-sdr
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
        -DENABLE_OSMOSDR=ON
        -DENABLE_MIRI=ON
        -DENABLE_AIRSPY=ON
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
