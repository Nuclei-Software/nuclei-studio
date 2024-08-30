# Nuclei Studio Supply Documents

[![Deploy MkDocs](https://github.com/Nuclei-Software/nuclei-studio/actions/workflows/mkdoc.yml/badge.svg)](https://github.com/Nuclei-Software/nuclei-studio/actions/workflows/mkdoc.yml) [![pages-build-deployment](https://github.com/Nuclei-Software/nuclei-studio/actions/workflows/pages/pages-build-deployment/badge.svg)](https://nuclei-software.github.io/nuclei-studio/)

**Document, User Guide, Wiki, and Discussions For Nuclei Studio**

> [!NOTE]
> - The latest version of Nuclei Studio IDE is **2024.06**, which can be found in https://github.com/Nuclei-Software/nuclei-studio/releases/tag/2024.06

> [!NOTE]
> - In **Ubuntu 20.04**, you must install `libncursesw5 libtinfo5 libfdt1 libpixman-1-0 libpng16-16 libasound2 libglib2.0-0` to make **riscv64-unknown-elf-gdb and qemu** able to run.


- **Nuclei Studio IDE Documentation**: https://nucleisys.com/upload/files/doc/nucleistudio/Nuclei_Studio_User_Guide.pdf
- **Nuclei Tools(Toolchain/OpenOCD/Qemu/Model) Documentation**: https://doc.nucleisys.com/nuclei_tools/
- **Nuclei Studio NPK Introduction**: https://github.com/Nuclei-Software/nuclei-sdk/wiki/Nuclei-Studio-NPK-Introduction


Please create new doc based on [Doc Template](0-template.md)

Click [this link](https://nuclei-software.github.io/nuclei-studio/) to see online version.

> 如果您在文档中发现任何拼写错误或不完善之处，我们欢迎您提交Pull Request或Issue，以协助我们进行改进！

> If you come across any spelling errors or areas that need improvement in the document, feel free to submit a Pull Request or Issue to help us enhance it!

## Documents

> Generated by `python3 update.py` @ 2024-08-30 18:49:01

| Document | Description |
|:---|:---|
| [1-cannot-setup-guestmemory.md](1-cannot-setup-guestmemory.md) | 因内存不足，导致在Nuclei Studio中启动qemu失败 |
| [2-qemu-glib-gio-unexpectedly.md](2-qemu-glib-gio-unexpectedly.md) | windows 11下使用Nuclei Studio进行qemu调试程序时报错 |
| [3-print_memor_usage_in_ide.md](3-print_memor_usage_in_ide.md) | How to print memory usage in Nuclei Studio |
| [4-use_pre_build_or_post_build.md](4-use_pre_build_or_post_build.md) | 在编译工程时，使用了Pre-build Command/Post-build Command时报错 |
| [5-update_npk_to_support_nucleistudio_202310.md](5-update_npk_to_support_nucleistudio_202310.md) | 升级npk.yml以支持Nuclei Studio 2023.10 |
| [6-gcc13_gen_rvv_instructions_when_rvv_enabled.md](6-gcc13_gen_rvv_instructions_when_rvv_enabled.md) | GCC13 auto generated RVV instructions when RVV enabled |
| [7-update_nucleistudio_202310_to_fixed_version.md](7-update_nucleistudio_202310_to_fixed_version.md) | 更新 Nuclei Studio 2023.10 到最新修正版本 |
| [8-openocd_202310_flashloader_flaws.md](8-openocd_202310_flashloader_flaws.md) | OpenOCD在操作容量大于16M-Byte的nor-flash时的问题 |
| [9-modify_the_cproject_file_to_change_the_project_to_gcc13.md](9-modify_the_cproject_file_to_change_the_project_to_gcc13.md) | 通过修改.cproject文件，升级工程工具链到GCC 13 |
| [10-compiling_projects_with_headless_in_nuclei_studio.md](10-compiling_projects_with_headless_in_nuclei_studio.md) | 在Nuclei Studio下用命令行编译工程 |
| [11-openocd_reported_error_not_known_as_fespi_capable.md](11-openocd_reported_error_not_known_as_fespi_capable.md) | OpenOCD烧写程序时报错Error:Device ID 8xle2g8a6d is not known as FESPI capable |
| [12-nucleisdk-0.5.0-dhrystone-score-lower-than-expected-in-IDE.md](12-nucleisdk-0.5.0-dhrystone-score-lower-than-expected-in-IDE.md) | 关于dhrystone在IDE上跑分和NSDK 0.5.0命令行跑分不一致的问题 |
| [13-error_could_not_find_an_available_hardware_trigger.md](13-error_could_not_find_an_available_hardware_trigger.md) | Error: Couldn't find an available hardware trigger / Error: can't add breakpoint: resource not available |
| [14-cannot_find_-lncrt_balanced_no_such_file_or_directory.md](14-cannot_find_-lncrt_balanced_no_such_file_or_directory.md) | cannot find -lncrt_balanced: No such file or directory |
| [15-unsatisfiedLinkError_of_swt-win32-4965r8_dll_on_windows7.md](15-unsatisfiedLinkError_of_swt-win32-4965r8_dll_on_windows7.md) | UnsatisfiedLinkError of swt-win32-4965r8.dll on Windows 7 |
| [16-incomplete_data_output_when_using_profiling_function.md](16-incomplete_data_output_when_using_profiling_function.md) | 使用 Profiling 功能时可能遇到的一些问题 |
| [17-an_example_to_demonstrate_the_use_of_profiling_and_code_coverage.md](17-an_example_to_demonstrate_the_use_of_profiling_and_code_coverage.md) | 一个例子用来展示 Profiling 以及 Code coverage 功能 |
| [18-demonstrate_NICE_VNICE_acceleration_of_the_Nuclei_Model_through_profiling.md](18-demonstrate_NICE_VNICE_acceleration_of_the_Nuclei_Model_through_profiling.md) | 通过Profiling展示Nuclei Model NICE/VNICE指令加速 |

