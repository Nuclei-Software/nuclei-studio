# How to Use the DebugMap Registers Provided by Nuclei to Analyze Error Scenarios

## First, Confirm That the Hardware Supports the DebugMap Feature

There is a signal called **dm_map_enable** at the top level of the core. Tying this signal to 1 enables the DebugMap feature.

> For details, refer to the *Debug Control Interface* section of the *Nuclei_CPU_Debug_Function_Specification.pdf* document

## What Are DebugMap Registers

The DebugMap feature allows you to inspect the internal state of the Core via OpenOCD when the Core is hung. Several internal states are mapped into DM registers. Currently, only the following three states are mapped:

- 00: Commit PC(i0 for dual issue)
- 16: ICache miss address(ICache is supported)
- 32: DCache address waiting for retire(DCache is supported)

> For details, refer to the *CFR0 (Custom Feature Register0)* section of the *Nuclei_CPU_Debug_Function_Specification.pdf* document

## DebugMap Output Information in OpenOCD

When using OpenOCD to connect to an FPGA/chip, you will often see output similar to the following:

```
Info : coreid=0, nuclei debug map reg 00: 0xa00003ac, 16: 0xa0003240, 32: 0x10003014
```

- **coreid** indicates which core's debug-map information is currently being output

## Possible Error Scenarios

Error scenario 1:

```
Info : Using libusb driver
Info : clock speed 1000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x10900a6d (mfg: 0x536 (Nuclei System Technology Co Ltd), part: 0x0900, ver: 0x1)
Info : [riscv.cpu] datacount=4 progbufsize=8
Info : coreid=0, nuclei debug map reg 00: 0xa0000496, 16: 0xa0003140, 32: 0x10002ff8
Error: [riscv.cpu] Unable to halt hart 0. dmcontrol=0x00000001, dmstatus=0x00400ca2
Error: [riscv.cpu] Fatal: Hart 0 failed to halt during examine()
Warn : target riscv.cpu examination failed
Info : [riscv.cpu] datacount=4 progbufsize=8
Error: Hart 0 doesn't exist.
Error: Fatal: Failed to read s0 from hart 0.
Info : [riscv.cpu] datacount=4 progbufsize=8
Error: Hart 0 doesn't exist.
Error: Fatal: Failed to read s0 from hart 0.
Info : starting gdb server for riscv.cpu on 22800
Info : Listening on port 22800 for gdb connections
Error: Target not examined yet
```

Error scenario 2:

```
Info : libusb_open() failed with LIBUSB_ERROR_NOT_FOUND
Info : no device found, trying D2xx driver
Info : D2xx device count: 2
Info : Connecting to "(null)" using D2xx mode...
Info : clock speed 1000 kHz
Info : JTAG tap: riscv0.cpu tap/device found: 0x10300a6d (mfg: 0x536 (Nuclei System Technology Co Ltd), part: 0x0300, ver: 0x1)
Info : [riscv0.cpu] datacount=4 progbufsize=2
Info : coreid=0, nuclei debug map reg 00: 0xa0000496, 16: 0xa0003140, 32: 0x10002ff8
Info : Examined RISC-V core; found 1 harts
Info :  hart 0: XLEN=32, misa=0x40001127
[riscv0.cpu] Target successfully examined.
Info : starting gdb server for riscv0.cpu on 3333
Info : Listening on port 3333 for gdb connections
Started by GNU MCU Eclipse
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Info : accepting 'gdb' connection on tcp/3333
Warn : Prefer GDB command "target extended-remote :3333" instead of "target remote :3333"
Error: Timed out after 2s waiting for busy to go low (abstractcs=0x2001004). Increase the timeout with riscv set_command_timeout_sec.
Error: Abstract command ended in error 'busy' (abstractcs=0x2001104)
```

## How to Correctly Use DebugMap to Analyze Error Scenarios

- After the Core-hang symptom occurs, you need to use OpenOCD to connect to the FPGA/chip again without power-cycling or resetting. Only the DebugMap output at this point can be used to analyze the error scenario.
- "00": The currently committed PC — indicates the most recently committed PC. From this information, you can roughly infer which PC location the CPU has reached.
- "16": If ICache is configured, this records the most recent address issued by the ICache (ILM addresses are not recorded for now). In theory, the ICache has 2 outstanding transactions; what is recorded is the address of the earliest issued transaction that has not yet returned a response.
- "32": If DCache is configured, this records the most recent address issued by the DCache (DLM and Mem can also be recorded; addresses issued to PPI/FIO are not recorded for now). In theory, the DCache has many outstanding transactions; what is recorded is the address of the earliest issued transaction that has not yet returned a response.

## Reading Other DebugMap Registers via OpenOCD

OpenOCD provides a set of commands, *nuclei expose_cpu_core* and *nuclei examine_cpu_core*, which can be used to read other DebugMap registers. For details, see https://doc.nucleisys.com/nuclei_tools/openocd/intro.html#debug-map-feature

> Command implementation and usage in OpenOCD: [source code](https://github.com/riscv-mcu/riscv-openocd/blob/be0e02e2f4b74fc33e7617154791570e74fde2d0/src/target/riscv/nuclei_riscv.c#L984-L999)

- Note that the *nuclei expose_cpu_core* command must be used before the **init** command
- *nuclei examine_cpu_core* is used after the **init** command, and can also be used after a gdb/telnet connection is established. Note that sending commands from gdb to OpenOCD requires the monitor keyword: *monitor nuclei examine_cpu_core*
