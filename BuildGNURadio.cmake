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
############################################################

set(VOLK_BRANCH v1.2)
set(GNURADIO_BRANCH v3.7.9)
set(GR_RUNTIME_BRANCH gr-runtime-v3.7.9)
set(GR_POTHOS_BRANCH master)
set(GROSMOSDR_BRANCH master)
set(GRRDS_BRANCH master)
set(GQRX_BRANCH v2.5.3)

############################################################
## Build Volk
############################################################
message(STATUS "Configuring volk - ${VOLK_BRANCH}")
ExternalProject_Add(volk
    GIT_REPOSITORY https://github.com/gnuradio/volk.git
    GIT_TAG ${VOLK_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/volk_cpuid_count_for_msvc.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_fix_msvc14.diff
        ${PROJECT_SOURCE_DIR}/patches/volk_qa_utils_config_h.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
        -DBOOST_ALL_DYN_LINK=TRUE
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
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
    DEPENDS volk uhd CppZMQ
    GIT_REPOSITORY https://github.com/gnuradio/gnuradio.git
    GIT_TAG ${GNURADIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_use_swig.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_use_alloca.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_public_defs.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_codec2_fdmdv_round.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_pfb_clock_sync_fff.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_filter_truncation.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_portaudio_add_io_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_udp_source_linger.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_config_msvc_math.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fix_msvc14.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_dllr_factor.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_dtv_use_gr_aligned.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_fec_ldpc_config_h.diff
        ${PROJECT_SOURCE_DIR}/patches/gnuradio_grc_windows_paths.diff
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
        -DENABLE_TESTING=OFF
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

install(FILES icons/grc-icon-256.ico DESTINATION share/gnuradio/icons)

list(APPEND CPACK_PACKAGE_EXECUTABLES "gnuradio-companion" "GNURadio Companion")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "gnuradio-companion")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\grc\\\\blocks\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\".grc\\\" \\\"\\\" \\\"GNURadio.Companion\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\DefaultIcon\\\" \\\"\\\" \\\"$INSTDIR\\\\share\\\\gnuradio\\\\icons\\\\grc-icon-256.ico\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\\Shell\\\\Open\\\\command\\\" \\\"\\\" \\\"${NEQ}$INSTDIR\\\\bin\\\\gnuradio-companion.exe${NEQ} ${NEQ}%1${NEQ} %*\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"GRC_BLOCKS_PATH\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\".grc\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\"GNURadio.Companion\\\"
")

########################################################################
## gnuradio-companion.exe
########################################################################
get_filename_component(PYTHON2_INSTALL ${PYTHON2_EXECUTABLE} DIRECTORY)
set(PYINSTALLER_EXECUTABLE ${PYTHON2_INSTALL}/Scripts/pyinstaller.exe)
set(GNURADIO_COMPANION_EXE ${CMAKE_BINARY_DIR}/dist/gnuradio-companion.exe)

if (EXISTS ${PYINSTALLER_EXECUTABLE})
    add_custom_command(
        OUTPUT ${GNURADIO_COMPANION_EXE}
        DEPENDS
            ${CMAKE_SOURCE_DIR}/icons/grc-icon-256.ico
            ${CMAKE_SOURCE_DIR}/Scripts/gnuradio-companion.py
        COMMAND ${PYINSTALLER_EXECUTABLE} --onefile
            --icon=${CMAKE_SOURCE_DIR}/icons/grc-icon-256.ico
            ${CMAKE_SOURCE_DIR}/Scripts/gnuradio-companion.py
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

    add_custom_target(grc_exe ALL DEPENDS ${GNURADIO_COMPANION_EXE})

    install(FILES ${GNURADIO_COMPANION_EXE} DESTINATION bin)
else ()
    message(WARNING "Skipping GRC executable -- missing ${PYINSTALLER_EXECUTABLE}")
endif ()

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
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
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
