cmake_minimum_required(VERSION 3.16)

project(riscv-sim)

add_subdirectory(src/pipeline)

set(CLI11_PRECOMPILED ON)
add_subdirectory(CLI11)
add_subdirectory(ELFIO)