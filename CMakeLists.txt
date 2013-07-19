PROJECT(pvr.argustv)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

ENABLE_LANGUAGE(CXX)

FIND_PACKAGE(xbmc REQUIRED)
FIND_PACKAGE(xbmcplatform REQUIRED)

addon_version(pvr.argustv ARGUSTV)

INCLUDE_DIRECTORIES(${xbmcplatform_INCLUDE_DIRS}
                    ${XBMC_INCLUDE_DIR}
                    ${PROJECT_SOURCE_DIR}/src)

IF (NOT WIN32)
  add_options(ALL_LANGUAGES ALL_BUILDS "-fPIC")
ENDIF(NOT WIN32)

SET(SOURCES src/activerecording.cpp
            src/argustvrpc.cpp
            src/channel.cpp
            src/client.cpp
            src/epg.cpp
            src/guideprogram.cpp
            src/KeepAliveThread.cpp
            src/pvrclient-argustv.cpp
            src/recording.cpp
            src/recordinggroup.cpp
            src/recordingsummary.cpp
            src/tools.cpp
            src/upcomingrecording.cpp
            src/uri.cpp
            src/utils.cpp)

SET(DEPLIBS ${xbmcplatform_LIBRARIES} tsreader)

FIND_PACKAGE(JsonCpp)
IF(JSONCPP_FOUND)
  LIST(APPEND DEPLIBS ${JSONCPP_LIBRARY})
  LIST(APPEND INCLUDES ${JSONCPP_INCLUDE_DIR})
ELSE(JSONCPP_FOUND)
  MESSAGE(STATUS "Building JsonCpp")
  INCLUDE(ExternalProject)
  ExternalProject_ADD(JsonCpp
                      URL http://garr.dl.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz
                      PREFIX JsonCpp
                      PATCH_COMMAND patch -p0 < ${PROJECT_SOURCE_DIR}/01-jsoncpp-add-cmake-buildsystem.patch
                      CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>)
  LIST(APPEND INCLUDES ${CMAKE_BINARY_DIR}/JsonCpp/include/jsoncpp)
  LIST(APPEND DEPLIBS ${CMAKE_BINARY_DIR}/JsonCpp/lib/libjsoncpp.a)
ENDIF(JSONCPP_FOUND)

INCLUDE_DIRECTORIES(${INCLUDES})

ADD_SUBDIRECTORY(src/lib/tsreader)

build_addon(pvr.argustv SOURCES DEPLIBS ARGUSTV_VERSION)
install_addon(pvr.argustv ${ARGUSTV_VERSION})
