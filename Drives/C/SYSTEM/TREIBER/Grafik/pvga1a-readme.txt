                          Paradise VESA 1.00 Driver

VESA.EXE is a TSR program that provides support for the VESA BIOS calls.
Type 'VESA' on the DOS command line before running an application using
a VESA compatible driver.

This VESA driver works to VESA spec. 1.00 on the following Paradise boards:

VGA+

VGA+16

VGA PROF.

VGA1024

The return info function says it will work at 1024x768x16, but this is true
only on the VGA 1024 card with 512K memory.  It also says it will work at
640x480x256, but this is true only if the board listed above has 512K memory.

Window B is disabled for this driver.  A future version will support 32k
windows when Window B is enabled.

The window granularity is 4K, so 64K Banks are 16 times 4K.

For boards with the 1A Chip, this driver unlocks the Paradise Registers.
To relock them, call the set mode function (02) for a non-super VGA mode.

