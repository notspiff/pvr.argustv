find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
  pkg_check_modules (JSONCPP jsoncpp)
endif()

if(NOT JSONCPP_FOUND)
  find_path(JSONCPP_INCLUDE_DIR json/json.h
            PATH_SUFFIXES jsoncpp)
  find_library(JSONCPP_LIBRARY jsoncpp)
endif()

if(NOT JSONCPP_FOUND)
  message(STATUS "Building JsonCpp")
  include(ExternalProject)
  externalproject_add(JsonCpp
                      URL http://garr.dl.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz
                      PREFIX JsonCpp
                      PATCH_COMMAND patch -p0 < ${PROJECT_SOURCE_DIR}/01-jsoncpp-add-cmake-buildsystem.patch
                      CMAKE_ARGS -DCMAKE_CXX_FLAGS=-fPIC
                                 -DBUILD_SHARED_LIBS=0
                                 -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                                 -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                                 -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>)
  set(JSONCPP_INCLUDE_DIRS ${CMAKE_BINARY_DIR}/JsonCpp/include/jsoncpp)
  set(JSONCPP_LIBRARIES ${CMAKE_BINARY_DIR}/JsonCpp/lib/libjsoncpp.a)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JsonCpp DEFAULT_MSG JSONCPP_LIBRARIES JSONCPP_INCLUDE_DIRS)

mark_as_advanced(JSONCPP_INCLUDE_DIRS JSONCPP_LIBRARIES)
