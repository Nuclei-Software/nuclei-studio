# OpenOCD在操作容量大于16M-Byte的nor-flash时的问题

操作0 ~ 16M地址区间spi控制器需要发送三个字节的地址信息，称为3byte地址模式；操作16M ~ 2G地址区间spi控制器则需要发送四个字节的地址信息，称为4byte地址模式；

nuspi控制器的普通spi和xip默认都是3byte地址模式

我们在OpenOCD里开发了两组spi驱动分别是nuspi和custom，都可以支持3byte模式和4byte模式，其中nuspi可通过判断操作地址，自动切换模式

在OpenOCD里有很多种方式可以read/verify flash内的数据，可以归结为两大类，一类是直接通过xip的方式读取flash数据，另一类则是通过调用驱动使用普通spi的方式读取flash数据。

因此，直接通过xip的方式读取flash数据时，就会有只能读到前面16M地址范围的限制，这样的命令有

- flash verify_image filename [offset] [type]
- dump_image filename address size
- gdb的x命令
- 等等 直接读取memory的命令

当然OpenOCD里面也存在一些读取flash的命令，会直接调用cfg文件注册的spi驱动，这样的命令有

- flash read_bank num filename [offset [length]]
- flash verify_bank num filename [offset]
