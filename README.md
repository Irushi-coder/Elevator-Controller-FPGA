# Elevator Controller - FPGA Implementation

## Project Overview
A 3-floor elevator controller designed and implemented using Verilog HDL on the Nexys4 FPGA board

## Features
- **3-Floor Operation:** Ground (0), First (1), and Second (2) floors
- **User Input:** Three push buttons to select destination floor
- **Visual Feedback:** 
  - LED indicators for selected floor
  - 7-segment displays showing current and next floor
- **1Hz Clock Operation:** Smooth state transitions

## Project Structure
```
├── docs/                    # Documentation and diagrams
│   ├── State_Diagram.pdf
│   └── Final_Report.pdf
├── src/                     # Verilog source files
│   ├── Elevator_Controller_Top.v
│   ├── FSM_Vending_Unit.v
│   ├── Cntr_Unit.v
│   └── Disp_Unit.v
├── testbench/              # Simulation testbenches
│   └── Elevator_Controller_TB.v
├── constraints/            # FPGA constraints file
│   └── Nexys4_constraints.xdc
└── simulation/             # Simulation results and waveforms
```

## Hardware Requirements
- Nexys4 DDR FPGA Board
- Xilinx Vivado Design Suite

## Module Descriptions

### 1. Cntr_Unit (Clock Divider)
Converts 100MHz FPGA clock to 1Hz for elevator operation.

### 2. FSM_Vending_Unit (Finite State Machine)
Controls elevator logic with 3 states (S0, S1, S2) representing each floor.

### 3. Disp_Unit (Display Controller)
Manages 7-segment displays using time-division multiplexing to show current and next floors.

### 4. Elevator_Controller_Top (Top Module)
Integrates all modules and manages I/O connections.

## Pin Assignments
| Signal | FPGA Pin | Description |
|--------|----------|-------------|
| clk | E3 | 100MHz system clock |
| reset | U9 | Reset button |
| g_f | U18 | Ground floor button (B0) |
| f_f | T18 | First floor button (B1) |
| s_f | W19 | Second floor button (B2) |
| LED[0] | U16 | Ground floor LED |
| LED[1] | E19 | First floor LED |
| LED[2] | U19 | Second floor LED |

## State Diagram
The FSM has 3 states with transitions based on button inputs:
- **S0 (Ground):** c_f = 0
- **S1 (First):** c_f = 1
- **S2 (Second):** c_f = 2

See `docs/State_Diagram.pdf` for detailed state transitions.

## How to Use

### Simulation
1. Open Vivado and create new project
2. Add all source files from `src/`
3. Add testbench from `testbench/`
4. Run behavioral simulation
5. Analyze waveforms

### Implementation
1. Add constraint file from `constraints/`
2. Run synthesis
3. Run implementation
4. Generate bitstream
5. Program FPGA board

## Testing
The testbench (`Elevator_Controller_TB.v`) verifies:
- Floor transitions (0→1, 1→2, 2→0)
- Self-loops (staying at current floor)
- LED indicators
- 7-segment display outputs

## Team Members
- Irushi Layanga

## Acknowledgments
- Xilinx documentation
- Nexys4 reference manual
