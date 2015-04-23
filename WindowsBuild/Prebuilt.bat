REM ############################################################
REM ## Pothos SDR environment build sub-script
REM ##
REM ## This script installs pre-built DLLs into the dest,
REM ## and sets dependency variables for the build scripts
REM ##
REM ## * boost (prebuilt runtime dlls)
REM ## * pthreads (prebuilt runtime dlls)
REM ## * portaudio (prebuilt runtime dlls)
REM ## * libusb (prebuilt runtime dlls)
REM ## * swig (prebuilt generator)
REM ## * qt5 (prebuilt runtime dlls)
REM ## * fftw (prebuilt runtime dlls)
REM ############################################################

REM ############################################################
REM ## Created required directories
REM ############################################################
mkdir "%INSTALL_PREFIX%"
mkdir "%INSTALL_PREFIX%/bin"

REM ############################################################
REM ## Boost dependency (prebuilt)
REM ############################################################
set BOOST_ROOT=C:/local/boost_1_57_0
set BOOST_LIBRARY_DIR=C:/local/boost_1_57_0/lib64-msvc-11.0

cp "%BOOST_LIBRARY_DIR%/boost_thread-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_system-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_date_time-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_chrono-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_serialization-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_regex-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_filesystem-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"
cp "%BOOST_LIBRARY_DIR%/boost_program_options-vc110-mt-1_57.dll" "%INSTALL_PREFIX%/bin"

REM ############################################################
REM ## Pthreads (prebuilt)
REM ############################################################
set THREADS_PTHREADS_ROOT=C:/pthreads
set THREADS_PTHREADS_INCLUDE_DIR=%THREADS_PTHREADS_ROOT%/include
set THREADS_PTHREADS_WIN32_LIBRARY=%THREADS_PTHREADS_ROOT%/lib/x64/pthreadVC2.lib

cp "C:/pthreads/dll/x64/pthreadVC2.dll" "%INSTALL_PREFIX%/bin"

REM ############################################################
REM ## PortAudio dependency (prebuilt)
REM ############################################################
set PORTAUDIO_INCLUDE_DIR=C:/portaudio-r1891-build/include
set PORTAUDIO_LIBRARY=C:/portaudio-r1891-build/lib/x64/Release/portaudio_x64.lib

cp "C:/portaudio-r1891-build/lib/x64/Release/portaudio_x64.dll" "%INSTALL_PREFIX%/bin"

REM ############################################################
REM ## Qt5 (prebuilt)
REM ############################################################
set QT5_DLL_ROOT=C:/Qt/Qt5.2.1/5.2.1/msvc2012_64

cp "%QT5_DLL_ROOT%/bin/libGLESv2.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/libEGL.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/icudt51.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/icuin51.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/icuuc51.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5Core.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5Gui.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5Widgets.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5Concurrent.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5OpenGL.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5Svg.dll" "%INSTALL_PREFIX%/bin"
cp "%QT5_DLL_ROOT%/bin/Qt5PrintSupport.dll" "%INSTALL_PREFIX%/bin"

mkdir "%INSTALL_PREFIX%/bin/platforms"
cp "%QT5_DLL_ROOT%/plugins/platforms/qwindows.dll" "%INSTALL_PREFIX%/bin/platforms"

REM ############################################################
REM ## LibUSB dependency (prebuilt)
REM ############################################################
set LIBUSB_ROOT=C:/libusb-1.0.19
set LIBUSB_INCLUDE_DIR=%LIBUSB_ROOT%/include/libusb-1.0
set LIBUSB_LIBRARIES=%LIBUSB_ROOT%/MS64/dll/libusb-1.0.lib

cp "%LIBUSB_LIBRARY_PATH%/libusb-1.0.dll" "%INSTALL_PREFIX%/bin"

REM ############################################################
REM ## SWIG dependency (prebuilt)
REM ############################################################
set SWIG_EXECUTABLE=C:/swigwin-3.0.5/swig.exe
set SWIG_DIR=C:/swigwin-3.0.5/Lib

REM ############################################################
REM ## FFTW (prebuilt)
REM ############################################################
set FFTW3F_ROOT=C:/fftw-3.3.4-dll64
set FFTW3F_INCLUDE_DIRS=%FFTW3F_ROOT%
set FFTW3F_LIBRARIES=%FFTW3F_ROOT%/libfftw3f-3.lib

cp "%FFTW3F_ROOT%/libfftw3f-3.dll" "%INSTALL_PREFIX%/bin"

cd "%FFTW3F_ROOT%"
lib /machine:x64 /def:libfftw3f-3.def
