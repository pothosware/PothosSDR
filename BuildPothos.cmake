############################################################
## Pothos SDR environment build sub-script
##
## This script builds Poco (dependency) and Pothos project
##
## * poco (dependency)
## * pothos (top level project)
############################################################

set(POCO_BRANCH poco-1.6.1-release)
set(SPUCE_BRANCH 0.4.1)
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
## Build Spuce
############################################################
message(STATUS "Configuring Spuce - ${SPUCE_BRANCH}")
ExternalProject_Add(Spuce
    GIT_REPOSITORY https://github.com/audiofilter/spuce.git
    GIT_TAG ${SPUCE_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/spuce_vc11_fixes.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_PYTHON=OFF
        -DCMAKE_PREFIX_PATH=${QT5_DLL_ROOT}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(Spuce SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/Spuce
)

############################################################
## Build Pothos
##
## * ENABLE_JAVA=OFF not useful component yet
############################################################
message(STATUS "Configuring Pothos - ${POTHOS_BRANCH}")
ExternalProject_Add(Pothos
    DEPENDS Poco SoapySDR Spuce
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
    FILES ${SOURCE_DIR}/library/LICENSE_1_0.txt
    DESTINATION licenses/Pothos
)
install(
    FILES ${SOURCE_DIR}/plotters/qwt-6.1.2/COPYING
    DESTINATION licenses/qwt
)
install(
    FILES ${SOURCE_DIR}/util/muparserx/License.txt
    DESTINATION licenses/muparserx
)
install(
    FILES ${SOURCE_DIR}/blocks/network/udt4/LICENSE.txt
    DESTINATION licenses/udt
)
install(
    FILES
        ${SOURCE_DIR}/gui/qtcolorpicker/LGPL_EXCEPTION.txt
        ${SOURCE_DIR}/gui/qtcolorpicker/LICENSE.GPL3
        ${SOURCE_DIR}/gui/qtcolorpicker/LICENSE.LGPL
    DESTINATION licenses/qtcolorpicker
)
