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
## * SoapyIris
############################################################

set(SOAPY_SDR_BRANCH maint)
set(SOAPY_REMOTE_BRANCH maint)
set(SOAPY_AIRSPY_BRANCH master)
set(SOAPY_BLADERF_BRANCH master)
set(SOAPY_HACKRF_BRANCH master)
set(SOAPY_UHD_BRANCH master)
set(SOAPY_OSMO_BRANCH master)
set(SOAPY_RTLSDR_BRANCH master)
set(SOAPY_RED_PITAYA_BRANCH master)
set(SOAPY_AUDIO_BRANCH master)
set(SOAPY_SDRPLAY_BRANCH master)
set(SOAPY_RX_TOOLS_BRANCH master)
set(SOAPY_IRIS_BRANCH master)

############################################################
## Build SoapySDR
############################################################
MyExternalProject_Add(SoapySDR
    DEPENDS swig
    GIT_REPOSITORY https://github.com/pothosware/SoapySDR.git
    GIT_TAG ${SOAPY_SDR_BRANCH}
    CMAKE_DEFAULTS ON
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
    LICENSE_FILES LICENSE_1_0.txt
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
MyExternalProject_Add(SoapyAirspy
    DEPENDS SoapySDR airspy
    GIT_REPOSITORY https://github.com/pothosware/SoapyAirspy.git
    GIT_TAG ${SOAPY_AIRSPY_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.txt
)

############################################################
## Build SoapyBladeRF
############################################################
MyExternalProject_Add(SoapyBladeRF
    DEPENDS SoapySDR bladeRF
    GIT_REPOSITORY https://github.com/pothosware/SoapyBladeRF.git
    GIT_TAG ${SOAPY_BLADERF_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.LGPLv2.1
)

############################################################
## Build SoapyHackRF
############################################################
MyExternalProject_Add(SoapyHackRF
    DEPENDS SoapySDR hackRF
    GIT_REPOSITORY https://github.com/pothosware/SoapyHackRF.git
    GIT_TAG ${SOAPY_HACKRF_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DLIBHACKRF_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/libhackrf
        -DLIBHACKRF_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/hackrf.lib
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE
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
MyExternalProject_Add(SoapyOsmo
    DEPENDS SoapySDR osmo-sdr miri-sdr #airspy bladeRF hackRF rtl-sdr
    GIT_REPOSITORY https://github.com/pothosware/SoapyOsmo.git
    GIT_TAG ${SOAPY_OSMO_BRANCH}
    CMAKE_DEFAULTS ON
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
    LICENSE_FILES COPYING
)

############################################################
## Build SoapyRTLSDR
############################################################
MyExternalProject_Add(SoapyRTLSDR
    DEPENDS SoapySDR rtl-sdr
    GIT_REPOSITORY https://github.com/pothosware/SoapyRTLSDR.git
    GIT_TAG ${SOAPY_RTLSDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.txt
)

############################################################
## Build SoapyRemote
############################################################
MyExternalProject_Add(SoapyRemote
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyRemote.git
    GIT_TAG ${SOAPY_REMOTE_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build SoapyUHD
############################################################
MyExternalProject_Add(SoapyUHD
    DEPENDS SoapySDR uhd
    GIT_REPOSITORY https://github.com/pothosware/SoapyUHD.git
    GIT_TAG ${SOAPY_UHD_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DUHD_INCLUDE_DIRS=${UHD_INCLUDE_DIRS}
        -DUHD_LIBRARIES=${UHD_LIBRARIES}
    LICENSE_FILES COPYING
)

############################################################
## Build SoapyRedPitaya
############################################################
MyExternalProject_Add(SoapyRedPitaya
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyRedPitaya.git
    GIT_TAG ${SOAPY_RED_PITAYA_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES COPYING
)

############################################################
## Build SoapyAudio
############################################################
MyExternalProject_Add(SoapyAudio
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyAudio.git
    GIT_TAG ${SOAPY_AUDIO_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.txt
)

############################################################
## Build SoapySDRPlay
############################################################
get_filename_component(SDRPLAY_API_DIR "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SDRplay\\API;Install_Dir]" ABSOLUTE)
if (EXISTS "${SDRPLAY_API_DIR}")

MyExternalProject_Add(SoapySDRPlay
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDRPlay.git
    GIT_TAG ${SOAPY_SDRPLAY_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.txt
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
MyExternalProject_Add(SoapyRxTools
    DEPENDS SoapySDR Pthreads
    GIT_REPOSITORY https://github.com/rxseger/rx_tools.git
    GIT_TAG ${SOAPY_RX_TOOLS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    LICENSE_FILES COPYING
)

############################################################
## Build Skylark's Iris support
############################################################
MyExternalProject_Add(SoapyIris
    DEPENDS SoapySDR SoapyRemote
    GIT_REPOSITORY https://github.com/skylarkwireless/sklk-soapyiris.git
    GIT_TAG ${SOAPY_IRIS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES BSD-3-CLAUSE-LICENSE.txt
)
