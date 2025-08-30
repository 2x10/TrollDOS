README.TXT    - Full Documentation of MaxDIR.
FASTREAD.TXT  - Quick Read Documentation of MaxDIR.
HISTORY.TXT   - History of Revisions to MaxDIR.

-----------------------------------------------------------------------------
 MaxDIR  v2.29      [Documentation - DI.EXE]   (C)1995-2005 MSH Softworks
-----------------------------------------------------------------------------
       [ This utility has always been and always will be FREEWARE ]

--> Type DI /? for a list of command-switches.  Use README.TXT for help. <--

-----------------------------------------------------------------------------
PC Recommended Min. Requirements:  80386-sx16, 512K Ram, Dos 5.0, any Drive.
PC Bare Minimum Requirements:      80386-sx16, 128K Ram, Dos 3.0, any Drive.
-----------------------------------------------------------------------------


OS Requirements to use this program:           ( + means "And Higher")
                                               ( * means "Not Tested")
One of the following:

 Windows XP (Home or Professional)
 Windows 95/98/ME DOS 7.0+ (Command Prompt).
 Windows 2000 (Command Prompt, all versions).
 Windows NT 4.0 (Service Pack 3+) (Command Prompt, Workstation and Server)
*Windows NT 3.51 (Latest Service Packs)
 MSDOS 2.1 thru MSDOS 6.22+, or PCDOS 5+, or PTS-DOS v5+, or DR-DOS.
 OS/2 2.1 thru OS/2 3.0+. (DOS Sessions).
 Mac DOS Window and/or Mac "Orange PC" Session. Not tested past OS7.5.
*UNIX DOS Session.
*Any other OS that supports DOS Emulation.


(OPTIONAL: Network Drives must be through a mapped drive letter)

 Netware v2.0 thru Netware v6+
 Windows 3.11 Network
 Windows XP/2000 Network in Active Directory/Domains/ or Workgroup modes.
 Windows NT4 Network ... *Windows NT 3.51 Network
 Windows 95/98/ME Network
 Lantastic v6.0+

-----------------------------------------------------------------------------


FOREWARD:

  MaxDIR is a DOS DIR command alternative/replacement, presenting a directory
of files in a much nicer format using much less screen-space.  MaxDIR makes
use of sorting, columns, and COLOR in order to assist the user in a multitude
of tasks, which include dealing with the brain clutter that occurs when
listing files in the current, or any directory.

Definition of Scroll:  What the screen does while you are trying to read it.


INSTALLATION:  

  Simply copy the MaxDIR files into your OS directory, or any place else
that is specified in your AUTOEXEC.BAT's PATH= statement.  Also, you can
rename it to anything you wish, such as D.EXE, which is how I use it.

IMPORTANT!:  All of the files MUST be in the same directory for MaxDIR to
             work properly!


NOTE:  For Windows NT/2000, you should extract all files to the C:\WINNT
       directory.

NOTE:  For Windows95/98/ME/XP, you should extract all files to the
       C:\WINDOWS directory.

NOTE:  For DOS, you should extract all files to the C:\DOS (or SYSTEM)
       directory.  You must make sure the directory is in the set PATH=
       statement.


ABOUT THE FILES:

DI.EXE     :This is MaxDIR.  Type DI to get a directory!

CFG.EXE    :This is MaxDIR Config.  This program lets you make up to 25
            custom config files for MaxDIR to use.  The documentation is
            built in to the help system.  Press F1 to find out how to use it.

MAXDIR.CFG :This is the default configuration file.  You may create up to 25
            different .CFG files to use with MaxDIR.


Now, whenever you type DI (or what you renamed it to) at a DOS prompt, you'll
receive a colorful listing on your screen of all the files in your current
directory.  There are also a variety of command-switches to aide you in your
quest for maximum performance, ie:  More info, meaningful at a glance,
ordered to your taste, etc..

 (Tip: Keep this document file handy.  You may want to read it again when
       you have a question about something you find or don't understand.)


About MaxDIR:

  MaxDIR shows a colorful Directory Listing of files, alphabetized into Four
Columns across the screen.  By default, it shows Filenames and Extensions,
colorized by Extension.  It shows FileSizes, Drive Usage, True Drive Usage
(Actual drive clusters used, in bytes), Total Drive Size, Total Drive Space
Used, Percentage of Drive Used Up, and its Volume Label.  Optionally, it will
show more/less drive information, which is described in detail in MaxDIR
OPTIONS.  As of version 2.23, MaxDIR can also show you a quick list of the
available drives at the top of the directory listing.


Files are always Colorized by Extension.  Here's the DEFAULT break-down:

EXE                 - Light Cyan    - Executables. (Programs)
COM                 - Light Green   - Commands.    (Assembly Programs)
BAT INI PIF CFG INF - Light Red     - Batch, Config, & Win Setup Files.
DOC PDF HTM SHT MSG - White         - Documents, HTML, and Message Files.
TXT RTF ANS ASC SC  - White         - Text, ANSI, ASCII, and Script Files.
WRI HLP SCR LOG ERR - White         - Write, Help, Script, & LOG Files.
DBF DB  MDB LCK XLS - Blue          - Database/Control and Spreadsheet Files.
ASM CPP PAS BAS C   - Green         - Program Source Code.
SYS OVR OVL DAT     - Green         - Overlays, Drivers/TSR's, & Data Files.
BMP PCX TAR TIF IFF - Cyan          - Graphics Files.
IMG PCD PIC PCT PSP - Cyan          - Graphics Files.
GIF JPG MOV AVI MPG - Cyan          - Graphics Files & Motion Video.
FLI FLC FLT TGA     - Cyan          - Graphics Files & Motion Video.
ZIP ARJ ARC LHA RAR - Red           - Archived / Compressed Files.
DRV 386 DLL GRP VXD - Brown         - Win Drivers, Groups, & Link Libraries.
MOD MID WAV VOC CMF - Light Blue    - Music & Sound Files.
S3M STM IT  XM  MP3 - Light Blue    - Music & Sound Files.
<Dir>               - Light Magenta - Sub-Directories.

All Others          - Light Grey    - All other non-standard and/or unknowns.

NOTE:  More default extension colors will be added in future versions.


MaxDIR OPTIONS:

  You may change the way MaxDIR shows files by using Command-Switches.  For
example, by typing  DI /F  MaxDIR will Alphabetize files by Filename instead
of by File Extension.  Here are the available command-switches:

By default, MaxDIR shows files alpha by file extension, ordered up/down.

/e   - Sort Files by Extension. (Default)
/f   - Sort Files by Filename.
/t   - Sort Files by Date/Time.
/s   - Sort Files by Size.
/n   - Disable Sorting.
/w   - Show Files Ordered Up-Down. (Default)
/l   - Show Files Ordered Left-to-Right.
/a   - Show Hidden/System files.
/d   - Show Directories ONLY.
/#   - Number of Columns (1,2,4,6) (Default: 4)
/c   - No Color.  (Output can Redirect)
/j   - Show Colors in ANSI format.  (Output can Redirect)
/u   - Show Files in ALL-Uppercase.
/v   - Disable Show Available Drives.
/p   - Disable Pause at full screen.
/o   - Use BIOS Video Addressing.
/i   - Include DIR clusters in 'Bytes Consumed'.
/x   - Show eXtra Drive Information.
/b   - Show MaxDIR Location, Build ID, and DOS Version Info.
/z   - Disable custom configuration. (Use Default Settings.)
/zfilename - Use custom configuration CFG file. (Don't add .CFG)


You can use more than one switch, in any order.  The path to sort must be the
last thing on the command line.

EXAMPLES:

di                -Will show files in current dir, alpha by extension.

di /?             -Will show Command Line Switches and info about MaxDIR.

di /s             -Will show files sorted from smallest to largest.

di /f /u /l ms*.* -Will show files in current dir starting with MS, alpha
                   by filename, in all uppercase, ordered left-to-right.

di /u e:\dos      -Will show files under the Dos dir on drive E, alpha 
                   by extension, in all uppercase.

di /d /x          -Will show directories under current dir, along with
                   extra info about the drive.

di /n /p          -Will show files, unsorted, with no pausing when the
                   screen fills up.

di /a             -Will show ALL files(including hidden and system files),
                   with hidden dirs at the end of the dir list, and all
                   hidden files at the end of the files list, with their
                   first characters in lower case.

di /v             -Will show files in current dir, alpha by extension,
                   without showing available drives.

di /zfilename     -Will use the custom configuration file: filename.cfg
                   Remember:  Don't add the .CFG in the command.

di \              -Will show the current drive's Root directory, alpha by
                   extension.

di /2             -Will show files in current dir, alpha by extension,
                   in 2 columns (which shows dates and times)

di /c > file.txt  -Will list files in current dir, sending output to
                   File.txt. (no color)

di /j > file.txt  -Will list files in current dir, sending output to
                   File.txt. (using ANSI color codes.)

di /c > lpt2      -Will list files in current dir, sending output to
                   printer on LPT2


TIP:   When outputting to another device, be sure to use the /p option
       to disable PAUSE.  Otherwise, you'll have to keep pressing a key
       until the output is completed.

NOTE:  Even though the /n option specifies No Sorting, all directories will
       still be pushed to the front of the listing, but they will not be
       sorted.

NOTE2: The /a option always pushes hidden/system files to the end of the
       list.  Hidden/System files are denoted by a lowercase first letter
       of the Filename and Extension.


AUTO-PAUSE:
  
  MaxDIR pauses after each screenful of information, and is smart enough to
detect screen modes.  It has been tested in 25, 43, and 50 line modes, and
should work correctly, regardless of what video card you use, in any other
mode.  It will work only in a text mode, in either Mono, B/W, 2, 4, 8, or
16 colors.  It will automatically pause at the right time, and if it gets an
error while detecting your video mode, it will bypass pausing altogether.


FILESIZE FORMAT:

  MaxDIR shows filesizes up to 9,999,999 bytes, without truncating.  Files
which are longer will be shown (For example, 15,437,121) truncated as 15.437M
Of course, due to space limitations in the way file lists are diplayed, all
commas are left out of the file-sizes.


MORE ON "BYTES CONSUMED":  (FAT16) (Windows 95[A] is not exempt.)

  MaxDIR calculates "Bytes Consumed" using a simple method.  First, to under-
stand what it means, here is a brief explanation:  All disk drives store
information in "Clusters" on a disk.  A "Cluster" is a set of sequential
"Sectors" which are usually 512 bytes in length (except on CD-ROMs).  The
cluster size is always determined by the size of the disk.  The reason for
this is somewhat complex, but it boils down to the ineffeciency of DOS making
use of very large drives...   When DOS stores a file onto a disk, it
allocates (uses) an entire cluster, even if the file is 1 byte in length!
Many newer computers have large drives and subsequently have a cluster size
of 32,768 bytes... One file, say 200 bytes or even 1 byte, will consume
32,768 bytes of drive space.  If a file is 32,769 bytes in length, it will
consume 2 clusters or 65,536 bytes!  MaxDIR looks at all of the files in your
current DIR, calculates the consumed bytes for each one by using simple
division, and then adds up the total you see at the bottom.  Also included
are the directories which you have in your current DIR, since they are
counted as files(except "." and ".." which are reference points).

 Type DI /X to see your current drive's cluster size, and what determines it.
(ie:  [Bytes Per Sector] * [Sectors Per Cluster] = Bytes Per Cluster.)

  Please read LIMITATIONS, below, to find out about Bytes Consumed on drives
not supported by DOS, such as FAT32 and NTFS/HPFS, etc.


EXTRA DRIVE INFO:  (The /X Option):

  With the /X option, MaxDIR will show your drives' bytes-per-sector, 
sectors-per-cluster, bytes-per-cluster, total clusters, available clusters, 
and clusters used.  Also, it shows the Disk (NOT DRIVE!) DOS Identifier Byte
and what it means (ie:  A 1.2 Megabyte 5.25" Floppy DRIVE can support 160K,
180K, 320K, 360K, and 1.20MB DISKS).  MaxDIR tells you the size of the DISK
in the floppy drive, not the floppy drive's size.  Most of the other
information this option provides is only useful for people who wish to know
how efficiently their drive(s) do file-keeping (cluster size).

NOTE:  MaxDIR tells you a network DISK TYPE by way of the DOS Identifier
       Byte, the same way as a local drive.  This may not be accurate on
       some networks, depending on the specific client/server interface.


LIMITATIONS:  (problems explained /possible solutions)

  MaxDIR has a limit of 2,400 files in any given Directory.  If, for some
strange reason, you have more than 1,800 files in the same directory, MaxDIR
will only show the first 2,400.

  Due to the strange nature of CD-Roms, MaxDIR may be in error when it shows
file consumption and disc size.  Some DOS CDRom drivers seem to put incorrect
information into the computer's bios, causing it to show the wrong disc size.
Also, some CD's report incorrect disc sizes anyway...  To be honest, I can
never tell which, or it could be that I was absent on the day they decided to
add a couple of bytes to the BIOS cluster table..?  At any rate, MaxDIR will
correctly report filesizes and total bytes used, but may be in error showing
consumption and total disc size on some CD-Roms.  If/when MaxDIR detects an
error in those, it will print [CDROM?] preceding the percentage-full.  This
means you should check for a later CD-Rom driver.  If it is a networked
drive, then you may want to check into a network software patch/update.


(v2.22+ UPDATE)
WINDOWS NT4:  If you are in a non-"8.3" compliant (LFN) directory, WinNT will
revert to the 8.3 version of the DIR upon exiting any 16 bit DOS application.
There is no workaround for this problem.  However, there is a program
available at http://maddogsw.com/cmdutils that, when run, will bring you
back to the LFN version of the DIR.  The program is called FIXP.EXE, and is
a 32bit WinNT program.  (Fixp.exe Length: 32K bytes)  Be advised that the
FIXP.EXE program should not be run in the root of a drive, ie: C:\ or D:\.
Doing this will close the DOS box with an error.


NOTE:  MaxDIR is not able to show drive Size and actual bytes Consumed on
drives that are not either FAT12 or FAT16.  DOS (and true DOS emulators) only
work with FAT12/16 drives.  Windows95/98 and WindowsNT can run on FAT32 and
NTFS (respectively), which use different and incompatable types of File
Allocation.  MaxDIR will work on Windows 95/98/NT/2K, but their DOS emulators
report incorrect Sector and Cluster information to keep DOS programs running
correctly on larger hard drives (DOS only supports HD's under 2GB in size.),
thus the Bytes Consumed and total drive sizes will be incorrect.  All other
information will be correct, and MaxDIR will run as it was intended.

-----------------------------------------------------------------------------

TEST-BED:

  MaxDIR has been successfully tested under the following:  MSDOS 2.1 thru
MSDOS 6.22, PCDOS 5.0+, Windows9x/NT/2K/XP, Tandy 1000HX, Compaq Laptops, and
in DOS sessions on the following:  OS/2 2.1, OS/2 3.0(Warp), IBM System/36,
Macintosh, Macintosh "Orange PC", and UNIX.  Testing recently (2003) went
well under PTS-DOS and FreeDOS.

  It has been tested on everything I could get my hands on, with no problems.
I was also fairly surprised to see it run flawlessly on an ancient IBM
System/36 workstation.

  MaxDIR has been thoroughly tested while running attached to the following
Network environments:  LANtastic v6.0/v7.0, LANtastic "Dedicated Server",
NETware v3.11 thru NETware v5.1, Windows Network, Windows95/98 and WindowsNT/
2K Networking, AppleTalk, and EtherTalk.  The only descrepancy I was able to
find was the fact that NETware drives sometimes report as CD-Roms(Under
LANtastic) when using the DI /X option, but it still performs as expected.

  MaxDIR also works perfectly on SCSI, IDE/EIDE/ATA drives, and RAID (all
levels) controlled drives on computers as well as networked drives.


BUG FIXES:

   If you are a regular user of MaxDIR, and you have the displeasure of
discovering a bug, you are strongly urged to e-mail a brief description to
the site address (don't forget the dash[-] in c-shore!  otherwise it will go
to an ISP in Connecticut)..  I might work 'till to wee hours in the morning
to fix it, and I will personally e-mail the fixed version to you so that
you'll be the first to have it.  I will also post the fix on the net at:

www.c-shore.com/maxdir


REGISTRATION:  (MaxDIR is FREE, but there are a couple of benefits.)

   Registering MaxDIR will add you to the new releases list.  This list is
PRIVATE and is not disclosed to ANYONE WHATSOEVER.  The only thing you will
get with registration is an occasional e-mail with the latest version of
MaxDIR attached, as soon as it is finished.

   To register, send a brief e-mail with your e-mail address, your
City, State/Province/County, Country, your current version of MaxDIR,
Your PC Type and OS(Your Computer's Operating System [MSDOS 6.22 or
Win98?] ), and any comments that you would like to say about MaxDIR.

Example:  (send to e-mail address listed on the site)

johndoe@anyisp.net.au
Sydney, Australia
MaxDIR v2.21
Home-Made PC [MSDOS 6.22] {.OR...} MAC [MacOS 8.0, OrangePC, PCDOS 5.0], etc.

Comments:  This program is ok. Please inform me when a new version is out.

--> This means you'll be e-mailed the latest version immediately. <--
--> Since... the latest version (for now) is MaxDIR v2.29 <--

-----------------------------------------------------------------------------
  ALL VERSIONS OF MAXDIR ARE VIRUS SCANNED BEFORE RELEASE VIA THE INTERNET.
-----------------------------------------------------------------------------

            >>>--- This is THE END of the Documentation! ---<<<

I hope you find this a useful utility!  Several Beta-Testers reported sudden
allergic reactions to the DOS DIR command after getting used to MaxDIR.  ;)

                                                        -MSH Softworks
                                                        -Michael S. Hooper

THIS PROGRAM IS FREEWARE!  COPY IT, DISTRIBUTE IT, GIVE IT AWAY, MASS PRODUCE
IT, BUT DO NOT SELL IT!  IT IS FREE TO ANYONE AND EVERYONE.

   If you have any suggestions or comments concerning this program, feel
free to send it to the email address listed on c-shore.com


SINCE THIS PROGRAM IS FREE TO EVERYONE:

   Please upload/copy MaxDIR in it's original state, with the three (3) files
in which it was intended:  DI.EXE, README.TXT, and FILE_ID.DIZ.  Use the file
you originally downloaded unless you are sure your system is virus-free.

   Just keep them together and untampered with, so everyone who receives it
will have the opportunity to judge for themselves whether or not it is useful
for their purposes.   Thank you!


LEGAL MUMBOJUMBO:

   As for legalities...  MaxDIR has been tested on many different systems
with no problems or complications, But...for the lawyers, if ever one should
need a new BMW:

   MSH Softworks will accept no liability for data loss, file or directory
corruption, program failure, system failure, or any problems that are judged
and/or assumed as being caused by the use of MaxDIR.  Due to the diversity of
computers and operating systems in use, MaxDIR comes without warranty neither
expressed nor implied.

-----------------------------------------------------------------------------
