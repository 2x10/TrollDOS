echo - - reloading: "config.bat" - - -
goto %reload%
goto e
:manuel
c:\system\xconfig\config.bat %1 %2
goto e
:auto
c:\system\xconfig\config.bat --nodesk --alias
:e