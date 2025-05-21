# Nuclei SDK基于evalsoc快速适配customsoc

## 方案说明

Nuclei Eval SoC(简称evalsoc)是芯来科技提供的一款用于评估芯来CPU的SoC，具有On-Chip SRAMs，UART, SPI等；
Nuclei SDK提供基于evalsoc的软件开发平台。客户通过evalsoc评估完芯来CPU后，希望在Nuclei SDK中快速适配为自己的SoC(本文称为customsoc)。


## 解决方案

拉取最新的[nuclei-sdk](https://github.com/Nuclei-Software/nuclei-sdk/tree/master)仓库或者直接使用cpu交付包中的nuclei-sdk


### 环境准备

### 适配修改

> 如果通过nuclei_gen工具生成了配套的文件，则直接替换同名文件即可，这样比较简单不出错；如果手动修改，则注意下文提到的文件和修改点


**先不要改任何目录名，文件名**，按步骤修改如下文件。

#### 1 修改cpu特性描述宏文件

**SoC/evalsoc/Common/Include/cpufeature.h**文件定义了customsoc支持的特性、参数相关的#define宏。CPU交付包中的nuclei_gen工具会自动生成该文件，直接替换即可。


#### 2 修改cpu特性isa配置

**SoC/evalsoc/cpufeature.mk**文件定义了customsoc的CORE(是否支持单/双精度浮点)ARCH_EXT(是否支持b和v扩展等)。CPU交付包中的nuclei_gen工具会自动生成该文件，直接替换即可。

#### 3  修改链接地址的memory map

**SoC/evalsoc/Board/nuclei_fpga_eval/Source/GCC/evalsoc.memory**描述了ILM/DLM/FLASH/SRAM/DDR 的BASE address和SIZE以及代码段的大小。CPU交付包中的nuclei_gen工具会自动生成该文件，直接替换即可。


#### 4 修改openocd配置文件

> openocd会通过jtag与cpu建立gdb server port，供gdb debug和load使用

**SoC/evalsoc/Board/nuclei_fpga_eval/openocd_evalsoc.cfg**是openocd的配置描述文件。CPU交付包中的nuclei_gen工具会自动生成该文件，直接替换即可。关键参数如下：

``````
# TODO: variables should be replaced by nuclei_gen
set workmem_base    0x80000000
set workmem_size    0x10000
set flashxip_base   0x20000000
set xipnuspi_base   0x10014000
``````

#### 5 修改Systimer频率

**SoC/evalsoc/Common/Include/evalsoc.h**中修改SOC_TIMER_FREQ为customsoc的Systimer的频率

``````
// 单位是hz 比如32768hz，这里填32768
#define SOC_TIMER_FREQ              customsoc_systimer_freq
``````


#### 6 修改CPU主频

**SoC/evalsoc/Common/Source/system_evalsoc.c**中，SystemCoreClock = get_cpu_freq()自动计算cpu主频(依赖Systimer)，可以直接修改为customsoc的主频

``````
// 单位是hz 比如50Mhz，这里填50000000
SystemCoreClock = customsoc_cpu_freq;
``````



#### 7 修改串口驱动


> evalsoc的uart IP是评估版本

> evalsoc_uart.c和evalsoc_uart.h里面的uart_xxx 名称不要修改，因为SoC/evalsoc/Common/Source/Stubs下的一些桩函数使用了uart的api


串口驱动位于**SoC/evalsoc/Common/Source/Drivers/evalsoc_uart.c**，**SoC/evalsoc/Common/Include/evalsoc_uart.h**，如果使用其它串口IP，根据实际的串口寄存器定义适配。



#### 8 修改串口波特率

**SoC/evalsoc/Common/Source/system_evalsoc.c: uart_init(SOC_DEBUG_UART, 115200)**; 一般波特率为115200


#### 9 修改_premain_init

> 一些在main函数之前执行的初始化可以放在这个函数

如果有 IOMUX 和 PLL 等其他相关的配置，可以在**SoC/evalsoc/Common/Source/system_evalsoc.c: _premain_init** 函数里面实现；如果没有，可以跳过



#### 10 删除Nuclei内部使用的代码

**SoC/evalsoc/Common/Source/system_evalsoc.c**: SIMULATION_EXIT是用于Nuclei内部仿真标记，可以定义为空

``````
define SIMULATION_EXIT(ret)    {}
``````



#### 11 检查外设地址

> 建议CPU配置时不要修改，保持与evalsoc一致

> 串口使用的SOC_DEBUG_UAR定义为UART0


* 外设的Base address由EVALSOC_PERIPS_BASE决定，EVALSOC_PERIPS_BASE在**SoC/evalsoc/Common/Include/cpufeature.h**(由nuclei_gen工具生成，拷贝覆盖即可)中定义，一般无需再修改

* 外设的offset address在**SoC/evalsoc/Common/Include/evalsoc.h**中定义，搜索Peripheral memory map, 一般无需修改

    ``````
    #define UART0_BASE              (EVALSOC_PERIPH_BASE + 0x13000)          /*!< (UART0) Base Address */
    #define QSPI0_BASE              (EVALSOC_PERIPH_BASE + 0x14000)          /*!< (QSPI0) Base Address */

    #define UART0                   ((UART_TypeDef *) UART0_BASE)
    ``````




### 测试运行

如果以上修改完毕，就可以测试SoC能否正常工作了

> 这里因为是在evalsoc的基础上改的，还没有修改相关地方的名称为customsoc

> 所以仍然SOC=evalsoc BOARD=nuclei_fpga_eval

``````
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
``````

如果可以正常运行打印Hello World From Nuclei RISC-V Processor，那基本没有问题了。如果还需要运行更多case，请参考[Nuclei SDK Application](https://doc.nucleisys.com/nuclei_sdk/design/app.html#overview)确认是否运行成功。


### 调整名称

> 重命名的地方有点多，这里就不列举了，最终保证编译通过就可以。

测试通过后，就可以把涉及evalsoc的文件名和目录名修改为customsoc，以及eval/EVAL开头的宏名/文件名替换成custom

``````
# 修改完后，再次测试运行
make SOC=customsoc BOARD=nuclei_fpga_custom upload
``````

至此，**Nuclei SDK就去掉了eval的logo，成为SDK for custom了。**


### 精简代码

因为Nuclei SDK支持Nuclei多款CPU系列的评估和内部测试，需要考虑非常多的场景，因此存在一些冗余代码，建议在阅读[Nuclei-SDK documentation](https://doc.nucleisys.com/nuclei_sdk/index.html)并且熟悉代码框架后，再进行精简删除。


### IAR工程

* IAR的工程有专门的链接脚本，位于SoC/evalsoc/Board/nuclei_fpga_eval/Source/IAR/*.icf
IAR的链接脚本当前没有通过nuclei_gen工具生成，所以需要手动检查调整ROM_region32/ILM_region32/RAM_region32的base address和size, 这里的from就是代表base address，size 表示该region的大小

    ``````
    define region ROM_region32 = mem:[from 0x20000000 size 0x800000];
    define region ILM_region32 = mem:[from 0x80000000 size 0x10000];
    define region RAM_region32 = mem:[from 0x90000000 size 0x10000];
    ``````

* IAR的工程位于ideprojects/iar，也是prebuilt for evalsoc，在未调整名称之前是可以直接运行的
如果经过了调整名称，路径和文件名都变化了，也需要重新新建工程，建议文本打开ewp文件，搜索“eval”关键词替换

    ``````diff
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
    ``````




### IDE工程支持

如果希望Nuclei Studion IDE能支持custom soc，需要修改以下文件中涉及eval的名字，npk.yml的语法格式见[2.4. Nuclei Studio NPK 介绍](https://doc.nucleisys.com/nuclei_tools/ide/npkoverview.html)

``````
evalsoc/Common/npk.yml
evalsoc/Board/nuclei_fpga_eval/npk.yml
``````



## 参考资料

- [Nuclei Eval SoC](https://doc.nucleisys.com/nuclei_sdk/design/soc/evalsoc.html)
- [port-your-nuclei-soc-into-nuclei-sdk](https://doc.nucleisys.com/nuclei_sdk/contribute.html#port-your-nuclei-soc-into-nuclei-sdk)
