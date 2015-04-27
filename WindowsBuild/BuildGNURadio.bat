REM ############################################################
REM ## Pothos SDR environment build sub-script
REM ##
REM ## This script builds GNU Radio and toolkit bindings
REM ##
REM ## * gnuradio
REM ## * gr-pothos (toolkit bindings project)
REM ############################################################

set GR_BRANCH=master

REM ############################################################
REM ## Build GNU Radio
REM ##
REM ## * Use Python27 for Cheetah templates support
REM ## * ENABLE_GR_DTV=OFF because of compiler error
REM ## * NOSWIG=ON to reduce size and build time
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
    -DENABLE_GR_DTV=OFF ^
    -DNOSWIG=ON
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install
cp "%BUILD_DIR%/gnuradio/COPYING" "%INSTALL_PREFIX%/licenses/COPYING.gnuradio"

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
    -DPYTHON_EXECUTABLE="C:/Python27/python.exe"
cmake --build . --config "%CONFIGURATION%"
cmake --build . --config "%CONFIGURATION%" --target install
