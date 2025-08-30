@echo off

goto %1
goto e

:clock
clock /x > NUL
goto e
 
:-?
echo syntax: taskkill <program>
:e
