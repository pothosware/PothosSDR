############################################################
## Pothos SDR environment build sub-script
##
## This script builds various common depedencies.
##
## * pthreads (sdr hw libs)
## * libusb (sdr hw libs)
## * zeromq (gr-zeromq)
## * cppzmq (gr-zeromq)
## * poco (pothos framework + toolkits)
## * spuce (pothos-comms + plotters)
## * muparserx (pothos framework)
## * portaudio (gr-audio, pothos-audio)
## * wxwidgets (cubicsdr, limesuite)
## * faac (gr-drm)
## * faad2 (gr-drm)
## * cppunit (gnuradio)
## * gsl (gnuradio)
############################################################

set(PTHREADS_BRANCH master)
set(LIBUSB_BRANCH v1.0.21)
set(ZEROMQ_BRANCH master)
set(CPPZMQ_BRANCH master)
set(POCO_BRANCH poco-1.8.1)
set(SPUCE_BRANCH 0.4.3)
set(MUPARSERX_BRANCH v4.0.7)
set(PORTAUDIO_BRANCH master)
set(WXWIDGETS_BRANCH v3.1.0)
set(FAAC_BRANCH master)
set(FAAD2_BRANCH master)
set(CPPUNIT_BRANCH master)
set(GSL_BRANCH master)

############################################################
## Build Pthreads for win32
############################################################
MyExternalProject_Add(Pthreads
    GIT_REPOSITORY https://github.com/VFR-maniac/pthreads-win32.git
    GIT_TAG ${PTHREADS_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/pthreads_win32_vc14.diff
    CONFIGURE_COMMAND echo "Configure pthreads..."
    BUILD_COMMAND cd <SOURCE_DIR> && nmake VC
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING COPYING.LIB
)

ExternalProject_Get_Property(Pthreads SOURCE_DIR)

#external install commands, variables use build paths
install(FILES
    ${SOURCE_DIR}/pthread.h
    ${SOURCE_DIR}/sched.h
    ${SOURCE_DIR}/semaphore.h
    DESTINATION include)
install(FILES ${SOURCE_DIR}/pthreadVC2.lib DESTINATION lib)
install(FILES ${SOURCE_DIR}/pthreadVC2.dll DESTINATION bin)

#use these variable to setup pthreads in dependent projects
set(THREADS_PTHREADS_ROOT ${SOURCE_DIR})
set(THREADS_PTHREADS_INCLUDE_DIR ${THREADS_PTHREADS_ROOT})
set(THREADS_PTHREADS_WIN32_LIBRARY ${THREADS_PTHREADS_ROOT}/pthreadVC2.lib)

############################################################
## Build libusb-1.0
############################################################
MyExternalProject_Add(libusb
    GIT_REPOSITORY https://github.com/libusb/libusb.git
    GIT_TAG ${LIBUSB_BRANCH}
    CONFIGURE_COMMAND echo "Configure libusb..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/msvc/libusb_dll_${MSVC_VERSION_YEAR}.vcxproj
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING
)

ExternalProject_Get_Property(libusb SOURCE_DIR)

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
MyExternalProject_Add(ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/zeromq4-1.git
    GIT_TAG ${ZEROMQ_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DHAVE_WS2_32=ON
        -DHAVE_RPCRT4=ON
        -DHAVE_IPHLAPI=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/zmq
    INSTALL_COMMAND
        #the actual cmake install target
        ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
        #zmq has non standard installation rules, move selected files from zmq -> root
        && ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX}/zmq/bin ${CMAKE_INSTALL_PREFIX}/bin
        && ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX}/zmq/lib ${CMAKE_INSTALL_PREFIX}/lib
        && ${CMAKE_COMMAND} -E copy_directory ${CMAKE_INSTALL_PREFIX}/zmq/include ${CMAKE_INSTALL_PREFIX}/include
        && ${CMAKE_COMMAND} -E remove_directory ${CMAKE_INSTALL_PREFIX}/zmq
    LICENSE_FILES COPYING COPYING.LESSER
)

set(ZEROMQ_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
set(ZEROMQ_LIBRARIES ${CMAKE_INSTALL_PREFIX}/lib/libzmq-v${MSVC_VERSION_XX}0-mt-4_1_7.lib)

############################################################
## Build CppZMQ
############################################################
MyExternalProject_Add(CppZMQ
    DEPENDS ZeroMQ
    GIT_REPOSITORY https://github.com/zeromq/cppzmq.git
    GIT_TAG ${CPPZMQ_BRANCH}
    CONFIGURE_COMMAND echo "Configured"
    BUILD_COMMAND echo "Built"
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/zmq.hpp ${CMAKE_INSTALL_PREFIX}/include
    LICENSE_FILES LICENSE
)

############################################################
## Build Poco
############################################################
MyExternalProject_Add(Poco
    GIT_REPOSITORY https://github.com/pocoproject/poco.git
    GIT_TAG ${POCO_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE
)

############################################################
## Build Spuce
############################################################
MyExternalProject_Add(Spuce
    GIT_REPOSITORY https://github.com/audiofilter/spuce.git
    GIT_TAG ${SPUCE_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_PYTHON=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_PREFIX_PATH=${QT5_LIB_PATH}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES LICENSE_1_0.txt
)

############################################################
## Build muparserx
############################################################
MyExternalProject_Add(muparserx
    GIT_REPOSITORY https://github.com/beltoforion/muparserx.git
    GIT_TAG ${MUPARSERX_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES License.txt
)

############################################################
## Build PortAudio
############################################################
MyExternalProject_Add(PortAudio
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
    LICENSE_FILES LICENSE.txt
)

ExternalProject_Get_Property(PortAudio SOURCE_DIR)
ExternalProject_Get_Property(PortAudio BINARY_DIR)

#external install commands, variables use build paths
install(DIRECTORY ${SOURCE_DIR}/include DESTINATION .)
install(FILES ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.lib DESTINATION lib)
install(FILES ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.dll DESTINATION bin)

#use these variable to setup portaudio in dependent projects
set(PORTAUDIO_INCLUDE_DIR ${SOURCE_DIR}/include)
set(PORTAUDIO_LIBRARY ${BINARY_DIR}/${CMAKE_BUILD_TYPE}/portaudio_x64.lib)


############################################################
## Build wxWidgets
############################################################
MyExternalProject_Add(wxWidgets
    GIT_REPOSITORY https://github.com/wxWidgets/wxWidgets.git
    GIT_TAG ${WXWIDGETS_BRANCH}
    CONFIGURE_COMMAND echo "Configure wxwidgets..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/build/msw/wx_vc${MSVC_VERSION_XX}.sln
    INSTALL_COMMAND echo "..."
    LICENSE_FILES README.md
)

ExternalProject_Get_Property(wxWidgets SOURCE_DIR)

#use these variable to setup wxWidgets in dependent projects
set(wxWidgets_ROOT_DIR ${SOURCE_DIR})
set(wxWidgets_LIB_DIR ${wxWidgets_ROOT_DIR}/lib/vc_x64_lib)

############################################################
## Build FAAC
############################################################
MyExternalProject_Add(faac
    GIT_REPOSITORY https://github.com/Arcen/faac.git
    GIT_TAG ${FAAC_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/faac_dll_project_files.diff
    CONFIGURE_COMMAND echo "Configure faac..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/libfaac/libfaac_dll.sln
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING
)

ExternalProject_Get_Property(faac SOURCE_DIR)

#external install commands, variables use build paths
install(FILES ${SOURCE_DIR}/include/faac.h DESTINATION include)
install(FILES ${SOURCE_DIR}/include/faaccfg.h DESTINATION include)
install(FILES ${SOURCE_DIR}/libfaac/ReleaseDLL/libfaac.lib DESTINATION lib)
install(FILES ${SOURCE_DIR}/libfaac/ReleaseDLL/libfaac.dll DESTINATION bin)

#use these variable to setup faac in dependent projects
set(Faac_INCLUDE_DIR ${SOURCE_DIR}/include)
set(Faac_LIBRARY ${SOURCE_DIR}/libfaac/ReleaseDLL/libfaac.lib)

############################################################
## Build FAAD2
############################################################
MyExternalProject_Add(faad2
    GIT_REPOSITORY https://github.com/dsvensson/faad2.git
    GIT_TAG ${FAAD2_BRANCH}
    PATCH_COMMAND
        ${GIT_EXECUTABLE} reset --hard HEAD &&
        ${GIT_EXECUTABLE} clean -dfx &&
        ${GIT_EXECUTABLE} apply ${PROJECT_SOURCE_DIR}/patches/faad2_dll_project_files.diff
    CONFIGURE_COMMAND echo "Configure faad2..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/libfaad/libfaad2_dll.sln
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING
)

ExternalProject_Get_Property(faad2 SOURCE_DIR)

#external install commands, variables use build paths
install(FILES ${SOURCE_DIR}/include/faad.h DESTINATION include)
install(FILES ${SOURCE_DIR}/include/neaacdec.h DESTINATION include)
install(FILES ${SOURCE_DIR}/libfaad/ReleaseDLL/libfaad2.lib DESTINATION lib)
install(FILES ${SOURCE_DIR}/libfaad/ReleaseDLL/libfaad2.dll DESTINATION bin)

############################################################
## Build FDK-AAC
############################################################
MyExternalProject_Add(fdk_aac
    GIT_REPOSITORY "https://github.com/argilo/fdk-aac.git"
    GIT_TAG 3b63dab59416a629f3de82463eb3875319a086d5
    CONFIGURE_COMMAND echo "..."
    BUILD_COMMAND cd <SOURCE_DIR> && nmake -f Makefile.vc
    INSTALL_COMMAND cd <SOURCE_DIR> && nmake -f Makefile.vc prefix=<BINARY_DIR> install
    LICENSE_FILES NOTICE
)

ExternalProject_Get_Property(fdk_aac BINARY_DIR)
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${BINARY_DIR}/include)
set(FDK_AAC_INCLUDE_DIR ${BINARY_DIR}/include)
set(FDK_AAC_LIBRARY ${BINARY_DIR}/lib/fdk-aac.lib)

############################################################
## Build CPPUNIT
############################################################
MyExternalProject_Add(CppUnit
    GIT_REPOSITORY git://anongit.freedesktop.org/git/libreoffice/cppunit/
    GIT_TAG ${CPPUNIT_BRANCH}
    PATCH_COMMAND ${GIT_PATCH_HELPER} --git ${GIT_EXECUTABLE}
        ${PROJECT_SOURCE_DIR}/patches/cppunit_dll_project_files.diff
    CONFIGURE_COMMAND echo "Configure CppUnit..."
    BUILD_COMMAND msbuild
        /p:Configuration=Release,Platform=x64
        /m <SOURCE_DIR>/src/cppunit/cppunit_dll.vcxproj
    INSTALL_COMMAND echo "..."
    LICENSE_FILES COPYING
)

ExternalProject_Get_Property(CppUnit SOURCE_DIR)

#external install commands, variables use build paths
install(DIRECTORY ${SOURCE_DIR}/include/cppunit DESTINATION include)
install(FILES ${SOURCE_DIR}/src/cppunit/ReleaseDll/cppunit_dll.lib DESTINATION lib)
install(FILES ${SOURCE_DIR}/src/cppunit/ReleaseDll/cppunit_dll.dll DESTINATION bin)

#use these variable to setup cppunit in dependent projects
set(CPPUNIT_INCLUDE_DIRS ${SOURCE_DIR}/include)
set(CPPUNIT_LIBRARIES ${SOURCE_DIR}/src/cppunit/ReleaseDll/cppunit_dll.lib)

############################################################
## Build GSL
############################################################
MyExternalProject_Add(gsl
    GIT_REPOSITORY https://github.com/ampl/gsl.git
    GIT_TAG ${GSL_BRANCH}
    CMAKE_DEFAULTS ON
    CMAKE_ARGS
        -Wno-dev
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    LICENSE_FILES COPYING
)

set(GSL_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/include)
set(GSL_LIBRARY ${CMAKE_INSTALL_PREFIX}/lib/gsl.lib)
set(GSL_CBLAS_LIBRARY ${CMAKE_INSTALL_PREFIX}/lib/gslcblas.lib)
