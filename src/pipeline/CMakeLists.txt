# NOTE: first of all check verilator package
find_package(verilator REQUIRED HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
#
if(NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Install it, or check setting of the $VERILATOR_ROOT environment variable")
endif()

add_executable(riscv_sim  main.cc)
target_compile_features(riscv_sim  PRIVATE cxx_std_20)
target_compile_options(riscv_sim  PRIVATE -Wall -Wextra -Wpedantic)

verilate(
  riscv_sim 
  SOURCES
  top.v
  TRACE
  VERILATOR_ARGS
  -cc
  -Wall
  --exe
)

#
target_link_libraries(riscv_sim PRIVATE CLI11::CLI11)
target_include_directories(riscv_sim SYSTEM PRIVATE ${CMAKE_SOURCE_DIR}/thirdparty/CLI11/include)

target_link_libraries(riscv_sim  PRIVATE elfio::elfio)
target_include_directories(riscv_sim SYSTEM PRIVATE ${CMAKE_SOURCE_DIR}/thirdparty/ELFIO/)


target_include_directories(riscv_sim SYSTEM PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/riscv_sim.dir/Vtop.dir)

target_include_directories(riscv_sim SYSTEM PRIVATE ${VERILATOR_ROOT}/include)