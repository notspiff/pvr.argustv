PROJECT(pvr.argustv)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

ENABLE_LANGUAGE(CXX)

FIND_PACKAGE(JsonCpp REQUIRED)
FIND_PACKAGE(xbmc REQUIRED)
FIND_PACKAGE(xbmcplatform REQUIRED)

addon_version(pvr.argustv ARGUSTV)

INCLUDE_DIRECTORIES(${xbmcplatform_INCLUDE_DIRS}
                    ${JSONCPP_INCLUDE_DIR}
                    ${XBMC_INCLUDE_DIR}
                    ${PROJECT_SOURCE_DIR}/src)

IF (NOT WIN32)
  include(AddOptions.cmake)
  add_options(ALL_LANGUAGES ALL_BUILDS "-fPIC")
ENDIF(NOT WIN32)

ADD_SUBDIRECTORY(src/lib/tsreader)

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

SET(DEPLIBS ${xbmcplatform_LIBRARIES}
            ${JSONCPP_LIBRARY} tsreader)

build_addon(pvr.argustv SOURCES DEPLIBS ARGUSTV_VERSION)
install_addon(pvr.argustv ${ARGUSTV_VERSION})

