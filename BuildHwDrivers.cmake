############################################################
## Pothos SDR environment build sub-script
##
## This script builds SDR hardware drivers
##
## * osmo-sdr
## * rtl-sdr
## * bladerf
## * hackrf
## * uhd/usrp
## * umtrx
## * airspy
## * airspy-hf+
## * mirisdr
## * libad9361 (plutosdr)
############################################################

set(OSMO_BRANCH master)
set(MIRISDR_BRANCH master)
set(RTL_BRANCH master)
set(BLADERF_BRANCH master)
set(HACKRF_BRANCH master)
set(UHD_BRANCH maint)
set(UMTRX_BRANCH master)
set(AIRSPY_BRANCH master)
set(AIRSPYHF_BRANCH master)
set(LIBAD9361_BRANCH master)

############################################################
## Build Osmo SDR
############################################################
MyExternalProject_Add(osmo-sdr
    DEPENDS libusb
    GIT_REPOSITORY git://git.osmocom.org/osmo-sdr.git
    GIT_TAG ${OSMO_BRANCH}
    CMAKE_DEFAULTS ON
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/software/libosmosdr
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
    LICENSE_FILES software/libosmosdr/COPYING
)

############################################################
## Build Miri SDR
############################################################
MyExternalProject_Add(miri-sdr
    DEPENDS libusb
    GIT_REPOSITORY git://git.osmocom.org/libmirisdr.git
    GIT_TAG ${MIRISDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
    LICENSE_FILES COPYING
)

############################################################
## Build RTL SDR
############################################################
MyExternalProject_Add(rtl-sdr
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/librtlsdr/librtlsdr.git
    GIT_TAG ${RTL_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    LICENSE_FILES COPYING
)

############################################################
## Build BladeRF
############################################################
MyExternalProject_Add(bladeRF
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/Nuand/bladeRF.git
    GIT_TAG ${BLADERF_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/bladerf_disable_test_config.diff
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/host
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DENABLE_BACKEND_USB=ON
        -DENABLE_BACKEND_LIBUSB=ON
        -DENABLE_BACKEND_CYAPI=${FX3_SDK_FOUND}
        -DFX3_SDK_PATH=${FX3_SDK_PATH}
        -DLIBUSB_HEADER_FILE=${LIBUSB_INCLUDE_DIR}/libusb.h
        -Dusb_LIBRARY=${LIBUSB_ROOT}/x64/Release/dll/libusb-1.0.lib
        -DLIBUSB_PATH=${LIBUSB_ROOT}
        -DLIBPTHREADSWIN32_HEADER_FILE=${THREADS_PTHREADS_INCLUDE_DIR}/pthread.h
        -DPTHREAD_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
        -DLIBPTHREADSWIN32_PATH=${THREADS_PTHREADS_ROOT}
        -DVERSION_INFO_OVERRIDE=${EXTRA_VERSION_INFO}
    BUILD_COMMAND echo "build bladerf..."
        #work around the bladerf copy external dll commands
        #since we are not using the exact same file path
        && ${CMAKE_COMMAND} -E make_directory ${THREADS_PTHREADS_ROOT}/dll/x64
        && ${CMAKE_COMMAND} -E copy
            ${THREADS_PTHREADS_ROOT}/pthreadVC2.dll
            ${THREADS_PTHREADS_ROOT}/dll/x64/pthreadVC2.dll
        && ${CMAKE_COMMAND} -E make_directory ${LIBUSB_ROOT}/MS64/dll
        && ${CMAKE_COMMAND} -E copy
            ${LIBUSB_ROOT}/x64/Release/dll/libusb-1.0.dll
            ${LIBUSB_ROOT}/MS64/dll/libusb-1.0.dll
        #the actual cmake build target
        && ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
        #cleanup from work around copies
        && ${CMAKE_COMMAND} -E remove_directory ${THREADS_PTHREADS_ROOT}/dll
        && ${CMAKE_COMMAND} -E remove_directory ${LIBUSB_ROOT}/MS64
    INSTALL_COMMAND echo "install bladerf..."
        #the actual cmake install target
        && ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        #post install: move dll from lib into the runtime path directory
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/lib/bladeRF.dll ${CMAKE_INSTALL_PREFIX}/bin/bladeRF.dll
    LICENSE_FILES legal/licenses/
)

#bladerf tries to install this file, but its not part of the SDK, so make it
if (NOT EXISTS "${FX3_SDK_PATH}/license/license.txt")
    file(WRITE "${FX3_SDK_PATH}/license/license.txt" "http://www.cypress.com")
endif()

############################################################
## Build HackRF
############################################################
MyExternalProject_Add(hackRF
    DEPENDS Pthreads libusb fftw
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
        -DFFTW_INCLUDES=${FFTW3F_INCLUDE_DIRS}
        -DFFTW_LIBRARIES=${FFTW3F_LIBRARIES}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        #post install: move lib from bin into the library path directory
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/bin/hackrf.lib ${CMAKE_INSTALL_PREFIX}/lib/hackrf.lib
        && ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/bin/hackrf_static.lib ${CMAKE_INSTALL_PREFIX}/lib/hackrf_static.lib
    LICENSE_FILES COPYING
)

############################################################
## Build UHD
############################################################
MyExternalProject_Add(uhd
    DEPENDS libusb
    GIT_REPOSITORY https://github.com/EttusResearch/uhd.git
    GIT_TAG ${UHD_BRANCH}
    CMAKE_DEFAULTS ON
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
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
    LICENSE_FILES host/LICENSE
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"UHD_PKG_PATH\\\" \\\"$INSTDIR\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"UHD_PKG_PATH\\\"
")

set(UHD_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
set(UHD_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/uhd.lib)

############################################################
## Build UmTRX
##
## Not building with recent UHD API
############################################################
#MyExternalProject_Add(umtrx
    #DEPENDS uhd
    #GIT_REPOSITORY https://github.com/fairwaves/UHD-Fairwaves.git
    #GIT_TAG ${UMTRX_BRANCH}
    #CMAKE_DEFAULTS ON
    #CONFIGURE_COMMAND
        #"${CMAKE_COMMAND}" <SOURCE_DIR>/host
        #-G ${CMAKE_GENERATOR}
        #-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        #-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        #-DBOOST_ROOT=${BOOST_ROOT}
        #-DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        #-DBOOST_ALL_DYN_LINK=TRUE
        #-DUHD_INCLUDE_DIRS=${UHD_INCLUDE_DIRS}
        #-DUHD_LIBRARIES=${UHD_LIBRARIES}
    #LICENSE_FILES README
#)

############################################################
## Build Airspy
############################################################
MyExternalProject_Add(airspy
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/airspy/host.git
    GIT_TAG ${AIRSPY_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    LICENSE_FILES README.md
)

############################################################
## Build AirspyHF
############################################################
MyExternalProject_Add(airspyhf
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/airspy/airspyhf.git
    GIT_TAG ${AIRSPYHF_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
        -DTHREADS_PTHREADS_INCLUDE_DIR=${THREADS_PTHREADS_INCLUDE_DIR}
        -DTHREADS_PTHREADS_WIN32_LIBRARY=${THREADS_PTHREADS_WIN32_LIBRARY}
    LICENSE_FILES LICENSE
)

############################################################
## Build libad9361
############################################################
MyExternalProject_Add(libad9361
    DEPENDS libiio
    GIT_REPOSITORY https://github.com/analogdevicesinc/libad9361-iio.git
    GIT_TAG ${LIBAD9361_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBIIO_INCLUDEDIR=${LIBIIO_INCLUDE_DIR}
        -DLIBIIO_LIBRARIES=${LIBIIO_LIBRARY}
    LICENSE_FILES LICENSE
)
