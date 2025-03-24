在binutils中新增自定义汇编指令教程
======================================

以下皆以32位指令为例说明

自定义扩展名的识别
----------------

以下以`xnice`扩展为例

文件:`bfd\elfxx-riscv.c`    

`riscv_supported_vendor_x_ext[]` 函数:

```
static struct riscv_supported_ext riscv_supported_vendor_x_ext[] ={
  {"xnice",   ISA_SPEC_CLASS_DRAFT, 1, 0, 0},  
}

```
Tips:该函数负责添加扩展名称和版本号，其中前面两位`1,0`为该扩展版本号


`riscv_multi_subset_supports` 函数:

```
/* Each instuction is belonged to an instruction class INSN_CLASS_*.
   Call riscv_subset_supports to make sure if the instuction is valid.  */

bool
riscv_multi_subset_supports (riscv_parse_subset_t *rps,
			     enum riscv_insn_class insn_class)
{
  switch (insn_class)
    {
      case INSN_CLASS_XNICE:
        return riscv_subset_supports (rps, "xnice"); 
    }
}

```
Tips: `switch`里面是要添加的内容，添加了`xnice`扩展的指令所对应的`INSN_CLASS_XNICE`与`xnice`扩展之间的联系

`riscv_implicit_subsets[]` 函数:(可选)

```
/* Please added in order since this table is only run once time.  */
static struct riscv_implicit_subset riscv_implicit_subsets[] ={
  {"xnice", "+zve32x", check_implicit_always},
}

```
Tips:该函数控制自定义的`xnice`扩展是否依赖其他扩展，如果不依赖，则不需要添加。假设依赖`zve32x`扩展，则需要在该函数内按上面形式添加依赖关系，若依赖多个扩展，则在`zve32x`扩展后面继续添加

文件 `include\opcode\riscv.h`

```
enum riscv_insn_class
{
  INSN_CLASS_XNICE,
}
```
Tips:该文件主要负责在`riscv_insn_class`枚举类中，对`INSN_CLASS_XNICE`进行声明

自定义汇编指令识别
----------------

以下以新增一条标准R类型`nice`指令为例

1、添加指令编码

假设该nice指令汇编格式为`nice rd, rs1, rs2`, 并且使用的是RISC-V预留的custom3区域的编码空间，其编码为： 

![alt text](asserts/images/24/24-1.png)

- 生成编译器所需的`opcode`宏(推荐使用`riscv-opcodes` https://github.com/riscv/riscv-opcodes/tree/master 仓库)   

```
git clone https://github.com/riscv/riscv-opcodes.git

cd riscv-opcodes/extensions/unratified/

vim rv_xnice //在该文件夹下创建xnice扩展指令文件(文件名规则是rv_name)，并根据指令模板添加一条指令

nice rd rs1 rs2 31..25=0x5D 14..12=1 6..2=0x1E 1..0=3 //此为需要添加的指令  

cd ../../

make EXTENSIONS='unratified/rv_xnice'
```

上述步骤后得到了`opcode`宏，在 `riscv-opcodes/encoding.out.h` 文件中, 如下所示:

```
#define MATCH_NICE 0xba00107b
#define MASK_NICE 0xfe00707f
```
注意：也可以根据编码手动生成宏，规则为：`MATCH_NICE` 的编码是未定义位置全为0，其余位置不变。`MASK_NICE` 的编码是未定义位置全为0，其余位置全为1.

- 在 `include\opcode\riscv-opc.h` 文件中，添加上述生成的宏

2、添加扩展与扩展指令编码之间的联系

文件：`opcodes\riscv-opc.c`

`riscv_opcodes[]`函数:
```
const struct riscv_opcode riscv_opcodes[] =
{
/* name, xlen, isa, operands, match, mask, match_func, pinfo.  */
{"xnice",  0, INSN_CLASS_XNICE,  "d,s,t", MATCH_XNICE, MASK_XNICE, match_opcode, 0 },
}
```
Tips: 第一个`0`代表该指令对`xlen`没有要求。`d,s,t` 分别代表`rd,rs1,rs2`, 其中对应的映射关系可在 `gas/config/tc-riscv.c` 文件 `validate_riscv_insn`函数中查找

使用说明
-------
使用时需要将`xnice`通过`-march`选项传递给编译器，例如`-march=rv32imafdc_xnice`

参考链接:
--------

修改binutils在RISC-V上添加汇编指令:  
https://blog.cyyself.name/add-compile-instr-for-riscv/

nuclei自定义vpu指令的扩展识别及汇编实现:  
https://github.com/riscv-mcu/riscv-binutils-gdb/commit/c8806f4bd8c1a1673ec61ad3badfc3d490fa52f7   
