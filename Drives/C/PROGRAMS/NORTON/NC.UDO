'Haupt-MenÅ fÅr Norton Commander
A:	Q-Format 
 C:\util\qformat
B:	Formatiere A: mit System 
 c:\sys\format a:/s
C:	1-Copy
 c:\util\1copy
D:	Sound Control
 c:\spectrum\pas *
F:	Diskcopy A: --> A:
 c:\sys\copyqm a: O=HC SILENT
G:	Diskcopy B: --> B:
 c:\sys\copyqm b: O=HC
H:	Undelete Dateien
 c:\nort\unerase
 pause
I:	LZH Datei erstellen (ARCHIV)
 c:\arc\lha a _archiv *.*
 pause
J:	LZH EXE Datei erstellen (ARCHIV)
 c:\arc\lha s _archiv
 pause
K:	LZH Datei im Pfad entpacken
 ren *.lzh !archiv.lzh
 c:\arc\lha e !archiv
 pause
L:	Virentest im Pfad
 c:\vir\scan *.* /NOMEM /M
 pause
M:	XCOPY A: --> B:
 c:\sys\xcopy a: b: /s
 pause
N:	LZH + EXE DATEI erstellen (+ PFADE)
 LHA a /r2x1 _archiv *.*
 LHA s /x1 _archiv
 pause      
O:	Virentest Laufw. A:
 c:\vir\scan a: /NOMEM /M
 pause
P:	Virentest Laufw. B:
 c:\vir\scan b: /NOMEM /M
 pause
Q:	FDF-SHELL fÅr hohe Disk KapazitÑt
 c:\tools\fdfshell
R:	Format A: 1.72 Mb
 c:\tools\fdformat A: F172 /U /X:2 /Y:2 /R
 pause
S:	Format B: 1.48 Mb	
 c:\tools\fdformat B: F148 /U /X:2 /Y:2 /R
 pause Q:	FDF-SHELL fÅr hohe Disk KapazitÑt
 c:\tools\fdfshell
R:	Format A: 1.72 Mb
 c:\tools\fdformat A: F172 /U /X:2 /Y:2 /R
 pause
S:	Format B: 1.48 Mb	
 c:\tools\fdformat B: F148 /U /X:2 /Y:2 /R
 pause                                    	