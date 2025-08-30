@echo off
:SYSD
cls
dcolor
echo.
echo ###############################################################################
echo #  ESC...Exit  #...Refresh                                                    #
echo ###############################################################################
echo #                          #                                                  #
echo #  A...4DOS.BAT            #  +...4DOS Settings                               #
echo #  M...CONFIG.BAT          #  Q...Switch DOS MODE                             #
echo #  D...DESK.BAT            #  Y...Deactivate Clock                            #
echo #  S...SYSEDIT.BAT         #  W...Activate Clock                              #
echo #  G...GAMES.BAT           #                                                  #
echo #  Z...AUTOEXEC.BAT (Z:\)  #                                                  #
echo #  L...DLOAD.BAT           #                                                  #
echo #  C...XCONFIG.BAT         #                                                  #
echo #  P...PARMS.BAT           #                                                  #
echo #  O...OUTP.BAT            #                                                  #
echo #                          #                                                  #
echo ###############################################################################
echo #                                                                             #
echo #  Editor   : 1...Aurora   # 2...FreeDOS Editor      # 7...PEDIT              #
echo #  Explorer : 3...Mdir     # 4...Norton_Commander    #                        #
echo #  Dir      : 5...Dir      # 6...MaxDir              #                        # 
echo #                                                                             #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
Choice /c:amd#sgy12h34567lcpo+qzw* /n /s
if errorlevel 25 goto msd
if errorlevel 24 goto ac
if errorlevel 23 goto dc
if errorlevel 22 goto dos
if errorlevel 21 goto 4s
if errorlevel 20 goto ou
if errorlevel 19 goto pa
if errorlevel 18 goto xc
if errorlevel 17 goto ld
if errorlevel 16 goto pd
if errorlevel 15 goto mxdr
if errorlevel 14 goto dr
if errorlevel 13 goto nc
if errorlevel 12 goto md
if errorlevel 11 goto CB_EDIT
if errorlevel 10 goto seta
if errorlevel 9 goto setm
if errorlevel 8 goto Z_AUTO_EDIT
if errorlevel 7 goto GAME_EDIT
if errorlevel 6 goto SYSD_EDIT
if errorlevel 5 goto ref
if errorlevel 4 goto DESK_EDIT
if errorlevel 3 goto MEGA_EDIT
if errorlevel 2 goto BOOT_EDIT
if errorlevel 1 LH C:\System\XCONFIG\VISUAL\Desk.BAT
goto SYSD
:msd
msd
goto sysd
:ac
clock > NUL
goto sysd
:dc
clock /x > NUL
clock /x > NUL
clock /x > NUL
clock /x > NUL
goto sysd
:dos
c:\system\xconfig\VISUAL\dosmode.bat
goto sysd
:4s
option
goto sysd
:ou
edit c:\system\xconfig\outp.bat
goto sysd
:pa
edit c:\system\xconfig\parms.bat
goto sysd
:xc
edit c:\system\xconfig\config.bat
goto sysd
:ld
edit c:\system\xconfig\VISUAL\DLOAD.bat
goto sysd
:pd
set dir=pedit
goto sysd
:dr
set dir=dir.
alias dir ndir
goto sysd
:mxdr
alias dir C:\Programs\bat\mxdr.bat
set dir=C:\Programs\bat\mxdr.bat
goto sysd
:md
set explorer=mdir
goto sysd
:nc
set explorer=norton_commander
goto sysd
:CB_EDIT
edit C:\SYSTEM\XCONFIG\CBIOS.BAT
goto sysd
:Seta
unalias edit         
alias editor edit
set editor=edit
goto SYSD
:setm
alias edit aurora
alias editor aurora
set editor=aurora
goto SYSD
:Z_AUTO_EDIT
edit Z:\AUTOEXEC.BAT
echo zugriff vergweigert!
pause
goto SYSD
:GAME_EDIT
edit C:\SYSTEM\XCONFIG\VISUAL\GAMES.BAT
goto SYSD
:ref
LH SYSEDIT.BAT
:SYSD_EDIT
edit C:\SYSTEM\XCONFIG\VISUAL\SYSEDIT.BAT
goto SYSD
:BOOT_EDIT
edit C:\SYSTEM\XCONFIG\4DOS.BAT
goto SYSD
:MEGA_EDIT
edit C:\SYSTEM\XCONFIG\CONFIG.BAT
goto SYSD
:DESK_EDIT
edit C:\SYSTEM\XCONFIG\VISUAL\DESK.BAT
goto SYSD
