cmake_minimum_required(VERSION 3.0)
project(HeadUnit-ffi LANGUAGES CXX C)                         

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

find_package(CommonAPI 3.2.0 REQUIRED)
find_package(CarControl-someip REQUIRED)
# find_package(CanReceiver-someip REQUIRED)
# find_package(CarInfo-someip REQUIRED)

include_directories(
  ./include
  ./src-gen/core
  ./src-gen/someip
  ${CANRECEIVER_INCLUDE_DIRS}
  ${CARCONTROL_INCLUDE_DIRS}
  ${CARINFO_INCLUDE_DIRS}
  ${COMMONAPI_INCLUDE_DIRS}
)

add_library(HeadUnit-someip
  SHARED
  src/commonapi.cpp
)
target_link_libraries(HeadUnit-someip CommonAPI)