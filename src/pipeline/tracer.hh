#ifndef TRACER_HH
#define TRACER_HH

#include <verilated_vcd_c.h>

#include "Vtop.h"
#include "Vtop_datapath.h"
#include "Vtop_imem.h"
#include "Vtop_pc_reg.h"
#include "Vtop_regfile.h"
#include "Vtop_riscv.h"
#include "Vtop_top.h"

#include <iostream>
#include <memory>
#include <string>

class Tracer final {

  std::unique_ptr<VerilatedVcdC> m_vcd{};
  uint32_t m_levels{};
  //
public:
  //
  enum DumpMode : uint32_t {
    COSIM = 0,
    REG_STATE,
    TACT,
  };

  bool is_end = false;
  DumpMode trace_mode{};
  //
public:
  Tracer(Vtop *top, const std::string &trace_path, enum DumpMode mode,
         uint32_t levels = 99)
      : m_vcd(std::make_unique<VerilatedVcdC>()), m_levels(levels),
        trace_mode(mode) {
    //
    top->trace(m_vcd.get(), m_levels);
    m_vcd->open(trace_path.c_str());
  }

private:
  void regfile_dump(const uint32_t *registers) {
    std::cout << std::setfill('0');
    constexpr std::size_t lineNum = 8;

    for (std::size_t i = 0; i < lineNum; ++i) {
      for (std::size_t j = 0; j < 32 / lineNum; ++j) {
        auto regIdx = j * lineNum + i;
        auto &reg = registers[regIdx];
        std::cout << "  [" << std::dec << std::setw(2) << regIdx << "] ";
        std::cout << "0x" << std::hex << std::setw(sizeof(reg) * 2) << reg;
      }
      std::cout << std::endl;
    }
  }

  void reg_state_dump(Vtop *top_module) {
    auto &pdatapath = top_module->top->riscv->dp;
    std::cout << "*********************************************************"
                 "**********************"
              << std::endl;
    //
    std::cout << "PC = "
              << "0x" << std::hex << pdatapath->pc_out << std::endl;
    std::cout << "CMD = " << std::hex << pdatapath->instr << std::endl;
    //
    if (pdatapath->reg_write) {
      int rd = (int)pdatapath->rd;
      std::string rd2str =
          (rd / 10) == 0 ? "0" + std::to_string(rd) : std::to_string(rd);
      std::cout << "[" << rd2str << "]";
      std::cout << " = " << std::hex << pdatapath->result << std::endl;
    }
    //
    else if (pdatapath->mem_write)
      std::cout << "MEM[" << std::hex << pdatapath->alu_out
                << "] = " << std::hex << pdatapath->write_data << std::endl;
    //
    regfile_dump(top_module->top->riscv->dp->rf->reg_file);
  }

  void cosim_dump(Vtop *top_module) {}
  void tact_dump(Vtop *top_module) {}

public:
  void dump(vluint64_t time) { m_vcd->dump(time); }

  void dump_state(Vtop *top_module) {
    //
    auto &pdatapath = top_module->top->riscv->dp;
    is_end = pdatapath->is_end;
    //
    if (pdatapath->valid) {

      switch (trace_mode) {
      case REG_STATE:
        reg_state_dump(top_module);
        break;
      case COSIM:
        cosim_dump(top_module);
        break;
      case TACT:
        tact_dump(top_module);
        break;
      default:
        break;
      }
    }
  }
};

#endif //! TRACER_HH