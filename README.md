# RISC-V 3 Stage Pipeline Processor

Welcome to the RISC-V Three Stage Pipelined Processor repository! This project is an implementation of a three-stage pipelined processor based on the RISC-V instruction set architecture. The design is crafted in System Verilog to provide a balance between performance and simplicity.
## Features

- **Three-Stage Pipeline:** The processor architecture encompasses three stages—fetch, decode, and execute—allowing for efficient instruction processing and throughput.

- **Comprehensive Instruction Support:** The processor supports a variety of RISC-V instructions, including R, I, B, S, LOADS, J, U, and CSR types.

- **Data Hazard Handling:** There are mechanisms for handling data hazards, including forwarding and stalling, ensure smooth execution of instructions.

- **Flushing Capability:** The processor supports instruction flushing, providing flexibility in managing and correcting the instruction flow.


## How to Use

### 3 Stage Pipelined Processor RISC-V 32I

#### Description

This project implements a 3 stage pipelined processor based on the RISC-V instruction architecture. The processor is designed using SystemVerilog.

#### Design

The processor design is encapsulated in the `riscv_pipelined_top.sv` file. All modules and interconnections are defined in this file.

The top modules include:

- tb_riscv_pipelined_top
- tb_alu_new

  
#### Diagram

[RISC-V 3 Stage Pipelined](RISC-V 3 Stage Pipelined.jpg)

#### Compilation and Running

1. Before compiling, paste the machine code of your program into `inst.mem`.
2. Compile by opening the terminal in the directory and running:

    ```bash
    vlog *.sv
    ```

3. To run the simulation, execute the following command:

    ```bash
    vsim -c -voptargs=+acc tb_processor -do "run -all"
    ```

This will run the simulation, executing all the code specified in `tb_riscv_pipelined_top.sv`.
