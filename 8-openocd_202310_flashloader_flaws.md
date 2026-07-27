# Issues with OpenOCD When Operating on NOR Flash Larger Than 16 MB

## Problem Description

To access the ``0 ~ 16M`` address range, the SPI controller needs to send three bytes of address information; this is called 3-byte address mode. To access the ``16M ~ 2G`` address range, the SPI controller needs to send four bytes of address information; this is called 4-byte address mode.

Both the normal SPI mode and XIP mode of the nuspi controller default to 3-byte address mode.

## Solution

We have developed two sets of SPI drivers in OpenOCD, namely nuspi and custom, both of which support 3-byte mode and 4-byte mode. The nuspi driver can automatically switch between modes by checking the address being accessed.

There are many ways to read/verify data in flash with OpenOCD, which can be grouped into two categories: one reads flash data directly through XIP, and the other reads flash data by calling the driver through normal SPI.

Therefore, when reading flash data directly through XIP, there is a limitation that only the first 16M of the address range can be read. Commands affected by this include:

- ``flash verify_image filename [offset] [type]``
- ``dump_image filename address size``
- the gdb ``x`` command
- and other commands that read memory directly

Of course, OpenOCD also provides flash-reading commands that directly call the SPI driver registered in the cfg file, such as:

- ``flash read_bank num filename [offset [length]]``
- ``flash verify_bank num filename [offset]``
