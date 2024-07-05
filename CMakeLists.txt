cmake_minimum_required(VERSION 3.0)
project(HeadUnit-ffi LANGUAGES CXX C)                         

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

### PACKAGES ###
find_package(CommonAPI REQUIRED)
find_package(CommonAPI-SomeIP REQUIRED)

# APP_INFO
set(APP_PACKAGE_NAME commonapi)
set(MAJOR_VERSION 0)
set(MINOR_VERSION 1)

include_directories(
  ./lib/ffi/include
  ./lib/ffi/src-gen/core
  ./lib/ffi/src-gen/someip
  ${COMMONAPI_INCLUDE_DIRS}
  ${COMMONAPI_SOMEIP_INCLUDE_DIRS}
)

add_library(myffi
  SHARED
  ./lib/ffi/src/commonapi.cpp
  ./lib/ffi/src/CarControlProxy.cpp
  ./lib/ffi/src/HeadUnitStubImpl.cpp
)
target_link_libraries(myffi CommonAPI)

### Library Sources ###
FILE(GLOB CARCONTROL_LIB_SRCS ./lib/ffi/src-gen/someip/v0/commonapi/CarControl*.cpp)
add_library(CarControl-someip SHARED ${CARCONTROL_LIB_SRCS})
target_link_libraries(CarControl-someip CommonAPI CommonAPI-SomeIP)

FILE(GLOB HEADUNIT_LIB_SRCS ./lib/ffi/src-gen/someip/v0/commonapi/HeadUnit*.cpp)
add_library(HeadUnit-someip SHARED ${HEADUNIT_LIB_SRCS})
target_link_libraries(HeadUnit-someip CommonAPI CommonAPI-SomeIP)

# Include GNUInstallDirs to use standard install directories
include(GNUInstallDirs)

# Install libraries
install(TARGETS myffi CarControl-someip HeadUnit-someip
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})