# ClassiCube RISC-V Port for SiFive HiFive Premier P550

![ClassiCube running on a Premier P550 RISC-V board](https://raw.githubusercontent.com/marcoscodas/classicube-riscv/refs/heads/main/screenshot2.png)

# Overview

This project provides an automated build and launch solution for running ClassiCube on the SiFive HiFive Premier P550 development platform.

The core objective is to ensure optimal hardware-accelerated rendering by utilizing the Zink driver. Zink is a Mesa component that translates OpenGL (or OpenGL ES) calls into the native Vulkan API, allowing ClassiCube to leverage the high-performance Vulkan drivers present on the P550 board for GPU acceleration.
Key Contributions

    Platform: SiFive HiFive Premier P550 (RISC-V architecture).

    Primary Goal: Achieve reliable hardware-accelerated rendering via the Zink driver.

    Author: Marcos Codas [idillicah]

    Special Thanks: SiFive, for their support of the RISC-V ecosystem and hardware.

# Project Changes and Automation

This solution includes specific modifications to facilitate the build and execution process on the target hardware:

    Makefile Patching: The build script automatically modifies the ClassiCube/Makefile to include the standard C math library (-lm) in the linking stage for the Linux platform.

    Automated Build Script: A robust build.sh script handles dependency installation, source code fetching, patching, and compilation.

    Zink Launch Wrapper: The build process replaces the final ClassiCube executable with a small shell script. This wrapper ensures that every time the user runs ./ClassiCube, the critical environment variable MESA_LOADER_DRIVER_OVERRIDE=zink is set, forcing Zink usage and launching the game in fullscreen mode by default.

# How to Run

If you just want to run the game, go to the Releases page, download the latest release, unzip it, and run the ClassiCube executable located in the /src/ClassiCube folder. 

This is a script that launches the actual executable (ClassiCube.bin) with the flags to enable the Zink driver and make hardware acceleration work on the Sifive Premier P550.

# What if I Don't Own A Premier P550?

Just run the ClassiCube.bin binary instead, which is the main ClassiCube binary, compiled for RISC-V with no flags. It is also located in /src/ClassiCube.

# I Want to Build This Myself

Well, I have great news!

# Build and Run Instructions

This process is designed to be run directly on your SiFive HiFive Premier P550 board (or a suitable RISC-V environment with appropriate tooling and Mesa drivers).
Prerequisites

You must have:

    A working Debian/Ubuntu-based operating system on the P550.

    The necessary development tools (git, build-essential, etc.). 

    NOTE: If you don't have these, the script WILL install them for you.

    The Mesa Vulkan drivers and Zink support enabled (all Eswin builds or SiFive builds from June 2025 or newer).

1. Execute the Automation Script

Save the complete automation script (which handles all cloning, patching, and wrapper creation) as build.sh and run it:

# Download the Script
wget https://www.github.com/marcoscodas/classicube-riscv/blob/main/build.sh

# Set execute permissions
chmod +x build.sh

# Run the script
./build.sh

2. Launch ClassiCube

The script places the Zink launch wrapper in the source directory.

# Navigate to the built directory
cd ~/src/ClassiCube

# Launch the game with automatic Zink acceleration 
./ClassiCube

# Licensing

This project adheres to the licensing of the core components it utilizes.
ClassiCube License

The original ClassiCube client is licensed under the ISC License.

    Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Automation Script License

The accompanying automation scripts (build.sh, Zink wrapper) created for this port are released under the MIT License.

    Copyright (c) 2025 Marcos Codas

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

![ClassiCube running on a Premier P550 RISC-V board](https://raw.githubusercontent.com/marcoscodas/classicube-riscv/refs/heads/main/screenshot1.png)
