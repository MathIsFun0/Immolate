cmake_minimum_required(VERSION 3.10)
project(Immolate LANGUAGES CXX)

# Set C++ standard and required flags
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)
option(TRACY_ENABLE "" ON)
include_directories(
    ${PROJECT_SOURCE_DIR}/tracy
)

# Define sources for the library
set(LIB_SOURCES
    src/functions.hpp
    src/instance.hpp
    src/filters.cpp
    src/items.cpp
    src/rng.cpp
    src/search.cpp
    src/seed.cpp
    src/util.cpp
    src/functions.cpp
    tracy/tracy/Tracy.hpp
)

FetchContent_Declare (
    tracy
    GIT_REPOSITORY https://github.com/wolfpld/tracy.git
    GIT_TAG master
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable(tracy)

# Define sources for the executable
set(EXECUTABLE_SOURCES
    src/main.cpp
    tracy/TracyClient.cpp
)

# Set optimization flags based on the compiler
if(MSVC)
    set(OPTIMIZATION_FLAGS "/Ox")  # Full optimization for MSVC
else()
    set(OPTIMIZATION_FLAGS "-O3 -g -std=c++20 -Wall -Wextra -Wpedantic -Wno-c++17-extensions -gdwarf-3 -march=native -lpthread -ldl")  # Full optimization for GCC/Clang, plus debugging info
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OPTIMIZATION_FLAGS}")

# Arm specific flags, todo; properly test this
if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ffp-model=fast -fp-model=fast")
endif()

# Output compile_commands.json for clangd stuff
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(${PROJECT_NAME} STATIC ${LIB_SOURCES})

# Define BUILDING_DLL when compiling the DLL
target_compile_definitions(${PROJECT_NAME} PRIVATE BUILDING_DLL)

set_target_properties(${PROJECT_NAME} PROPERTIES
    PREFIX ""
    RUNTIME_OUTPUT_NAME "${PROJECT_NAME}"
    ARCHIVE_OUTPUT_NAME "${PROJECT_NAME}"
)

# Generate export header
include(GenerateExportHeader)
generate_export_header(${PROJECT_NAME}
    BASE_NAME IMMOLATE
    EXPORT_MACRO_NAME IMMOLATE_API
    EXPORT_FILE_NAME ImmolateExport.h
    STATIC_DEFINE IMMOLATE_BUILT_AS_STATIC
)

add_executable(immol ${EXECUTABLE_SOURCES})
target_link_libraries(immol ${PROJECT_NAME} TracyClient)