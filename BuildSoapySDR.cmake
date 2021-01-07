############################################################
## Pothos SDR environment build sub-script
##
## This script builds SoapySDR and support modules
##
## * SoapySDR
## * SoapyAirspy
## * SoapyAirspyHF
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
## * SoapyPlutoSDR
## * LimeSuite
## * SoapyNetSDR
############################################################

set(SOAPY_SDR_BRANCH master)
set(SOAPY_REMOTE_BRANCH master)
set(SOAPY_AIRSPY_BRANCH master)
set(SOAPY_AIRSPYHF_BRANCH master)
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
set(SOAPY_PLUTO_SDR_BRANCH master)
set(LIME_SUITE_BRANCH master)
set(SOAPY_NET_SDR_BRANCH master)

############################################################
## Build SoapySDR
############################################################
MyExternalProject_Add(SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDR.git
    GIT_TAG ${SOAPY_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DSOAPY_SDR_EXTVER=${EXTRA_VERSION_INFO}
        -DENABLE_PYTHON=OFF
        -DENABLE_PYTHON3=OFF
    LICENSE_FILES LICENSE_1_0.txt
)

#disabling env SOAPY_SDR_ROOT because library can use relative path to dll
#set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
#WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"SOAPY_SDR_ROOT\\\" \\\"$INSTDIR\\\"
#")
#set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
#DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"SOAPY_SDR_ROOT\\\"
#")

############################################################
## Build SoapySDR python bindings
############################################################
MyExternalProject_Add(SoapySDRPython3
    DEPENDS swig SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDR.git
    GIT_TAG ${SOAPY_SDR_BRANCH}
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/python
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON3_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON3_LIBRARY}
        -DPYTHON_INSTALL_DIR=${PYTHON3_INSTALL_DIR}
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    #extra install command to inject add_dll_directory for DLL search changes in python3.8
    INSTALL_COMMAND
        ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install &&
        cat "${CMAKE_SOURCE_DIR}/python/soapysdr_python38_add_dll_directory.py" > "${CMAKE_BINARY_DIR}/SoapySDR.py" &&
        cat "${CMAKE_INSTALL_PREFIX}/${PYTHON3_INSTALL_DIR}/SoapySDR.py" >> "${CMAKE_BINARY_DIR}/SoapySDR.py" &&
        ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/SoapySDR.py" "${CMAKE_INSTALL_PREFIX}/${PYTHON3_INSTALL_DIR}"
    LICENSE_FILES LICENSE_1_0.txt
)

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
## Build SoapyAirspyHF
############################################################
MyExternalProject_Add(SoapyAirspyHF
    DEPENDS SoapySDR airspyhf
    GIT_REPOSITORY https://github.com/pothosware/SoapyAirspyHF.git
    GIT_TAG ${SOAPY_AIRSPYHF_BRANCH}
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
## * ENABLE_RFSPACE=OFF see Soapy NetSDR
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
if (EXISTS "${SDRPLAY_API_DIR}")

MyExternalProject_Add(SoapySDRPlay3
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapySDRPlay3
    GIT_TAG ${SOAPY_SDRPLAY_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE.txt
)

else ()
    message(STATUS "!Skipping SoapySDRPlay3 - sdrplay_api not found")
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

############################################################
## Build SoapyPlutoSDR
############################################################
MyExternalProject_Add(SoapyPlutoSDR
    DEPENDS SoapySDR libad9361
    GIT_REPOSITORY https://github.com/pothosware/SoapyPlutoSDR.git
    GIT_TAG ${SOAPY_PLUTO_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBIIO_INCLUDE_DIR=${LIBIIO_INCLUDE_DIR}
        -DLIBIIO_LIBRARY=${LIBIIO_LIBRARY}
    LICENSE_FILES LICENSE
)

############################################################
## Build LimeSuite
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
##
## -DFX3_SDK_PATH specifies the USB support for LimeSuite
## If the SDK is not present, USB support will be disabled.
##
############################################################
MyExternalProject_Add(LimeSuite
    DEPENDS SoapySDR wxWidgets
    GIT_REPOSITORY https://github.com/myriadrf/LimeSuite.git
    GIT_TAG ${LIME_SUITE_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIME_SUITE_EXTVER=${EXTRA_VERSION_INFO}
        -DWX_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
        -DFX3_SDK_PATH=${FX3_SDK_PATH}
    LICENSE_FILES COPYING
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "LimeSuiteGUI" "Lime Suite")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "LimeSuiteGUI")

############################################################
## Build SoapyNetSDR
############################################################
MyExternalProject_Add(SoapyNetSDR
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/SoapyNetSDR.git
    GIT_TAG ${SOAPY_NET_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES License.txt
)
