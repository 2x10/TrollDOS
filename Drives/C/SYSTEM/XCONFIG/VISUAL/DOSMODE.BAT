@echo off
:SW
dcolor
cls
echo ESC...Exit                                                          Refresh...#
echo.
echo 1...Restart/Start 4DOS
echo 2...Start DosBox Command (Z:\)
echo 3...Start MSDos
echo 4...Start NewDos
echo 5...Start PCDos
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
Choice /c:#123456789 /n /s
if errorlevel 9 goto SW
if errorlevel 8 goto SW
if errorlevel 7 goto PCDos
if errorlevel 6 goto NewDos
if errorlevel 5 goto MSDOS
if errorlevel 4 goto DosBox
if errorlevel 3 goto 4dos
if errorlevel 2 goto SW
if errorlevel 1 LH C:\System\XCONFIG\VISUAL\SYSEDIT.BAT
:PCDos
grau
cls
c:\SYSTEM\PCDOS\COMMAND.COM
echo - - - Dos Exited - - -
pause
dosmode
:NewDos
grau
cls
c:\system\newdos\cmd.com
echo - - - Dos Exited - - -
pause
dosmode
:MSDos
grau
cls
c:\system\msdos\dos.com
echo - - - Dos Exited - - -
pause
dosmode
:DosBox
grau
cls
z:\command.com
echo - - - Dos Exited - - -
pause
dosmode
:4dos
grau
cls
C:\SYSTEM\4DOS\4DOS.COM /p
echo - - - Dos Exited - - -
pause
dosmode