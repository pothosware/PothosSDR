############################################################
## Pothos SDR environment build sub-script
##
## This script builds the Pothos framework and toolkits
##
## * pothos (framework)
## * pothos-audio (toolkit)
## * pothos-blocks (toolkit)
## * pothos-comms (toolkit)
## * pothos-gui (toolkit)
## * pothos-plotters (toolkit)
## * PothosPython (toolkit)
## * pothos-sdr (toolkit)
## * pothos-widgets (toolkit)
############################################################

set(POTHOS_BRANCH maint)
set(POTHOS_AUDIO_BRANCH maint)
set(POTHOS_BLOCKS_BRANCH maint)
set(POTHOS_COMMS_BRANCH maint)
set(POTHOS_GUI_BRANCH maint)
set(POTHOS_PLOTTERS_BRANCH maint)
set(POTHOS_PYTHON_BRANCH maint)
set(POTHOS_SDR_BRANCH maint)
set(POTHOS_WIDGETS_BRANCH maint)
set(POTHOS_MODULES_DIR "modules0.5")

############################################################
## Build Pothos framework
############################################################
MyExternalProject_Add(Pothos
    DEPENDS Poco muparserx
    GIT_REPOSITORY https://github.com/pothosware/PothosCore.git
    GIT_TAG ${POTHOS_BRANCH}
    GIT_SUBMODULES muparserx #cant turn them all off, so turn only one on
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPOTHOS_EXTVER=${EXTRA_VERSION_INFO}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DENABLE_INTERNAL_POCO=OFF
        -DENABLE_INTERNAL_SPUCE=OFF
        -DENABLE_INTERNAL_MUPARSERX=OFF
        -DENABLE_TOOLKITS=OFF
    LICENSE_FILES LICENSE_1_0.txt
)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"POTHOS_ROOT\\\" \\\"$INSTDIR\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegValue HKEY_LOCAL_MACHINE \\\"${NSIS_ENV}\\\" \\\"POTHOS_ROOT\\\"
")

############################################################
## Build Pothos Audio toolkit
############################################################
MyExternalProject_Add(PothosAudio
    DEPENDS Pothos PortAudio
    GIT_REPOSITORY https://github.com/pothosware/PothosAudio.git
    GIT_TAG ${POTHOS_AUDIO_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPORTAUDIO_INCLUDE_DIR=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARY=${PORTAUDIO_LIBRARY}
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build Pothos Blocks toolkit
############################################################
MyExternalProject_Add(PothosBlocks
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/PothosBlocks.git
    GIT_TAG ${POTHOS_BLOCKS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    LICENSE_FILES LICENSE_1_0.txt
)

ExternalProject_Get_Property(PothosBlocks SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/network/udt4/LICENSE.txt
    DESTINATION licenses/udt
)

############################################################
## Build Pothos Comms toolkit
############################################################
MyExternalProject_Add(PothosComms
    DEPENDS Pothos Spuce
    GIT_REPOSITORY https://github.com/pothosware/PothosComms.git
    GIT_TAG ${POTHOS_COMMS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    LICENSE_FILES LICENSE_1_0.txt
)

ExternalProject_Get_Property(PothosComms SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/fft/COPYING.kissfft
    DESTINATION licenses/kissfft
)

############################################################
## Build Pothos Gui toolkit
############################################################
MyExternalProject_Add(PothosGui
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/PothosFlow.git
    GIT_TAG ${POTHOS_GUI_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
    LICENSE_FILES LICENSE_1_0.txt
)

ExternalProject_Get_Property(PothosGui SOURCE_DIR)
install(
    FILES
        ${SOURCE_DIR}/qtcolorpicker/LGPL_EXCEPTION.txt
        ${SOURCE_DIR}/qtcolorpicker/LICENSE.GPL3
        ${SOURCE_DIR}/qtcolorpicker/LICENSE.LGPL
    DESTINATION licenses/qtcolorpicker
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "PothosGui" "Pothos GUI")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "PothosGui")

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
WriteRegStr HKEY_CLASSES_ROOT \\\".pothos\\\" \\\"\\\" \\\"Pothos.GUI\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"Pothos.GUI\\\\DefaultIcon\\\" \\\"\\\" \\\"$INSTDIR\\\\bin\\\\PothosGui.exe\\\"
WriteRegStr HKEY_CLASSES_ROOT \\\"Pothos.GUI\\\\Shell\\\\Open\\\\command\\\" \\\"\\\" \\\"${NEQ}$INSTDIR\\\\bin\\\\PothosGui.exe${NEQ} ${NEQ}%1${NEQ} %*\\\"
")

set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
DeleteRegKey HKEY_CLASSES_ROOT \\\".pothos\\\"
DeleteRegKey HKEY_CLASSES_ROOT \\\"Pothos.GUI\\\"
")

############################################################
## Build Pothos Plotters toolkit
############################################################
MyExternalProject_Add(PothosPlotters
    DEPENDS Pothos Spuce
    GIT_REPOSITORY https://github.com/pothosware/PothosPlotters.git
    GIT_TAG ${POTHOS_PLOTTERS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
    LICENSE_FILES LICENSE_1_0.txt
)

ExternalProject_Get_Property(PothosPlotters SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/qwt6/COPYING
    DESTINATION licenses/qwt
)

############################################################
## Build Pothos Python toolkit
##
## Two builds here for python2 and python3:
## Python3 depends on python2 so it will install last,
## and overwrite the python2 module to become default.
## Each module is also copied to a version-specific name
## so the user can switch between python versions.
############################################################
MyExternalProject_Add(PothosPython2
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/PothosPython.git
    GIT_TAG ${POTHOS_PYTHON_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON2_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON2_LIBRARY}
        -DPOTHOS_PYTHON_DIR=${PYTHON2_INSTALL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        && ${CMAKE_COMMAND} -E copy
            ${CMAKE_INSTALL_PREFIX}/lib/Pothos/${POTHOS_MODULES_DIR}/proxy/environment/PythonSupport.dll
            ${CMAKE_INSTALL_PREFIX}/lib/Pothos/${POTHOS_MODULES_DIR}/proxy/environment/PythonSupport.dll.2
    LICENSE_FILES LICENSE_1_0.txt
)

MyExternalProject_Add(PothosPython3
    DEPENDS Pothos PothosPython2
    GIT_REPOSITORY https://github.com/pothosware/PothosPython.git
    GIT_TAG ${POTHOS_PYTHON_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPYTHON_EXECUTABLE=${PYTHON3_EXECUTABLE}
        -DPYTHON_INCLUDE_DIR=${PYTHON3_INCLUDE_DIR}
        -DPYTHON_LIBRARY=${PYTHON3_LIBRARY}
        -DPOTHOS_PYTHON_DIR=${PYTHON3_INSTALL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        && ${CMAKE_COMMAND} -E copy
            ${CMAKE_INSTALL_PREFIX}/lib/Pothos/${POTHOS_MODULES_DIR}/proxy/environment/PythonSupport.dll
            ${CMAKE_INSTALL_PREFIX}/lib/Pothos/${POTHOS_MODULES_DIR}/proxy/environment/PythonSupport.dll.3
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build Pothos SDR toolkit
############################################################
MyExternalProject_Add(PothosSDR
    DEPENDS Pothos SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/PothosSoapy.git
    GIT_TAG ${POTHOS_SDR_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build Pothos Widgets toolkit
############################################################
MyExternalProject_Add(PothosWidgets
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/PothosWidgets.git
    GIT_TAG ${POTHOS_WIDGETS_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build BTLE demo
############################################################
MyExternalProject_Add(BtleDemo
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/DesignSparkrs/sdr-ble-demo.git
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    LICENSE_FILES README.md
)

############################################################
## Build LoRa demo
############################################################
MyExternalProject_Add(LoRaDemo
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/myriadrf/LoRa-SDR.git
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    LICENSE_FILES README.md
)
