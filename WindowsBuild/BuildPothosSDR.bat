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
set RTL_BRANCH=master
set UHD_BRANCH=release_003_008_002
set POCO_BRANCH=poco-1.6.0-release
set POTHOS_BRANCH=master
set SOAPY_BRANCH=master
set GR_BRANCH=master

COLOR
mkdir "%BUILD_DIR%"

REM ############################################################
REM ## pre-built dependencies
REM ############################################################
call "%SOURCE_DIR%/Prebuilt.bat"

REM ############################################################
REM ## sdr hardware support
REM ############################################################
call "%SOURCE_DIR%/BuildSDR.bat"

REM ############################################################
REM ## Pothos data-flow suite
REM ############################################################
call "%SOURCE_DIR%/BuildPothos.bat"

REM ############################################################
REM ## GNU Radio toolkit
REM ############################################################
call "%SOURCE_DIR%/BuildGNURadio.bat"
