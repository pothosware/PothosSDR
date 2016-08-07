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
############################################################

set(VOLK_BRANCH maint)
set(GNURADIO_BRANCH v3.7.10)
set(GR_RUNTIME_BRANCH master)
set(GR_POTHOS_BRANCH master)
set(GROSMOSDR_BRANCH master)
set(GRRDS_BRANCH master)
set(GQRX_BRANCH master)
set(GRDRM_BRANCH master)

############################################################
## Build Volk
############################################################
message(STATUS "Configuring volk - ${VOLK_BRANCH}")
ExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/volk_disable_warnings.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_prefetch_compat_macro.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DVOLK_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(volk SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/volk
)

############################################################
## Build GNU Radio
############################################################
message(STATUS "Configuring GNURadio - ${GNURADIO_BRANCH}")
ExternalProject_Add(GNURadio
    DEPENDS volk uhd CppZMQ PortAudio CppUnit
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
       ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_public_defs.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_pfb_clock_sync_fff.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_portaudio_add_io_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_dllr_factor.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_ldpc_config_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_ifdef_unistd_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_paths_return_fix.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_config_msvc_rand48.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DENABLE_INTERNAL_VOLK=OFF
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON2_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON2_LIBRARY}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DFFTW3F_INCLUDE_DIRS=${FFTW3F_INCLUDE_DIRS}
        -DFFTW3F_LIBRARIES=${FFTW3F_LIBRARIES}
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
        -DENABLE_TESTING=ON
        -DCPPUNIT_INCLUDE_DIRS=${CPPUNIT_INCLUDE_DIRS}
        -DCPPUNIT_LIBRARIES=${CPPUNIT_LIBRARIES}
        -DENABLE_PYTHON=ON
        -DPORTAUDIO_INCLUDE_DIRS=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARIES=${PORTAUDIO_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GNURadio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GNURadio
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\grc\\\\blocks\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\"
")

########################################################################
## gnuradio-companion.exe
########################################################################
set(GNURADIO_COMPANION_EXE_BRANCH master)
message(STATUS "Configuring GnuradioCompanionExe - ${GNURADIO_COMPANION_EXE_BRANCH}")
ExternalProject_Add(GnuradioCompanionExe
    GIT_REPOSITORY https://github.com/pothosware/gnuradio-companion-exe.git
    GIT_TAG ${GNURADIO_COMPANION_EXE_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gnuradio-companion" "GNURadio Companion")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gnuradio-companion")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_CLASSES_ROOT \\\".grc\\\" \\\"\\\" \\\"GNURadio.Companion\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\DefaultIcon\\\" \\\"\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\icons\\\\grc-icon-256.ico\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\Shell\\\\Open\\\\command\\\" \\\"\\\" \\\"${NEQ}$INSTDIR\\\\bin\\\\gnuradio-companion.exe${NEQ} ${NEQ}%1${NEQ} %*\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegKey HKEY_CLASSES_ROOT \\\".grc\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\"
")

############################################################
## GR runtime
############################################################
message(STATUS "Configuring gr-runtime - ${GR_RUNTIME_BRANCH}")
ExternalProject_Add(GrRuntime
    DEPENDS GNURadio Pothos
    GIT_REPOSITORY https://github.com/pothosware/gr-runtime.git
    GIT_TAG ${GR_RUNTIME_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrRuntime SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrRuntime
)

############################################################
## GR Pothos bindings
############################################################
message(STATUS "Configuring gr-pothos - ${GR_POTHOS_BRANCH}")
ExternalProject_Add(GrPothos
    DEPENDS GNURadio Pothos
    GIT_REPOSITORY https://github.com/pothosware/gr-pothos.git
    GIT_TAG ${GR_POTHOS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrPothos SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrPothos
)

############################################################
## Build GrOsmoSDR
##
## * ENABLE_RFSPACE=OFF build errors
############################################################
message(STATUS "Configuring GrOsmoSDR - ${GROSMOSDR_BRANCH}")
ExternalProject_Add(GrOsmoSDR
    DEPENDS GNURadio SoapySDR bladeRF uhd hackRF rtl-sdr osmo-sdr miri-sdr airspy
    GIT_REPOSITORY git://git.osmocom.org/gr-osmosdr
    GIT_TAG ${GROSMOSDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DUHD_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
        -DUHD_LIBRARIES=${CMAKE_INSTALL_PREFIX}/lib/uhd.lib
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DSWIG_EXECUTABLE=${SWIG_EXECUTABLE}
        -DSWIG_DIR=${SWIG_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DGR_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
        -DENABLE_RFSPACE=OFF
        -DENABLE_REDPITAYA=ON
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrOsmoSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrOsmoSDR
)

############################################################
## Build gr-rds
############################################################
message(STATUS "Configuring GrRDS - ${GRRDS_BRANCH}")
ExternalProject_Add(GrRDS
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/bastibl/gr-rds.git
    GIT_TAG ${GRRDS_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gr_rds_msvc_fixes.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
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
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrRDS SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GrRDS
)

############################################################
## Build GQRX
############################################################
message(STATUS "Configuring GQRX - ${GQRX_BRANCH}")
ExternalProject_Add(GQRX
    DEPENDS GNURadio GrOsmoSDR
    GIT_REPOSITORY https://github.com/csete/gqrx.git
    GIT_TAG ${GQRX_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GQRX SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/GQRX
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gqrx" "GQRX SDR")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gqrx")

############################################################
## Build gr-drm
############################################################
message(STATUS "Configuring GrDRM - ${GRDRM_BRANCH}")
ExternalProject_Add(GrDRM
    DEPENDS GNURadio faac faad2
    GIT_REPOSITORY https://github.com/kit-cel/gr-drm.git
    GIT_TAG ${GRDRM_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gr_drm_msvc_fixes.diff
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/gr-drm
        -G ${CMAKE_GENERATOR}
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
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(GrDRM SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING.txt
    DESTINATION licenses/GrDRM
)
