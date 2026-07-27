Tutorial for Adding Custom Assembly Instructions in LLVM
===========================

All examples below use 32-bit instructions

Recognizing the Custom Extension Name
----------------

The following uses the `xnice` extension as an example

File: `llvm/lib/Target/RISCV/RISCVFeatures.td`

Content to add:
```
def FeatureVendorXnice
    : RISCVExtension<"xnice", 1, 0,
                    "'Xnice' (Xnice extension)">;
def HasVendorXnice
    : Predicate<"Subtarget->hasVendorXnice()">,
    AssemblerPredicate<(all_of FeatureVendorXnice),
                        "'Xnice' (Xnice extension)">;
```

Note: In `RISCVExtension`, the first `xnice` is the actual extension name recognized by the LLVM compiler, the following `1, 0` is the version number of the extension, and the second `Xnice` is only used for the extension's functional description

Recognizing Custom Assembly Instructions
----------------

The following uses the addition of a standard R-type `nice` instruction as an example

1. Add the corresponding decoder

File: `llvm/lib/Target/RISCV/Disassembler/RISCVDisassembler.cpp`

Function: `DecodeStatus RISCVDisassembler::getInstruction32()`

Content:
```
TRY_TO_DECODE_FEATURE(RISCV::FeatureVendorXnice, DecoderTableXnice32,
                      "Xnice extension");
```

2. Create the encoding/decoding file

Create an encoding/decoding file named `RISCVInstrInfoXnice.td` under `llvm/lib/Target/RISCV/`, and include this file in `llvm/lib/Target/RISCV/RISCVInstrInfo.td`
```
include "RISCVInstrInfoXnice.td"
```

3. Instruction encoding

Assume the assembly format of the nice instruction is `nice rd, rs1, rs2`, and it uses the encoding space of the custom3 region reserved by RISC-V. The encoding steps are as follows:

- Create a class named `XniceInstr` to describe the unified format of all instructions in the XNICE extension. Since it is an R-type instruction, it can be directly inherited from the pre-defined `RVInstR` class in LLVM; otherwise, you need to inherit from another matching class or write a new instruction class from the base class. The declarations of all instruction classes in LLVM are located in `llvm/lib/Target/RISCV/RISCVInstrFormats.td`

- Use `Predicates` to specify the extension the `nice` instruction belongs to (`[HasVendorXnice]`) and the decoder it uses (`DecoderNamespace = "Xnice"`)

- Use `def` to add an instruction definition. You only need `XniceInstr` and to fill in the parameters missing from the class declaration to complete the encoding of an instruction. For example, a custom R-type instruction only requires declaring funct7, funct3, and the assembly instruction name again

Complete example:

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

`OPC_CUSTOM_3` is a macro already reserved in `llvm/lib/Target/RISCV/RISCVInstrFormats.td`. If you use a different encoding space, you can directly look it up and change it

The uppercase `NICE` after `def` is generally used for intrinsics or auto-vectorization calls. When only doing assembly, you can simply provide the uppercase format of the assembly instruction name for differentiation

In addition, the above example does not restrict the usage scenarios of the instruction under RV32/64, so it can be recognized under both RV32 and RV64. If you need to restrict it to RV32 only, you need to additionally specify the restriction together with the extension in `Predicates`, for example `[HasVendorXxlczbitop, IsRV32]`


Usage Instructions
-------
Usage is the same as with GCC. You only need to pass `xnice` to the LLVM compiler via the `-march` option, for example `-march=rv32imafdc_xnice`


References
-------

LLVM TableGen syntax reference
https://llvm.org/docs/TableGen/ProgRef.html

PLCT's example of adding custom RISC-V instructions in LLVM
https://www.bilibili.com/video/BV1JR4y1J7he

Extension recognition and assembly implementation of Nuclei's custom VPU instructions
https://github.com/riscv-mcu/llvm-project/commit/f5d025b9800f3cd662e93c11eb7c7b0f65ca4472
