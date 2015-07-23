############################################################
## Pothos SDR environment build sub-script
##
## This script builds Poco (dependency) and Pothos project
##
## * poco (dependency)
## * pothos (top level project)
############################################################

set(POCO_BRANCH poco-1.6.0-release)
set(POTHOS_BRANCH master)

############################################################
## Build Poco
############################################################
message(STATUS "Configuring Poco - ${POCO_BRANCH}")
ExternalProject_Add(Poco
    GIT_REPOSITORY https://github.com/pocoproject/poco.git
    GIT_TAG ${POCO_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(Poco SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE
    DESTINATION licenses/Poco
)

############################################################
## Build Pothos
##
## * ENABLE_JAVA=OFF not useful component yet
############################################################
message(STATUS "Configuring Pothos - ${POTHOS_BRANCH}")
ExternalProject_Add(Pothos
    DEPENDS Poco SoapySDR
    GIT_REPOSITORY https://github.com/pothosware/pothos.git
    GIT_TAG ${POTHOS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPOTHOS_EXTVER=${EXTRA_VERSION_INFO}
        -DPYTHON_EXECUTABLE=C:/Python34/python.exe
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DPORTAUDIO_INCLUDE_DIR=${PORTAUDIO_INCLUDE_DIR}
        -DPORTAUDIO_LIBRARY=${PORTAUDIO_LIBRARY}
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
        -DENABLE_JAVA=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(Pothos SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/pothos-library/LICENSE_1_0.txt
    DESTINATION licenses/Pothos
)
install(
    FILES ${SOURCE_DIR}/pothos-widgets/qwt/COPYING
    DESTINATION licenses/qwt
)
install(
    FILES ${SOURCE_DIR}/pothos-util/muparserx/License.txt
    DESTINATION licenses/muparserx
)
install(
    FILES ${SOURCE_DIR}/pothos-blocks/network/udt4/LICENSE.txt
    DESTINATION licenses/udt
)
install(
    FILES
        ${SOURCE_DIR}/pothos-gui/qtcolorpicker/LGPL_EXCEPTION.txt
        ${SOURCE_DIR}/pothos-gui/qtcolorpicker/LICENSE.GPL3
        ${SOURCE_DIR}/pothos-gui/qtcolorpicker/LICENSE.LGPL
    DESTINATION licenses/qtcolorpicker
)
