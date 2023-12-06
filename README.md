<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="docs/riscv pic.png" alt="Project logo"></a>
</p>

<h3 align="center">Spek CPU</h3>

<div align="center">

  [![Status](https://img.shields.io/badge/status-active-success.svg)]() 
  [![GitHub Issues](https://img.shields.io/github/issues/kylelobo/The-Documentation-Compendium.svg)](https://github.com/sprsr/rv32_processor/issues)
  [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/kylelobo/The-Documentation-Compendium.svg)](https://github.com/sprsr/rv32_processor/pulls)
  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> A simple Risc V CPU supporting a 5 stage pipeline and in conformance with RISC V 32I Instruction set.  <br>
  A single core capable of handling every RV32I Instruction.  Minimal verification has been conducted thusfar, however the framework to run simulations and view waveforms are in place.
    <br> 
</p>

## 📝 Table of Contents
- [About](#about)
- [Getting Started](#getting_started)
- [Built Using](#built_using)
- [Contributing](../CONTRIBUTING.md)
- [Authors](#authors)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>
This project was started to gain experience in digital design and brush up on chip architecture while becoming equipped with RISC V ISA.  RTL is described in Verilog 2012 and EDA tools consist of Icarus Verilog & Yosys. I also found the open source risc v assembler python package provided by _ very useful when testing in my Test Bench.  
The RV32 Processor is architected as a single core standard 5 stage pipeline.  Only Fetch and Decode stages will stall in two cases:  Failed Branch Prediction and sequential data conflict when the first instruction must write from data memory.  

## 🏁 Getting Started <a name = "getting_started"></a>
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

Verify iverilog and gtkwave are installed and run the following commands from root:

    cd run
    source run_spek.csh


### Prerequisites
What things you need to install the software and how to install them.
- [Icarus Verilog](https://github.com/steveicarus/iverilog) - Compiler
- [GTKWave](https://github.com/gtkwave/gtkwave) - Waveform Simulator
- [YoSys](https://github.com/YosysHQ/yosys) - Synthesis Suite
- [Risc V Assembler Python Package] (https://github.com/celebi-pkg/riscv-assembler) - Assembler helper


## ⛏️ Built Using <a name = "built_using"></a>
- [Verilog 2012](https://ece.uah.edu/~gaede/cpe526/2012%20System%20Verilog%20Language%20Reference%20Manual.pdf) - Language
- [Icarus Verilog](https://github.com/steveicarus/iverilog) - Compiler
- [GTKWave](https://github.com/gtkwave/gtkwave) - Waveform Simulator
- [Risc V Manual]([https://github.com/YosysHQ/yosys](https://riscv.org/wp-content/uploads/2019/12/riscv-spec-20191213.pdf)) - Instruction Set Architecture

## ✍️ Authors <a name = "authors"></a>
- [@sprsr](https://github.com/sprsr) - Idea & Initial work



## 🎉 Acknowledgements <a name = "acknowledgement"></a>
- Open Source EDA Tools
- Risc V Org
- [Onur Mutlu](ttps://www.youtube.com/channel/UCIwQ8uOeRFgOEvBLYc3kc3g) (Computer Architecture lectures on Youtube)
