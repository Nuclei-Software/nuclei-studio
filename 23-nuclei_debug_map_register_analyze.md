# 如何使用芯来提供的DebugMap寄存器分析错误现场

## 首先需要确定硬件支持DebugMap功能

core的顶层有一个信号叫做**dm_map_enable**，这个信号接1表示使能DebugMap功能

> 详情参见 *Nuclei_CPU_Debug_Function_Specification.pdf* 文档的 *Debug Control Interface* 部分内容

## 什么是DebugMap寄存器

DebugMap功能就是当Core被hang的时候可以通过OpenOCD查看core内部的状态，将若干内部状态映射到DM寄存器中，目前只实现了下面三个状态的映射：

- 00: Commit PC(i0 for dual issue)
- 16: ICache miss address(ICache is supported)
- 32: DCache address waiting for retire(DCache is supported)

> 详情参见 *Nuclei_CPU_Debug_Function_Specification.pdf* 文档的 *CFR0 (Custom Feature Register0)* 部分内容

## OpenOCD里DebugMap的输出信息

在使用OpenOCD连接FPGA/芯片时，经常会看到类似下面这样的输出信息：

```
Info : coreid=0, nuclei debug map reg 00: 0xa00003ac, 16: 0xa0003240, 32: 0x10003014
```

- **coreid** 表示当前输出的是哪个core的debug-map信息

## 可能出现的错误现场

错误现场一：

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

错误现场二：

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

## 如何正确利用DebugMap分析错误现场

- 在出现Core被hang的现象之后，需要在不断电、不复位的情况下再次使用OpenOCD连接FPGA/芯片，此时OpenOCD输出的DebugMap才可被用于分析错误现场
- “00”：当前Commit的PC——用来指示最近正在Commit的PC，通过此信息可以大概推测CPU跑到了什么PC位置
- “16”：配置了ICache的话，记录ICache最近发出去的地址（暂时没有记录ILM的地址），理论上ICache有2个Oustanding，记录的是那个最先发出去还没有返回Response的地址
- “32”：配置了DCache 的话，记录DCache最近发出去的地址（DLM、Mem也可以被记录，暂时没有记录PPI/FIO发出去的地址），理论上DCache有很多个Oustanding，记录的是那个最先发出去还没有返回Response的地址

## 通过OpenOCD读取其他DebugMap寄存器

OpenOCD里有一组 *nuclei expose_cpu_core* *nuclei examine_cpu_core* 命令，可以使用这两个命令读取其他DebugMap寄存器

> OpenOCD里的命令实现及使用方法 [source code](https://github.com/riscv-mcu/riscv-openocd/blob/be0e02e2f4b74fc33e7617154791570e74fde2d0/src/target/riscv/nuclei_riscv.c#L984-L999)

- 注意 *nuclei expose_cpu_core* 命令需要在**init**命令之前使用
- *nuclei examine_cpu_core* 在**init**命令之后使用，也可以在gdb/telent连接上后使用，注意gdb给openocd发送命令需要使用monitor关键词 *monitor nuclei examine_cpu_core*
