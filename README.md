# Wire Function - RISC-V Assembly Example

Educational example of GPIO control using RISC-V Assembly for Raspberry Pi Pico 2 W.

## Description

This project demonstrates how to implement a logic wire in RISC-V Assembly: pin 12 is configured as input and pin 15 as output. The program loops continuously, reading the logic level on pin 12 and immediately copying it to pin 15, with no delay. Rather than accessing hardware registers directly, the assembly code calls a thin C API layer (`pico_gpio_api.c`) that wraps the Pico SDK.

## Hardware

- **Board:** Raspberry Pi Pico 2 W
- **Input Pin:** GPIO 12
- **Output Pin:** GPIO 15
- **Architecture:** RISC-V

## Behaviour

| Pin 12 (input) | Pin 15 (output) |
|----------------|-----------------|
| 1 (high)       | 1 (high)        |
| 0 (low)        | 0 (low)         |

## Code Structure

### Architecture

```
main.S  ──calls──►  pico_gpio_api.c  ──calls──►  Pico SDK  ──►  Hardware
```

### `main.S` — Assembly entry point

Defines configuration constants and implements `main`:

1. **GPIO Initialisation:**
   - Calls `pico_gpio_init(12, 0)` to configure pin 12 as input
   - Calls `pico_gpio_init(15, 1)` to configure pin 15 as output
2. **Main Loop:**
   - Read pin 12 via `pico_gpio_read(12)` → result in `a0`
   - Write result to pin 15 via `pico_gpio_write(15, a0)`
   - Repeat indefinitely (no delay)

### `pico_gpio_api.c` — C GPIO wrapper

Provides three integer-based functions designed to be called from RISC-V Assembly following the standard calling convention (arguments in `a0`–`a7`, return value in `a0`):

| Function | Signature | Description |
|---|---|---|
| `pico_gpio_init` | `(int pin, int is_output)` | Initialises a pin and sets its direction |
| `pico_gpio_write` | `(int pin, int value)` | Drives a pin high (1) or low (0) |
| `pico_gpio_read` | `(int pin) → int` | Returns the current level of a pin (1 or 0) |

## Requirements

- Raspberry Pi Pico SDK (version 2.2.0)
- RISC-V Toolchain (RISCV_ZCB_RPI_2_2_0_2)
- CMake (version 3.13 or higher)
- picotool (version 2.2.0-a4)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/afmiguel/risc-v-wrire-function.git
```

### 2. Open the project in VS Code

```bash
cd risc-v-wrire-function
code .
```

## Building

### All platforms (VS Code — recommended)

1. Install [VS Code](https://code.visualstudio.com/) and the **Raspberry Pi Pico** extension
2. Open the project folder in VS Code
3. The extension detects `CMakeLists.txt` and configures everything automatically
4. Click **Compile Project** in the bottom status bar

### macOS / Linux (terminal)

```bash
mkdir build && cd build
cmake ..
ninja
```

### Windows (terminal)

```cmd
mkdir build
cd build
cmake -G "Ninja" ..
ninja
```

Build outputs: `wire.uf2`, `wire.elf`, `wire.bin`, `wire.hex` inside `build/`.

## Uploading to Pico

1. Press and hold the BOOTSEL button on the Pico
2. Connect the Pico to your computer via USB
3. Release the BOOTSEL button (the Pico will appear as a USB drive)
4. Copy the `build/wire.uf2` file to the Pico drive
5. The Pico will automatically reboot and the wire function will start

## Project Structure

```
risc-v-wrire-function/
├── main.S                # RISC-V Assembly entry point (main)
├── pico_gpio_api.c       # C GPIO wrapper callable from assembly
├── CMakeLists.txt        # CMake build configuration
├── pico_sdk_import.cmake # Pico SDK import helper
├── build/                # Build output directory
└── .vscode/              # VS Code and Pico extension settings
```

## Additional Resources

- [pico_stdlib RISC-V ABI Reference](https://afmiguel.github.io/pico-riscv-asm-reference/) — How to call Pico SDK functions from RISC-V Assembly, with argument-to-register mapping and annotated examples for each function.

## Learning Objectives

This project is ideal for understanding:
- RISC-V Assembly programming and control flow
- RISC-V calling conventions (ABI): argument registers, return values
- Cross-language function calls between assembly and C
- GPIO input reading and output driving through a layered software abstraction
- Pico SDK project structure and CMake build system

## License

Open-source educational project.

## Author

Developed as an educational example for the Microprocessor Systems Design course.
