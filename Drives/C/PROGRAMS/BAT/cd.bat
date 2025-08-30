@echo off

cdd %1
goto %1 %2
goto e
:4dos
cdd c:\system\4dos
goto e
:system
cdd c:\system\
goto e
:xconfig
cdd c:\system
goto e
:programs
cdd c:\programs\
goto e
:programs\bat
cdd c:\programs\bat
goto e
:temp
cdd c:\temp
goto e
:logs
cdd c:\logs\
goto e

:/?
cdd /?
:e