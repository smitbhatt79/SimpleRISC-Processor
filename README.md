# SimpleRISC Processor

## Overview

This project implements a **SimpleRISC Processor** in Verilog, designed to simulate a basic RISC architecture. It includes modular components for instruction handling, arithmetic operations, memory interaction, and control signal generation. The system is suitable for educational use, custom extension, or as a foundational processor model.

---

## How to Run (on Linux or PowerShell)

### 1. Compile the Verilog files:

```bash
iverilog -o processor_sim \
ALUComponents.v \
BasicComponents.v \
ControlUnit.v \
InstructionComponents.v \
MemoryComponents.v \
RegisterComponents.v \
SimpleRISC_Processor.v \
testbench.v
```

### 2. Run the simulation:

```bash
vvp processor_sim
```

### 3. View waveforms (optional):

If your testbench uses `$dumpfile("waveform.vcd")` and `$dumpvars`, open the waveform file with GTKWave:

```bash
gtkwave waveform.vcd
```

---

## Project Structure

### Core Modules

* **SimpleRISC\_Processor.v** – Top-level module integrating all components.
* **ControlUnit.v** – Generates control signals based on instruction type.
* **ALUComponents.v** – Performs arithmetic and logical operations.
* **InstructionComponents.v** – Parses and decodes machine instructions.
* **MemoryComponents.v** – Implements data and instruction memory.
* **RegisterComponents.v** – Handles the register file and associated operations.
* **BasicComponents.v** – Contains essential building blocks like muxes, adders, etc.

### Simulation Files

* **testbench.v** – Stimulates the processor and verifies functionality using `program.hex`.
* **program.hex** – A memory initialization file containing machine-level instructions.
* **waveform.vcd** – Generated after simulation (if enabled) for waveform analysis.

---

## Features

* Modular, easy-to-understand Verilog design.
* Simulates a simplified RISC architecture.
* Supports arithmetic, branching, and memory operations.
* Testbench-driven validation and optional waveform visualization.

---

## How to Use

1. Open the project folder in a Verilog-compatible IDE or editor.
2. Modify `program.hex` to change the instruction set loaded into memory.
3. Compile and run the simulation using the provided commands.
4. Analyze processor behavior via terminal output or waveform viewer (GTKWave).

---

