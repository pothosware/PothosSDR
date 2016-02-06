############################################################
## Pothos SDR environment build sub-script
##
## This script builds CubicSDR and dependencies
##
## * CubicSDR
############################################################

set(CUBIC_SDR_BRANCH master)

############################################################
## Build CubicSDR
############################################################
message(STATUS "Configuring CubicSDR - ${CUBIC_SDR_BRANCH}")
ExternalProject_Add(CubicSDR
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/cjcliffe/CubicSDR.git
    GIT_TAG ${CUBIC_SDR_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(CubicSDR SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE
    DESTINATION licenses/CubicSDR
)
