REM ############################################################
REM ## Pothos SDR environment build sub-script
REM ##
REM ## This script builds SoapySDR and vendor drivers
REM ##
REM ## * rtl-sdr
REM ## * uhd/usrp
REM ## * SoapySDR
REM ############################################################

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
