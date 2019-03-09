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
## * liquiddsp (prebuilt runtime dlls)
## * winflexbison (generator exes)
############################################################

############################################################
## Zadig for USB devices
############################################################
set(ZADIG_NAME "zadig-2.4.exe")

if (NOT EXISTS "${CMAKE_BINARY_DIR}/${ZADIG_NAME}")
    message(STATUS "Downloading zadig...")
    file(DOWNLOAD
        "https://github.com/pbatard/libwdi/releases/download/b721/zadig-2.4.exe"
        ${CMAKE_BINARY_DIR}/${ZADIG_NAME}
    )
    message(STATUS "...done")
endif ()

install(FILES "${CMAKE_BINARY_DIR}/${ZADIG_NAME}" DESTINATION bin)

list(APPEND CPACK_PACKAGE_EXECUTABLES "zadig-2.4" "Zadig v2.4")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "zadig-2.4")

############################################################
## Boost dependency (prebuilt)
############################################################
set(BOOST_ROOT C:/local/boost_1_67_0)
set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-${MSVC_VERSION_MAJOR}.${MSVC_VERSION_MINOR})
set(BOOST_DLL_SUFFIX vc${MSVC_VERSION_MAJOR}${MSVC_VERSION_MINOR}-mt-x64-1_67.dll)

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
set(QT5_ROOT C:/Qt/Qt5.8.0)
#support VC-specific suffix for multiple installs to coexist
if (EXISTS ${QT5_ROOT}-vc${MSVC_VERSION_MAJOR})
    set(QT5_ROOT ${QT5_ROOT}-vc${MSVC_VERSION_MAJOR})
endif()
set(QT5_LIB_PATH ${QT5_ROOT}/5.8/msvc${MSVC_VERSION_YEAR}_64)

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
    message(STATUS "!FX3 SDK not found (${FX3_SDK_PATH})")
    set(FX3_SDK_FOUND FALSE)
endif()

#nothing to install, this is a static

############################################################
## SWIG dependency (prebuilt)
############################################################
MyExternalProject_Add(swig
    URL https://downloads.sourceforge.net/project/swig/swigwin/swigwin-3.0.12/swigwin-3.0.12.zip
    URL_MD5 a49524dad2c91ae1920974e7062bfc93
    CONFIGURE_COMMAND echo "..."
    BUILD_COMMAND echo "..."
    INSTALL_COMMAND echo "..."
    LICENSE_FILES LICENSE LICENSE-GPL COPYRIGHT
)

ExternalProject_Get_Property(swig SOURCE_DIR)
set(SWIG_EXECUTABLE ${SOURCE_DIR}/swig.exe)
set(SWIG_DIR ${SOURCE_DIR}/Lib)

############################################################
## FFTW (prebuilt)
############################################################
MyExternalProject_Add(fftw
    URL ftp://ftp.fftw.org/pub/fftw/fftw-3.3.5-dll64.zip
    URL_MD5 cb3c5ad19a89864f036e7a2dd5be168c
    CONFIGURE_COMMAND echo "..."
    BUILD_COMMAND lib /machine:x64 /def:libfftw3f-3.def
    BUILD_IN_SOURCE TRUE
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING COPYRIGHT
)

ExternalProject_Get_Property(fftw SOURCE_DIR)
set(FFTW3F_INCLUDE_DIRS ${SOURCE_DIR})
set(FFTW3F_LIBRARIES ${SOURCE_DIR}/libfftw3f-3.lib)
install(FILES "${SOURCE_DIR}/libfftw3f-3.dll" DESTINATION bin)

############################################################
## LiquidDSP (prebuilt)
##
## external directory in CubicSDR (thanks!)
############################################################
MyExternalProject_Add(liquiddsp
    GIT_REPOSITORY https://github.com/cjcliffe/CubicSDR.git
    CONFIGURE_COMMAND echo "Configure liquiddsp..."
    BUILD_COMMAND echo "..."
    INSTALL_COMMAND echo "..."
    LICENSE_FILES external/liquid-dsp/COPYING
)

ExternalProject_Get_Property(liquiddsp SOURCE_DIR)
set(SOURCE_DIR "${SOURCE_DIR}/external/liquid-dsp")

#use these variable to setup liquiddsp in dependent projects
set(LIQUIDDSP_INCLUDE_DIR ${SOURCE_DIR}/include)
set(LIQUIDDSP_LIBRARY ${SOURCE_DIR}/msvc/64/libliquid.lib)
set(LIQUIDDSP_DLL ${SOURCE_DIR}/msvc/64/libliquid.dll)

#external install commands, variables use build paths
install(FILES ${LIQUIDDSP_INCLUDE_DIR}/liquid/liquid.h DESTINATION include/liquid)
install(FILES ${LIQUIDDSP_LIBRARY} DESTINATION lib)
install(FILES ${LIQUIDDSP_DLL} DESTINATION bin)

############################################################
## Download winflexbison
############################################################
MyExternalProject_Add(winflexbison
    URL https://github.com/lexxmark/winflexbison/archive/v2.5.15.zip
    URL_MD5 cbc9d36d620c2cc7a4a2da32c4e96409
    CONFIGURE_COMMAND echo "..."
    BUILD_COMMAND echo "..."
    INSTALL_COMMAND echo "..."
    LICENSE_FILES README.md
)

ExternalProject_Get_Property(winflexbison SOURCE_DIR)
set(FLEX_EXECUTABLE "${SOURCE_DIR}/bin/Release/win_flex.exe")
set(BISON_EXECUTABLE "${SOURCE_DIR}/bin/Release/win_bison.exe")
