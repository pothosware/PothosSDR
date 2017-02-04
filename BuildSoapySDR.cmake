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
## * SoapyRedPitaya
## * SoapyAudio
## * SoapyS9CExtIO
## * SoapyRxTools
############################################################

set(SOAPY_SDR_BRANCH maint) #soapy-sdr-0.5.*
set(SOAPY_AIRSPY_BRANCH soapy-airspy-0.1.0)
set(SOAPY_BLADERF_BRANCH soapy-bladerf-0.3.2)
set(SOAPY_HACKRF_BRANCH soapy-hackrf-0.2.2)
set(SOAPY_UHD_BRANCH soapy-uhd-0.3.2)
set(SOAPY_OSMO_BRANCH soapy-osmo-0.2.4)
set(SOAPY_RTLSDR_BRANCH soapy-rtlsdr-0.2.2)
set(SOAPY_REMOTE_BRANCH maint) #soapy-remote-0.3.*
set(SOAPY_RED_PITAYA_BRANCH soapy-redpitaya-0.1.0)
set(SOAPY_AUDIO_BRANCH master)
set(SOAPY_SDRPLAY_BRANCH master)
set(SOAPY_RX_TOOLS_BRANCH master)

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
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON2_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON2_LIBRARY}
        -DPYTHON_INSTALL_DIR=${PYTHON2_INSTALL_DIR}
        -DPYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DPYTHON3_INCLUDE_DIR=${PYTHON3_INCLUDE_DIR}
        -DPYTHON3_LIBRARY=${PYTHON3_LIBRARY}
        -DPYTHON3_INSTALL_DIR=${PYTHON3_INSTALL_DIR}
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

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"SOAPY_SDR_ROOT\\\" \\\"$INSTDIR\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"SOAPY_SDR_ROOT\\\"
")

############################################################
## Build SoapyAirspy
############################################################
message(STATUS "Configuring SoapyAirspy - ${SOAPY_AIRSPY_BRANCH}")
ExternalProject_Add(SoapyAirspy
    DEPENDS SoapySDR airspy
    GIT_REPOSITORY https://github.com/pothosware/SoapyAirspy.git
    GIT_TAG ${SOAPY_AIRSPY_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyAirspy SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.txt
    DESTINATION licenses/SoapyAirspy
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
## * ENABLE_AIRSPY=OFF see Soapy Airspy
############################################################
message(STATUS "Configuring SoapyOsmo - ${SOAPY_OSMO_BRANCH}")
ExternalProject_Add(SoapyOsmo
    DEPENDS SoapySDR osmo-sdr miri-sdr #airspy bladeRF hackRF rtl-sdr
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
        -DENABLE_AIRSPY=OFF
        -DENABLE_OSMOSDR=ON
        -DENABLE_MIRI=ON
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

############################################################
## Build SoapyRedPitaya
############################################################
message(STATUS "Configuring SoapyRedPitaya - ${SOAPY_RED_PITAYA_BRANCH}")
ExternalProject_Add(SoapyRedPitaya
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyRedPitaya.git
    GIT_TAG ${SOAPY_RED_PITAYA_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyRedPitaya SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/SoapyRedPitaya
)

############################################################
## Build SoapyAudio
############################################################
message(STATUS "Configuring SoapyAudio - ${SOAPY_AUDIO_BRANCH}")
ExternalProject_Add(SoapyAudio
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyAudio.git
    GIT_TAG ${SOAPY_AUDIO_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyAudio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.txt
    DESTINATION licenses/SoapyAudio
)

############################################################
## Build SoapySDRPlay
##
## Requires: SDRplay_RSP_API-Windows-2.09.1.exe
############################################################
get_filename_component(SDRPLAY_API_DIR "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SDRplay\\API;Install_Dir]" ABSOLUTE)
if (EXISTS "${SDRPLAY_API_DIR}")

message(STATUS "Configuring SoapySDRPlay - ${SOAPY_SDRPLAY_BRANCH}")
ExternalProject_Add(SoapySDRPlay
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDRPlay.git
    GIT_TAG ${SOAPY_SDRPLAY_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapySDRPlay SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.txt
    DESTINATION licenses/SoapySDRPlay
)

message(STATUS "SDRPLAY_API_DIR: ${SDRPLAY_API_DIR}")
install(
    FILES ${SDRPLAY_API_DIR}/x64/mir_sdr_api.dll
    DESTINATION bin
)

else ()
    message(STATUS "!Skipping SoapySDRPlay - MiricsSDRAPI not found")
endif ()

############################################################
## Build SoapyRxTools
############################################################
message(STATUS "Configuring SoapyRxTools - ${SOAPY_RX_TOOLS_BRANCH}")
ExternalProject_Add(SoapyRxTools
    DEPENDS SoapySDR Pthreads
    GIT_REPOSITORY https://github.com/rxseger/rx_tools.git
    GIT_TAG ${SOAPY_RX_TOOLS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(SoapyRxTools SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/SoapyRxTools
)
