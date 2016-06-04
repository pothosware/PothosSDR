############################################################
## Pothos SDR environment build sub-script
##
## This script builds LimeSuite w/ SoapySDR bindings
##
## * LimeSuite
############################################################

set(LIME_SUITE_BRANCH master)

############################################################
## Build LimeSuite
##
## -DWX_ROOT_DIR is a hack to prevent FindwxWidgets.cmake
## from clearing wxWidgets_LIB_DIR the first configuration.
##
## -DFX3_SDK_PATH specifies the USB support for LimeSuite
## If the SDK is not present, USB support will be disabled.
##
## -DENABLE_uLimeSDR=OFF because of FTD3XX library issues
############################################################
message(STATUS "Configuring LimeSuite - ${LIME_SUITE_BRANCH}")
ExternalProject_Add(LimeSuite
    DEPENDS SoapySDR
    GIT_REPOSITORY https://github.com/myriadrf/LimeSuite.git
    GIT_TAG ${LIME_SUITE_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DLIME_SUITE_EXTVER=${EXTRA_VERSION_INFO}
        -DWX_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_ROOT_DIR=${wxWidgets_ROOT_DIR}
        -DwxWidgets_LIB_DIR=${wxWidgets_LIB_DIR}
        -DSoapySDR_DIR=${CMAKE_INSTALL_PREFIX}
        -DFX3_SDK_PATH=${FX3_SDK_PATH}
        -DENABLE_uLimeSDR=OFF
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
