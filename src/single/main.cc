// verilator  -Wno-COMBDLY -Wno-IMPLICIT -Wno-WIDTH --build --exe --trace -cc
// top.v main.cpp
// ./obj_dir/Vtop
// gtkwave ./out.vcd
#include <CLI/CLI.hpp>

#include "elfloader.hh"
#include "tracer.hh"
//
#include <array>
#include <stdlib.h>
#include <string>

void parse_args(std::string &elf_path, std::string &vcd_path, int argc,
                char **argv) {
  //
  CLI::App app{"Verilator tool RISCV simulator"};
  app.add_option("--elf-path", elf_path, "Path to elf file")
      ->required()
      ->check(CLI::ExistingFile);
  //
  app.add_option("--vcd-path", vcd_path, "Path to {name}.vcd file")
      ->default_val("out.vcd");

  app.add_option("--end-time", end_time, "Set end time of simulation")
      ->default_val(1000);
  //
  CLI11_PARSE(app, argc, argv);
  return 0;
}

int main(int argc, char **argv) {

  std::string elf_path{}, vcd_path{};
  parse_args(elf_path, vcd_path, argc, argv);

  // Init verialtor
  Verilated::commandArgs(argc, argv);
  //
  auto top_module = std::make_unique<Vtop>();
  Verilated::traceEverOn(true);

  Tracer my_tracer(top_module.get(), vcd_path);
  ELFLoader my_loader(elf_path);
  //
  my_loader.load(top_module);
}