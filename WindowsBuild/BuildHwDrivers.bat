REM ############################################################
REM ## Pothos SDR environment build sub-script
REM ##
REM ## This script builds SoapySDR and vendor drivers
REM ##
REM ## * rtl-sdr
REM ## * bladerf
REM ## * hackrf
REM ## * uhd/usrp
REM ## * SoapySDR
REM ############################################################

set RTL_BRANCH=master
set BLADERF_BRANCH=libbladeRF_v1.2.1
set HACKRF_BRANCH=755a9f67aeb96d7aa6993c4eb96f7b47963593d7
set UHD_BRANCH=release_003_008_002
set SOAPY_BRANCH=master

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
rm CMakeCache.txt
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
REM ## Build BladeRF
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/bladeRF (
    git clone https://github.com/Nuand/bladeRF.git
)
cd bladeRF/host
git remote update
git checkout %BLADERF_BRANCH%
mkdir build
cd build
rm CMakeCache.txt
cmake .. -G "%GENERATOR%" ^
    -DCMAKE_BUILD_TYPE="%CONFIGURATION%" ^
    -DCMAKE_INSTALL_PREFIX="%INSTALL_PREFIX%" ^
    -DENABLE_BACKEND_USB=ON ^
    -DENABLE_BACKEND_LIBUSB=ON ^
    -DLIBUSB_HEADER_FILE="%LIBUSB_INCLUDE_DIR%/libusb.h" ^
    -DLIBUSB_PATH="%LIBUSB_ROOT%" ^
    -DLIBPTHREADSWIN32_HEADER_FILE="%THREADS_PTHREADS_INCLUDE_DIR%/pthread.h" ^
    -DLIBPTHREADSWIN32_PATH="%THREADS_PTHREADS_ROOT%"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install

REM ############################################################
REM ## Build HackRF
REM ############################################################
cd %BUILD_DIR%
if NOT EXIST %BUILD_DIR%/hackrf (
    git clone https://github.com/mossmann/hackrf.git
)
cd hackrf/host
git remote update
git checkout %HACKRF_BRANCH%
mkdir build
cd build
rm CMakeCache.txt
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
rm CMakeCache.txt
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
REM ##
REM ## * ENABLE_RFSPACE=OFF build errors
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
    -DUHD_INCLUDE_DIRS="%INSTALL_PREFIX%/include" ^
    -DUHD_LIBRARIES="%INSTALL_PREFIX%/lib/uhd.lib" ^
    -DPYTHON_EXECUTABLE="C:/Python34/python.exe" ^
    -DSWIG_EXECUTABLE="%SWIG_EXECUTABLE%" ^
    -DSWIG_DIR="%SWIG_DIR%" ^
    -DENABLE_RFSPACE=OFF
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install
