cmake_minimum_required(VERSION 3.0)
project(HeadUnit-ffi LANGUAGES CXX C)                         

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

### PACKAGES ###
find_package(CommonAPI REQUIRED)
find_package(CommonAPI-SomeIP REQUIRED)
find_package(CarControl-someip REQUIRED)
# find_package(CanReceiver-someip REQUIRED)
# find_package(CarInfo-someip REQUIRED

# APP_INFO
set(APP_PACKAGE_NAME commonapi)
set(MAJOR_VERSION 0)
set(MINOR_VERSION 1)

include_directories(
  ./include
  ./src-gen/core
  ./src-gen/someip
  ${CANRECEIVER_INCLUDE_DIRS}
  ${CARCONTROL_INCLUDE_DIRS}
  ${CARINFO_INCLUDE_DIRS}
  ${COMMONAPI_INCLUDE_DIRS}
  ${COMMONAPI_SOMEIP_INCLUDE_DIRS}
)

FILE(GLOB PRJ_SOMEIP_LIB_SRCS ./src-gen/someip/v${MAJOR_VERSION}/${APP_PACKAGE_NAME}/*.cpp)

add_library(HeadUnit-someip
  SHARED
  src/commonapi.cpp
  src/HeadUnitStubImpl.cpp
  ${PRJ_SOMEIP_LIB_SRCS}
)
target_link_libraries(HeadUnit-someip CommonAPI CommonAPI-SomeIP)