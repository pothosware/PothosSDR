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

install(FILES "${CMAKE_BINARY_DIR}/${ZADIG_NAME}" DESTINATION ".")

############################################################
## Boost dependency (prebuilt)
############################################################
set(BOOST_ROOT C:/local/boost_1_59_0)

if (MSVC14)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-14.0)
    set(BOOST_DLL_SUFFIX vc140-mt-1_59.dll)
endif ()

if (MSVC12)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-12.0)
    set(BOOST_DLL_SUFFIX vc120-mt-1_59.dll)
endif ()

if (MSVC11)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib64-msvc-11.0)
    set(BOOST_DLL_SUFFIX vc110-mt-1_59.dll)
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
set(THREADS_PTHREADS_ROOT C:/pthreads)
set(THREADS_PTHREADS_INCLUDE_DIR ${THREADS_PTHREADS_ROOT}/include)
set(THREADS_PTHREADS_WIN32_LIBRARY ${THREADS_PTHREADS_ROOT}/lib/x64/pthreadVC2.lib)

message(STATUS "THREADS_PTHREADS_ROOT: ${THREADS_PTHREADS_ROOT}")

install(FILES "C:/pthreads/dll/x64/pthreadVC2.dll" DESTINATION bin)

install(FILES
    "${THREADS_PTHREADS_ROOT}/COPYING"
    "${THREADS_PTHREADS_ROOT}/COPYING.lib"
    DESTINATION licenses/pthreads
)

############################################################
## PortAudio dependency (prebuilt)
############################################################
set(PORTAUDIO_ROOT C:/portaudio-r1891-build)
set(PORTAUDIO_INCLUDE_DIR ${PORTAUDIO_ROOT}/include)
set(PORTAUDIO_LIBRARY ${PORTAUDIO_ROOT}/lib/x64/Release/portaudio_x64.lib)

message(STATUS "PORTAUDIO_ROOT: ${PORTAUDIO_ROOT}")

install(FILES "${PORTAUDIO_ROOT}/lib/x64/Release/portaudio_x64.dll" DESTINATION bin)

############################################################
## Qt5 (prebuilt)
############################################################
if (MSVC12)
    set(QT5_DLL_ROOT C:/Qt/Qt5.5.1/5.5/msvc2013_64)
endif ()

if (MSVC11)
    set(QT5_DLL_ROOT C:/Qt/Qt5.2.1/5.2.1/msvc2012_64)
endif()

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
    DESTINATION bin
)

install(FILES "${QT5_DLL_ROOT}/plugins/platforms/qwindows.dll" DESTINATION bin/platforms)

############################################################
## LibUSB dependency (prebuilt)
############################################################
set(LIBUSB_ROOT C:/libusb-1.0.20)
set(LIBUSB_INCLUDE_DIR ${LIBUSB_ROOT}/include/libusb-1.0)
set(LIBUSB_LIBRARIES ${LIBUSB_ROOT}/MS64/dll/libusb-1.0.lib)

message(STATUS "LIBUSB_ROOT: ${LIBUSB_ROOT}")

install(FILES "${LIBUSB_ROOT}/MS64/dll/libusb-1.0.dll" DESTINATION bin)

############################################################
## SWIG dependency (prebuilt)
############################################################
set(SWIG_ROOT C:/swigwin-3.0.7)
set(SWIG_EXECUTABLE ${SWIG_ROOT}/swig.exe)
set(SWIG_DIR ${SWIG_ROOT}/Lib)

message(STATUS "SWIG_ROOT: ${SWIG_ROOT}")

############################################################
## FFTW (prebuilt)
############################################################
set(FFTW3F_ROOT C:/fftw-3.3.4-dll64)
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
