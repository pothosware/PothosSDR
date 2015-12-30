############################################################
## Pothos SDR environment build sub-script
##
## This script builds various Pothos toolkits.
##
## * pothos-audio (toolkit)
## * pothos-blocks (toolkit)
## * pothos-comms (toolkit)
## * pothos-gui (toolkit)
## * pothos-plotters (toolkit)
## * pothos-python (toolkit)
## * pothos-sdr (toolkit)
## * pothos-widgets (toolkit)
############################################################

set(POTHOS_AUDIO_BRANCH pothos-audio-0.1.2)
set(POTHOS_BLOCKS_BRANCH pothos-blocks-0.3.0)
set(POTHOS_COMMS_BRANCH pothos-comms-0.1.1)
set(POTHOS_GUI_BRANCH pothos-gui-0.3.0)
set(POTHOS_PLOTTERS_BRANCH pothos-plotters-0.1.0)
set(POTHOS_PYTHON_BRANCH pothos-python-0.1.2)
set(POTHOS_SDR_BRANCH pothos-sdr-0.3.0)
set(POTHOS_WIDGETS_BRANCH pothos-widgets-0.3.0)

############################################################
## Build Pothos Audio toolkit
############################################################
message(STATUS "Configuring PothosAudio - ${POTHOS_AUDIO_BRANCH}")
ExternalProject_Add(PothosAudio
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/pothos-audio.git
    GIT_TAG ${POTHOS_AUDIO_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPORTAUDIO_INCLUDE_DIR=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARY=${PORTAUDIO_LIBRARY}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosAudio SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosAudio
)

############################################################
## Build Pothos Blocks toolkit
############################################################
message(STATUS "Configuring PothosBlocks - ${POTHOS_BLOCKS_BRANCH}")
ExternalProject_Add(PothosBlocks
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/pothos-blocks.git
    GIT_TAG ${POTHOS_BLOCKS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosBlocks SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosBlocks
)

install(
    FILES ${SOURCE_DIR}/network/udt4/LICENSE.txt
    DESTINATION licenses/udt
)

############################################################
## Build Pothos Comms toolkit
############################################################
message(STATUS "Configuring PothosComms - ${POTHOS_COMMS_BRANCH}")
ExternalProject_Add(PothosComms
    DEPENDS Pothos Spuce
    GIT_REPOSITORY https://github.com/pothosware/pothos-comms.git
    GIT_TAG ${POTHOS_COMMS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosComms SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosComms
)

install(
    FILES ${SOURCE_DIR}/fft/COPYING.kissfft
    DESTINATION licenses/kissfft
)

############################################################
## Build Pothos Gui toolkit
############################################################
message(STATUS "Configuring PothosGui - ${POTHOS_GUI_BRANCH}")
ExternalProject_Add(PothosGui
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/pothos-gui.git
    GIT_TAG ${POTHOS_GUI_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosGui SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosGui
)

install(
    FILES
        ${SOURCE_DIR}/qtcolorpicker/LGPL_EXCEPTION.txt
        ${SOURCE_DIR}/qtcolorpicker/LICENSE.GPL3
        ${SOURCE_DIR}/qtcolorpicker/LICENSE.LGPL
    DESTINATION licenses/qtcolorpicker
)

############################################################
## Build Pothos Plotters toolkit
############################################################
message(STATUS "Configuring PothosPlotters - ${POTHOS_PLOTTERS_BRANCH}")
ExternalProject_Add(PothosPlotters
    DEPENDS Pothos Spuce
    GIT_REPOSITORY https://github.com/pothosware/pothos-plotters.git
    GIT_TAG ${POTHOS_PLOTTERS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosPlotters SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosPlotters
)

install(
    FILES ${SOURCE_DIR}/qwt-6.1.2/COPYING
    DESTINATION licenses/qwt
)

############################################################
## Build Pothos Python toolkit
############################################################
message(STATUS "Configuring PothosPython - ${POTHOS_PYTHON_BRANCH}")
ExternalProject_Add(PothosPython
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/pothos-python.git
    GIT_TAG ${POTHOS_PYTHON_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPYTHON_EXECUTABLE=C:/Python34/python.exe
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosPython SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosPython
)

############################################################
## Build Pothos SDR toolkit
############################################################
message(STATUS "Configuring PothosSDR - ${POTHOS_SDR_BRANCH}")
ExternalProject_Add(PothosSDR
    DEPENDS Pothos SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/pothos-sdr.git
    GIT_TAG ${POTHOS_SDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosSDR
)

############################################################
## Build Pothos Widgets toolkit
############################################################
message(STATUS "Configuring PothosWidgets - ${POTHOS_WIDGETS_BRANCH}")
ExternalProject_Add(PothosWidgets
    DEPENDS Pothos
    GIT_REPOSITORY https://github.com/pothosware/pothos-widgets.git
    GIT_TAG ${POTHOS_WIDGETS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosWidgets SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosWidgets
)
