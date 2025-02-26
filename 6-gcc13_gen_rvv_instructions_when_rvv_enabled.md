# GCC13 auto generated RVV instructions when RVV enabled

## 问题说明

If you are using `Nuclei SDK 0.5.0` with Nuclei RISC-V Toolchain 2023.10, and
when compile some examples with RVV enabled, it may generate rvv instructions
which called auto-vectorzation.

Take `application/baremetal/benchmark/dhrystone` for example:

~~~shell
cd application/baremetal/benchmark/dhrystone
# enable extra vector extension, which means the -march=rv64imafdcv
make CORE=nx900fd ARCH_EXT=v clean
make CORE=nx900fd ARCH_EXT=v dasm
~~~

Then if you check the `dhrystone.dasm`, you will be able to see rvv instructions:

## 解决方案

This auto generated instructions may affect your hardware performance, so if you want
to disable it, you don't need to pass rvv extension when compile application.

~~~shell
$ cat dhrystone.dasm |grep vs
    800003e2:   cc3ff057                vsetivli        zero,31,e8,m8,ta,ma
    800003f8:   02038427                vse8.v  v8,(t2)
    8000040c:   020b8027                vse8.v  v0,(s7)
    800004a2:   cc3ff057                vsetivli        zero,31,e8,m8,ta,ma
    800004b2:   02098827                vse8.v  v16,(s3)
    80000524:   cc3ff057                vsetivli        zero,31,e8,m8,ta,ma
    80000530:   02098c27                vse8.v  v24,(s3)
    80000df2:   cdb3f057                vsetivli        zero,7,e64,m8,ta,ma
    80000dfa:   0204f427                vse64.v v8,(s1)
    80000e20:   cdb3f057                vsetivli        zero,7,e64,m8,ta,ma
    80000e28:   02047027                vse64.v v0,(s0)
~~~

You can check https://gcc.gnu.org/bugzilla/show_bug.cgi?id=112537 for more details.

In gcc 14.x, if you want to disable the RISC-V RVV automatic vectorization, you can use the options ``-fno-tree-loop-vectorize -fno-tree-slp-vectorize``.

In gcc 13.x, you need to pass ``--param=riscv-autovec-preference=none``
