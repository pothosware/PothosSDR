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
install(FILES "C:/zadig_2.1.1.exe" DESTINATION ".")

############################################################
## Boost dependency (prebuilt)
############################################################
set(BOOST_ROOT C:/local/boost_1_57_0)
set(BOOST_LIBRARY_DIR ${BOOST_ROOT}/lib64-msvc-11.0)

install(FILES
    "${BOOST_LIBRARY_DIR}/boost_thread-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_system-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_date_time-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_chrono-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_serialization-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_regex-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_filesystem-vc110-mt-1_57.dll"
    "${BOOST_LIBRARY_DIR}/boost_program_options-vc110-mt-1_57.dll"
    DESTINATION bin
)

############################################################
## Pthreads (prebuilt)
############################################################
set(THREADS_PTHREADS_ROOT C:/pthreads)
set(THREADS_PTHREADS_INCLUDE_DIR ${THREADS_PTHREADS_ROOT}/include)
set(THREADS_PTHREADS_WIN32_LIBRARY ${THREADS_PTHREADS_ROOT}/lib/x64/pthreadVC2.lib)

install(FILES "C:/pthreads/dll/x64/pthreadVC2.dll" DESTINATION bin)

install(FILES
    "${THREADS_PTHREADS_ROOT}/COPYING"
    "${THREADS_PTHREADS_ROOT}/COPYING.lib"
    DESTINATION licenses/pthreads
)

############################################################
## PortAudio dependency (prebuilt)
############################################################
set(PORTAUDIO_INCLUDE_DIR C:/portaudio-r1891-build/include)
set(PORTAUDIO_LIBRARY C:/portaudio-r1891-build/lib/x64/Release/portaudio_x64.lib)

install(FILES "C:/portaudio-r1891-build/lib/x64/Release/portaudio_x64.dll" DESTINATION bin)

############################################################
## Qt5 (prebuilt)
############################################################
set(QT5_DLL_ROOT C:/Qt/Qt5.2.1/5.2.1/msvc2012_64)

install(FILES
    "${QT5_DLL_ROOT}/bin/libGLESv2.dll"
    "${QT5_DLL_ROOT}/bin/libEGL.dll"
    "${QT5_DLL_ROOT}/bin/icudt51.dll"
    "${QT5_DLL_ROOT}/bin/icuin51.dll"
    "${QT5_DLL_ROOT}/bin/icuuc51.dll"
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
set(LIBUSB_ROOT C:/libusb-1.0.19)
set(LIBUSB_INCLUDE_DIR ${LIBUSB_ROOT}/include/libusb-1.0)
set(LIBUSB_LIBRARIES ${LIBUSB_ROOT}/MS64/dll/libusb-1.0.lib)

install(FILES "${LIBUSB_ROOT}/MS64/dll/libusb-1.0.dll" DESTINATION bin)

############################################################
## SWIG dependency (prebuilt)
############################################################
set(SWIG_EXECUTABLE C:/swigwin-3.0.5/swig.exe)
set(SWIG_DIR C:/swigwin-3.0.5/Lib)

############################################################
## FFTW (prebuilt)
############################################################
set(FFTW3F_ROOT C:/fftw-3.3.4-dll64)
set(FFTW3F_INCLUDE_DIRS ${FFTW3F_ROOT})
set(FFTW3F_LIBRARIES ${FFTW3F_ROOT}/libfftw3f-3.lib)

install(FILES "${FFTW3F_ROOT}/libfftw3f-3.dll" DESTINATION bin)

#TODO
#cd "${FFTW3F_ROOT}"
#lib /machine:x64 /def:libfftw3f-3.def

install(FILES
    "${FFTW3F_ROOT}/COPYING"
    "${FFTW3F_ROOT}/COPYRIGHT"
    DESTINATION licenses/fftw
)
