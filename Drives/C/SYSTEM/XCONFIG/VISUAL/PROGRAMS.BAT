:Programs
cls
dcolor
echo.
echo ###############################################################################
echo #  ESC...Exit  #...Refresh                                                    #
echo ############################################################################### 
echo #                                                                             #
echo #  1...Aurora                                                                 #
echo #  2...FreeDOS editor                                                         #
echo #  3...Cubic                                                                  #
echo #  4...Mdir                                                                   #
echo #  5...Norton Commander                                                       #
echo #  6...DosMem                                                                 #
echo #  7...Nod32                                                                  #
echo #  8...Stress Test                                                            #
echo #  9...max dir                                                                #
echo #  A...reload                                                                 #
echo #  B...Dumm                                                                   #
echo #  C...Mem                                                                    #
echo #  D...PEDIT                                                                  # 
echo #                                                                             #
echo #                                                                             #
echo #                                                                             #
echo #                                                                             #
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
Choice /c:#123456789abcd /n /s
if errorlevel 15 goto pd
if errorlevel 14 goto mem
if errorlevel 13 goto dum
if errorlevel 12 goto rel
if errorlevel 11 goto max
if errorlevel 10 goto st
if errorlevel 9 goto n32
if errorlevel 8 goto dm
if errorlevel 7 goto n
if errorlevel 6 goto m
if errorlevel 5 goto c
if errorlevel 4 goto fe
if errorlevel 3 goto a
if errorlevel 2 programs.bat
if errorlevel 1 desk.bat
:pd
cls
C:\programs\pedit\pedit.exe
goto Programs
:mem
cls
mem
pause > NUL
goto Programs
:n
norton
goto Programs
:a
aurora
goto Programs
:fe
unalias edit
edit
alias edit aurora
alias editor aurora
goto Programs
:c
cd C:\Musik\
cubic
cd..
goto Programs
:m
mdir
goto Programs
:n32
nod32
goto Programs
:dm
cls
dosmem
pause > NUL
goto programs
:dum
dumm
goto Programs
:rel
cls
reload
goto programs
:max
cls
C:\System\MSDOS\Maxdir.exe
pause > NUL
goto Programs
:st
cls
srt
goto Programs