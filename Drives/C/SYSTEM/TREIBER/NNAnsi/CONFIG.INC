;*************************************************************
;*****************                         *******************
;*****************  User Definable Options *******************
;*****************      for NNANSI.SYS     *******************
;*****************       Version 5/93      *******************
;*****************                         *******************
;*************************************************************

; Author: Tom Almy, except as noted.
; Card id printout idea by Arend van den Brug.
; DOS/V support by Akira Kikuchi.


; Note: I haven't tried all combinations. (says Tom)

; If you want to use NNANSI under DOS/V, make DOSV TRUE.
; It disables EGA, and cheap_pc options (DOS/V requires 80286 or higher),
; and enables DESQVIEW and DOS/V support code.             Akira Kikuchi

; Select only one of the following choices to customize for your display
; hardware.

DOSV	=	FALSE	; Japanese DOS/V
BIOS_ONLY = 	FALSE	; Write only through BIOS (special applications only)
VEGA	=	FALSE	; Configure for Video-Seven FastWrite VGA, or
			; compatible (such as Tatung VGA (not VGA-16))
PARA480	=	FALSE	; Paradise EGA 480
PARADISE =	FALSE	; Paradise VGA 
STBVGA  =	FALSE	; STB VGA Extra
TVGA16	=	FALSE	; Tatung VGA-16
EGAWIZ  =	FALSE	; EGA Wizard Deluxe
ATT600  =	FALSE	; AT&T VDC600
MAGICVGA =	FALSE	; MAGIC VGA (CT-8490) Twinhead International
			; ps2parms or necparms must loaded for ext. modes
TridentVGA =	FALSE	; Trident VGA
CHIPS	=	FALSE	; Chips SVGA (with C&T VGA chip F82C451)
TSENG4000 =	FALSE	; Diamond Speedstar, Orchid Prodesigner II
			; (and other TSENG 4000 based, I hope)
ATI	=	FALSE	; ATI VGAWonder, Graphics Ultra/Vantage
FAHREN1280 =	FALSE	; Orchid Fahrenheit 1280, also Diamond Steath
			; and probably other S3 based cards.
IBMXGA	=	FALSE	; IBM XGA display (also define as VGA, below)

; Define both of these TRUE is display type is unknown.
; Otherwise define FALSE what your display isn't.
; Note: If display is neither VGA nor EGA, then this driver won't work, 
;       but the driver will work if you define both of these FALSE. 
;	This is useful for VGA systems that want the 43 line mode to
;	display 50 lines. Note that if VGA is FALSE,, attempting to 
;       set 50 line mode will try to put the display in mode 50, which
;       might just be a disaster!

VGA	=	TRUE    ; define TRUE for VGA, defining as FALSE eliminates
			; 50 line mode code. (43 line mode will run with 50
			; lines like older nansi and nnansi drivers
EGA	=	FALSE	; define TRUE for EGA for best results on EGA.
			; defining as FALSE eliminates 43 line cursor fix code



; If you also want NNANSI to work with a monochrome card ("double headed")
; define MONO to be true. Otherwise define as false since this makes the
; driver larger. Note monochrome operation with NNANSI is not spectacular,
; if all you have is a monochrome display, use another ANSI driver.

MONO	=	FALSE


; The following option is used to compile NNANSI as an TSR/DRIVER program.
; When saved as an .EXE format file it can *STILL* be loaded as a driver on 
; most systems (some older PC-DOS versions did not allow EXE format) or 
; as a TSR from the command line. When used as a TSR, the DSR command and key
; redefinition do not function. The driver can be unloaded (if the last TSR
; loaded) by running "NNANSI U".

; TSR	=	FALSE	; defined in TASM command line --
			; see MAKEFILE.


; DESQVIEW compatability -- NNANSI, when run as a TSR can be made
; "Desqview aware" when compiled with this option. 
; NOTICE -- you cannot use both a monochrome display adapter under DESQVIEW
;           with this version of NNANSI.


DESQVIEW =	TRUE


; VESA Compatibility -- ONLY SET IF YOUR DISPLAY CONTROLLER IS VESA
; COMPATIBLE. This changes some code in the body of NNANSI. You will
; also need to select a display card or use the default. Don't set for DOS/V

VESA	=	FALSE



BAD_ERASE =	FALSE	; Set to TRUE if erase to end of line and
			; erase to start/end of screen commands erase
			; wrong portion of display (Automatically set
			; to true for TSENG4000 based cards)

; Define the following TRUE if you have an 8088/6 (PC XT or clone), or might 
; want to use the driver with an 8088/6. Define as FALSE for 
; processors >=80186 for best performance and smallest size.

cheap_pc	=	FALSE	; no fancy instructions if true

; Define the following true if you have a keyboard with 12 function keys
; as opposed to the original ones with 10 keys.

ext_keybd	=	TRUE	; Modern keyboard if true


; The following options specify certain feature options. These options 
; take space if turned on, but improve performance and/or add features.

key_redef	=	FALSE	; keyboard redefinition allowed if true
	; If you don't use key redefinition, set at FALSE, since some Trojan 
	; Horse programs take advantage of this. Also it takes space.
init_buf_size	=	256	; size of keyboard redefinition buffer 
	; and parameter buffer when key_redef TRUE. You may want to change 
	; the size, if you use this feature. Don't make it <100.
quick_char	=	TRUE ; quick graphic characters in modes 10 and 12
	; quick_char should be "TRUE" unless 
	; you have an incompatible display card.
	; And I don't know of any that are.
fast29		=	TRUE	; 15 % faster operation (overall)
	;  of int29 calls (costs 100 bytes)
bios_write_tty	=	TRUE	; take over BIOS write_tty if true
	; NOTE: if bios_write_tty is true, the color rendition of text may 
	; change, but performance will improve and ANSI control codes can 
	; be used. This feature can be enabled/disabled at runtime as
	; long as it is assembled (TRUE)
gbackground	=	TRUE	; generate non-black graphic backgrounds
	; This option may cause problems for software not expectings its
	; existance. Also you must specify quick_char to use gbackground.
dos4		=	TRUE	; Answers ANSI.SYS installed
	; If you are running a DOS version less than 4.0, you don't need
	; this. Probably don't need it for DR DOS, but don't know for sure


; The following options affect initial state. They do not affect the 
; size of the driver.

initbiosw	=	FALSE	; ANSI write_tty initially on if true
initgc		=	FALSE	; graphics cursor initially on if true
initfast	=	FALSE	; initially fast mode if true
	; note- you may have to clear the display (CLS command) before 
	; running some programs, or just before leaving "shell escapes" in
	; some programs.  But it's typically worth the effort.
	; You can disable/enable it with a simple control sequence anyway.

IF BIOS_ONLY
fast29		= 	FALSE
bios_write_tty	=	FALSE
ENDIF

IF DOSV
BIOS_ONLY	= 	TRUE
EGA		= 	FALSE
cheap_pc	=	FALSE	; DOS/V runs only on >= 80286
ENDIF

IF BIOS_ONLY
DESQVIEW	=	TRUE
ENDIF
