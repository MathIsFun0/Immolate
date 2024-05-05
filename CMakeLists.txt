cmake_minimum_required(VERSION 3.10)
project(Immolate)

set(SOURCES
    immolate.cpp
    immolate.hpp
    util.hpp
    instance.hpp
)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

add_executable(${PROJECT_NAME} ${SOURCES})