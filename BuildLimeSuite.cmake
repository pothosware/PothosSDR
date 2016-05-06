############################################################
## Pothos SDR environment build sub-script
##
## This script builds LimeSuite w/ SoapySDR bindings
##
## * CubicSDR
############################################################

set(LIME_SUITE_BRANCH master)

set(FX3_SDK_PATH "C:/local/EZ-USB FX3 SDK/1.3")

if (NOT EXISTS ${FX3_SDK_PATH})
    return()
endif()

############################################################
## Build LimeSuite
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
############################################################
message(STATUS "Configuring LimeSuite - ${LIME_SUITE_BRANCH}")
ExternalProject_Add(LimeSuite
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/myriadrf/LimeSuite.git
    GIT_TAG ${LIME_SUITE_BRANCH}
    CONFIGURE_COMMAND
        "${CMAKE_COMMAND}" <SOURCE_DIR>/src
        -G ${CMAKE_GENERATOR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DWX_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
        -DFX3_SDK_PATH=${FX3_SDK_PATH}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(LimeSuite SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/LimeSuite
)

list(APPEND CPACK_PACKAGE_EXECUTABLES "lms7suite" "LMS7 Suite")
list(APPEND CPACK_CREATE_DESKTOP_LINKS "lms7suite")
