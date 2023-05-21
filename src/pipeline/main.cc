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

constexpr int end = 1000;

int parse_args(std::string &elf_path, std::string &vcd_path, int &end_time,
               Tracer::DumpMode& trace_mode, int argc, char **argv) {
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

  app.add_option("--trace", trace_mode, "Trace dump mode")
      ->default_val(Tracer::DumpMode::REG_STATE);
  //
  CLI11_PARSE(app, argc, argv);
}

int main(int argc, char **argv) {

  Tracer::DumpMode trace_mode{};
  std::string elf_path{}, vcd_path{};
  int end_time = 0;
  //
  if (parse_args(elf_path, vcd_path, end_time, trace_mode, argc, argv) == 0)
    return 0;

  // Init verialtor
  Verilated::commandArgs(argc, argv);
  //
  auto top_module = std::make_unique<Vtop>();
  Verilated::traceEverOn(true);

  Tracer my_tracer(top_module.get(), vcd_path, trace_mode);
  ELFLoader my_loader{elf_path};
  //
  my_loader.load(top_module.get());

  int clock = 0;
  for (vluint64_t vtime = 0; !Verilated::gotFinish() && vtime <= end; ++vtime) {
    //
    if (vtime % 8 == 0) {
      // always @(negedge clk)
      if (!clock and !my_tracer.is_end)
        my_tracer.dump_state(top_module.get());

      clock ^= 1;
    }
    //
    top_module->clk = clock;
    top_module->eval();
    my_tracer.dump(vtime);
  }

  top_module->final();

  return 0;
}