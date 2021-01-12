############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio and toolkit bindings
##
## * volk
## * gnuradio
## * gr-runtime (runtime + pothos support)
## * gr-pothos (toolkit bindings project)
## * gr-osmosdr
## * gr-rds
## * gqrx
## * gr-drm
## * gr-rftap
## * gr-nrsc5
## * gr-iio
## * gr-limesdr
############################################################

set(VOLK_BRANCH master)
set(GNURADIO_BRANCH master)
set(GR_POTHOS_BRANCH master)
set(GROSMOSDR_BRANCH master)
set(GRRDS_BRANCH maint-3.7)
set(GQRX_BRANCH master)
set(GRDRM_BRANCH master)
set(GRRFTAP_BRANCH master)
set(GRNRSC5_BRANCH 610d6d772390cee9afdeea07f7e7a79bd3460a57) #prior to 3.8 req
set(GRIIO_BRANCH master)
set(GRLIMESDR_BRANCH master)

############################################################
# python generation tools
# volk uses mako
# gnuradio uses pygccxml numpy PyQt5
# gr-pothos uses same python3 deps as PothosLiquidDSP
############################################################
execute_process(COMMAND ${PYTHON3_ROOT}/Scripts/pip.exe install mako pygccxml numpy PyQt5 OUTPUT_QUIET)

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
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/orocos
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/orocos-log4cpp.lib
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

########################################################################
## gnuradio-companion.exe
########################################################################
if (FALSE) #TODO
MyExternalProject_Add(GnuradioCompanionExe
    GIT_REPOSITORY https://github.com/pothosware/gnuradio-companion-exe.git
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES README.md
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gnuradio-companion" "GNURadio Companion")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gnuradio-companion")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_CLASSES_ROOT \\\".grc\\\" \\\"\\\" \\\"GNURadio.Companion\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\DefaultIcon\\\" \\\"\\\" \\\"$INSTDIR\\\\bin\\\\gnuradio-companion.exe\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\Shell\\\\Open\\\\command\\\" \\\"\\\" \\\"${NEQ}$INSTDIR\\\\bin\\\\gnuradio-companion.exe${NEQ} ${NEQ}%1${NEQ} %*\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegKey HKEY_CLASSES_ROOT \\\".grc\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\"
")

############################################################
## GR Pothos bindings
############################################################
MyExternalProject_Add(GrPothos
    DEPENDS GNURadio PothosCore
    GIT_REPOSITORY https://github.com/pothosware/gr-pothos.git
    GIT_TAG ${GR_POTHOS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
    LICENSE_FILES COPYING
)
endif()

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
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/orocos
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/orocos-log4cpp.lib
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
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON3_INSTALL_DIR}
        -DENABLE_RFSPACE=OFF
        -DENABLE_REDPITAYA=ON
    LICENSE_FILES COPYING
)

############################################################
## Build gr-rds
############################################################
if (FALSE) #TODO
MyExternalProject_Add(GrRDS
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/bastibl/gr-rds.git
    GIT_TAG ${GRRDS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
    LICENSE_FILES COPYING
)
endif()

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
        -DLOG4CPP_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include/orocos
        -DLOG4CPP_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/orocos-log4cpp.lib
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

#FIXME as we test
return()

############################################################
## Build gr-drm
############################################################
MyExternalProject_Add(GrDRM
    DEPENDS GNURadio faac faad2
    GIT_REPOSITORY https://github.com/kit-cel/gr-drm.git
    GIT_TAG ${GRDRM_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DFaac_INCLUDE_DIR=${Faac_INCLUDE_DIR}
        -DFaac_LIBRARY=${Faac_LIBRARY}
        -DCPPUNIT_INCLUDE_DIRS=${CPPUNIT_INCLUDE_DIRS}
        -DCPPUNIT_LIBRARIES=${CPPUNIT_LIBRARIES}
    LICENSE_FILES COPYING.txt
)

############################################################
## Build gr-RFtap
############################################################
MyExternalProject_Add(GrRFtap
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/rftap/gr-rftap.git
    GIT_TAG ${GRRFTAP_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DCPPUNIT_INCLUDE_DIRS=${CPPUNIT_INCLUDE_DIRS}
        -DCPPUNIT_LIBRARIES=${CPPUNIT_LIBRARIES}
    LICENSE_FILES MANIFEST.md
)

############################################################
## Build gr-NRSC5
############################################################
MyExternalProject_Add(GrNRSC5
    DEPENDS GNURadio fdk_aac
    GIT_REPOSITORY https://github.com/argilo/gr-nrsc5.git
    GIT_TAG ${GRNRSC5_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DCPPUNIT_INCLUDE_DIRS=${CPPUNIT_INCLUDE_DIRS}
        -DCPPUNIT_LIBRARIES=${CPPUNIT_LIBRARIES}
        -DFDK_AAC_INCLUDE_DIR=${FDK_AAC_INCLUDE_DIR}
        -DFDK_AAC_LIBRARY=${FDK_AAC_LIBRARY}
    LICENSE_FILES COPYING
)

############################################################
## Build gr-IIO
############################################################
MyExternalProject_Add(GrIIO
    DEPENDS GNURadio libad9361 winflexbison
    GIT_REPOSITORY https://github.com/analogdevicesinc/gr-iio.git
    GIT_TAG ${GRIIO_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DIIO_INCLUDE_DIRS=${LIBIIO_INCLUDE_DIR}
        -DIIO_LIBRARIES=${LIBIIO_LIBRARY}
        -DAD9361_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include/
        -DAD9361_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/libad9361.lib
        -DFLEX_EXECUTABLE=${FLEX_EXECUTABLE}
        -DBISON_EXECUTABLE=${BISON_EXECUTABLE}
    LICENSE_FILES COPYING
)

############################################################
## Build gr-limesdr
############################################################
MyExternalProject_Add(GrLimeSDR
    DEPENDS GNURadio LimeSuite
    GIT_REPOSITORY https://github.com/myriadrf/gr-limesdr.git
    GIT_TAG ${GRLIMESDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DLIMESUITE_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include/lime
        -DLIMESUITE_LIB=${CMAKE_INSTALL_PREFIX}/lib/LimeSuite.lib
    LICENSE_FILES LICENSE
)
