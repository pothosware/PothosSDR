############################################################
## Pothos SDR environment build sub-script
##
## This script installs pre-built DLLs into the dest,
## and sets dependency variables for the build scripts
##
## * zadig (prebuilt executable)
## * boost (prebuilt runtime dlls)
## * pthreads (prebuilt runtime dlls)
## * portaudio (prebuilt runtime dlls)
## * libusb (prebuilt runtime dlls)
## * swig (prebuilt generator)
## * qt5 (prebuilt runtime dlls)
## * fftw (prebuilt runtime dlls)
## * wxgui (prebuilt runtime dlls)
############################################################

############################################################
## Zadig for USB devices
############################################################
set(ZADIG_NAME "zadig_2.1.2.exe")

if (NOT EXISTS "${CMAKE_BINARY_DIR}/${ZADIG_NAME}")
    message(STATUS "Downloading zadig...")
    file(DOWNLOAD
        "http://zadig.akeo.ie/downloads/${ZADIG_NAME}"
        ${CMAKE_BINARY_DIR}/${ZADIG_NAME}
    )
    message(STATUS "...done")
endif ()

install(FILES "${CMAKE_BINARY_DIR}/${ZADIG_NAME}" DESTINATION bin)

list(APPEND CPACK_PACKAGE_EXECUTABLES "zadig_2.1.2" "Zadig v2.1.2")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "zadig_2.1.2")

############################################################
## Boost dependency (prebuilt)
############################################################
set(BOOST_ROOT C:/local/boost_1_60_0)

if (MSVC14)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-14.0)
    set(BOOST_DLL_SUFFIX vc140-mt-1_60.dll)
endif ()

if (MSVC12)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-12.0)
    set(BOOST_DLL_SUFFIX vc120-mt-1_60.dll)
endif ()

message(STATUS "BOOST_ROOT: ${BOOST_ROOT}")
message(STATUS "BOOST_LIBRARYDIR: ${BOOST_LIBRARYDIR}")

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

############################################################
## Pthreads (prebuilt)
############################################################
set(THREADS_PTHREADS_ROOT C:/local/pthreads-w32-2.9.1)
set(THREADS_PTHREADS_INCLUDE_DIR ${THREADS_PTHREADS_ROOT}/include)
set(THREADS_PTHREADS_WIN32_LIBRARY ${THREADS_PTHREADS_ROOT}/lib/x64/pthreadVC2.lib)

message(STATUS "THREADS_PTHREADS_ROOT: ${THREADS_PTHREADS_ROOT}")

install(FILES "${THREADS_PTHREADS_ROOT}/dll/x64/pthreadVC2.dll" DESTINATION bin)

install(FILES
    "${THREADS_PTHREADS_ROOT}/COPYING"
    "${THREADS_PTHREADS_ROOT}/COPYING.lib"
    DESTINATION licenses/pthreads
)

############################################################
## PortAudio dependency (prebuilt)
############################################################
set(PORTAUDIO_ROOT C:/local/portaudio-r1891-build)
set(PORTAUDIO_INCLUDE_DIR ${PORTAUDIO_ROOT}/include)
set(PORTAUDIO_LIBRARY ${PORTAUDIO_ROOT}/lib/x64/Release/portaudio_x64.lib)

message(STATUS "PORTAUDIO_ROOT: ${PORTAUDIO_ROOT}")

install(FILES "${PORTAUDIO_ROOT}/lib/x64/Release/portaudio_x64.dll" DESTINATION bin)

############################################################
## Qt5 (prebuilt)
############################################################
if (MSVC14)
    set(QT5_DLL_ROOT C:/Qt/Qt5.6.0/5.6/msvc2015_64)
endif ()

if (MSVC12)
    set(QT5_DLL_ROOT C:/Qt/Qt5.6.0/5.6/msvc2013_64)
endif ()

message(STATUS "QT5_DLL_ROOT: ${QT5_DLL_ROOT}")

file(GLOB QT5_ICU_DLLS "${QT5_DLL_ROOT}/bin/icu*.dll")

install(FILES
    ${QT5_ICU_DLLS}
    "${QT5_DLL_ROOT}/bin/libGLESv2.dll"
    "${QT5_DLL_ROOT}/bin/libEGL.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Core.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Gui.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Widgets.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Concurrent.dll"
    "${QT5_DLL_ROOT}/bin/Qt5OpenGL.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Svg.dll"
    "${QT5_DLL_ROOT}/bin/Qt5PrintSupport.dll"
    "${QT5_DLL_ROOT}/bin/Qt5Network.dll"
    DESTINATION bin
)

install(FILES "${QT5_DLL_ROOT}/plugins/platforms/qwindows.dll" DESTINATION bin/platforms)
install(FILES "${QT5_DLL_ROOT}/plugins/iconengines/qsvgicon.dll" DESTINATION bin/iconengines)

############################################################
## LibUSB dependency (prebuilt)
############################################################
set(LIBUSB_ROOT C:/local/libusb-1.0.20)
set(LIBUSB_INCLUDE_DIR ${LIBUSB_ROOT}/include/libusb-1.0)
set(LIBUSB_LIBRARIES ${LIBUSB_ROOT}/MS64/dll/libusb-1.0.lib)

message(STATUS "LIBUSB_ROOT: ${LIBUSB_ROOT}")

install(FILES "${LIBUSB_ROOT}/MS64/dll/libusb-1.0.dll" DESTINATION bin)

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
set(SWIG_ROOT C:/local/swigwin-3.0.8)
set(SWIG_EXECUTABLE ${SWIG_ROOT}/swig.exe)
set(SWIG_DIR ${SWIG_ROOT}/Lib)

message(STATUS "SWIG_ROOT: ${SWIG_ROOT}")

############################################################
## FFTW (prebuilt)
############################################################
set(FFTW3F_ROOT C:/local/fftw-3.3.4-dll64)
set(FFTW3F_INCLUDE_DIRS ${FFTW3F_ROOT})
set(FFTW3F_LIBRARIES ${FFTW3F_ROOT}/libfftw3f-3.lib)

message(STATUS "FFTW3F_ROOT: ${FFTW3F_ROOT}")

install(FILES "${FFTW3F_ROOT}/libfftw3f-3.dll" DESTINATION bin)

#TODO
#cd "${FFTW3F_ROOT}"
#lib /machine:x64 /def:libfftw3f-3.def

install(FILES
    "${FFTW3F_ROOT}/COPYING"
    "${FFTW3F_ROOT}/COPYRIGHT"
    DESTINATION licenses/fftw
)

############################################################
## wxWidgets (prebuilt)
############################################################
set(wxWidgets_ROOT_DIR C:/local/wxWidgets-3.1.0)

if (MSVC14)
    set(wxWidgets_LIB_DIR ${wxWidgets_ROOT_DIR}/lib/vc140_x64_lib)
endif ()

if (MSVC12)
    set(wxWidgets_LIB_DIR ${wxWidgets_ROOT_DIR}/lib/vc120_x64_lib)
endif ()

message(STATUS "wxWidgets_ROOT_DIR: ${wxWidgets_ROOT_DIR}")
message(STATUS "wxWidgets_LIB_DIR: ${wxWidgets_LIB_DIR}")

if (WX_USES_DLL)
    file(GLOB WX_MSW_DLLS "${wxWidgets_LIB_DIR}/wxmsw310u_*.dll")
    file(GLOB WX_BASE_DLLS "${wxWidgets_LIB_DIR}/wxbase310u_*.dll")
    install(FILES ${WX_MSW_DLLS} ${WX_BASE_DLLS} DESTINATION bin)
endif()
