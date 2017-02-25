############################################################
## Pothos SDR environment build sub-script
##
## This script installs pre-built DLLs into the dest,
## and sets dependency variables for the build scripts
##
## * zadig (prebuilt executable)
## * boost (prebuilt runtime dlls)
## * qt5 (prebuilt runtime dlls)
## * fx3 (prebuilt static libs)
## * swig (prebuilt generator)
## * fftw (prebuilt runtime dlls)
############################################################

############################################################
## Zadig for USB devices
############################################################
set(ZADIG_NAME "zadig_2.2.exe")

if (NOT EXISTS "${CMAKE_BINARY_DIR}/${ZADIG_NAME}")
    message(STATUS "Downloading zadig...")
    file(DOWNLOAD
        "http://zadig.akeo.ie/downloads/${ZADIG_NAME}"
        ${CMAKE_BINARY_DIR}/${ZADIG_NAME}
    )
    message(STATUS "...done")
endif ()

install(FILES "${CMAKE_BINARY_DIR}/${ZADIG_NAME}" DESTINATION bin)

list(APPEND CPACK_PACKAGE_EXECUTABLES "zadig_2.2" "Zadig v2.2")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "zadig_2.2")

############################################################
## Boost dependency (prebuilt)
############################################################
set(BOOST_ROOT C:/local/boost_1_63_0)
set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-${MSVC_VERSION_XX}.0)
set(BOOST_DLL_SUFFIX vc${MSVC_VERSION_XX}0-mt-1_63.dll)

message(STATUS "BOOST_ROOT: ${BOOST_ROOT}")
message(STATUS "BOOST_LIBRARYDIR: ${BOOST_LIBRARYDIR}")
message(STATUS "BOOST_DLL_SUFFIX: ${BOOST_DLL_SUFFIX}")

install(FILES
    "${BOOST_LIBRARYDIR}/boost_thread-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_system-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_date_time-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_chrono-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_serialization-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_regex-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_filesystem-${BOOST_DLL_SUFFIX}"
    "${BOOST_LIBRARYDIR}/boost_program_options-${BOOST_DLL_SUFFIX}"
    DESTINATION bin
)

install(FILES ${BOOST_ROOT}/LICENSE_1_0.txt DESTINATION licenses/Boost)

############################################################
## Qt5 (prebuilt)
############################################################
set(QT5_ROOT C:/Qt/Qt5.7.1-vc${MSVC_VERSION_XX})
set(QT5_LIB_PATH ${QT5_ROOT}/5.7/msvc${MSVC_VERSION_YEAR}_64)

message(STATUS "QT5_ROOT: ${QT5_ROOT}")
message(STATUS "QT5_LIB_PATH: ${QT5_LIB_PATH}")

file(GLOB QT5_ICU_DLLS "${QT5_LIB_PATH}/bin/icu*.dll")

install(FILES
    ${QT5_ICU_DLLS}
    "${QT5_LIB_PATH}/bin/libGLESv2.dll"
    "${QT5_LIB_PATH}/bin/libEGL.dll"
    "${QT5_LIB_PATH}/bin/Qt5Core.dll"
    "${QT5_LIB_PATH}/bin/Qt5Gui.dll"
    "${QT5_LIB_PATH}/bin/Qt5Widgets.dll"
    "${QT5_LIB_PATH}/bin/Qt5Concurrent.dll"
    "${QT5_LIB_PATH}/bin/Qt5OpenGL.dll"
    "${QT5_LIB_PATH}/bin/Qt5Svg.dll"
    "${QT5_LIB_PATH}/bin/Qt5PrintSupport.dll"
    "${QT5_LIB_PATH}/bin/Qt5Network.dll"
    DESTINATION bin
)

install(FILES "${QT5_LIB_PATH}/plugins/platforms/qwindows.dll" DESTINATION bin/platforms)
install(FILES "${QT5_LIB_PATH}/plugins/iconengines/qsvgicon.dll" DESTINATION bin/iconengines)

install(DIRECTORY ${QT5_ROOT}/Licenses/ DESTINATION licenses/Qt)

############################################################
## Cypress API (prebuilt)
############################################################
set(FX3_SDK_PATH "C:/local/EZ-USB FX3 SDK/1.3")

if (EXISTS ${FX3_SDK_PATH})
    message(STATUS "FX3_SDK_PATH: ${FX3_SDK_PATH}")
    set(FX3_SDK_FOUND TRUE)
else()
    set(FX3_SDK_FOUND FALSE)
endif()

#nothing to install, this is a static

############################################################
## SWIG dependency (prebuilt)
############################################################
set(SWIG_ROOT C:/local/swigwin-3.0.12)
set(SWIG_EXECUTABLE ${SWIG_ROOT}/swig.exe)
set(SWIG_DIR ${SWIG_ROOT}/Lib)

message(STATUS "SWIG_ROOT: ${SWIG_ROOT}")

############################################################
## FFTW (prebuilt)
############################################################
set(FFTW3F_ROOT C:/local/fftw-3.3.5-dll64)
set(FFTW3F_INCLUDE_DIRS ${FFTW3F_ROOT})
set(FFTW3F_LIBRARIES ${FFTW3F_ROOT}/libfftw3f-3.lib)

message(STATUS "FFTW3F_ROOT: ${FFTW3F_ROOT}")

install(FILES "${FFTW3F_ROOT}/libfftw3f-3.dll" DESTINATION bin)

if (NOT EXISTS ${FFTW3F_LIBRARIES})
    message(STATUS "Generating ${FFTW3F_LIBRARIES}...")
    get_filename_component(VC_BIN_DIR "${CMAKE_CXX_COMPILER}" DIRECTORY)
    find_program(VCVARS_BAT "vcvarsx86_amd64.bat" HINTS "${VC_BIN_DIR}")
    if (NOT VCVARS_BAT)
        message(FATAL_ERROR "Cant find vcvars script")
    endif()
    message(STATUS "VCVARS_BAT: ${VCVARS_BAT}")
    set(GEN_FFTW3F_LIB_BAT "${CMAKE_BINARY_DIR}/gen_fftw3f_lib.bat")
    file(WRITE "${GEN_FFTW3F_LIB_BAT}" "call \"${VCVARS_BAT}\"\n")
    file(APPEND "${GEN_FFTW3F_LIB_BAT}" "lib /machine:x64 /def:libfftw3f-3.def\n")
    file(APPEND "${GEN_FFTW3F_LIB_BAT}" "exit /b %ERRORLEVEL%\n")
    message(STATUS "Executing ${GEN_FFTW3F_LIB_BAT}")
    execute_process(COMMAND "${GEN_FFTW3F_LIB_BAT}"
        WORKING_DIRECTORY ${FFTW3F_ROOT}
        RESULT_VARIABLE GEN_FFTW3F_LIB_RESULT
        OUTPUT_VARIABLE GEN_FFTW3F_LIB_OUTPUT
        ERROR_VARIABLE GEN_FFTW3F_LIB_OUTPUT)
    if (NOT "${GEN_FFTW3F_LIB_RESULT}" STREQUAL "0")
        message(FATAL_ERROR "${GEN_FFTW3F_LIB_RESULT}: ${GEN_FFTW3F_LIB_OUTPUT}")
    endif()
    message(STATUS "Done")
endif ()

install(FILES
    "${FFTW3F_ROOT}/COPYING"
    "${FFTW3F_ROOT}/COPYRIGHT"
    DESTINATION licenses/fftw
)
