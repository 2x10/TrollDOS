@echo off
:fx
cls
dcolor
echo.
echo ###############################################################################
echo #  ESC...Exit                                             #   D e s k t o p   #
echo #  R...Reboot                                             #####################
echo #  O...Standby                                            #  T r o l l D O S  #
echo #  I...DosBox Help                                        #  E m u l a t o r  #
echo #  H...4DOS Help                                          #    S y s t e m    #
echo #  #...Refresh                                            #      2 0 1 7      #
echo ###############################################################################
echo #                                                                             #
echo #  N...Explorer    Y...Dos Benchmark                                          #
echo #  C...Music       Z...Stupid Stuff                                           #
echo #  A...Antivirus                                                              #
echo #  T...Editor                                                                 #
echo #                                                                             #
echo ###############################################################################
echo #                                                                             #
echo #  S...Edit Systemfiles and Settings                                          #
echo #                                                                             #
echo #  G...Games, Emulators and Demos                                             # 
echo #                                                                             #
echo #  Q...All Programs                                                           #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
Choice /c:onqcatsg#ri*zhybf- /n /s 
if errorlevel 18 goto GS
if errorlevel 18 goto FDE
if errorlevel 17 LH C:\SYSTEM\XCONFIG\VISUAL\SETTINGS.BAT
if errorlevel 16 goto dumm
if errorlevel 15 goto help
if errorlevel 14 goto srt
if errorlevel 13 goto sysinfo
if errorlevel 12 goto intro
if errorlevel 11 goto rebt
if errorlevel 10 LH C:\SYSTEM\XCONFIG\VISUAL\DESK.BAT
if errorlevel 9 LH C:\SYSTEM\XCONFIG\VISUAL\Games.BAT
if errorlevel 8 LH C:\SYSTEM\XCONFIG\VISUAL\SYSEDIT.BAT
if errorlevel 7 goto NP
if errorlevel 6 goto A
if errorlevel 5 goto CB
if errorlevel 4 LH C:\SYSTEM\XCONFIG\VISUAL\PROGRAMS.BAT
if errorlevel 3 goto NC
if errorlevel 2 goto ST
if errorlevel 1 goto ext   
goto fx
:GS
echo ######################################################################!-!#! X !
echo #  ESC...Exit                                             #   D e s k t o p   #
echo #  R...Reboot                                             #####################
echo #  O...Standby                                            #  T r o l l D O S  #
echo #  I...DosBox Help                                        #  E m u l a t o r  #
echo #  H...4DOS Help                                          #    S y s t e m    #
echo #  #...Refresh                                            #      2 0 1 7      #
echo ###############################################################################
echo #                                                                             #
echo #  N...Explorer    D...Mem Display                                            #
echo #  C...Music       Y...Dos Benchmark                                          #
echo #  A...Antivirus   Z...Stupid Stuff                                           #
echo #  T...Editor                                                                 #
echo #                                                                             #
echo ###############################################################################
echo #                                                                             #
echo #  S...Edit Systemfiles and Settings                                          #
echo #                                                                             #
echo #  G...Games, Emulators and Demos                                             # 
echo #                                                                             #
echo #  Q...All Programs                                                           #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
echo ######################################################################!-!#! X !
echo #  ESC...Exit                                             #   D e s k t o p   #
echo #  R...Reboot                                             #####################
echo #  O...Standby                                            #  T r o l l D O S  #
echo #  I...DosBox Help                                        #  E m u l a t o r  #
echo #  H...4DOS Help                                          #    S y s t e m    #
echo #  #...Refresh                                            #      2 0 1 7      #
echo ###############################################################################
echo #                                                                             #
echo #  N...Explorer    D...Mem Display                                            #
echo #  C...Music       Y...Dos Benchmark                                          #
echo #  A...Antivirus   Z...Stupid Stuff                                           #
echo #  T...Editor                                                                 #
echo #                                                                             #
echo ###############################################################################
echo #                                                                             #
echo #  S...Edit Systemfiles and Settings                                          #
echo #                                                                             #
echo #  G...Games, Emulators and Demos                                             # 
echo #                                                                             #
echo #  Q...All Programs                                                           #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
cls
echo ######################################################################!-!#! X !
echo #  ESC...Exit                                             #   D e s k t o p   #
echo #  R...Reboot                                             #####################
echo #  O...Standby                                            #  T r o l l D O S  #
echo #  I...DosBox Help                                        #  E m u l a t o r  #
echo #  H...4DOS Help                                          #    S y s t e m    #
echo #  #...Refresh                                            #      2 0 1 7      #
echo ###############################################################################
echo #                                                                             #
echo #  N...Explorer    D...Mem Display                                            #
echo #  C...Music       Y...Dos Benchmark                                          #
echo #  A...Antivirus   Z...Stupid Stuff                                           #
echo #  T...Editor                                                                 #
echo #                                                                             #
echo ###############################################################################
echo #                                                                             #
echo #  S...Edit Systemfiles and Settings                                          #
echo #                                                                             #
echo #  G...Games, Emulators and Demos                                             # 
echo #                                                                             #
echo #  Q...All Programs                                                           #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
cls
goto GS
:opt
cls
option
goto fx
:FDE
cls
unalias edit
edit
alias edit aurora
goto fx
:dumm
cls
piep.bat
goto fx
:help
cls 
4help 
goto fx
:srt
srt
goto fx
:DosMem
cls
mem
pause > NUL
goto fx
:intro
intro
goto fx
:NP
%editor%
goto fx
:A
%av%
goto fx
:CB
cdd D:\Musik\
%Player%
goto fx
:NC
%Explorer%
goto fx
:St
color 0 0
cls
pause > NUL
goto fx
:reboot
cls
LH C:\AUTOEXEC.BAT
:rebt
LH FREB.BAT
goto desk
@echo off
:normald
lh NORM.BAT
goto fx
:exit
:ext
outp.bat
:exx
