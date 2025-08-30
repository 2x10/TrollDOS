
  README.TXT -- NOTES ON PC DOS 2000

  This README.TXT file contains important information about PC DOS 2000.

  T A B L E   o f   C O N T E N T S
  ---------------------------------
  0.0  PC DOS 2000
       0.1  Update to PC DOS 7
            0.1.1  Version
       0.2  Testing Your System for Year 2000
       0.3  How to Specify the Year
       0.4  General Product Information
            0.4.1  Product Year 2000 Readiness
            0.4.2  Year 2000 Ready Definition
            0.4.3  IBM Position on the Readiness of this Product
       0.5  PC DOS Documentation
       0.6  Installing PC DOS 2000
            0.6.1  Installing from Diskette
            0.6.2  Installing from CD
            0.6.3  Creating PC DOS Diskettes
            0.6.4  Installing from a LAN Server CD Drive
            0.6.5  Installing from a LAN Administrator Directory
       0.7  Content of the PC DOS 2000 CD-ROM
            0.7.1  PCDOS7 Directory
            0.7.2  DOSFILES Directory
            0.7.3  IMAGES Directory
  1.0  SETUP
       1.1  Unformatted Hard Disks
       1.2  External 1.2MB & 1.44MB Drives
       1.3  SETVER.EXE
       1.4  DOSKEY.COM
       1.5  IBM AntiVirus/DOS
       1.6  Norton Anti-Virus
       1.7  Incompatible Compression Programs
            1.7.1  Xtradrive
            1.7.2  DoubleDisk Gold 6.0
            1.7.3  SuperStor Versions Prior to 1.4
       1.8  LAN Administrator Install to OS/2
       1.9  Stacker for OS/2 & DOS
       1.10 HELP renamed to HELP5
  2.0  Networks
       2.1  Lantastic
  3.0  IBM AntiVirus/DOS Updates
  4.0  DOS Commands
       4.1  CPBACKUP
            4.1.1  Running POWER.EXE
            4.1.2  CPBACKUP Confidence Test
            4.1.3  GSI Model 11 Controllers
       4.2  FORMAT
       4.3  LABEL
       4.4  MEM
       4.5  RAMSetup/RAMBoost
            4.5.1  RAMBoost and Programs that Require Expanded Memory
            4.5.2  RAMBoost and Windows v3.1
            4.5.3  RAMBoost and INT4BCAM.SYS from Future Domain
       4.6  UNDELETE
       4.7  PenDOS
            4.7.1  Video Mode Support
            4.7.2  Using Central Point Utilities & PenDOS
            4.7.3  Using PC DOS Defragmenter Utility & PenDOS
            4.7.4 Running PenDOS 2.2
  5.0  Hardware and Device Drivers
       5.1  PS/2 Server Password Mode
  6.0  Windows
       6.1  After installing Windows
       6.2  Hot Docking under Windows
       6.3  Windows and VSAFE.EXE
  7.0  Differentiating 7.0 Version Checks
  8.0  Working with OS/2's WIN-OS2
  9.0  Upgrading from DR DOS or Novell DOS
 10.0  Compression
 11.0  PCMCIA
       11.1  PCM+ v3.01 Notes
       11.2  Limitations and Operation under Suspend and Hibernation
       11.3  Modem Suspend and Resume on IBM ThinkPADs
       11.4  PCMCIA & PC Card Upper Memory Requirements
 12.0  Norton Utilities - DISKREET.SYS
 13.0  IBM Screen Reader
 14.0  Eurocurrency Symbol Support
 15.0  Notices


  0.0  PC DOS 2000
  ================

  Welcome to IBM's PC DOS 2000!  You will find PC DOS 2000 a convenient
  package containing IBM's Year 2000 ready version of PC DOS 7, our
  award-winning DOS product.  It contains everything you need in one
  easy-to-install package to get your DOS ready for Year 2000.


  0.1  Update to PC DOS 7
  -----------------------
  IBM's latest version of DOS, PC DOS 2000, is Year 2000 ready and
  includes the latest updates to PC DOS 7.  No additional fixpaks are
  required.

  Some PCs might incorrectly change the date to 1980 after the date has
  "rolled-over" to the next century.  PC DOS 2000 contains updates for
  correcting the BIOS century information in many of these PCs.  This
  correction is included when you install this version of PC DOS; you do
  not have to take any additional action to enable this support.  This
  support has been designed to fix the century "roll-over" problem in
  many PCs, however, it is your responsibility to ensure that all
  products (for example, hardware, software and firmware) used with
  PC DOS 2000 properly exchange accurate date data with it.

  PC DOS 2000 also includes new support for the European Monetary Union's
  (EMU) Eurocurrency symbol.


  0.1.1   Version
  ---------------
  The version number of PC DOS 2000 is displayed when you enter the VER
  command.  The version number is:

          PC DOS Version 7.0
          Revision 1

  The previous release of PC DOS 7 is Revision 0.


  0.2  Testing Your System for Year 2000
  --------------------------------------
  After you install PC DOS 2000, you should thoroughly test the remainder
  of your DOS environment to make sure dates are being processed and
  displayed correctly.

  If you experience a date-handling problem, ensure that your application
  programs and hardware are handling the date correctly before contacting
  PC DOS service and support.

  Contact your application program manufacturer to see if there are any
  known problems or an update available for your application program.  PC
  DOS 2000 cannot fix date handling problems that are being caused by
  application programs.  Only the application program manufacturer can
  correct these problems.

  PC DOS 2000 contains a fix for the "century roll-over" problem in some
  BIOS programs.  Your PC's BIOS may have other date-handling problems
  even with this fix applied.  Contact your PC manufacturer to see if
  there are any known problems or an update available for your PC's BIOS.


  0.3  How to Specify the Year
  ----------------------------
  When you specify the year using two digits, PC DOS interprets 00 to 79
  as years 2000 to 2079 and 80 to 99 as years 1980 to 1999.  For example,
  7/15/78 (in mm/dd/yy format) is July 15, 2078 and 7/15/81 is July 15,
  1981.  To avoid ambiguity errors, whenever possible, you should specify
  the year using four digits.  For example, specify 7/15/2078 for July
  15, 2078.  PC DOS does not support dates before 1980 or after 2079.


  0.4  General Product Information
  --------------------------------
  The following sections describe Year 2000.


  0.4.1  Product Year 2000 Readiness
  ----------------------------------
  IBM has taken reasonable measures to provide accurate information
  regarding the Year 2000 readiness of this product.  However, you
  should be aware that information regarding Year 2000 can change.  IBM
  cannot guarantee that the information contained in this README is
  complete or current or that it applies in every situation.


  0.4.2  Year 2000 Ready Definition
  ---------------------------------
  "Year 2000 ready" means "a product, when used in accordance with its
  associated documentation, is capable of correctly processing,
  providing and/or receiving date data within and between the 20th and
  21st centuries, provided that all products (for example, hardware,
  software and firmware) used with the product properly exchange
  accurate date data with it."


  0.4.3  IBM Position on the Readiness of this Product
  ----------------------------------------------------
  Information on the Year 2000 ready status of this product applies to
  this product only.

  By providing this data, IBM is not performing a Year 2000 assessment
  or conversion.  You are solely responsible for the implementation of
  your Year 2000 project and IBM does not guarantee your results.

  You are solely responsible for the installation and implementation of
  any Product Temporary Fix, Customer Service Diskette(s) or other
  related Year 2000 modification required for an IBM product to be
  considered Year 2000 Ready.  IBM shall not in any way be responsible
  for your failure to apply such correction.

  IBM's obligations and responsibilities regarding IBM products are
  governed solely by the agreements under which they are sold or
  licensed.


  0.5  PC DOS Documentation
  -------------------------
  The PC DOS library includes both online books and printed documentation.
  All PC DOS 7 documentation can be used with this PC DOS 2000 product.


  0.6  Installing PC DOS 2000
  ---------------------------
  PC DOS 2000 is available from IBM on 3.5-inch diskettes or CD-ROM.

  The diskettes are used to install PC DOS over an existing version of
  DOS or on a computer system that does not have an operating system
  installed.

  The CD is used to install PC DOS over an existing version of DOS.  If
  you need a set of diskettes, the CD contains PC DOS diskette images
  that you copy to your 3.5-inch diskettes with the MAKEDISK command.
  See section, "Creating PC DOS Diskettes."

  The diskettes or CD can be used to create a LAN server administrator
  directory containing PC DOS.  Workstations connected to the LAN server
  can then install from this administrator directory.

  See Chapter 1, "Installing" and Appendix A, "More About Installing" in
  the PC DOS 7 User's Guide for installation guidelines.

  Note:  The PC DOS 2000 diskettes and diskette images are in non-XDF
         format.

  Note:  If your computer is running an operating system other than DOS,
         installing PC DOS could result in a loss of program and data files.


  0.6.1  Installing from Diskette
  -------------------------------
  Insert the PC DOS Setup Diskette 1 into a diskette drive on a PC
  running DOS version 3.3 or later.  Then, to see the syntax and brief
  explanation of the SETUP command, type:

          d:setup /?

  where d: is the diskette drive.  Continue the installation procedure by
  following the instructions in PC DOS 7.0 SETUP program.

  If your PC is not running DOS version 3.3 or later, insert the PC DOS
  Setup Diskette 1 into drive A.  Restart your computer.  Type Y to
  answer YES when asked whether you want to install PC DOS 7. Follow the
  instructions in SETUP program.


  0.6.2  Installing from CD
  -------------------------
  Insert the PC DOS CD into a CD drive on a PC running DOS version 3.3 or
  later.  Then, to see the syntax and brief explanation of the SETUP
  command, type:

          d:setup /?

  where d: is the CD drive.  Continue the installation procedure by
  following the instructions in PC DOS 7.0 SETUP program.


  0.6.3  Creating PC DOS Diskettes
  --------------------------------
  You can create PC DOS diskettes from the PC DOS 2000 CD.  You will need
  up to seven (7) high-density (1.44 MB) formatted 3.5-inch diskettes
  (some language versions require fewer diskettes).

  Insert the CD into a drive on a PC running DOS version 3.3 or later.
  Then, type:

          d:makedisk

  where d: is the CD drive.  Continue the diskette creation procedure by
  following the instructions in the MAKEDISK program.


  0.6.4  Installing from a LAN Server CD Drive
  --------------------------------------------
  If you are installing PC DOS on a network connected workstation, you can
  install from the PC DOS CD located on a LAN server.

  Insert the PC DOS CD in a drive at the LAN server.  Follow the LAN
  administrator procedures to share this CD drive with workstations that
  will be installing PC DOS across the LAN.

  Start the workstation with your current version of DOS and network
  software.  Then connect to the CD drive at the LAN server and type:

          d:setup

  where d: is the connected CD drive on the LAN server.  Continue the
  installation procedure by following the instructions in PC DOS 7.0 SETUP
  program.


  0.6.5  Installing from a LAN Administrator Directory
  ----------------------------------------------------
  Running SETUP /A creates a LAN administrator directory on a LAN server
  that allows for PC DOS installation across the network by individual
  workstations.  You can run SETUP /A from either the PC DOS CD or Setup
  Diskette 1.

  After SETUP /A is completed, PC DOS can be installed to a workstation
  using the SETUP program from this directory.

  If your server is running OS/2 WARP, you can run SETUP /A from the DOS
  Full-Screen session or DOS Window session.  If your server is running
  an earlier version OS/2, run SETUP /A from a remote DOS workstation with
  read/write access to the LAN server.

  To create an Administrator's Directory at the LAN server:

  1.  Make sure you have 9.5 MB of disk space available for the LAN
      administrator's directory before beginning the installation.

  2.  Insert the PC DOS CD or Setup Diskette 1 into a drive on the
      LAN server.

  3.  Start SETUP by typing:

          d:setup /a

      where d represents the drive.  Follow the PC DOS 7.0 SETUP
      instructions.

  4.  When the LAN Server Administrator Installation Option screen
      appears, select "Create an administrator directory."  Verify that
      the path specified in the "Install to path" is correct.

      All the files on the PC DOS installation diskettes are then
      copied to the DOS7 directory unless you specified your own
      directory name.  If you specify the name for the administrator's
      directory, do not specify the DOS directory or the DOSFILES
      directory and do not specify the root directory.

  5.  After the installation has been completed, mark the files in the
      directory as read only by using the ATTRIB command.

  6.  Follow the LAN administrator procedures necessary to share this
      directory with workstations that will be installing PC DOS
      across the LAN.

  To create an administrator's directory from a remote workstation to a
  LAN server:

  1.  Start your network software on the workstation and connect to the
      LAN server where the administrator directory is to be created.  The
      workstation must have read/write access to the server.

  2.  Insert the PC DOS CD or Setup Diskette 1 into a drive on the
      workstation.

  3.  Follow step 3 through step 6 in the above instructions for creating
      an Administrator's Directory at the LAN server.

  To install PC DOS after the LAN administrator has made it available within
  the LAN:

  1.  Start the workstation with your current version DOS.

  2.  Start your network software; then connect to the server containing
      PC DOS.

  3.  Start the SETUP program that is on the server.  For example, if the
      LAN Administrator's Directory is DOS7, you would type:

               d:\dos7\setup

      where d: is the LAN drive.  Continue the installation procedure by
      following the instructions in the PC DOS 7.0 SETUP program.


  0.7  Contents of the PC DOS 2000 CD-ROM
  ---------------------------------------
  If you have the PC DOS 2000 CD-ROM package, you can find the following
  programs and information in the following directories on the CD.


  0.7.1  PCDOS7 Directory
  -----------------------
  This directory contains the compressed PC DOS files used by the
  PC DOS 7.0 SETUP program.  You start the SETUP program from the root
  directory of the PC DOS CD (see the "Installing from CD or Diskette"
  section of this document).


  0.7.2  DOSFILES Directory
  -------------------------
  This directory and its subdirectories contain the complete set of
  PC DOS 7 program and documentation files.  Use this directory to copy
  or view individual files as needed.

  Note:  This directory is not used to install PC DOS on your hard disk.


  0.7.3  IMAGES Directory
  -----------------------
  This directory contains the images of the PC DOS installation diskettes
  created by the MAKEDISK program.  You start the MAKEDISK program from
  the root directory of the PC DOS CD (see the "Creating PC DOS Diskettes"
  section of this document).


  1.0  SETUP
  ==========

  1.1 Unformatted Hard Disks
  --------------------------
  When installing, SETUP gives you the option to format unformatted
  partitions.  When running SETUP as an application in DOS 3.3 the partitions
  should not be formatted.  To work around the problem, boot from SETUP
  Diskette 1 or format the partitions with your previous version of DOS.


  1.2  External 1.2MB & 1.44MB Drives
  -----------------------------------
  ValueStor 3.5" external floppy drives, some MCT adapters with GSI BIOS, GSI
  Model 11 floppy controllers, and CompatiCard IV controller cards provide
  their own adapter BIOS to handle Int 23H calls.  The current versions of
  these particular BIOS do not properly implement the Disk Parameter Table
  and read only 512 byte sectors.  XDF formatted diskettes have 1K sectors
  and are therefore unsupported by this BIOS limitation.

  Future versions of these products may correct this problem.  Software and/or
  firmware updates may be available from the respective manufacturers.


  1.3  SETVER.EXE
  ---------------
  For SETVER to get updated correctly during installation, you must make sure
  the "Previous DOS path" indicated is correct.  If it does not point to the
  correct path, then SETUP will not find a SETVER to update.


  1.4  DOSKEY.COM
  ---------------
  SETUP now inserts the line 'DOSKEY' (a command line retrieval program) in
  your AUTOEXEC.BAT.  If you are already using a command line retrieval
  program, modify your AUTOEXEC.BAT to remove one of the two programs to save
  memory.  Having both in memory should not cause conflicts.


  1.5  IBM AntiVirus/DOS
  ----------------------
  If you are using AntiVirus Services, a full-service offering provided
  separately by IBM, or have previously purchased the IBM AntiVirus/DOS
  product separately, you do not need to install the AntiVirus/DOS optional
  tools provided with PC DOS.


  1.6  Norton Anti-Virus
  ----------------------
  PC DOS 7.0's SETUP program will not function correctly if the Norton
  Anti-Virus TSR (NAVTSR) is loaded in memory.  The error message "Fatal
  Error esh0001:  Memory could not be restored..."  is generated if
  NAVTSR is running and you execute SETUP.

  Before running SETUP, remove Norton Anti-Virus from memory by changing to
  the subdirectory that contains NAVTSR.EXE and enter:  NAVTSR /U.


  1.7  Incompatible Compression Programs
  --------------------------------------

  1.7.1  Xtradrive
  ----------------
  If your computer uses XtraDrive disk compression, use its uninstallation
  program to remove the compression, and then install PC DOS 7.0.


  1.7.2  DoubleDisk Gold 6.0
  --------------------------
  DoubleDisk Gold 6.0 is not compatible with the PC DOS 7.0 SETUP program if
  you have used it to compress drive C.


  1.7.3  SuperStor Versions Prior to 1.4
  --------------------------------------
  If you are using a version of SuperStor before Version 1.4 (such as the
  SuperStor compression provided with DR DOS Version 6.0), you will need to
  do one of the following:

  1) Back up the files that are currently compressed with DR DOS's SuperStor,
     upgrade your compression program to PC DOS 7's Stacker Compression, and
     then restore the files you backed up.

  2) Or contact IBM Service for the latest version of SSTORDRV.SYS or any
     other required Addstor files.


  1.8  LAN Administrator Install to OS/2
  --------------------------------------
  LAN Administrator installs (SETUP /A) are no longer supported under
  OS/2 1.X and 2.X, and the SETUP program will exit if it determines it
  is being invoked from an OS/2 DOS session.  OS/2 Warp Version 3 does
  support PC DOS 7 LAN Administrator installs from within a DOS session.
  For more information related to performing a LAN Administrator install,
  please refer to Appendix A in the PC DOS User's Guide.


  1.9  Stacker for OS/2 & DOS
  ---------------------------
  Please do not install Stacker 4.0 on a system that is using Stacker for
  OS/2 & DOS.  If you do, you won't be able to see your compressed DOS drives
  under OS/2.  Stacker for OS/2 & DOS does not yet take advantage of Stacker
  SmartPack.  If you want to install PC DOS 7's Stacker 4.0, you'll have to
  first remove Stacker for OS/2.  First use the UNSTACK command to decompress
  your data.  Then, remove the OS/2 Stacker driver STACKER.SYS and its
  associated files from their directory (usually C:\STACKER\OS2).  Then you
  can set up Stacker 4.0.


  1.10  HELP renamed to HELP5
  ---------------------------
  If you were using DOS 5 or DOS 6, your old HELP command will be renamed
  to HELP5.  To use your old help command type HELP5 at the command prompt.


  2.0  Networks
  =============

  2.1  Lantastic
  --------------
  Users of Lantastic Lancache may experience trouble with warm boots
  (CTRL+ALT+DEL) with EMM386 running.  If your system fails to warm
  boot, you will be forced to turn the system power switch OFF and ON to
  cold boot when running EMM386 and Lancache.


  3.0  IBM AntiVirus/DOS Updates
  ==============================

  The virus protection in PC DOS 7.0 is comprehensive protection for all
  known viruses as of PC DOS 7.0's release date.  However, over time, new
  viruses are created and the user might not be protected from these newer
  viruses.


  4.0  DOS Commands
  =================

  4.1  CPBACKUP
  -------------

  4.1.1  Running POWER.EXE
  ------------------------
  If you are running POWER.EXE (the DOS Advanced Power Management device
  driver), it might cause the performance of CPBACKUP to degrade.  To avoid
  this, disable power management before running CPBACKUP by entering the
  following at the DOS command line:

                POWER OFF

  After you have finished backing up your system, remember to re-enable
  power management by entering POWER at the command line.


  4.1.2  CPBACKUP Confidence Test
  -------------------------------
  On some machines, the automatic disk-sensing may not work properly.  If
  during the "compare" phase of the Backup Confidence Test your system
  appears to pause indefinitely, eject the diskette and then put the diskette
  back in.  This should clear up the indefinite pause should it occur.


  4.1.3  GSI Model 11 Controllers
  -------------------------------
  Some MCT adapters with GSI BIOS and GSI Model 11 floppy controllers
  provide their own adapter BIOS to handle Int 23H calls.

  Future versions of these products may correct this problem.  Software
  and/or firmware updates may be available from the respective
  manufacturers.


  4.2  FORMAT
  -----------
  If you cannot use the FORMAT command to format an unformatted disk, try
  using the /U switch to instruct FORMAT to do an unconditional format.

  If you have Stacker disk compression and receive the message "Insert DOS
  disk in drive A:" when doing a FORMAT /S do the following:  boot from
  your hard disk, insert the PC DOS 7.0 SETUP diskette 1 into drive A:,
  and at the DOS prompt type SYS A: C:


  4.3  LABEL
  ----------
  LABEL will not rename a volume label if the volume is shared and has the
  same volume label name as a current file on the volume, and the file is
  being used in the following manner:

    LABEL < FOO (where FOO is the new volume label)


  4.4  MEM
  --------
  The pause (/P) parameter may not pause the screen on systems with a BIOS
  dated prior to 1985.


  4.5  RAMSetup/RAMBoost
  ----------------------
  If after initially running the RAMSetup program you add or remove an
  adapter from your hardware system, rerun RAMSetup.  It will do a memory
  analysis of your hardware system and create a new EMM386.EXE statement in
  your CONFIG.SYS file.


  4.5.1  RAMBoost and Programs that Require Expanded Memory
  ---------------------------------------------------------
  If your machine previously used EMM386.EXE to simulate expanded memory by
  using extended memory, then RAMBoost can also be used to provide full
  memory management.  To do so, do the following:

   1. In the CONFIG.SYS file, put 'REM' on the 'device=EMM386' statement.
   2. Reboot.
   3. Run RAMSetup.
   4. In RAMSetup, choose ADVANCED.
   5.              choose OPTIONS.
   6.              ENABLE EMS.
   7.              Choose OK, OK, OK.
   8.              Choose REBOOT.
   9. RAMSetup will enable RAMBoost and provide a new EMM386 statement that
      utilizes expanded memory.


  4.5.2  RAMBoost and Windows v3.1
  --------------------------------
  If you have an 80386 or 80486 computer with extended memory and a Super
  VGA display, you can use the MONOUMB.386 file, in conjunction with
  RAMBoost, to conserve conventional memory for running programs.

  To conserve memory if you have a Super VGA display:

  1. Open your Windows SYSTEM.INI file, and find the [386Enh] section.

  2. Add a DEVICE command for the MONOUMB.386 file located in your DOS
  directory.  For example, if your DOS files are in C:\DOS, you would add
  the following line to this section:

      DEVICE=C:\DOS\MONOUMB.386

  3. Save the file and restart your computer.


  4.5.3  RAMBoost and INT4BCAM.SYS from Future Domain
  ---------------------------------------------------
  Future Domain has made changes to their INT4BCAM.SYS device driver so that
  it works with DOS' RAMBoost.  If you are using the device driver and
  RAMBoost, we suggest that you contact Future Domain at the address
  provided below to obtain an updated version of INT4BCAM.SYS.

         Future Domain Corporation
         Customer Service Department
         2801 McGaw Avenue
         Irvine, CA  92714
         Phone:  (714) 253-0440
         FAX:    (714) 253-0913


  4.6  UNDELETE
  -------------
  Do not use the UNDELETE command in the following circumstances:

  * With other programs when they are active.
  * With the Shift+Enter key combination in Windows or a Shell.
  * With Task Swapper in DOS Shell.


  4.7  PenDOS
  -----------
  The PENDOS.BAT file created by SETUP contains a MODE COM1:9600,N,8,1
  statement that is needed by serial-attached pen tablets.  If your tablet
  is not serial attached, delete the MODE statement from the PENDOS.BAT
  file.

  If you have a Kurta XGT Opaque Tablet, adjust your tablet to the following
  options:

      1) Select ALT, F4, F5 and align the tablet.
      2) Emulation/Compatibility   P-KEY       ->  P1
                                   Emulation   ->  KURTA IS/ONE
      3) Format                    Binary      ->  B3
         Other Parameters          Data Bits   ->  8
                                   Parity      ->  none
                                   Baud Rate   ->  19200
                                   Resolution  ->  1016 LPI/40 LPMM
                                   Output rate ->  Max.
                                   Origin      ->  Lower Left
      4) Save to                   P1
         Exit to                   P1


  4.7.1  Video Mode Support
  -------------------------
  PenDOS is designed to operate in the following standard VGA display modes.


              Video Mode              Virtual Screen Size
              ---------               -------------------
                 2                     640 x 200 TEXT
                 3                     640 x 200 TEXT
                11                     640 x 480 GRAPHICS (MCGA NOT SUPPORTED)
                12                     640 x 480 GRAPHICS

  PenDOS operates in other display modes but the compatibility level and
  application functions are severely restricted.

  Most of today's off-the-shelf applications are not designed with notepad
  computers in mind.  Installing these applications with the color display
  option sometimes results in the application objects not being visible.
  Install the application with the display option set to LCD or black and
  white screen.


  4.7.2  Using Central Point Utilities & PenDOS
  ---------------------------------------------
  Central Point's UNDELETE, CPBACKUP, and SCHEDULE utilities can be run
  in either graphics or text mode.  When running these utilities in
  graphics mode with PenDOS active, video corruption occurs if invoking
  the PenDOS Writing Window or "pop-up" keyboard.

  To avoid this problem, run the Central Point utilities in text mode.

         EXAMPLE:  C:\DOS\UNDELETE /nf
                   C:\DOS\CPBACKUP /nf
                   C:\DOS\SCHEDULE /nf


  4.7.3  Using PC DOS Defragmenter Utility & PenDOS
  -------------------------------------------------
  The Defragmenter utility (DEFRAG) can be run in either graphics or text
  mode. When running this utility in graphics mode with PenDOS active, video
  corruption occurs if invoking the Writing Window or "pop-up" keyboard.

  To avoid this problem, run the Defragmenter utility in text mode.

         EXAMPLE:  C:\DOS\DEFRAG /G0


  4.7.4  Running PenDOS 2.2
  -------------------------
  The "MIN=" statement is recommended on the EMM386 line in the CONFIG.SYS
  file when running under PC DOS 7.0.  This parameter prevents any memory
  conflicts that may occur while running PenDOS TSRs under PC DOS 7.0.

        Sample CONFIG.SYS file
        ----------------------
        Buffers=48,8
        Files=30
        DOS=HIGH,UMB
        Device=C:\DOS\HIMEM.SYS
        Device=C:\DOS\EMM386.EXE MIN=128 RAM AUTO
        Devicehigh=C:\DOS\SYSTEM\PENDEV.SYS


  5.0  Hardware and Device Drivers
  ================================

  5.1  PS/2 Server Password Mode
  ------------------------------
  If your PS/2 appears to hang when booting, you might have the server
  password mode set.  Try entering your password and see if the computer
  will resume booting.  Also be aware that F5-Clean Boot, F8-Interactive
  Boot, ?=, and the startup menus all require keyboard input and cannot
  function until your password is entered.

  Other DOS utilities and device drivers might also require keyboard input.


  6.0  Windows
  ============

  6.1  After installing Windows
  -----------------------------
  If you are running Windows, set STACKS=9,256 in the CONFIG.SYS file.

  If you install Windows v3.1 after you have installed PC DOS, modify your
  system's CONFIG.SYS and AUTOEXEC.BAT files.  Make sure that the paths for
  HIMEM.SYS, EMM386.EXE, and SMARTDRV.EXE point to your DOS directory
  and not to the Windows directory.


  6.2  Hot Docking under Windows
  ------------------------------
  The Windows mouse driver should be used when docking and undocking,
  and not the PC DOS mouse driver.

  If you are using DOSDOCK and DDPOPUP on a computer that supports hot
  docking you cannot be in a Windows full screen DOS session when you
  perform a hot or warm dock.  You must perform one of the following
  actions:

   1. Leave the full DOS session and return to the Windows desktop before
      docking.

   2. Change the full screen DOS session into a DOS window session by
      pressing ALT+ENTER when residing in the full screen DOS session.

   If you do not perform one of the above operations your docking event will
   not be properly processed.


  6.3  Windows and VSAFE.EXE
  --------------------------
  The VSAFE.EXE anti-virus TSR requires one of the following statements to
  be added to the [windows] section of the WIN.INI:

    load=wntsrman.exe

  or for the VSAFE.EXE packaged with Microsoft MS-DOS:

    load=mwavtsr.exe


  7.0  Differentiating 7.0 Version Checks
  =======================================

  For programs wanting to determine if the DOS version they are running on
  is PC DOS 7.0, the following should be done:

  Use INT 21h function 30h (Get DOS Version)

  Entry: AX=3000h
  Exit:  AL=DOS major version
         AH=DOS minor version
         BH=OEM id byte (00=IBM, FF=Microsoft)

  Thus, for PC DOS 7.0, the registers on exit will have the following values:
         AX=0007
         BH=00


  8.0  Working with OS/2's WIN-OS2
  ================================

  In order to get your PC DOS 7.0 Windows tools to function correctly in
  WIN-OS2 or while OS/2 for Windows is running, do the following:

  1. Open the OS/2 System object on the desktop by double-clicking on it.

  2. Open the Command Prompts folder in the OS/2 System object by double
     clicking on the Command Prompts folder.

  3. Start a WIN-OS2 session by double clicking on the WIN-OS2 Full Screen
     icon in the Command Prompts folder.

  4. Once the Program Manager is finished loading, open your PC DOS 7.0
     Tools group.

  5. For each item in the group, edit the Properties of each object (using
     ALT+ENTER) placing the following in each item:

     -- putting the DOS path before the program name in the "Command
        line:" field

     -- putting the DOS path as the "Working directory", however, no
        path is to be provided for the PC DOS Prompt icon


  9.0  Upgrading from DR DOS or Novell DOS
  ========================================

  If your CONFIG.SYS file uses any conditional commands such as the "?" or
  GOTO commands, remove them and adjust the order of the commands in your
  startup files accordingly.

  If your CONFIG.SYS file uses the CHAIN command, remove it and adjust the
  order of commands in the file accordingly.

  After PC DOS 7's installation is complete and after rebooting the
  system, PC DOS displays an "Unrecognized command" with the failing
  line number on your screen for each command in your CONFIG.SYS file
  that is not valid in PC DOS.  Remove these commands from your
  CONFIG.SYS file.

  Your DOS prompt may be set in the AUTOEXEC.BAT so that it displays "DR
  DOS" or "Novell DOS" immediately prior to the PC DOS prompt statement.
  This can be changed by deleting the PROMPT command line in your
  AUTOEXEC.BAT file.


  10.0  Compression
  =================

  See the README.TXT in the STACKER directory (\DOS\STACKER) for additional
  information on Stacker Compression.  You will not have this directory
  unless you select Stacker during DOS SETUP.  If you have installed Stacker
  Compression then the file will exist either in the \STACKER directory or
  the one you specified.


  11.0  PCMCIA
  ============

  11.1  PCM+ v3.01 Notes
  ----------------------
  * If you are using M-SYSTEM flash file support, you must upgrade to the
    2.1 compliant level of M-SYSTEM TFFS 3.202 or higher.

  * With MS-FLASH support, the syntax for formatting a SRAM card is:
         FORMAT drive:
    You should not use the /t and /n options of the FORMAT command;
    PCMFFCS driver will return the SRAM size automatically.

  * If you are using a LAN PCMCIA Card and have network drivers loaded in
    your CONFIG.SYS, after running PCMSETUP the PCM drivers will be
    placed at the end of the CONFIG.SYS (after the network drivers).  You
    should move the PCM drivers before the network drivers.  Otherwise,
    the LAN card will not be configured and the connection will fail.

  * If you are using a memory manager (ex:  EMM386), erroneous card
    status information may be displayed for Memory cards (SRAM and FLASH)
    in PCM or PCMWIN utilities.  Excluding an additional 4K from the
    memory manager will fix the problem.

  * COMBO cards may come up unconfigured in PCMWIN, but the card may be
    configured and operational.  Attempt to use the card to ensure it is
    accessible.

  * When using the MS-Flash interface, PCMFFCS, and the system only has
    one socket, two drive letters will be reserved instead of one.  To
    have PCMFFCS only assign one drive letter, specify /S0=1 on PCMSS so
    only one drive letter is generated instead of two.

  * In the PCM utility, editing a configured card with unavailable
    resource and not committing changes will display the card
    unconfigured.  Extract and re-insert the card to get the configured
    status back.

  * Some PC Cards will only work with the client driver the card is
    shipped with.  If so, you should not use the Super Client Driver
    (SCD) provided with PCMCIA to configure the card.

    If you had already configured the card using the Super Client Driver,
    use the following steps to stop SCD from configuring the card:

    1) Run PCMSETUP.
    2) At the Card List screen, using the space bar, only select the cards
       which you want the Super Client Driver to configure (i.e.  Do not
       select the card which uses its own client driver).
    3) Press Enter when done with selections and complete PCMSETUP.
    4) Reboot your system.

    Follow your PC Card Documentation to install the client driver
    shipped with the card.

  * The WaveJammer 16 Bit sound card by New Media Corp. causes system
    errors 201 and 4101 on the IBM ThinkPad 750 series when Ramboost
    reboots the system.

    To avoid this, remove the card from the socket before Ramboost
    reboots the system.  If you do get the system error, select "Restart"
    at the System Error screen and the process will continue.


  11.2  Limitations and Operation under Suspend and Hibernation
  -------------------------------------------------------------
  Some PC Cards do not support operation under suspend mode.  Refer to
  the operations instructions that came with the PC Card.

  Some PC card types do not support hibernation mode, thus not allowing
  your system to hibernate.

  If you are using the Thinkpad 720 and a Token Ring PC Card, Hot
  extraction is not supported with IRQ 9.  The system will hang upon
  removal of the Token Ring card.

  When installing PCMCIA on a Thinkpad 720, the installation will
  falsely report that Power Management is not supported.  Ensure that
  you are loading POWER.EXE.  If you are, disregard this message.


  11.3  Modem Suspend and Resume on IBM ThinkPADs
  -----------------------------------------------
  The suspend and resume function on IBM 720 and 750 ThinkPADs is
  provided by the $ICPMDOS.SYS driver that is shipped with the system.
  If you are using a modem on one of these systems then you need to add
  /MODEMOFF (must be capitalized) to the end of the DEVICE=$ICPMDOS.SYS
  statement in your CONFIG.SYS (ie. DEVICE=C:$ICPMDOS.SYS /MODEMOFF)
  and add /NOPM to Card Services (PCMCS.EXE) in PCM.INI file.  More
  information is provided in the Online help on how to update the
  PCM.INI file.


  11.4  PCMCIA & PC Card Upper Memory Requirements
  ------------------------------------------------
  The following are the pre-configured default settings for PCMCIA

  =======================================================================
  DRIVER/PCMCIA        UPPER MEMORY        DEFAULT         EMM386 EXCLUDE
      CARD               REQUIRED                             REGIONS
  =======================================================================
  PCMCS.EXE                 4K            /ADDR=DF          X=DF00-DFFF
  PCMATA.SYS               16K            /ADDR=D4          X=D400-D7FF
  IBM Ethernet             16K                              X=D800-DBFF
  IBM 3270                  8K                              X=CE00-CFFF
  IBM Token Ring           24K                              X=DC00-DDFF and
                                                            X=D800-DBFF

  12.0  Norton Utilities - DISKREET.SYS
  =====================================

  If you are using EMM386 with the RAM option and you attempt to load the
  Norton Utilities DISKREET.SYS driver into upper memory using DEVICEHIGH,
  the machine will lock or reboot.  This is due to an error in DISKREET.SYS
  extending itself into memory which is not a valid UMB area.  If you do not
  require EMS support, use the NOEMS switch with EMM386 and you can continue
  to use DISKREET.SYS.


  13.0  IBM Screen Reader
  =======================

  If you are using the IBM Screen Reader program you need to make sure that
  it is loaded after PC DOS 7's SMARTDRV.EXE.  Check your AUTOEXEC.BAT
  file and consider moving the SMARTDRV line from AUTOEXEC.BAT to
  CONFIG.SYS and load it with the 'INSTALL=' command.


  14.0  Eurocurrency Symbol Support
  =================================

  PC DOS provides support for the new Eurocurrency symbol defined by
  the European Community as part of the European Monetary Union (EMU).
  The symbol is provided in code page 850 at offset 0xD5.  You can
  invoke the symbol through the keyboard by using the same AltGr or
  AltCar + character key sequence that is used for many other
  country-specific symbols (the AltGr and AltCar keys are the same as
  the right-hand Alt key).  For additional information, see the
  "Multiple Characters on a Key" section in the PC DOS 7 Keyboards and
  Code Pages book which is sold separately.  The table below shows the
  particular key sequence for each country supported.

  The symbol comes in 8x8, 8x14 and 8x16 pixel resolutions in code page
  850 in both the EGA.CPI and EGAX.CPI code page information files, and
  in 8x16 pixel resolution in code page 850 in the ISO.CPI file.  These
  CPI files are specified in the MODE command that is placed in the
  AUTOEXEC.BAT file by SETUP.

  SETUP automatically installs the Eurocurrency symbol support for
  the countries listed in the following table.  The support is activated
  in the same way that code page 850 support is activated, as the
  following examples shows.

  Note:  These examples assume PC DOS has been installed in the \DOS
  directory on your hard disk.  For additional information see the
  section "Customizing Keyboards for International Use" and the specific
  commands in the PC DOS 7 Command Reference and Error Messages book.

  1) When you install any keyboard or country other than the default
     U.S., SETUP adds a command to the CONFIG.SYS file to allocate a
     buffer for the code page:

          DEVICE=C:\DOS\DISPLAY.SYS CON=(,,1)

  2) Commands are also added to AUTOEXEC.BAT to load, prepare and select
     the code page:

          MODE CON CP PREP=((850) C:\DOS\xxx.CPI)
                  (where xxx is either EGA, EGAX or ISO)

          MODE CON CP SEL=850

  3) A command is added to AUTOEXEC.BAT to load the country-specific
     keyboard support:

          KEYB yy,,C:\DOS\KEYBOARD.SYS
                  (where yy is the keyboard code)

  For Turkish keyboards 179 and 440, code page 857 is the default in the
  above commands and not 850.  To activate the Eurocurrency symbol
  support for these Turkish keyboards, install code page 850 in addition
  to the default code page.  For more information, see the section
  "Customizing Keyboards for International Use" and the specific
  commands in the PC DOS 7 Command Reference and Error Messages book.
  The following command can then be added to the AUTOEXEC.BAT file or
  entered at the command line to activate code page 850:

                  CHCP 850

  For International English, you must select both International English
  as the country and US English as the keyboard to get code page 850 and
  the Eurocurrency symbol support.

  The following table gives the key sequence for each supported country
  (the AltGr and AltCar keys are the same as the right-hand Alt key).

            KEY SEQUENCE FOR EUROCURRENCY SYMBOL SUPPORT

  COUNTRY         KEYBOARD          KEYBOARD CODE    EURO KEY SEQUENCE
  -------         --------          -------------    -----------------
  Belgium         Belgian                 BE            AltCar + e
  Canada (French) Canadian French         CF            AltCar + e
  Denmark         Danish                  DK            AltGr  + 5
  Finland         Finnish                 SU            AltGr  + 5
  France          French (189)            FR            AltGr  + e
  France          French (120)            FR            AltCar + e
  Germany         German (129)            GR            AltGr  + e
  Germany         German (453)            GR            AltGr  + e
  Iceland         Icelandic               IC            AltGr  + 5
  International   US English              UX            AltGr  + 5
    English
  Italy           Italian (141)           IT            AltGr  + 5
  Italy           Italian (142)           IT            AltGr  + 5
  Latin America   Latin American          LA            AltGr  + e
  Netherlands     Dutch                   NL            AltGr  + e
  Norway          Norwegian               NO            AltGr  + 5
  Portugal        Portuguese              PO            AltGr  + 5
  Spain           Spanish                 SP            AltGr  + 5
  Sweden          Swedish                 SV            AltGr  + 5
  Switzerland     Swiss (French)          SF            AltGr  + e
  Switzerland     Swiss (German)          SG            AltGr  + e
  Turkey          Turkish (440)           TR            AltGr  + e
  Turkey          Turkish (179)           TR            AltGr  + e
  United Kingdom  UK English              UK            AltGr  + 4


  15.0  Notices
  =============

  The following are trademarks of the IBM Corporation in the United
  States or other countries or both:
  IBM
  OS/2

  Other company, product, and service names may be trademarks or service
  marks of others.

  THIS DOCUMENT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.  IBM
  DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING
  WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
  PURPOSE AND MERCHANTABILITY WITH RESPECT TO THE INFORMATION IN THIS
  DOCUMENT.  BY FURNISHING THIS DOCUMENT, IBM GRANTS NO LICENSES TO ANY
  PATENTS OR COPYRIGHTS.

  (c) Copyright IBM Corporation 1981, 1998.  All rights reserved.

                        **** End of Document ****
