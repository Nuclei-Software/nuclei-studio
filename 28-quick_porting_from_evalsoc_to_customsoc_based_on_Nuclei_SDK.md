# Quick Porting from evalsoc to customsoc Based on Nuclei SDK

## Overview

Nuclei Eval SoC (evalsoc for short) is a SoC provided by Nuclei System Technology for evaluating Nuclei CPUs. It features On-Chip SRAMs, UART, SPI, and more.

[Nuclei SDK][1] and [Nuclei N100 SDK][2] provide an evalsoc-based software development platform. After evaluating Nuclei CPUs with evalsoc, customers often want to quickly adapt the corresponding SDK to their own SoC (referred to as customsoc in this document).

- **Nuclei SDK** mainly supports Nuclei 200/300/600/900/1000 series RISC-V CPUs, for rapid software evaluation and development on EvalSoC based on these CPU series
- **Nuclei N100 SDK** mainly supports Nuclei 100 series RISC-V CPUs, for rapid software evaluation and development on EvalSoC based on these CPU series

## Solution

Depending on the CPU series to be ported and adapted, pull the latest corresponding SDK repository, or directly use the SDK included in the CPU delivery package.

### Environment Preparation

### Adaptation Modifications

> If the accompanying files were generated with the nuclei_gen tool, simply replace the files with the same names directly — this is simple and less error-prone. If modifying manually, pay attention to the files and modification points mentioned below.


**Do not rename any directories or files yet.** Modify the following files step by step.

#### 1 Modify the CPU feature description macro file

The **SoC/evalsoc/Common/Include/cpufeature.h** file defines the `#define` macros related to the features and parameters supported by customsoc. The nuclei_gen tool in the CPU delivery package automatically generates this file; simply replace it.


#### 2 Modify the CPU feature ISA configuration

The **SoC/evalsoc/cpufeature.mk** file defines the CORE (whether single/double-precision floating point is supported) and ARCH_EXT (whether the b and v extensions are supported, etc.) of customsoc. The nuclei_gen tool in the CPU delivery package automatically generates this file; simply replace it.

#### 3  Modify the memory map of link addresses

**SoC/evalsoc/Board/nuclei_fpga_eval/Source/GCC/evalsoc.memory** describes the BASE addresses and SIZEs of ILM/DLM/FLASH/SRAM/DDR, as well as the size of the code sections. The nuclei_gen tool in the CPU delivery package automatically generates this file; simply replace it.


#### 4 Modify the OpenOCD configuration file

> OpenOCD establishes a gdb server port with the CPU via JTAG, which is used by GDB for debugging and loading.

**SoC/evalsoc/Board/nuclei_fpga_eval/openocd_evalsoc.cfg** is the OpenOCD configuration description file. The nuclei_gen tool in the CPU delivery package automatically generates this file; simply replace it. Key parameters are as follows:

```c
# TODO: variables should be replaced by nuclei_gen
set workmem_base    0x80000000
set workmem_size    0x10000
set flashxip_base   0x20000000
set xipnuspi_base   0x10014000
```

#### 5 Modify the Systimer frequency

In **SoC/evalsoc/Common/Include/evalsoc.h**, modify `SOC_TIMER_FREQ` to the actual Systimer frequency of customsoc (consult your SoC hardware designers).

```c
// The unit is Hz; for example, for 32768 Hz, enter 32768 here
#define SOC_TIMER_FREQ              customsoc_systimer_freq
```


#### 6 Modify the CPU core frequency

In **SoC/evalsoc/Common/Source/system_evalsoc.c**, `SystemCoreClock = get_cpu_freq()` automatically calculates the CPU core frequency (depending on Systimer). It can be modified directly to the customsoc core frequency.

```c
// The unit is Hz; for example, for 50 MHz, enter 50000000 here
SystemCoreClock = customsoc_cpu_freq;
```

#### 7 Modify the UART driver


> The UART IP of evalsoc is an evaluation version.

> Do not modify the `uart_xxx` API names in `evalsoc_uart.c` and `evalsoc_uart.h`, because some stub functions under `SoC/evalsoc/Common/Source/Stubs` use the UART APIs.


The UART driver is located in **SoC/evalsoc/Common/Source/Drivers/evalsoc_uart.c** and **SoC/evalsoc/Common/Include/evalsoc_uart.h**. If a different UART IP is used, adapt it according to the actual UART register definitions.



#### 8 Modify the UART baud rate

**SoC/evalsoc/Common/Source/system_evalsoc.c**: ``uart_init(SOC_DEBUG_UART, 115200)``; the baud rate is generally **115200**.


#### 9 Modify _premain_init

> Some initialization that needs to run before the main function can be placed in this function.

If there are other related configurations such as IOMUX and PLL, they can be implemented in the ``_premain_init`` function in **SoC/evalsoc/Common/Source/system_evalsoc.c**; if not, this step can be skipped.


#### 10 Remove the code used internally by Nuclei

**SoC/evalsoc/Common/Source/system_evalsoc.c**: the ``SIMULATION_EXIT`` macro definition is a marker used for Nuclei internal simulation, and can be defined as empty.

```c
#define SIMULATION_EXIT(ret)    {}
```

#### 11 Check peripheral addresses

> It is recommended not to modify these when configuring the CPU; keep them consistent with evalsoc.

> The `SOC_DEBUG_UART` used by the UART is defined as `UART0`.


* The base addresses of peripherals are determined by `EVALSOC_PERIPS_BASE`, which is defined in **SoC/evalsoc/Common/Include/cpufeature.h** (generated by the nuclei_gen tool; just copy and overwrite it). Generally no further modification is needed.

* The offset addresses of peripherals are defined in **SoC/evalsoc/Common/Include/evalsoc.h**. Search for `Peripheral memory map`; generally no modification is needed.

```c
#define UART0_BASE              (EVALSOC_PERIPH_BASE + 0x13000)          /*!< (UART0) Base Address */
#define QSPI0_BASE              (EVALSOC_PERIPH_BASE + 0x14000)          /*!< (QSPI0) Base Address */
#define UART0                   ((UART_TypeDef *) UART0_BASE)
```

### Test Run

Once the above modifications are complete, you can test whether the SoC works properly.

> Since this is modified on the basis of `evalsoc`, the related names have not yet been changed to `customsoc`.

> Therefore, still use `SOC=evalsoc BOARD=nuclei_fpga_eval`.

```shell
# Test helloworld application
## cd to helloworld application directory
cd application/baremetal/helloworld
## clean and build helloworld application for ncstar_eval board
make SOC=evalsoc BOARD=nuclei_fpga_eval clean all
## connect your board to PC and install jtag driver, open UART terminal
## set baudrate to 115200bps and then upload the built application
## to the fpga board using openocd, and you can check the
## run messsage in UART terminal
make SOC=evalsoc BOARD=nuclei_fpga_eval upload
```

If it runs normally and prints Hello World From Nuclei RISC-V Processor, then there are basically no problems. If you need to run more cases, please refer to the following application example documentation to confirm whether they run successfully.

- Nuclei SDK: https://doc.nucleisys.com/nuclei_sdk/design/app.html
- Nuclei N100 SDK: https://doc.nucleisys.com/nuclei_n100_sdk/design/app.html

### Adjust Names

> There are quite a few places to rename, so they are not listed here. Ultimately, just make sure compilation passes.

After the test passes, you can change the file names and directory names involving evalsoc to customsoc, and replace the macro names/file names starting with eval/EVAL with custom.

```shell
# After the modifications, test again
make SOC=customsoc BOARD=nuclei_fpga_custom upload
```

At this point, **the SDK has shed the eval logo and become an SDK for custom.**


### Streamline the Code

Because Nuclei SDK/N100 SDK supports evaluation and internal testing of multiple Nuclei CPU series, it has to cover a great many scenarios, so there is some redundant code. It is recommended to streamline and remove code only after reading the SDK documentation and becoming familiar with the code framework.


### IAR Project

* The IAR project has a dedicated linker script, located at `SoC/evalsoc/Board/nuclei_fpga_eval/Source/IAR/*.icf`.
The IAR linker script is currently not generated by the nuclei_gen tool, so you need to manually check and adjust the base addresses and sizes of `ROM_region32/ILM_region32/RAM_region32`. Here, "from" represents the base address, and "size" indicates the size of that region.

```c
define region ROM_region32 = mem:[from 0x20000000 size 0x800000];
define region ILM_region32 = mem:[from 0x80000000 size 0x10000];
define region RAM_region32 = mem:[from 0x90000000 size 0x10000];
```

* The IAR project is located at `ideprojects/iar` and is also `prebuilt for evalsoc`, so it can run directly before the names are adjusted.
If the names have been adjusted, the paths and file names have changed, and the project needs to be recreated. It is recommended to open the `ewp` file in a text editor and search for the keyword "eval" to replace it.

```diff
diff --git a/ideprojects/iar/baremetal/coremark.ewp b/ideprojects/iar/baremetal/coremark.ewp
index 3eed66a8..17443eae 100644
--- a/ideprojects/iar/baremetal/coremark.ewp
+++ b/ideprojects/iar/baremetal/coremark.ewp
@@ -434,8 +434,8 @@
                <option>
                    <name>CCIncludePath2</name>
                    <state>$PROJ_DIR$\..\..\..\NMSIS\Core\Include</state>
-                    <state>$PROJ_DIR$\..\..\..\SoC\evalsoc\Board\nuclei_fpga_eval\Include</state>
-                    <state>$PROJ_DIR$\..\..\..\SoC\evalsoc\Common\Include</state>
+                    <state>$PROJ_DIR$\..\..\..\SoC\customsoc\Board\nuclei_fpga_custom\Include</state>
+                    <state>$PROJ_DIR$\..\..\..\SoC\customsoc\Common\Include</state>
                    <state>$PROJ_DIR$\..\..\..\application\baremetal\benchmark\coremark</state>
                </option>
```

### IDE Project Support

If you want Nuclei Studio IDE to support the custom SoC, you need to modify the names involving "eval" in the following files. For the syntax format of npk.yml, see [2.4. Nuclei Studio NPK Introduction](https://doc.nucleisys.com/nuclei_tools/ide/npkoverview.html).

```c
evalsoc/Common/npk.yml
evalsoc/Board/nuclei_fpga_eval/npk.yml
```

## References

- [Nuclei 200/300/600/900/1000 Eval SoC](https://doc.nucleisys.com/nuclei_sdk/design/soc/evalsoc.html)
- [Port your SoC into Nuclei SDK](https://doc.nucleisys.com/nuclei_sdk/contribute.html#port-your-nuclei-soc-into-nuclei-sdk)

- [Nuclei 100 Eval SoC](https://doc.nucleisys.com/nuclei_n100_sdk/design/soc/evalsoc.html)
- [Port your SoC into Nuclei N100 SDK](https://doc.nucleisys.com/nuclei_n100_sdk/contribute.html#port-your-nuclei-soc-into-nuclei-sdk)


[1]: https://github.com/Nuclei-Software/nuclei-sdk/tree/master
[2]: https://github.com/Nuclei-Software/nuclei-sdk/tree/master_n100
