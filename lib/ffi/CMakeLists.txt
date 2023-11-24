cmake_minimum_required(VERSION 3.0)
project(ffi LANGUAGES CXX C)                         

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

find_package(CommonAPI 3.2.0 REQUIRED)

include_directories(
  ./include
  /home/jinholee/dummie/src-gen/core
  ${COMMONAPI_INCLUDE_DIRS}
)

add_library(ffi
  SHARED
  commonapi.cpp
)
target_link_libraries(ffi CommonAPI)