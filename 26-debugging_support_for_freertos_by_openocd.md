# OpenOCD对FreeRTOS的调试支持使用指南

## **问题说明**

在FreeRTOSconfig.h文件中启用以下选项，openocd调试报错。

~~~
#define configUSE_TRACE_FACILITY 1     // 启用内核对象跟踪
#define configUSE_STATS_FORMATTING_FUNCTIONS 1  // 允许调试器读取任务状态
~~~

![img](asserts\images\26\26-1.png)

## 解决方案

通过更新您的Nuclei Studio IDE到202502版本和下载0.7.1的sdk-nuclei_sdk,并配合一些下面的修改，就可以使用OpenOCD对FreeRTOS进行调试。

### 环境准备

**Nuclei Studio**：

- [NucleiStudio 202502 Windows](https://download.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202502-win64.zip)
- [NucleiStudio 202502 Linux](https://download.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202502-lin64.tgz)

**Nuclei OpenOCD**：

- 使用NucleiStudio 202502自带的的OpenOCD即可。

### 使用步骤

**step1：修改portmacro.h内容**

在NucleiStudio IDE下载好0.7.1版本的sdk-nuclei_sdk。

![image-20250513103947602](asserts\images\26\26-2.png)

找到安装好的0.7.1版本sdk-nuclei_sdk所在目录，一般是在用户路径下nuclei-pack-npk-v2\NPKs\nuclei\Software_Development_Kit\sdk-nuclei_sdk\0.7.1\nuclei-sdk-0.7.1。如果不在，参考下图，在所设置的user path或global path下查看。

![image-20250513104852460](asserts\images\26\26-3.png)然后我们要修改sdk-nuclei_sdk里面的OS\FreeRTOS\Source\portable\portmacro.h

![image-20250513104138906](asserts\images\26\26-4.png)

portmacro.h文件修改内容如下

~~~
typedef uint32_t TickType_t;
#define portMAX_DELAY           ( TickType_t )0xFFFFFFFFUL
/* RISC-V TIMER is 64-bit long */
//typedef uint64_t TickType_t;
//#define portMAX_DELAY           ( TickType_t )0xFFFFFFFFFFFFFFFFULL
~~~

![image-20250513105245671](asserts\images\26\26-5.png)

**step2：创建原始工程，修改openocd_evalsoc.cfg内容**

创建一个n900的项目，如下图。

![image-20250513110357711](asserts\images\26\26-6.png)

项目创建好，找到nuclei_sdk/SoC/evalsoc/Board/nuclei_fpga_eval/openocd_evalsoc.cfg,修改第118行内容

~~~
target create $_TARGETNAME riscv -chain-position $_TARGETNAME -coreid $BOOTHART -rtos FreeRTOS

~~~

![image-20250513110651517](asserts\images\26\26-7.png)

开发板烧写对应的bit即可，这里我们使用n900_best_config_2c_ku060_50M_c1dd7f44af_915aefa97_202504141008_v4.1.0.bit

**step3：openocd调试工程**

Debug运行程序，打开Debugger Console视图。

在Debugger Console视图下输入info threads，回车。

![image-20250513115922401](asserts\images\26\26-8.png)

### 使用说明

目前支持**FreeRTOS**,不支持**Zephyr**、**ThreadX**、**UCOSII**。

另调试时，可能出现如下错误，但是不影响使用，最开始进到main的threads显示不正常。运行后暂停下就正常了。

- IDE restart这个按钮点击后工作不正常了，不能重新下载代码并停在main函数

- 下一次可能openocd也连不上了，需要重新运行openocd再连gdb

- 可能下载freertos demo会卡死，需要把断点设置到 `_start` 位置，这样可以。![image](asserts\images\26\26-9.png)

  ~~~
  Error: Error allocating memory for 2415923088 threads
  Error: Error allocating memory for 2415923088 threads
  ~~~

  

  