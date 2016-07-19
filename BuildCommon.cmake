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

set(PTHREADS_BRANCH master)
set(LIBUSB_BRANCH master) #> v1.0.20 for vc14 support
set(ZEROMQ_BRANCH master)
set(CPPZMQ_BRANCH master)
set(POCO_BRANCH poco-1.7.4)
set(SPUCE_BRANCH 0.4.3)
set(MUPARSERX_BRANCH v4.0.7)
set(PORTAUDIO_BRANCH master)

############################################################
## Build Pthreads for win32
############################################################
message(STATUS "Configuring Pthreads - ${PTHREADS_BRANCH}")
ExternalProject_Add(Pthreads
    GIT_REPOSITORY https://github.com/VFR-maniac/pthreads-win32.git
    GIT_TAG ${PTHREADS_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/pthreads_win32_vc14.diff &&
        ${CMAKE_COMMAND} -E copy
            ${PROJECT_SOURCE_DIR}/patches/pthreads_win32_CMakeLists.txt
            <SOURCE_DIR>/CMakeLists.txt
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DLIBNAME=pthreadVC${MSVC_VERSION}
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(Pthreads SOURCE_DIR)
install(
    FILES
        ${SOURCE_DIR}/COPYING
        ${SOURCE_DIR}/COPYING.LIB
    DESTINATION licenses/Pthreads
)

#use these variable to setup pthreads in dependent projects
set(THREADS_PTHREADS_ROOT ${SOURCE_DIR})
set(THREADS_PTHREADS_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include)
set(THREADS_PTHREADS_WIN32_LIBRARY ${CMAKE_INSTALL_PREFIX}/lib/pthreadVC${MSVC_VERSION}.lib)

############################################################
## Build libusb-1.0
############################################################

if (MSVC12)
    set(LIBUSB_DLL_PROJ libusb_dll_2013.vcxproj)
endif ()
if (MSVC14)
    set(LIBUSB_DLL_PROJ libusb_dll_2015.vcxproj)
endif ()

message(STATUS "Configuring libusb - ${LIBUSB_BRANCH}")
ExternalProject_Add(libusb
    GIT_REPOSITORY https://github.com/libusb/libusb.git
    GIT_TAG ${LIBUSB_BRANCH}
    CONFIGURE_COMMAND echo "Configure libusb..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/msvc/${LIBUSB_DLL_PROJ}
    INSTALL_COMMAND echo "..."
)

ExternalProject_Get_Property(libusb SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/COPYING
    DESTINATION licenses/libusb
)

#external install commands, variables use build paths
install(FILES ${SOURCE_DIR}/libusb/libusb.h DESTINATION include/libusb-1.0)
install(FILES ${SOURCE_DIR}/x64/Release/dll/libusb-1.0.lib DESTINATION lib)
install(FILES ${SOURCE_DIR}/x64/Release/dll/libusb-1.0.dll DESTINATION bin)

#use these variable to setup libusb in dependent projects
set(LIBUSB_ROOT ${SOURCE_DIR})
set(LIBUSB_INCLUDE_DIR ${SOURCE_DIR}/libusb)
set(LIBUSB_LIBRARIES ${SOURCE_DIR}/x64/Release/dll/libusb-1.0.lib)

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
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
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

############################################################
## Build PortAudio
############################################################
message(STATUS "Configuring PortAudio - ${PORTAUDIO_BRANCH}")
ExternalProject_Add(PortAudio
    GIT_REPOSITORY https://github.com/EddieRingle/portaudio.git #git mirror
    GIT_TAG ${PORTAUDIO_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/portaudio_no_ksguid_lib.diff
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND echo "..."
)

ExternalProject_Get_Property(PortAudio SOURCE_DIR)
ExternalProject_Get_Property(PortAudio BINARY_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE.txt
    DESTINATION licenses/PortAudio
)

#external install commands, variables use build paths
install(DIRECTORY ${SOURCE_DIR}/include DESTINATION .)
install(FILES ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.lib DESTINATION lib)
install(FILES ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.dll DESTINATION bin)

#use these variable to setup portaudio in dependent projects
set(PORTAUDIO_INCLUDE_DIR ${SOURCE_DIR}/include)
set(PORTAUDIO_LIBRARY ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.lib)
