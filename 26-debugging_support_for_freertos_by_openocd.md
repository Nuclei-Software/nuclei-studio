# OpenOCD对FreeRTOS的调试支持使用指南

通过更新您的Nuclei Studio IDE到202502版本和下载0.7.1的sdk-nuclei_sdk,并配合一些下面的修改，就可以使用OpenOCD对FreeRTOS进行调试。

### 环境准备

**Nuclei Studio**：

- [NucleiStudio 202502 Windows](https://download.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202502-win64.zip)
- [NucleiStudio 202502 Linux](https://download.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202502-lin64.tgz)

**Nuclei OpenOCD**：

- 使用NucleiStudio 202502自带的的OpenOCD即可。

### 使用步骤

**step1：创建原始工程**

在NucleiStudio IDE下载好0.7.1版本的sdk-nuclei_sdk。

![image-20250513103947602](asserts\images\26\26-1.png)

创建一个900的项目，如下图。

![image-20250513170041690](asserts\images\26\26-2.png)

开发板烧写对应的bit即可，这里我们使用u900_best_config_ku060_50M_c1dd7f44af_915aefa97_202504141013_v4.1.0.bit



**step2：修改portmacro.h内容**

项目创建好，找到nuclei_sdk\OS\FreeRTOS\Source\portable\portmacro.h, 修改该文件内容如下

~~~
typedef uint32_t TickType_t;
#define portMAX_DELAY           ( TickType_t )0xFFFFFFFFUL
/* RISC-V TIMER is 64-bit long */
//typedef uint64_t TickType_t;
//#define portMAX_DELAY           ( TickType_t )0xFFFFFFFFFFFFFFFFULL
~~~

![image-20250513165844658](asserts\images\26\26-3.png)



**step3：修改openocd_evalsoc.cfg内容**

找到nuclei_sdk/SoC/evalsoc/Board/nuclei_fpga_eval/openocd_evalsoc.cfg,修改第118行内容

~~~
target create $_TARGETNAME riscv -chain-position $_TARGETNAME -coreid $BOOTHART -rtos FreeRTOS

~~~

![image-20250513165933970](asserts\images\26\26-4.png)



**step4：openocd调试工程**

Debug运行程序，打开Debugger Console视图。

在Debugger Console视图下输入info threads，回车。

![image-20250513165625083](asserts\images\26\26-5.png)

### 使用说明

目前支持**FreeRTOS**,不支持**Zephyr**、**ThreadX**、**UCOSII**。

