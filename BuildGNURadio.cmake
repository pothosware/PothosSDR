############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * volk
## * SoapyVolk
## * gnuradio
## * gr-osmosdr
## * gqrx
## * gr-sdrplay3
############################################################

set(VOLK_BRANCH master)
set(SOAPYVOLK_BRANCH master)
set(GNURADIO_BRANCH master)
set(GROSMOSDR_BRANCH master)
set(GQRX_BRANCH master)
set(GRSDRPLAY3 master)

if (NOT EXISTS ${BOOST_ROOT})
    return() #boost is a requirement for all projects here
endif ()

############################################################
# python generation tools
# volk uses mako
# gnuradio uses pygccxml numpy PyQt5
# gr-sdrplay3 uses six
############################################################
execute_process(COMMAND ${PYTHON3_ROOT}/Scripts/pip.exe install mako pygccxml numpy PyQt5 six OUTPUT_QUIET)

############################################################
## Build Volk
############################################################
MyExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DVOLK_PYTHON_DIR=${PYTHON3_INSTALL_DIR}
    LICENSE_FILES COPYING
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"VOLK_PREFIX\\\" \\\"$INSTDIR\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"VOLK_PREFIX\\\"
")

############################################################
## Build SoapyVolk
############################################################
MyExternalProject_Add(SoapyVolk
    DEPENDS SoapySDR volk
    GIT_REPOSITORY https://github.com/pothosware/SoapyVOLKConverters.git
    GIT_TAG ${SOAPYVOLK_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES COPYING
)

############################################################
## Build GNU Radio
############################################################
MyExternalProject_Add(GNURadio
    DEPENDS volk PyBind11 Log4CPP MPIR uhd CppZMQ PortAudio CppUnit gsl fftw Qt5 qwt libsndfile
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gnuradio.diff
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/log4cpp.lib
        -DMPIR_INCLUDE_DIR=${MPIR_INCLUDE_DIR}
        -DMPIR_LIBRARY=${MPIR_LIBRARY}
        -DMPIRXX_LIBRARY=${MPIRXX_LIBRARY}
        -DENABLE_INTERNAL_VOLK=OFF
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON3_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON3_LIBRARY}
        -DGR_PYTHON_DIR=${PYTHON3_INSTALL_DIR}
        -DFFTW3f_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3f_LIBRARIES=${FFTW3F_LIBRARIES}
        -DUHD_INCLUDE_DIRS=${UHD_INCLUDE_DIRS}
        -DUHD_LIBRARIES=${UHD_LIBRARIES}
        -DENABLE_TESTING=ON
        -DCPPUNIT_INCLUDE_DIRS=${CPPUNIT_INCLUDE_DIRS}
        -DCPPUNIT_LIBRARIES=${CPPUNIT_LIBRARIES}
        -DENABLE_PYTHON=ON
        -DPORTAUDIO_INCLUDE_DIRS=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARIES=${PORTAUDIO_LIBRARY}
        -DZEROMQ_INCLUDE_DIRS=${ZEROMQ_INCLUDE_DIRS}
        -DZEROMQ_LIBRARIES=${ZEROMQ_LIBRARIES}
        -DGSL_INCLUDE_DIRS=${GSL_INCLUDE_DIRS}
        -DGSL_LIBRARY=${GSL_LIBRARY}
        -DGSL_CBLAS_LIBRARY=${GSL_CBLAS_LIBRARY}
        -DENABLE_GR_QTGUI=ON
        -DCMAKE_PREFIX_PATH=${QT5_ROOT}
        -DQWT_INCLUDE_DIRS=${QWT_INCLUDE_DIR}
        -DQWT_LIBRARIES=${QWT_LIBRARY}
        -DENABLE_GRC=ON
    LICENSE_FILES COPYING
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GR_PREFIX\\\" \\\"$INSTDIR\\\"
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\grc\\\\blocks\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GR_PREFIX\\\"
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\"
")

############################################################
## Build GrOsmoSDR
##
## * ENABLE_RFSPACE=OFF build errors
############################################################
MyExternalProject_Add(GrOsmoSDR
    DEPENDS GNURadio SoapySDR bladeRF uhd hackRF rtl-sdr osmo-sdr miri-sdr airspy
    GIT_REPOSITORY git://git.osmocom.org/gr-osmosdr
    GIT_TAG ${GROSMOSDR_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gr-osmosdr.diff
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/log4cpp.lib
        -DMPIR_INCLUDE_DIR=${MPIR_INCLUDE_DIR}
        -DMPIR_LIBRARY=${MPIR_LIBRARY}
        -DMPIRXX_LIBRARY=${MPIRXX_LIBRARY}
        -DFFTW3f_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3f_LIBRARIES=${FFTW3F_LIBRARIES}
        -DUHD_INCLUDE_DIRS=${UHD_INCLUDE_DIRS}
        -DUHD_LIBRARIES=${UHD_LIBRARIES}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DENABLE_PYTHON=OFF #FIXME, master looks for GrSWIG.cmake, we we cant python yet
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON3_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON3_LIBRARY}
        -DGR_PYTHON_DIR=${PYTHON3_INSTALL_DIR}
        -DENABLE_RFSPACE=OFF
        -DENABLE_REDPITAYA=ON
    LICENSE_FILES COPYING
)

############################################################
## Build GQRX
############################################################
MyExternalProject_Add(GQRX
    DEPENDS GNURadio GrOsmoSDR Qt5
    GIT_REPOSITORY https://github.com/csete/gqrx.git
    GIT_TAG ${GQRX_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/log4cpp.lib
        -DMPIR_INCLUDE_DIR=${MPIR_INCLUDE_DIR}
        -DMPIR_LIBRARY=${MPIR_LIBRARY}
        -DMPIRXX_LIBRARY=${MPIRXX_LIBRARY}
        -DFFTW3f_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3f_LIBRARIES=${FFTW3F_LIBRARIES}
        -DPORTAUDIO_INCLUDE_DIRS=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARIES=${PORTAUDIO_LIBRARY}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DCMAKE_PREFIX_PATH=${QT5_ROOT}
    LICENSE_FILES COPYING
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gqrx" "GQRX SDR")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gqrx")

############################################################
## Build GrSDRPlay3
############################################################
if (EXISTS "${SDRPLAY_API_DIR}")
MyExternalProject_Add(GrSDRPlay3
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/fventuri/gr-sdrplay3.git
    GIT_TAG ${GRSDRPLAY3}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/log4cpp.lib
        -DMPIR_INCLUDE_DIR=${MPIR_INCLUDE_DIR}
        -DMPIR_LIBRARY=${MPIR_LIBRARY}
        -DMPIRXX_LIBRARY=${MPIRXX_LIBRARY}
        -DFFTW3f_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3f_LIBRARIES=${FFTW3F_LIBRARIES}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
    LICENSE_FILES COPYING LICENSE
)

else ()
    message(STATUS "!Skipping GrSDRPlay3 - sdrplay_api not found")
endif ()
