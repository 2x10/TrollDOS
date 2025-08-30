@echo off

REM PKZIP for DOS V2.04g to V2.50 Update
REM Copyright 1999 PKWARE, Inc All Rights Reserved
REM PK250UPD.BAT Version 5

echo This program will update PKZIP for DOS to Version 2.50.  
echo .
echo This program must be run from the folder that contains
echo the programs for version 2.04g.  Press Control-C to quit,
echo or any other key to continue.
pause > nul

echo .
rem make sure we haven't tried to run this before
if exist VER_204G\PKZIP.EXE goto errorrun

rem Check for the existence of needed files.
rem These are considered fatal errors.

if not exist PKZIP.EXE      goto noPKZIP
if not exist PK250UPD.BAT   goto noBATFIL
if not exist PKPATCH.EXE    goto noPKPTCH
if not exist SSSPTCHD.EXE   goto noSSPTCH

rem Check for other files that must exist
if not exist ADDENDUM.DOC   goto noADDEND
if not exist AUTHVERI.FRM   goto noAUTHVE
if not exist INSTALL.BAT    goto noINSTAL
if not exist LICENSE.DOC    goto noLICENS
if not exist ORDER.DOC      goto noORDER
if not exist PKSFANSI.COM   goto noPKSFAC
if not exist PKSFANSI.DOC   goto noPKSFAN
if not exist PKUNZIP.EXE    goto noPKUNZI
if not exist PKUNZJR.COM    goto noPKUNZJ
if not exist PKZIPFIX.EXE   goto noPKZFIX
if not exist PUTAV.EXE      goto noPUTAV
if not exist README         goto noREADME
if not exist ZIP2EXE.EXE    goto noZIP2EX

rem Check for non-critical files and prompt to continue.
if exist APPNOTE.TXT goto skipAPP1
echo .
echo Warning: APPNOTE.TXT does not exist.
echo Press Control-C to quit, or any other key to continue.
pause > nul
:skipAPP1

if exist HINTS.TXT goto skiphin1
echo .
echo Warning: HINTS.TXT does not exist.
echo Press Control-C to quit, or any other key to continue.
pause > nul
:skiphin1

rem Backup existing 2.04g files before updating

echo .
echo Saving PKZIP V2.04g files to folder: .\VER_204G
md       VER_204G                                   >nul
if exist README       copy README         VER_204G  >nul
if exist INSTALL.BAT  copy INSTALL.BAT    VER_204G  >nul
if exist ADDENDUM.DOC copy ADDENDUM.DOC   VER_204G  >nul
if exist WHATSNEW.204 copy WHATSNEW.204   VER_204G  >nul
if exist V204G.NEW    copy V204G.NEW      VER_204G  >nul
if exist HINTS.TXT    copy HINTS.TXT      VER_204G  >nul
if exist ORDER.DOC    copy ORDER.DOC      VER_204G  >nul
if exist PKZIP.EXE    copy PKZIP.EXE      VER_204G  >nul
if exist PKUNZIP.EXE  copy PKUNZIP.EXE    VER_204G  >nul
if exist ZIP2EXE.EXE  copy ZIP2EXE.EXE    VER_204G  >nul
if exist PKZIPFIX.EXE copy PKZIPFIX.EXE   VER_204G  >nul
if exist PUTAV.EXE    copy PUTAV.EXE      VER_204G  >nul
if exist PKCFG.EXE    copy PKCFG.EXE      VER_204G  >nul
if exist PKUNZJR.COM  copy PKUNZJR.COM    VER_204G  >nul
if exist PKSFANSI.COM copy PKSFANSI.COM   VER_204G  >nul
if exist PKSFANSI.DOC copy PKSFANSI.DOC   VER_204G  >nul
if exist APPNOTE.TXT  copy APPNOTE.TXT    VER_204G  >nul
if exist LICENSE.DOC  copy LICENSE.DOC    VER_204G  >nul
if exist AUTHVERI.FRM copy AUTHVERI.FRM   VER_204G  >nul
if exist PKZIP.ICO    copy PKZIP.ICO      VER_204G  >nul
if exist OMBUDSMN.ASP copy OMBUDSMN.ASP   VER_204G  >nul
if exist PKZ204G.EXE  copy PKZ204G.EXE    VER_204G  >nul


rem Start the actual update process by patching files

echo .
echo Updating PKZIP for DOS to Version 2.50

REM Update all patch files now...
SSSPTCHD.EXE ADDENDUM.DOC ADDENDUM.TMP ADDENDUM.PCH > nul
if ERRORLEVEL 1 goto erroradd

if not exist APPNOTE.TXT goto skipapp2
SSSPTCHD.EXE APPNOTE.TXT  APPNOTE.TMP  APPNOTE.PCH  > nul
if ERRORLEVEL 1 goto warnapp
:skipapp2

SSSPTCHD.EXE AUTHVERI.FRM AUTHVERI.TMP AUTHVERI.PCH > nul
if ERRORLEVEL 1 goto errorath

if not exist HINTS.TXT goto skiphin2
SSSPTCHD.EXE HINTS.TXT    HINTS.TMP    HINTS.PCH    > nul
if ERRORLEVEL 1 goto warnhint
:skiphin2

SSSPTCHD.EXE INSTALL.BAT  INSTALL.TMP  INSTALL.PCH  > nul
if ERRORLEVEL 1 goto errorins

SSSPTCHD.EXE LICENSE.DOC  LICENSE.TMP  LICENSE.PCH  > nul
if ERRORLEVEL 1 goto errorlic

SSSPTCHD.EXE ORDER.DOC    ORDER.TMP    ORDER.PCH    > nul
if ERRORLEVEL 1 goto errorord

SSSPTCHD.EXE PKSFANSI.COM PKSFACOM.TMP PKSFACOM.PCH > nul
if ERRORLEVEL 1 goto errorsfc

SSSPTCHD.EXE PKSFANSI.DOC PKSFANSI.TMP PKSFANSI.PCH > nul
if ERRORLEVEL 1 goto errorsfa

SSSPTCHD.EXE PKUNZIP.EXE  PKUNZIP.TMP  PKUNZIP.PCH  > nul
if ERRORLEVEL 1 goto errorunz

SSSPTCHD.EXE PKUNZJR.COM  PKUNZJR.TMP  PKUNZJR.PCH  > nul
if ERRORLEVEL 1 goto errorjr

SSSPTCHD.EXE PKZIPFIX.EXE PKZIPFIX.TMP PKZIPFIX.PCH > nul
if ERRORLEVEL 1 goto errorFIX

SSSPTCHD.EXE PUTAV.EXE    PUTAV.TMP    PUTAV.PCH    > nul
if ERRORLEVEL 1 goto errorav

SSSPTCHD.EXE README       README.TMP   README.PCH   > nul
if ERRORLEVEL 1 goto errorrea

SSSPTCHD.EXE ZIP2EXE.EXE  ZIP2EXE.TMP  ZIP2EXE.PCH  > nul
if ERRORLEVEL 1 goto errorEXE

if exist PKZIP.EXE attrib -r PKZIP.EXE > nul
PKPATCH.EXE PKZIP.PAT > nul
if ERRORLEVEL 1 goto errorzip
goto success


:warnhint
echo Warning: Failed to update HINTS.TXT.
goto skiphin2

:warnapp
echo Warning: Failed to update APPNOTE.TXT.
goto skipapp2

:erroradd
echo Error: Cannot update ADDENDUM.DOC.
goto error

:errorath
echo Error: Cannot update AUTHVERI.FRM.
goto error

:errorins
echo Error: Cannot update INSTALL.BAT.
goto error

:errorlic
echo Error: Cannot update LICENSE.DOC.
goto error

:errorord
echo Error: Cannot update ORDER.DOC.
goto error

:errorsfc
echo Error: Cannot update PKSFANSI.COM.
goto error

:errorsfc
echo Error: Cannot update PKSFANSI.DOC.
goto error

:errorunz
echo Error: Cannot update PKUNZIP.EXE.
goto error

:errorjr
echo Error: Cannot update PKUNZJR.COM.
goto error

:errorFIX
echo Error: Cannot update PKZIPFIX.EXE.
goto error

:errorav
echo Error: Cannot update PUTAV.EXE.
goto error

:errorrea
echo Error: Cannot update README.
goto error

:errorEXE
echo Error: Cannot update ZIP2EXE.EXE.
goto error

:errorzip
echo Error: Cannot update PKZIP.EXE.
goto error

:noPKZIP
echo Error: PKZIP.EXE was not found.  
goto noBATFIL

:noADDEND
echo Error: ADDENDUM.DOC was not found.  
goto noBATFIL

:noAUTHVE
echo Error: AUTHVERI.FRM was not found.  
goto noBATFIL

:noINSTAL
echo Error: INSTALL.BAT was not found.  
goto noBATFIL

:noLICENS
echo Error: LICENSE.DOC was not found.  
goto noBATFIL

:noORDER
echo Error: ORDER.DOC was not found.  
goto noBATFIL

:noPKSFAC
echo Error: PKSFANSI.COM was not found.  
goto noBATFIL

:noPKSFAN
echo Error: PKSFANSI.DOC was not found.  
goto noBATFIL

:noPKUNZI
echo Error: PKUNZIP.EXE was not found.  
goto noBATFIL

:noPKUNZJ
echo Error: PKUNZJR.COM was not found.  
goto noBATFIL

:noPKZFIX
echo Error: PKZIPFIX.EXE was not found.  
goto noBATFIL

:noPUTAV
echo Error: PUTAV.EXE was not found.  
goto noBATFIL

:noREADME
echo Error: README was not found.  
goto noBATFIL

:noZIP2EX
echo Error: ZIP2EXE.EXE was not found.  
goto noBATFIL

:noPKPTCH
echo Error: PKPATCH.EXE was not found.  
goto noBATFIL

:noSSPTCH
echo Error: SSSPTCHD.EXE was not found.  
goto noBATFIL

:noBATFIL
echo .
echo Please make sure you are running this 
echo update from the folder that contains 
echo your PKZIP V2.04g programs.
goto error

:errorrun
echo .
echo An attempt to update to PKZIP for DOS V2.50
echo appears to have already been made.  Please
echo make sure you restore your original files
echo for version 2.04g before running this update.
goto cleanup

:error
echo .
echo Failed to update PKZIP for DOS to Version 2.50!
if exist CNVCFG.BAT    del CNVCFG.BAT   > nul
if exist MANUAL.TXT    del MANUAL.TXT   > nul
if exist PKZF25.TXT    del PKZF25.TXT   > nul
if exist PKZFIND.EXE   del PKZFIND.EXE  > nul
if exist SAMPLE.INI    del SAMPLE.INI   > nul
if exist WHATSNEW.TXT  del WHATSNEW.TXT > nul
goto cleanup

:success
if exist ADDENDUM.DOC   attrib -r ADDENDUM.DOC > nul
if exist APPNOTE.TXT    attrib -r APPNOTE.TXT  > nul
if exist AUTHVERI.FRM   attrib -r AUTHVERI.FRM > nul
if exist HINTS.TXT      attrib -r HINTS.TXT    > nul
if exist INSTALL.BAT    attrib -r INSTALL.BAT  > nul
if exist LICENSE.DOC    attrib -r LICENSE.DOC  > nul
if exist ORDER.DOC      attrib -r ORDER.DOC    > nul
if exist PKSFANSI.COM   attrib -r PKSFANSI.COM > nul
if exist PKSFANSI.DOC   attrib -r PKSFANSI.DOC > nul
if exist PKUNZIP.EXE    attrib -r PKUNZIP.EXE  > nul
if exist PKUNZJR.EXE    attrib -r PKUNZJR.COM  > nul
if exist PKZIPFIX.EXE   attrib -r PKZIPFIX.EXE > nul
if exist PUTAV.EXE      attrib -r PUTAV.EXE    > nul
if exist README         attrib -r README       > nul
if exist ZIP2EXE.EXE    attrib -r ZIP2EXE.EXE  > nul

if exist ADDENDUM.TXT    del   ADDENDUM.TXT               > nul
if exist ADDENDUM.TMP    copy  ADDENDUM.TMP  ADDENDUM.TXT > nul
if exist APPNOTE.TXT     del   APPNOTE.TXT                > nul
if exist APPNOTE.TMP     copy  APPNOTE.TMP   APPNOTE.TXT  > nul
if exist AUTHVERI.TXT    del   AUTHVERI.TXT               > nul
if exist AUTHVERI.TMP    copy  AUTHVERI.TMP  AUTHVERI.TXT > nul
if exist HINTS.TXT       del   HINTS.TXT                  > nul
if exist HINTS.TMP       copy  HINTS.TMP     HINTS.TXT    > nul
if exist INSTALL.BAT     del   INSTALL.BAT                > nul
if exist INSTALL.TMP     copy  INSTALL.TMP   INSTALL.BAT  > nul
if exist LICENSE.TXT     del   LICENSE.TXT                > nul
if exist LICENSE.TMP     copy  LICENSE.TMP   LICENSE.TXT  > nul
if exist ORDER.TXT       del   ORDER.TXT                  > nul
if exist ORDER.TMP       copy  ORDER.TMP     ORDER.TXT    > nul
if exist PKSFANSI.COM    del   PKSFANSI.COM               > nul
if exist PKSFACOM.TMP    copy  PKSFACOM.TMP  PKSFANSI.COM > nul
if exist PKSFANSI.TXT    del   PKSFANSI.TXT               > nul
if exist PKSFANSI.TMP    copy  PKSFANSI.TMP  PKSFANSI.TXT > nul
if exist PKUNZIP.EXE     del   PKUNZIP.EXE                > nul
if exist PKUNZIP.TMP     copy  PKUNZIP.TMP   PKUNZIP.EXE  > nul
if exist PKUNZJR.COM     del   PKUNZJR.COM                > nul
if exist PKUNZJR.TMP     copy  PKUNZJR.TMP   PKUNZJR.COM  > nul
if exist PKZIPFIX.EXE    del   PKZIPFIX.EXE               > nul
if exist PKZIPFIX.TMP    copy  PKZIPFIX.TMP  PKZIPFIX.EXE > nul
if exist PUTAV.EXE       del   PUTAV.EXE                  > nul
if exist PUTAV.TMP       copy  PUTAV.TMP     PUTAV.EXE    > nul
if exist README.TXT      del   README.TXT                 > nul
if exist README.TMP      copy  README.TMP    README.TXT   > nul
if exist ZIP2EXE.EXE     del   ZIP2EXE.EXE                > nul
if exist ZIP2EXE.TMP     copy  ZIP2EXE.TMP   ZIP2EXE.EXE  > nul

REM delete files that have been renamed 
if exist ADDENDUM.DOC    del ADDENDUM.DOC > nul
if exist AUTHVERI.FRM    del AUTHVERI.FRM > nul
if exist LICENSE.DOC     del LICENSE.DOC  > nul
if exist ORDER.DOC       del ORDER.DOC    > nul
if exist PKSFANSI.DOC    del PKSFANSI.DOC > nul
if exist README          del README       > nul

REM delete files that are now obsolete
if exist PKCFG.EXE       del PKCFG.EXE    > nul
if exist PKZ204G.EXE     del PKZ204G.EXE  > nul
if exist V204G.new       del V204G.NEW    > nul
if exist WHATSNEW.204    del WHATSNEW.204 > nul

REM We're all done
echo .
echo Successfully updated PKZIP for DOS to Version 2.50!

:cleanup
REM delete .TMP files
if exist ADDENDUM.TMP    del ADDENDUM.TMP > nul
if exist APPNOTE.TMP     del APPNOTE.TMP  > nul
if exist AUTHVERI.TMP    del AUTHVERI.TMP > nul
if exist HINTS.TMP       del HINTS.TMP    > nul
if exist INSTALL.TMP     del INSTALL.TMP  > nul
if exist LICENSE.TMP     del LICENSE.TMP  > nul
if exist ORDER.TMP       del ORDER.TMP    > nul
if exist PKSFACOM.TMP    del PKSFACOM.TMP > nul
if exist PKSFANSI.TMP    del PKSFANSI.TMP > nul
if exist PKUNZIP.TMP     del PKUNZIP.TMP  > nul
if exist PKUNZJR.TMP     del PKUNZJR.TMP  > nul
if exist PKZIP.OLD       del PKZIP.OLD    > nul
if exist PKZIPFIX.TMP    del PKZIPFIX.TMP > nul
if exist PUTAV.TMP       del PUTAV.TMP    > nul
if exist README.TMP      del README.TMP   > nul
if exist ZIP2EXE.TMP     del ZIP2EXE.TMP  > nul

REM delete patch files
if exist ADDENDUM.PCH    del ADDENDUM.PCH > nul
if exist APPNOTE.PCH     del APPNOTE.PCH  > nul
if exist AUTHVERI.PCH    del AUTHVERI.PCH > nul
if exist HINTS.PCH       del HINTS.PCH    > nul
if exist INSTALL.PCH     del INSTALL.PCH  > nul
if exist LICENSE.PCH     del LICENSE.PCH  > nul
if exist ORDER.PCH       del ORDER.PCH    > nul
if exist PKSFACOM.PCH    del PKSFACOM.PCH > nul
if exist PKSFANSI.PCH    del PKSFANSI.PCH > nul
if exist PKUNZIP.PCH     del PKUNZIP.PCH  > nul
if exist PKUNZJR.PCH     del PKUNZJR.PCH  > nul
if exist PKZIPFIX.PCH    del PKZIPFIX.PCH > nul
if exist PUTAV.PCH       del PUTAV.PCH    > nul
if exist README.PCH      del README.PCH   > nul
if exist ZIP2EXE.PCH     del ZIP2EXE.PCH  > nul
if exist PKZIP.PAT       del PKZIP.PAT    > nul

REM delete patch programs
if exist SSSPTCHD.EXE    del SSSPTCHD.EXE > nul
if exist PKPATCH.EXE     del PKPATCH.EXE  > nul

pause

