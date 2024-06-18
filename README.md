Zig RTOS (in development)
---

## Requirements
Zig (Master)
riscv64-unknown-elf compiler and linker
QEMU RISC-V System

### (Optional)
GDB Multiarch

## Building
Run `zig build`.

## Running
Run `zig build run`, will spawn QEMU session.

## Debugging
Run `zig build run -Dgdb`, will create localhost:1234 GDB server.

