cmake_minimum_required(VERSION 3.7) # 3.1 << C_STANDARD 11

project(Immolate LANGUAGES C)

find_package(OpenCL REQUIRED)

add_executable(${PROJECT_NAME} immolate.c)

target_link_libraries(${PROJECT_NAME} PRIVATE OpenCL::OpenCL)

set_target_properties(${PROJECT_NAME} PROPERTIES C_STANDARD 11
                                                 C_STANDARD_REQUIRED ON
                                                 C_EXTENSIONS OFF)

target_compile_definitions(${PROJECT_NAME} PRIVATE CL_TARGET_OPENCL_VERSION=100)