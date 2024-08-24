cmake_minimum_required(VERSION 3.10)
project(Immolate)

# Define sources for the library
set(LIB_SOURCES
    immolate.cpp
    immolate.hpp
    util.hpp
    instance.hpp
)

# Define sources for the executable
set(EXECUTABLE_SOURCES
    main.cpp
)

set(CMAKE_CXX_STANDARD 11)
# I need a better check for ARM before I re-add this
IF(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm") 
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ffp-model=fast /fp:fast -fp-model=fast") 
# I ran into issues when enabling this one on x86, so this check could cause some trouble down the road
ELSE(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")

ENDIF(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")

# Create the shared library (DLL)
add_library(${PROJECT_NAME} SHARED ${LIB_SOURCES})

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

# Create the executable and link it with the library
add_executable(immol ${EXECUTABLE_SOURCES})
target_link_libraries(immol ${PROJECT_NAME})
