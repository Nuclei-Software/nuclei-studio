在llvm中新增自定义汇编指令教程
===========================

以下皆以32位指令为例说明

自定义扩展名的识别
----------------

以下以`xnice`扩展为例

文件:`llvm/lib/Target/RISCV/RISCVFeatures.td`

添加内容：
```
def FeatureVendorXnice
    : RISCVExtension<"xnice", 1, 0,
                    "'Xnice' (Xnice extension)">;
def HasVendorXnice
    : Predicate<"Subtarget->hasVendorXnice()">,
    AssemblerPredicate<(all_of FeatureVendorXnice),
                        "'Xnice' (Xnice extension)">;
```

注意：`RISCVExtension`处第一个`xnice`为实际llvm编译器可识别的扩展名, 后面的`1, 0`为该扩展的版本号，第二个`Xnice`只是用于扩展功能描述

自定义汇编指令识别
----------------

以下以新增一条标准R类型`nice`指令为例

1、添加对应解码器

文件:`llvm/lib/Target/RISCV/Disassembler/RISCVDisassembler.cpp`

函数:`DecodeStatus RISCVDisassembler::getInstruction32()`

内容：
```
TRY_TO_DECODE_FEATURE(RISCV::FeatureVendorXnice, DecoderTableXnice32,
                      "Xnice extension");
```

2、创建编解码文件

在`llvm/lib/Target/RISCV/`下创建一个`RISCVInstrInfoXnice.td`的编解码文件，并在`llvm/lib/Target/RISCV/RISCVInstrInfo.td`中将该文件include进来
```
include "RISCVInstrInfoXnice.td"
```

3、指令编码

假设该nice指令汇编格式为`nice rd, rs1, rs2`, 并且使用的是RISC-V预留的custom3区域的编码空间，则编码步骤如下：

- 新建一个`XniceInstr`的类用于说明XNICE扩展的所有指令的统一格式，由于是R类型指令，所以可以直接从llvm中预先写好的`RVInstR`类继承而来，否则需要继承其他相匹配的类或者继承基类重新写一个指令类出来, llvm中所有指令类的声明位于`llvm/lib/Target/RISCV/RISCVInstrFormats.td`

- 通过`Predicates`限定`nice`指令所在的扩展（`[HasVendorXnice]`）以及使用的解码器（`DecoderNamespace = "Xnice"`）

- 通过`def`新增一个指令说明，只需要通过`XniceInstr`以及填充该类在声明时缺少的参数即可完成一条指令的编码，例如自定义的R类型指令只需要再次声明func7，func3以及汇编指令名

完整示例如下：

```
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
 class XniceInstr<bits<7> funct7, bits<3> funct3, string opcodestr>
     : RVInstR<funct7, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
               (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;
 }

 let Predicates = [HasVendorXnice], DecoderNamespace = "Xnice" in {
   def NICE  : XniceInstr<0b1111010, 0b001, "nice">;
 }
```

`OPC_CUSTOM_3`是`llvm/lib/Target/RISCV/RISCVInstrFormats.td`中已经预留的宏，如果使用的其他编码空间，则可以直接查找更改

对于`def`后大写的`NICE`一般用于intrinsic或者自定向量化等调用，只做汇编时可以只给汇编指令名的大写格式用于区分

另外，以上示例中没有限制指令在RV32/64下的使用场景，因此RV32/64下都可识别，如果需要限定只在RV32下使用，则需要额外在`Predicates`中指定扩展时同时进行限定，例如`[HasVendorXxlczbitop, IsRV32]`


使用说明
-------
使用时与GCC一样，只需要将`xnice`通过`-march`选项传递给llvm编译器即可，例如`-march=rv32imafdc_xnice`


参考链接
-------

llvm table gen语法手册
https://llvm.org/docs/TableGen/ProgRef.html

PLCT关于在LLVM中添加RISC-V的自定义指令的示例
https://www.bilibili.com/video/BV1JR4y1J7he

nuclei自定义vpu指令的扩展识别及汇编实现
https://github.com/riscv-mcu/llvm-project/commit/f5d025b9800f3cd662e93c11eb7c7b0f65ca4472


