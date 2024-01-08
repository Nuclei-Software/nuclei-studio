# 关于dhrystone在IDE上跑分和NSDK命令行跑分不一致的问题

## 在0.5.0版本的sdk-nuclei_sdk中，为了IDE上使用libncrt库的时候编译有些程序不报错，设置了会默认带上-msave-restore,但该内容会影响跑分结果。



## 正常跑分的设置
在跑分的时候，需要在对应项目的Properties -> C/C++ Build -> Settings中，取消对Small prologue/epilogue(-msave-restore)的选中。
具体流程和示例图如下：

1. 下载sdk-nuclei_sdk 0.5.0组件包。

2. 新建一个Nuclei RISCV-V C/C++ project。

3. 在新建项目的过程中，选中Dhrystone Benchmark和N307FD Core组件,其他选项默认设置即可。此时运行跑分为1.405。

4. 在正常跑分时，取消选中-msave-restore选项，该跑分结果为1.664。

![](asserts/images/12-1.png)
![](asserts/images/12-2.png)
![](asserts/images/12-3.png)
![](asserts/images/12-4.png)
![](asserts/images/12-5.png)
![](asserts/images/12-6.png)
