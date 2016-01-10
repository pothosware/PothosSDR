############################################################
## Pothos SDR environment build sub-script
##
## This script builds the Pothos library and dependencies.
##
## * poco (dependency)
## * spuce (dependency)
## * muparserx (dependency)
## * serialization (dependency)
## * pothos (top level project)
############################################################

set(POCO_BRANCH poco-1.6.2)
set(SPUCE_BRANCH 0.4.3)
set(MUPARSERX_BRANCH master)
set(POTHOS_SERIALIZATION_BRANCH pothos-serialization-0.2.0)
set(POTHOS_BRANCH pothos-0.3.1)

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
		${PROJECT_SOURCE_DIR}/patches/spuce_fix_msvc14.diff
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

############################################################
## Build Pothos Serialization
############################################################
message(STATUS "Configuring PothosSerialization - ${POTHOS_SERIALIZATION_BRANCH}")
ExternalProject_Add(PothosSerialization
    GIT_REPOSITORY https://github.com/pothosware/pothos-serialization.git
    GIT_TAG ${POTHOS_SERIALIZATION_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(PothosSerialization SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/PothosSerialization
)

############################################################
## Build Pothos
############################################################
message(STATUS "Configuring Pothos - ${POTHOS_BRANCH}")
ExternalProject_Add(Pothos
    DEPENDS Poco PothosSerialization muparserx
    GIT_REPOSITORY https://github.com/pothosware/pothos.git
    GIT_TAG ${POTHOS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -Wno-dev
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPOTHOS_EXTVER=${EXTRA_VERSION_INFO}
        -DPoco_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/Poco
        -DENABLE_TOOLKITS=OFF
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)

ExternalProject_Get_Property(Pothos SOURCE_DIR)
install(
    FILES ${SOURCE_DIR}/LICENSE_1_0.txt
    DESTINATION licenses/Pothos
)
