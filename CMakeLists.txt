cmake_minimum_required(VERSION 3.10)
project(Immolate)

set(SOURCES
    immolate.cpp
    immolate.hpp
    util.hpp
    instance.hpp
    main.cpp
)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Create the shared library (DLL)
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# Define BUILDING_DLL when compiling the DLL
target_compile_definitions(${PROJECT_NAME} PRIVATE BUILDING_DLL)

# Set properties for the shared library
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