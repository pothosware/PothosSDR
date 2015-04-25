REM ############################################################
REM ## Pothos SDR environment build sub-script
REM ##
REM ## This script builds Poco (dependency) and Pothos project
REM ##
REM ## * poco (dependency)
REM ## * pothos (top level project)
REM ############################################################

set POCO_BRANCH=poco-1.6.0-release
set POTHOS_BRANCH=master

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
REM ## Pothos GUI shortcut
REM ############################################################
cp "%SOURCE_DIR%/Launchers/PothosGui.exe" "%INSTALL_PREFIX%"
