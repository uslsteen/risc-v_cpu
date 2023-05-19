#ifndef ELFLOADER_HH
#define ELFLOADER_HH

#include "Vtop.h"
#include "Vtop_datapath.h"
#include "Vtop_pc_reg.h"
#include "Vtop_imem.h"
#include "Vtop_riscv.h"
#include "Vtop_top.h"
#include <elfio/elfio.hpp>
#include <string>

using word_t = std::uint32_t;
using addr_t = std::uint32_t;
using byte_t = std::uint8_t;

class ELFLoader final {
  ELFIO::elfio m_reader{};

public:
  ELFLoader(const std::string &filepath) {
    if (!m_reader.load(filepath))
      throw std::invalid_argument("Bad ELF filename : " + filepath);
  }
  //
  void load(Vtop *top_module) {
    //
    top_module->top->riscv->dp->pcreg->pc = get_entry();
    //
    // ->top->riscv->datapath->pcreg->pc = get_entry();
    //
    //! NOTE: Check for 32-bit
    if (m_reader.get_class() != ELFIO::ELFCLASS32)
      throw std::runtime_error("Wrong ELF file class.");

    //! NOTE: Check for little-endian
    if (m_reader.get_encoding() != ELFIO::ELFDATA2LSB)
      throw std::runtime_error("Wrong ELF encoding.");

    ELFIO::Elf_Half seg_num = m_reader.segments.size();
    //
    for (size_t seg_i = 0; seg_i < seg_num; ++seg_i) {
      const ELFIO::segment *segment = m_reader.segments[seg_i];
      if (segment->get_type() != ELFIO::PT_LOAD)
        continue;

      addr_t address = segment->get_virtual_address();
      //
      size_t filesz = static_cast<size_t>(segment->get_file_size());
      //
      //! NOTE: Load into RAM
      if (filesz) {
        auto beg = reinterpret_cast<const byte_t *>(segment->get_data());
        auto dst = reinterpret_cast<byte_t *>(top_module->top->imem->RAM);
        //
        std::copy(beg, beg + filesz, dst + address);
      }
    }
  }
  //
  addr_t get_entry() const { return static_cast<addr_t>(m_reader.get_entry()); }
};

#endif //! ELFLOADER_HH