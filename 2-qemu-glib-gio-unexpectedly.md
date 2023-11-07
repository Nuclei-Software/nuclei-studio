# windows 11下使用Nuclei Studio进行qemu调试程序时报错

windows 11下使用Nuclei Studio开发时，当使用qemu调试程序时,会有报错如下，是因为在windows 11下缺少相关依赖，但一般不引响qemu的正确使用，可以呼略此错误。
```
qemu-system-riscv32.exe: warning: GLib-GIO: Unexpectedly, UWP app `Microsoft.ScreenSketch_11.2309.16.0_x64__8wekyb3d8bbwe' (AUMId `Microsoft.ScreenSketch_8wekyb3d8bbwe!App') supports 29 extensions but has no verbs
qemu-system-riscv32.exe: warning: GLib-GIO: Unexpectedly, UWP app `Clipchamp.Clipchamp_2.8.1.0_neutral__yxz26nhyzhsrt' (AUMId `Clipchamp.Clipchamp_yxz26nhyzhsrt!App') supports 41 extensions but has no verbs

```

![](asserts/images/vx_16993400095638.png)
