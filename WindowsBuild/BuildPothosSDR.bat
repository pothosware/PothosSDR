@echo off
REM ############################################################
REM ## Pothos SDR environment build script
REM ##
REM ## * Various pre-built dependencies
REM ## * Soapy SDR and vendor drivers
REM ## * Poco and Pothos suite
REM ## * GNU Radio and toolkit bindings
REM ############################################################

set SOURCE_DIR=%~dp0
set BUILD_DIR=C:/build/PothosSDR
set INSTALL_PREFIX=C:/PothosSDR
set CONFIGURATION=RelWithDebInfo
set GENERATOR=Visual Studio 11 2012 Win64

COLOR
mkdir "%BUILD_DIR%"
mkdir "%INSTALL_PREFIX%/licenses"

REM ############################################################
REM ## pre-built dependencies
REM ############################################################
call "%SOURCE_DIR%/InstallPrebuilt.bat"

REM ############################################################
REM ## sdr hardware support
REM ############################################################
call "%SOURCE_DIR%/BuildHwDrivers.bat"

REM ############################################################
REM ## Pothos data-flow suite
REM ############################################################
call "%SOURCE_DIR%/BuildPothos.bat"

REM ############################################################
REM ## GNU Radio toolkit
REM ############################################################
call "%SOURCE_DIR%/BuildGNURadio.bat"

REM ############################################################
REM ## Zip the install dir
REM ############################################################
if EXIST "%BUILD_DIR%/PothosSDR.zip" (
    rm "%BUILD_DIR%/PothosSDR.zip"
)
"C:\Program Files\7-Zip\7z.exe" a "%BUILD_DIR%/PothosSDR.zip" "%INSTALL_PREFIX%"
