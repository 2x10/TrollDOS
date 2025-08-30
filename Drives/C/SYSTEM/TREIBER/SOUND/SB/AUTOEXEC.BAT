@echo off

path c:\windows\command

xcopy \eapci*.* c:\windows\system /v
xcopy \*.exe c:\eapci /v
xcopy \apinit.com c:\eapci /v
xcopy \audiopci.bin c:\eapci /v

