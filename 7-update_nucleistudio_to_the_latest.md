# 更新 Nuclei Studio 2023.10 到最新版本

## 问题描述
2023年11月06日发布的Nuclei Studio 2023.10版本中存在一些问题,引响用户使用:
* build tools的busybox存在问题导致make 带 pre- post- steps时编译出问题
* Nuclei Settings中corner cases在特定场景下会出错，
* Nuclei Settings的打开方式引响工程中其他文件的打开发方式
* 在QEMU中使用V扩展时，没有传入RVV length

我们重新做了一些变更，以修复以上问题：
* 修改并发布Nuclei Studio Plugins 2.1.0
* 修改并发布build-tools 1.2
* 发布了新的Nuclei Studio 2023.10，替换了原来的Nuclei Studio 2023.10包

## 升级Nuclei Studio 2023.10 到最新版本的方法

如果您的Nuclei Studio 2023.10，是在2023年11月16日之前下载，版本中存在的上述问题可能会引响您的使用体验，您可以选择手动进行升级，也可以选择重官网上下载我们最新发布的版本。

### 对2023年11月16日之前下载了Nuclei Studio 2023.10进行升级
如果您是在2023年11月16日之前下载了Nuclei Studio 2023.10，可以通过以下方式更新您的Nuclei Studio 2023.10 到最新版本
**1. 升级Nuclei Studio Plugins**
在Nuclei Studio菜单中找到Help->Install New Software ,然后在Install工具的Work with选中“NucleiStudio - https://ide.nucleisys.com/NucleiStudio/”,下面会列出所有待更新的插件。

![](asserts/images/195660415249583.png)

在弹出的插件列表中选中需要升级的插件，我们选中Nuclei Studio IDE For RISC-V C/C++ Development 2.1.0 、Nuclei Studio IDE QEMU Debug 1.1.0 ,然后Next。
![](asserts/images/v_20231116151002.png)

在升级过程中，Nuclei Studio会询问Trust Artifacts时，操作如下图，选择Trust Selected,然后升级完成，Nuclei Studio会重启。至此Nuclei Studio Plugins升级完成。
![](asserts/images/v_17001190261409.png)
    
**2. 升级build-tools**
下载build-tools-1.2，并替换Nuclei Studio 2023.10中的NucleiStudio\toolchain\build-tools中内容。关于这部分，可以查阅[编译工程时，使用了Pre-build Command/Post-build Command时报错](https://github.com/Nuclei-Software/nuclei-studio/blob/main/4-use_pre_build_or_post_build.md)中的详细说明。

- [build-tools-1.2下载](https://www.nucleisys.com/upload/files/toochain/build-tools/win32-buildtools-1.2.zip)

经此两步，完成了对Nuclei Studio 2023.10的升级。
    
### 从官网下载最新的版本
如果不想做手动升级工作，可以直接从我们的网站上下载最新的Nuclei Studio 2023.10。
- [Windows版下载](https://www.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202310-win64.zip)
- [Linux版下载](https://www.nucleisys.com/upload/files/toochain/qemu/nuclei-qemu-2023.10-linux-x64.tar.gz)
## 参考资料

- [Nuclei Studio FAQs](https://www.rvmcu.com/nucleistudio-faq.html)
- [Nuclei Studio/Tools 不断更新的补充文档](https://github.com/Nuclei-Software/nuclei-studio)
- [Nuclei Studio Issues](https://github.com/Nuclei-Software/nuclei-studio/issues)
