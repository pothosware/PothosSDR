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
## * mirisdr
############################################################

set(OSMO_BRANCH master)
set(MIRISDR_BRANCH master)
set(RTL_BRANCH master)
set(BLADERF_BRANCH master)
set(HACKRF_BRANCH master)
set(UHD_BRANCH release_003_010_001_001)
set(UMTRX_BRANCH master)
set(AIRSPY_BRANCH v1.0.9)

############################################################
## Build Osmo SDR
############################################################
message(STATUS "Configuring osmo-sdr - ${OSMO_BRANCH}")
ExternalProject_Add(osmo-sdr
    DEPENDS libusb
    GIT_REPOSITORY git://git.osmocom.org/osmo-sdr.git
    GIT_TAG ${OSMO_BRANCH}
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/software/libosmosdr
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(osmo-sdr SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/software/libosmosdr/COPYING
    DESTINATION licenses/osmo-sdr
)

############################################################
## Build Miri SDR
############################################################
message(STATUS "Configuring miri-sdr - ${MIRISDR_BRANCH}")
ExternalProject_Add(miri-sdr
    DEPENDS libusb
    GIT_REPOSITORY git://git.osmocom.org/libmirisdr.git
    GIT_TAG ${MIRISDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIBUSB_INCLUDE_DIR=${LIBUSB_INCLUDE_DIR}
        -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(miri-sdr SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/miri-sdr
)

############################################################
## Build RTL SDR
############################################################
message(STATUS "Configuring rtl-sdr - ${RTL_BRANCH}")
ExternalProject_Add(rtl-sdr
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/librtlsdr/librtlsdr.git
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
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/Nuand/bladeRF.git
    GIT_TAG ${BLADERF_BRANCH}
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
)

ExternalProject_Get_Property(bladeRF SOURCE_DIR)
install(
    DIRECTORY ${SOURCE_DIR}/legal/licenses/
    DESTINATION licenses/bladeRF
)

############################################################
## Build HackRF
############################################################
message(STATUS "Configuring hackRF - ${HACKRF_BRANCH}")
ExternalProject_Add(hackRF
    DEPENDS Pthreads libusb
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
## Build UHD
############################################################
message(STATUS "Configuring uhd - ${UHD_BRANCH}")
ExternalProject_Add(uhd
    DEPENDS libusb
    GIT_REPOSITORY https://github.com/EttusResearch/uhd.git
    GIT_TAG ${UHD_BRANCH}
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
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(uhd SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/host/LICENSE
    DESTINATION licenses/uhd
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"UHD_PKG_PATH\\\" \\\"$INSTDIR\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"UHD_PKG_PATH\\\"
")

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
## Build Airspy
############################################################
message(STATUS "Configuring airspy - ${AIRSPY_BRANCH}")
ExternalProject_Add(airspy
    DEPENDS Pthreads libusb
    GIT_REPOSITORY https://github.com/airspy/host.git
    GIT_TAG ${AIRSPY_BRANCH}
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
