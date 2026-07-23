# Upgrading the Project Toolchain to GCC 13 by Modifying the .cproject File

## Problem Description

> Nuclei Studio 2023.10 is a major version upgrade of the IDE, in which the bundled toolchain was upgraded from gcc10 to gcc13, and the toolchain prefix also changed.
> See https://github.com/Nuclei-Software/nuclei-studio/releases/tag/2023.10

Although the 2023.10 IDE provides a [one-click upgrade tool by right-clicking a project (see Chapter 8 of the IDE manual)](https://doc.nucleisys.com/nuclei_tools/ide/advanceusage.html#gcc-13), it can only convert one project at a time, which is not friendly for projects that need to convert a large number of projects in batch. Therefore,
we list here the approach you can refer to if you want to write a script to convert and upgrade projects.

The following changes only apply to upgrading gcc10 projects created with versions of Nuclei Studio earlier than 2023.10. If batch conversion is required, the script should first check whether the project is a riscv gcc10 project.

## Modifying Toolchain-Related Configuration

The gcc used in versions of Nuclei Studio earlier than 2023.10 incorporated many customizations, whereas the gcc used in Nuclei Studio 2023.10 inherits the features and some naming conventions of the official version. In the project's `.cproject` file, the following values mainly need to be modified. If the value of `ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.name` is `RISC-V Nuclei GCC`, the value of `ilg.gnumcueclipse.managedbuild.cross.riscv.option.toolchain.id` is `3901352267`, and the value of `ilg.gnumcueclipse.managedbuild.cross.riscv.option.command.prefix` is `riscv-nuclei-elf-`, it means the project was created using GCC 10. To make the project support GCC 13, the following changes are required:

* Change the value of toolchain.name from **RISC-V Nuclei GCC** to **RISC-V GCC/Newlib**
* Change the value of toolchain.id from **3901352267** to **2262347901**
* Change the value of command.prefix from **riscv-nuclei-elf-** to **riscv64-unknown-elf-**

Contents of the `.cproject` file before the change

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

Contents of the `.cproject` file after the change

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

## Modifying RISC-V Extension-Related Configuration

In projects created with versions of Nuclei Studio earlier than 2023.10, RISC-V extensions were stored in four separate boolean values, whereas in projects created with Nuclei Studio 2023.10,
they are stored in a single string value. Therefore, we need to find the four old values in the project's `.cproject` file, convert them into the new RISC-V extension string according to the rules,
store it in `ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions`, and clear or delete the four old separate boolean values.

```
# The four separate boolean values
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvk
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector

# The single string value
ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions
```

1. First, determine whether the arch corresponding to the project is rv32/rv64 based on `ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base`
2. Second, determine whether f/d is included based on `ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp`
3. Finally, convert to the correct RISC-V extension string according to the corresponding conversion rules

Conversion rules (note in particular that the value of p needs to be appended at the end of the RISC-V extension string):

* `b` -> `_zba_zbb_zbc_zbs`
* `k` -> `_zk_zks`
* `v` -> `rv32f/d : _zve32f`, `rv64f: _zve64f`, `rv64fd: v`
* `p` -> `rv64: _xxldsp`, `rv32: _xxldspn1x`


For example, suppose there is an N307FD project whose `arch=rv32imafdcbpv` (gcc10). We can tell that it is **rv32**, includes **fd**, and uses the **bpv** extensions. According to the conversion rules, the resulting RISC-V extension string is `_zba_zbb_zbc_zbs_zve32f_xxldspn1x`.

Contents of the `.cproject` file before the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base.489743203" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.base" value="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.arch.rv32i" valueType="enumerated"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp.1936924005" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.fp" value="ilg.gnumcueclipse.managedbuild.cross.riscv.option.isa.fp.double" valueType="enumerated"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb.168405526" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.rvb" value="true" valueType="boolean"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp.565204765" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.dsp" value="true" valueType="boolean"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector.1142078455" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extension.vector" value="true" valueType="boolean"/>		
```

Contents of the `.cproject` file after the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions.1832321358" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.isa.extensions" value="_zba_zbb_zbc_zbs_zve32f_xxldspn1x" valueType="string"/>
```

## Modifying libncrt C Library-Related Configuration

In projects created with versions of Nuclei Studio earlier than 2023.10, when the libncrt C library is used, the project includes a `--specs=libncrt_xxx.specs` option, or the linked libraries
include `-lncrt_xxx`. In projects created with Nuclei Studio 2023.10, if the libncrt C library is used, the `--specs=libncrt_xxx.specs` approach needs to be changed to `-lncrt_xxx`,
and additionally `-lncrt_small -lheapops_basic -lfileops_uart` need to be added at link time, while the general target compile options need to include `-isystem=/include/libncrt`

**Examples**:
* `-lncrt_small` -> `-lncrt_small -lheapops_basic -lfileops_uart`
* `--specs=libncrt_small.specs` -> `-lncrt_small -lheapops_basic -lfileops_uart`


1. Check whether `--specs=libncrt_xxx.specs` exists in the `.cproject` file. If it exists, it means this is a project that uses libncrt, and you can proceed with the subsequent steps
2. If `--specs=libncrt_xxx.specs` exists, delete it first
3. If `-lm` exists, delete it first
4. Check whether `m` exists in `ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs` or `ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`; if it exists, delete it first
5. Check whether `ncrt_xxx` exists in `ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs` or `ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`
6. Based on the above results, add the corresponding values to `ilg.gnumcueclipse.managedbuild.cross.riscv.option.c.linker.libs` or `ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs`
    * If `--specs=libncrt_xxx.specs` exists, add `ncrt_xxx`; or if `ncrt_xxx` exists, you also need to add `heapops_basic` and `fileops_uart`
7. Add ` -isystem=/include/libncrt` to `ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other`

```
# --specs=libncrt_xxx1.specs may exist in the following string values
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

For example, the project uses `--specs=libncrt_balanced.specs`

Contents of the `.cproject` file before the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other" value=" " valueType="string"/>
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.optimization.other.443378574" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.optimization.other" value="--specs=libncrt_balanced.specs" valueType="string"/>
```

Contents of the `.cproject` file after the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other" value="-isystem=/include/libncrt " valueType="string"/>
<option IS_BUILTIN_EMPTY="false" IS_VALUE_EMPTY="false" id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs.146128417" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.libs" valueType="libs">
	<listOptionValue builtIn="false" value="ncrt_balanced"/>
	<listOptionValue builtIn="false" value="fileops_uart"/>
	<listOptionValue builtIn="false" value="heapops_basic"/>
</option>
```

## Adding Configuration to Eliminate Link Warnings

Many warning messages are generated when using GCC 13. You can add the `-Wl,--no-warn-rwx-segments` parameter to the link options to disable these warning messages.

For details, see https://sourceware.org/binutils/docs/ld/Options.html#index-_002d_002dwarn_002drwx_002dsegments

Contents of the `.cproject` file before the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other.1000044097" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other" value="" valueType="string"/>
```

Contents of the `.cproject` file after the change

```xml
<option id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other.1000044097" superClass="ilg.gnumcueclipse.managedbuild.cross.riscv.option.cpp.linker.other" value="-Wl,--no-warn-rwx-segments" valueType="string"/>
```


After completing the above changes, reload the project, and the project can be compiled, debugged, and run normally under Nuclei Studio 2023.10.

> **Note**:
> 
> In this document, in all referenced examples of the `.cproject` file, in entries like `id="ilg.gnumcueclipse.managedbuild.cross.riscv.option.target.other.1735566114"`,
> `1735566114` is a hash value generated by Nuclei Studio. It varies across different times and different projects, and it does not affect the configuration. If it can be kept the same as the original value, try to keep it the same.
