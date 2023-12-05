# OpenOCD烧写程序时报错Error:Device ID 8xle2g8a6d is not known as FESPI capable

Nuclei Studio 2023.10版中烧写程序时有报以下错误：

参见这个 https://github.com/riscv-mcu/hbird-sdk/issues/8

```
Info : Using libusb driver
Info : clock speed 1000 kHz
Info : JTAG tap: riscv.cpu tap/device found: 0x1e200a6d (mfg: 0x536 (Nuclei System Technology Co Ltd), part: 0xe200, ver: 0x1)
Info : [riscv.cpu] Found 0 triggers
halted at 0x200000b2 due to debug interrupt
Info : Examined RISCV core; XLEN=32, misa=0x40001105
[riscv.cpu] Target successfully examined.
Info : starting gdb server for riscv.cpu on 3333
Info : Listening on port 3333 for gdb connections
Error: Device ID 0x1e200a6d is not known as FESPI capable
Error: auto_probe failed
```

因为在openocd 2023.10中，将`flash bank $_FLASHNAME`从`fespi`修改为了`nuspi`，需要工程中的openocd配置文件中的`fespi`修改为了`nuspi`，
以蜂鸟工程为例，将`hbird_sdk/SoC/hbirdv2/Board/mcu200t/openocd_hbirdv2.cfg`修改为如下配置，工程即可正常使用。

```
adapter_khz     1000

interface ftdi
ftdi_vid_pid 0x0403 0x6010
ftdi_oscan1_mode off

transport select jtag

ftdi_layout_init 0x0008 0x001b
ftdi_layout_signal nSRST -oe 0x0020 -data 0x0020
ftdi_layout_signal TCK -data 0x0001
ftdi_layout_signal TDI -data 0x0002
ftdi_layout_signal TDO -input 0x0004
ftdi_layout_signal TMS -data 0x0008
ftdi_layout_signal JTAG_SEL -data 0x0100 -oe 0x0100

set _CHIPNAME riscv
jtag newtap $_CHIPNAME cpu -irlen 5

set _TARGETNAME $_CHIPNAME.cpu
target create $_TARGETNAME riscv -chain-position $_TARGETNAME
$_TARGETNAME configure -work-area-phys 0x80000000 -work-area-size 10000 -work-area-backup 1

set _FLASHNAME $_CHIPNAME.flash
flash bank $_FLASHNAME nuspi 0x20000000 0 0 0 $_TARGETNAME
# Set the ILM space also as flash, to make sure it can be add breakpoint with hardware trigger
#flash bank onboard_ilm nuspi 0x80000000 0 0 0 $_TARGETNAME

# Expose Nuclei self-defined CSRS range 770-800,835-850,1984-2032,2064-2070
# See https://github.com/riscv/riscv-gnu-toolchain/issues/319#issuecomment-358397306
# Then user can view the csr register value in gdb using: info reg csr775 for CSR MTVT(0x307)
riscv expose_csrs 770-800,835-850,1984-2032,2064-2070

init
#reset
if {[ info exists pulse_srst]} {
  ftdi_set_signal nSRST 0
  ftdi_set_signal nSRST z
}
halt
# We must turn on this because otherwise the IDE version debug cannot download the program into flash
flash protect 0 0 last off
```
