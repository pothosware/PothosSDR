############################################################
## Pothos SDR environment build sub-script
##
## This script builds various common depedencies.
##
## * zeromq (gr-zeromq)
## * cppzmq (gr-zeromq)
## * poco (pothos framework + toolkits)
## * spuce (pothos-comms + plotters)
## * muparserx (pothos framework)
############################################################

set(ZEROMQ_BRANCH master)
set(CPPZMQ_BRANCH master)
set(POCO_BRANCH poco-1.6.2)
set(SPUCE_BRANCH 0.4.3)
set(MUPARSERX_BRANCH master)

############################################################
## Build ZeroMQ
############################################################
message(STATUS "Configuring ZeroMQ - ${ZEROMQ_BRANCH}")
ExternalProject_Add(ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/zeromq4-x.git
    GIT_TAG ${ZEROMQ_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/zeromq_readme_docs_path.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DHAVE_WS2_32=ON
        -DHAVE_RPCRT4=ON
        -DHAVE_IPHLAPI=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(ZeroMQ SOURCE_DIR)
install(
    FILES
        ${SOURCE_DIR}/COPYING
        ${SOURCE_DIR}/COPYING.LESSER
    DESTINATION licenses/ZeroMQ
)

############################################################
## Build CppZMQ
############################################################
message(STATUS "Configuring CppZMQ - ${CPPZMQ_BRANCH}")
ExternalProject_Add(CppZMQ
    DEPENDS ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/cppzmq.git
    GIT_TAG ${CPPZMQ_BRANCH}
    CONFIGURE_COMMAND echo "Configured"
    BUILD_COMMAND echo "Built"
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/zmq.hpp ${CMAKE_INSTALL_PREFIX}/include
)

ExternalProject_Get_Property(CppZMQ SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE
    DESTINATION licenses/CppZMQ
)

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
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_PYTHON=OFF
        -DBUILD_TESTING=OFF
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
## Build muparserx
############################################################
message(STATUS "Configuring muparserx - ${MUPARSERX_BRANCH}")
ExternalProject_Add(muparserx
    GIT_REPOSITORY https://github.com/beltoforion/muparserx.git
    GIT_TAG ${MUPARSERX_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(muparserx SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/License.txt
    DESTINATION licenses/muparserx
)
