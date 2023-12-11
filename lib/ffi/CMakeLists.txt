cmake_minimum_required(VERSION 3.0)
project(ffi LANGUAGES CXX C)                         

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

find_package(CommonAPI 3.2.0 REQUIRED)

include_directories(
  ./include
  ~/meta-car_control/car_control/src-gen/core
  ~/meta-car_info/car_info/src-gen/core
  ~/DES_Head-Unit/can_receiver/src-gen/core
  ${COMMONAPI_INCLUDE_DIRS}
)

add_library(ffi
  SHARED
  commonapi.cpp
)
target_link_libraries(ffi CommonAPI)