# 通过修改.cproject文件，升级工程工具链到GCC 13

## 问题描述

> Nuclei Studio 2023.10的IDE进行了一次大版本的升级, 其中自带的工具链从gcc10升级到了gcc13, 并且工具链的前缀也发生了变化。
> 参见 https://github.com/Nuclei-Software/nuclei-studio/releases/tag/2023.10

虽然我们在2023.10的IDE中提供了[右键选中工程一键升级的工具（参见IDE的手册第8章节）](https://doc.nucleisys.com/nuclei_tools/ide/advanceusage.html#gcc-13)，但是这个只能一个工程一个工程的转换，对于有大量工程需要批量转换的项目而言不太友好，因此
我们这里列出来如果写脚本进行工程的转换升级，则可以参考如下的思路进行转换。

以下变更仅针对Nuclei Studio 2023.10之前版本创建的gcc10的工程，进行升级变更，如果需要批量变更，编写脚本的时候应先检查工程是否是riscv gcc10的工程。

## 修改toolchain相关配置

在Nuclei Studio 2023.10之前的版本中使用的gcc是做了许多个性化的变更，需要Nuclei Studio 2023.10版中使用的gcc,继承了官方版本的特性和一些命名方式，在工程中的`.cproject`文件中，主要是要修改以下几个值。其中`ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name`的值是`RISC-V Nuclei GCC` 、`ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id`的值是`3901352267` 、`ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix`的值是`riscv-nuclei-elf-`,则说明工程在创建时所使用的是GCC 10。如果需要使工程支持GCC 13,需要进行如下变更：

* toolchain.name的值 从**RISC-V Nuclei GCC**变更为**RISC-V GCC/Newlib**
* toolchain.id的值 从**3901352267**变更为**2262347901**
* command.prefix的值 从**riscv-nuclei-elf-**变更为**riscv64-unknown-elf-**

变更前`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name.129748485" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name" value="RISC-V Nuclei GCC" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id.1143901706" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id" value="3901352267" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix.1270840820" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix" value="riscv-nuclei-elf-" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.c.718590769" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.c" value="gcc" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.cpp.243660928" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.cpp" value="g++" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.ar.416250093" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.ar" value="ar" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objcopy.741068581" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objcopy" value="objcopy" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objdump.1474975752" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objdump" value="objdump" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.size.2085350427" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.size" value="size" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.make.1355881376" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.make" value="make" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.rm.1330665916" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.rm" value="rm" valueType="string"/>
```

变更后`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name.129748485" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name" value="RISC-V GCC/Newlib" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id.1143901706" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id" value="2262347901" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix.1270840820" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix" value="riscv64-unknown-elf-" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.c.718590769" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.c" value="gcc" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.cpp.243660928" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.cpp" value="g++" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.ar.416250093" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.ar" value="ar" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objcopy.741068581" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objcopy" value="objcopy" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objdump.1474975752" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.objdump" value="objdump" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.size.2085350427" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.size" value="size" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.make.1355881376" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.make" value="make" valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.rm.1330665916" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.rm" value="rm" valueType="string"/>
```

## 修改RISC-V扩展相关配置

在Nuclei Studio 2023.10之前的版创建的工程中，RISC-V扩展是存放在四个单独的boolean类型的值中，而在Nuclei Studio 2023.10创建的工程中，
改为一个string类型的值中,所以我在要在工程的`.cproject`文件中找到四个旧的值，并按规则转换成为新的RISC-V扩展的字符串，
存放到`ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions`中，同时将旧的四个单独的boolean类型的值置空或者删除。

```
# 四个单独的boolean类型的值
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvk
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector

# 一个string类型的值
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions
```

1. 首先，根据`ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base`确认工程对应的arch是rv32/rv64
2. 其次，根据`ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp`确认是否带f/d
3. 最后，根据对应转换规则转换出正确的RISC-V扩展字符串

转换规则(特别说明，p的值需要接在RISC-V扩展字符串的最后)：

* `b` -> `_zba_zbb_zbc_zbs`
* `k` -> `_zk_zks`
* `v` -> `rv32f/d : _zve32f`, `rv64f: _zve64f`, `rv64fd: v`
* `p` -> `rv64: _xxldsp`, `rv32: _xxldspn1x`


例如，现在有一个N307FD的工程，它的`arch=rv32imafdcbpv`(gcc10)，可以知道它是一个**rv32**,带**fd**并且使用了**bpv**扩展，那么根据转换规则，转换出来的RISC-V扩展字符串为`_zba_zbb_zbc_zbs_zve32f_xxldspn1x`。

变更前`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base.489743203" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base" value="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.arch.rv32i" valueType="enumerated"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp.1936924005" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp" value="ilg.gnumcueclipse.managedbuild.cross.riscv.option.isa.fp.double" valueType="enumerated"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb.168405526" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb" value="true" valueType="boolean"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp.565204765" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp" value="true" valueType="boolean"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector.1142078455" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector" value="true" valueType="boolean"/>		
```

变更后`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions.1832321358" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions" value="_zba_zbb_zbc_zbs_zve32f_xxldspn1x" valueType="string"/>
```

## 修改libncrt C库相关配置

在Nuclei Studio 2023.10之前的版创建的工程中,使用libncrt C库时，会在工程中包含一个`--specs=libncrt_xxx.specs`或者链接库 
里面包含 `-lncrt_xxx`，而在Nuclei Studio 2023.10创建的工程中，如果使用了libncrt C库，需要将`--specs=libncrt_xxx.specs`的方式变更为`-lncrt_xxx`，
然后额外需要链接的时候补上 `-lncrt_small -lheapops_basic -lfileops_uart`, 通用的target编译选项需要补上 `-isystem=/include/libncrt`

**举例如下**：
* `-lncrt_small` -> `-lncrt_small -lheapops_basic -lfileops_uart`
* `--specs=libncrt_small.specs` -> `-lncrt_small -lheapops_basic -lfileops_uart`


1. 在`.cproject`文件中确认否存存在`--specs=libncrt_xxx.specs`，如果存在，则表示这个是一个使用了libncrt的工程，则可以进行后续的步骤
2. 如果`--specs=libncrt_xxx.specs`存在，先将其删除
3. 如果`-lm`存在，则先将其删除
4. 查找`ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs`或者`ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`中是否存`m`，如果存在则先将删除
5. 查找`ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs`或者`ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`中是否存`ncrt_xxx`
6. 根据上面的结果，在`ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs`或者`ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`中补充对应的值
    * `--specs=libncrt_xxx.specs`存在，添加`ncrt_xxx`；或者`ncrt_xxx`存在。需要额外添加`heapops_basic`和`fileops_uart`
7. 在`ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other`中补上 ` -isystem=/include/libncrt`

```
# --specs=libncrt_xxx1.specs可能存在于以下string类型的值
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.optimization.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.warnings.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.debugging.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.assembler.otherwarnings
ilg.gnumcueclipse.managedbuild.cross.riscv.option.assembler.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.compiler.otheroptimizations
ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.compiler.otherwarnings
ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.compiler.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.compiler.otheroptimizations
ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.compiler.otherwarnings
ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.compiler.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.createflash.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.createlisting.other
ilg.gnumcueclipse.managedbuild.cross.riscv.option.printsize.other
```

举例，工程中用到了`--specs=libncrt_balanced.specs`

变更前`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other" value=" " valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.optimization.other.443378574" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.optimization.other" value="--specs=libncrt_balanced.specs" valueType="string"/>
```

变更后`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other" value="-isystem=/include/libncrt " valueType="string"/>
<option IS_BUILTIN_EMPTY="false" IS_VALUE_EMPTY="false" id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs.146128417" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs" valueType="libs">
	<listOptionValue builtIn="false" value="ncrt_balanced"/>
	<listOptionValue builtIn="false" value="fileops_uart"/>
	<listOptionValue builtIn="false" value="heapops_basic"/>
</option>
```

## 增加link warning消除的配置

在GCC 13使用过程中会产生很多的warning信息，可以在链接选项中额外增加`-Wl,--no-warn-rwx-segments`参数，用以关闭这些warning信息。

具体参见 https://sourceware.org/binutils/docs/ld/Options.html#index-_002d_002dwarn_002drwx_002dsegments

变更前`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other.1000044097" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other" value="" valueType="string"/>
```

变更后`.cproject`文件的内容

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other.1000044097" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other" value="-Wl,--no-warn-rwx-segments" valueType="string"/>
```


完成以上变更后，reload一下工程，工程就可以在Nuclei Studio 2023.10下正常编译、调试、运行了。

> **说明**：
> 
> 本文档中，所有引用的例子中关于`.cproject`文件，出现的类似`id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114"`中，
> `1735566114`是一个Nuclei Studio生成的hash值，不同时间不同工程各不相同，且其不影响配置，如果能保持与原值相同的情况下，尽量保持相同。
