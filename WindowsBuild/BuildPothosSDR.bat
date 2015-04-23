@echo off
REM ############################################################
REM ## Pothos SDR environment build script
REM ##
REM ## * boost (prebuilt runtime dlls)
REM ## * pthreads (prebuilt runtime dlls)
REM ## * portaudio (prebuilt runtime dlls)
REM ## * libusb (prebuilt + static link)
REM ## * swig (prebuilt generator)
REM ## * rtl sdr
REM ## * uhd
REM ## * SoapySDR
REM ## * Poco 1.6
REM ## * qt5 (prebuilt runtime dlls)
REM ## * Pothos
REM ## * gnuradio
REM ############################################################

set BUILD_DIR=C:/build/PothosSDR
set INSTALL_PREFIX=C:/PothosSDR
set CONFIGURATION=RelWithDebInfo
set GENERATOR=Visual Studio 11 2012 Win64
set RTL_BRANCH=master
set UHD_BRANCH=release_003_008_002
set POCO_BRANCH=poco-1.6.0-release
set POTHOS_BRANCH=master
set SOAPY_BRANCH=master
set GR_BRANCH=master

COLOR
mkdir "%BUILD_DIR%"
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
set THREADS_PTHREADS_INCLUDE_DIR=C:/pthreads/include
set THREADS_PTHREADS_WIN32_LIBRARY=C:/pthreads/lib/x64/pthreadVC2.lib

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
set LIBUSB_INCLUDE_DIR=C:/build/libusb/libusb
set LIBUSB_LIBRARIES=C:/build/libusb/x64/Release/lib/libusb-1.0.lib

REM ############################################################
REM ## SWIG dependency (prebuilt)
REM ############################################################
set SWIG_EXECUTABLE=C:/swigwin-3.0.5/swig.exe
set SWIG_DIR=C:/swigwin-3.0.5/Lib

REM ############################################################
REM ## Build RTL SDR
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/rtl-sdr (
    git clone git://git.osmocom.org/rtl-sdr.git
)
cd rtl-sdr
git remote update
git checkout %RTL_BRANCH%
mkdir build
cd build
cmake .. -G "%GENERATOR%" ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DLIBUSB_INCLUDE_DIR="%LIBUSB_INCLUDE_DIR%" ^
    -DLIBUSB_LIBRARIES="%LIBUSB_LIBRARIES%" ^
    -DTHREADS_PTHREADS_INCLUDE_DIR="%THREADS_PTHREADS_INCLUDE_DIR%" ^
    -DTHREADS_PTHREADS_WIN32_LIBRARY="%THREADS_PTHREADS_WIN32_LIBRARY%"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## Build UHD
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/uhd (
    git clone https://github.com/EttusResearch/uhd.git
)
cd uhd/host
git remote update
git checkout %UHD_BRANCH%
mkdir build
cd build
cmake .. -G "%GENERATOR%" -Wno-dev ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DLIBUSB_INCLUDE_DIR="%LIBUSB_INCLUDE_DIR%" ^
    -DLIBUSB_LIBRARIES="%LIBUSB_LIBRARIES%" ^
    -DBOOST_ROOT="%BOOST_ROOT%" ^
    -DBOOST_LIBRARY_DIR="%BOOST_LIBRARY_DIR%" ^
    -DBOOST_ALL_DYN_LINK="TRUE" ^
    -DPYTHON_EXECUTABLE="C:/Python27/python.exe"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## Build SoapySDR
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/SoapySDR (
    git clone https://github.com/pothosware/SoapySDR.git
)
cd SoapySDR
git remote update
git checkout %SOAPY_BRANCH%
git pull origin %SOAPY_BRANCH%
git submodule init
git submodule update
mkdir build
cd build
rm CMakeCache.txt
cmake .. -G "%GENERATOR%" ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DBOOST_ROOT="%BOOST_ROOT%" ^
    -DBOOST_LIBRARY_DIR="%BOOST_LIBRARY_DIR%" ^
    -DLIBRTLSDR_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DLIBRTLSDR_LIBRARIES="%INSTALL_PREFIX%/lib/rtlsdr.lib" ^
    -DUHD_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DUHD_LIBRARIES="%INSTALL_PREFIX%/lib/uhd.lib" ^
    -DPYTHON_EXECUTABLE="C:/Python34/python.exe" ^
    -DSWIG_EXECUTABLE="%SWIG_EXECUTABLE%" ^
    -DSWIG_DIR="%SWIG_DIR%" ^
    -DENABLE_RFSPACE=OFF
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## Build Poco
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/poco (
    git clone https://github.com/pocoproject/poco.git
)
cd poco
git remote update
git checkout %POCO_BRANCH%
mkdir build
cd build
cmake .. -G "%GENERATOR%" -Wno-dev ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## Build Pothos
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/pothos (
    git clone https://github.com/pothosware/pothos.git
)
cd pothos
git remote update
git checkout %POTHOS_BRANCH%
git pull origin %POTHOS_BRANCH%
mkdir build
cd build
rm CMakeCache.txt
cmake .. -G "%GENERATOR%" -Wno-dev ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DPYTHON_EXECUTABLE="C:/Python34/python.exe" ^
    -DSoapySDR_DIR="%INSTALL_PREFIX%" ^
    -DPoco_DIR="%INSTALL_PREFIX%/lib/cmake/Poco" ^
    -DPORTAUDIO_INCLUDE_DIR="%PORTAUDIO_INCLUDE_DIR%" ^
    -DPORTAUDIO_LIBRARY="%PORTAUDIO_LIBRARY%"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## FFTW (prebuilt)
REM ############################################################
set FFTW3F_ROOT=C:/fftw-3.3.4-dll64
set FFTW3F_INCLUDE_DIRS=%FFTW3F_ROOT%
set FFTW3F_LIBRARIES=%FFTW3F_ROOT%/libfftw3f-3.lib

cp "%FFTW3F_ROOT%/libfftw3f-3.dll" "%INSTALL_PREFIX%/bin"

cd "%FFTW3F_ROOT%"
lib /machine:x64 /def:libfftw3f-3.def

REM ############################################################
REM ## Build GNU Radio
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/gnuradio (
    git clone https://github.com/pothosware/gnuradio.git
)
cd gnuradio
git remote update
git checkout %GR_BRANCH%
git pull origin %GR_BRANCH%
mkdir build
cd build
rm CMakeCache.txt
cmake .. -G "%GENERATOR%" -Wno-dev ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DBOOST_ROOT="%BOOST_ROOT%" ^
    -DBOOST_LIBRARY_DIR="%BOOST_LIBRARY_DIR%" ^
    -DBOOST_ALL_DYN_LINK="TRUE" ^
    -DSWIG_EXECUTABLE="%SWIG_EXECUTABLE%" ^
    -DSWIG_DIR="%SWIG_DIR%" ^
    -DPYTHON_EXECUTABLE="C:/Python27/python.exe" ^
    -DFFTW3F_INCLUDE_DIRS="%FFTW3F_INCLUDE_DIRS%" ^
    -DFFTW3F_LIBRARIES="%FFTW3F_LIBRARIES%" ^
    -DENABLE_GR_DTV=OFF
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## GR Pothos bindings
REM ############################################################
cd %BUILD_DIR%
mkdir GrPothos
cd GrPothos
rm CMakeCache.txt
cmake "%INSTALL_PREFIX%/share/cmake/gr-pothos" -G "%GENERATOR%" -Wno-dev ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DPYTHON_EXECUTABLE="C:/Python27/python.exe" ^
    -DGNURADIO_ANALOG_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DGNURADIO_ANALOG_LIBRARIES_gnuradio-analog="%INSTALL_PREFIX%/lib/gnuradio-analog.lib" ^
    -DGNURADIO_DIGITAL_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DGNURADIO_DIGITAL_LIBRARIES_gnuradio-digital="%INSTALL_PREFIX%/lib/gnuradio-digital.lib" ^
    -DGNURADIO_FFT_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DGNURADIO_FFT_LIBRARIES_gnuradio-fft="%INSTALL_PREFIX%/lib/gnuradio-fft.lib" ^
    -DGNURADIO_FILTER_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DGNURADIO_FILTER_LIBRARIES_gnuradio-filter="%INSTALL_PREFIX%/lib/gnuradio-filter.lib"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install
