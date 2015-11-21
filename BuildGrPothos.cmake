############################################################
## Pothos SDR environment build sub-script
##
## This script builds GNU Radio bindings
##
## * gr-pothos (toolkit bindings project)
############################################################

set(GR_POTHOS_BRANCH master)

############################################################
## GR Pothos bindings
############################################################
message(STATUS "Configuring gr-pothos - ${GR_POTHOS_BRANCH}")
ExternalProject_Add(GrPothos
    DEPENDS GNURadio
    GIT_REPOSITORY https://github.com/pothosware/gr-pothos.git
    GIT_TAG ${GR_POTHOS_BRANCH}
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DPYTHON_EXECUTABLE=${PYTHON2_EXECUTABLE}
        -DBOOST_ROOT=${BOOST_ROOT}
        -DBOOST_LIBRARYDIR=${BOOST_LIBRARYDIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --target install
)
