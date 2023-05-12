#ifndef TRACER_HH
#define TRACER_HH

#include <verilated_vcd_c.h>

#include "Vtop.h"
// #include "Vtop_datapath.h"
// #include "Vtop_pcReg.h"
// #include "Vtop_riscv.h"
#include "Vtop_imem.h"
#include "Vtop_top.h"

#include <iostream>
#include <memory>
#include <string>

//! NOTE: it should just do:

// VerilatedVcdC *vcd = nullptr;
// vcd = new VerilatedVcdC;
// top_module->trace(vcd, 99); // Trace 99 levels of hierarchy
// vcd->open("out.vcd");

class Tracer final {

  std::unique_ptr<VerilatedVcdC> m_vcd{};
  uint32_t m_levels{};
  //
public:
  Tracer(Vtop *top, const std::string &trace_path, uint32_t levels = 99)
      : m_vcd(std::make_unique<VerilatedVcdC>()), m_levels(levels) {
    top->trace(m_vcd.get(), m_levels);
    m_vcd->open(trace_path.c_str());
  }

  void dump(vluint64_t time) { m_vcd->dump(time); }
};

#endif //! TRACER_HH