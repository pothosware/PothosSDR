############################################################
## Pothos SDR environment build sub-script
##
## This script builds gr-qtgui dependecies
##
## * qt4 (prebuilt)
## * qwt5
## * qwt6
## * python2_sip
## * python2_pyqt4
## * python2_pyqwt5
############################################################

set(GNURADIO_BRANCH maint)
set(GR_POTHOS_BRANCH master)
set(GROSMOSDR_BRANCH master)
set(GRRDS_BRANCH master)
set(GQRX_BRANCH master)
set(GRDRM_BRANCH master)
set(GRRFTAP_BRANCH master)

############################################################
## Qt4 (prebuilt)
## Can be built downlading https://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.zip
## Patch with: https://gist.github.com/eduardosm/70beffbc6f78793ae0609fe7ea89978e
## (bsed on the patch provided here: https://stackoverflow.com/a/32848999)
## Running from the VS2015 X64 Native Tools Command Prompt:
## configure -make nmake -release -shared -platform win32-msvc2015 ^
##     -prefix C:\Qt\Qt4.8.7-msvc2015 -opensource -confirm-license ^
##     -opengl desktop -graphicssystem opengl -nomake examples -nomake network ^
##     -nomake demos -nomake tools -nomake sql -no-script -no-scripttools ^
##     -no-qt3support -qt-libpng -qt-libjpeg -no-webkit
## nmake
## nmake install
############################################################
set(QT4_ROOT C:/Qt/Qt4.8.7-msvc2015)

message(STATUS "QT4_ROOT: ${QT5_ROOT}")

install(FILES
    "${QT4_ROOT}/bin/QtCore4.dll"
    "${QT4_ROOT}/bin/QtGui4.dll"
    "${QT4_ROOT}/bin/QtSvg4.dll"
    "${QT4_ROOT}/bin/QtOpenGL4.dll"
    DESTINATION bin
)

############################################################
## Build Qwt5
############################################################
MyExternalProject_Add(qwt5
    GIT_REPOSITORY https://github.com/eduardosm/qwt-5.2.3.git
    GIT_TAG v5.2.3
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/qwt5_project_files.diff
    CONFIGURE_COMMAND ${QT4_ROOT}/bin/qmake.exe <SOURCE_DIR>/qwt.pro
        CONFIG+=release
        PREFIX=<INSTALL_DIR>
        MAKEDLL=NO AVX2=NO
    BUILD_COMMAND nmake
    INSTALL_COMMAND nmake install
    LICENSE_FILES COPYING
)

ExternalProject_Get_Property(qwt5 INSTALL_DIR)
set(QWT5_INSTALL_PREFIX ${INSTALL_DIR})

############################################################
## Build Qwt6
############################################################
MyExternalProject_Add(qwt6
    GIT_REPOSITORY https://github.com/eduardosm/qwt-6.1.3.git
    GIT_TAG v6.1.3
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/qwt6_project_files.diff
    CONFIGURE_COMMAND ${QT4_ROOT}/bin/qmake.exe <SOURCE_DIR>/qwt.pro
        CONFIG+=release
        PREFIX=${CMAKE_INSTALL_PREFIX}
        MAKEDLL=YES AVX2=NO QT_DLL=YES &&
        # Avoid too long commands
        nmake "src\\Makefile" &&
        powershell -Command "(gc src\\Makefile.release) -replace '= @echo compiling', '= cl #' | Out-File src\\Makefile.release" &&
        # Avoid debug build
        powershell -Command "(gc src\\Makefile) -replace 'install: release-install debug-install', 'install: release-install' | Out-File src\\Makefile" &&
        powershell -Command "(gc src\\Makefile) -replace 'all: release-all debug-all', 'all: release-all' | Out-File src\\Makefile"
    BUILD_COMMAND nmake
    INSTALL_COMMAND
        nmake install &&
        ${CMAKE_COMMAND} -E remove -f ${CMAKE_INSTALL_PREFIX}/bin/qwt6.dll &&
        ${CMAKE_COMMAND} -E rename ${CMAKE_INSTALL_PREFIX}/lib/qwt6.dll ${CMAKE_INSTALL_PREFIX}/bin/qwt6.dll
    LICENSE_FILES COPYING
)

############################################################
## Build Python2-SIP
############################################################
MyExternalProject_Add(python2_sip
    GIT_REPOSITORY https://github.com/eduardosm/sip-4.19.7.git
    GIT_TAG v4.19.7
    CONFIGURE_COMMAND cd <SOURCE_DIR> &&
        ${PYTHON2_EXECUTABLE} configure.py --platform win32-msvc2015
        -b ${CMAKE_INSTALL_PREFIX}/bin
        -d ${CMAKE_INSTALL_PREFIX}/lib/python2.7/site-packages
        -e ${CMAKE_INSTALL_PREFIX}/include
        -v ${CMAKE_INSTALL_PREFIX}/sip
        --stubsdir=${CMAKE_INSTALL_PREFIX}/lib/python2.7/site-packages
    BUILD_COMMAND cd <SOURCE_DIR> && nmake
    INSTALL_COMMAND cd <SOURCE_DIR> && nmake install
    LICENSE_FILES LICENSE LICENSE-GPL2 LICENSE-GPL3
)

############################################################
## Build Python2-SIP
############################################################
MyExternalProject_Add(python2_pyqt4
    DEPENDS python2_sip
    GIT_REPOSITORY https://github.com/eduardosm/PyQt4_gpl_win-4.12.1.git
    GIT_TAG v4.12.1
    CONFIGURE_COMMAND cd <SOURCE_DIR> &&
        powershell -ExecutionPolicy ByPass
        -File ${PROJECT_SOURCE_DIR}/Scripts/python2_pyqt4_configure.ps1
        -InstallPrefix ${CMAKE_INSTALL_PREFIX}
        -Qt4Root ${QT4_ROOT}
        -Python2Executable ${PYTHON2_EXECUTABLE}
    BUILD_COMMAND cd <SOURCE_DIR> && nmake
    INSTALL_COMMAND cd <SOURCE_DIR> && nmake install
    LICENSE_FILES LICENSE
)

############################################################
## Build Python2-PyQwt5
############################################################
MyExternalProject_Add(python2_pyqwt5
    DEPENDS python2_sip python2_pyqt4
    GIT_REPOSITORY https://github.com/PyQwt/PyQwt5.git
    GIT_TAG master
    CONFIGURE_COMMAND cd <SOURCE_DIR>/configure &&
        powershell -ExecutionPolicy ByPass
        -File ${PROJECT_SOURCE_DIR}/Scripts/python2_pyqwt5_configure.ps1
        -InstallPrefix ${CMAKE_INSTALL_PREFIX}
        -QwtInstallPrefix ${QWT5_INSTALL_PREFIX}
        -Qt4Root ${QT4_ROOT}
        -Python2Executable ${PYTHON2_EXECUTABLE}
    BUILD_COMMAND cd <SOURCE_DIR>/configure && nmake
    INSTALL_COMMAND cd <SOURCE_DIR>/configure && nmake install
    LICENSE_FILES COPYING COPYING.GSE COPYING.INTES COPYING.PyQwt
)
