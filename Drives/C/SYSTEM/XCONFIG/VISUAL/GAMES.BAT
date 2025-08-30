@echo off
:GM
cdd C:\
cls
dcolor
echo.
echo ###############################################################################
echo #  ESC...Exit #...Refresh                                                     #
echo #                                                                             #
echo ###############################################################################
echo #  A...Atari  B...Amiga   N...SNES                                            #                        
echo #                                                                             #
echo ###############################################################################      
echo #  U..Unreal  1...Real    2...2nd_real                                        #                                                                                
echo #                                                                             #   
echo ###############################################################################                                                  
echo #  T...TRYRIAN                                                                # 
echo #  D...DOOM 1                                                                 #          
echo #  O...DOOM 2                                                                 #
echo #  0...DOOM MOD                                                               #             
echo #  M...Super Mario Bros.                                                      #           
echo #  Z...The Legend of Zelda                                                    #
echo #  3...Super Mario Bros. 2                                                    #          
echo #  4...Super Mario Bros. 3                                                    #              
echo #  5...Super Mario World                                                      #   
echo #  6...Mega Man                                                               #        
echo #  7...Tetris                                                                 #             
echo #                                                                             #
echo #                                                                             #
echo ###############################################################################
Choice /c:ba#utndo012mz34567 /n /s
if errorlevel 19 goto Tetris
if errorlevel 18 goto MegaMan
if errorlevel 17 goto world
if errorlevel 16 goto super3
if errorlevel 15 goto super2
if errorlevel 14 goto zelda
if errorlevel 13 goto super
if errorlevel 12 goto 2r
if errorlevel 11 goto 1r
if errorlevel 10 goto d3
if errorlevel 9 goto d2
if errorlevel 8 goto d1
if errorlevel 7 goto sn
if errorlevel 6 goto tr
if errorlevel 5 goto ur
if errorlevel 4 goto ref
if errorlevel 3 goto at
if errorlevel 2 goto am
if errorlevel 1 C:\System\XCONFIG\VISUAL\Desk.bat
goto GM
:Tetris
cd D:\Games\SMB
sys01 7
goto GM
:MegaMan
cd D:\Games\SMB
sys01 6
goto GM
:world
cd D:\Games\SMB
sys01 5
goto GM
:super3
cd D:\Games\SMB
sys01 4
goto GM
:super2
cd D:\Games\SMB
sys01 3
goto GM
:zelda
cd D:\Games\SMB
sys01 2
goto GM
:super
cd D:\Games\SMB
sys01 1
goto GM
:1r
D:\Demos\Real\Real.bat
goto GM
:2r
goto GM
:d3
cdd D:\GAMES\FDOOM
D:\GAMES\FDOOM\DOOM2.EXE -playdemo %
goto GM
:d2
cdd D:\GAMES\DOOM2
D:\GAMES\DOOM2\DOOM.EXE -playdemo %
goto GM
:d1
cdd D:\GAMES\DOOM
D:\GAMES\DOOM\DOOM.EXE -playdemo
goto GM
:sn
cls
cdd D:\Emulator\SuperNin\G1\
D:\Emulator\SuperNin\zsnes.exe -s -r 3 -a -v 4 -r 3
goto GM
:tr
cdd D:\GAMES\TYRIAN\
D:\GAMES\TYRIAN\tyrian.exe
goto GM
:ur
D:\Demos\unreal\unreal.exe
goto GM
:ref
LH D:\SYSTEM\XCONFIG\GAMES.BAT
goto GM
:at
cdd D:\Emulator\A2600\Games\
lh D:\Emulator\A2600\Launcher\Z26.EXE
goto GM
:am
lh D:\Emulator\Amiga\Fellow\fellow.exe
goto GM
