; display specific definitions follow. You will need to add to these to 
; configure for unsupported display controllers.

	 ; default generic graphics. USE THESE AS "TEMPLATES"
gmode_test macro isgraphic
	; This macro is to jump if display is in an EGA/VGA 16 color 
	; "compatible" mode -- this means one which is a simple extension
	; (more rows and/or columns) than modes 10h or 12h. At minimum
	; modes 10h and 12h themselves qualify.
	; No registers may be altered.
	; Byte location "cs:video_mode" is a copy of byte 40:49H.
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
endm
gmode_code macro
	; this macro is used to tell if display is in graphics
	; mode by looking at the byte 40:49H, which is in
	; register AL at the start of the macro.
	; It is to set location cs:gmode_flag non-zero if in a graphics mode.
	; Value of 7 is reserved for the monochrome adapter.
	; No registers may be altered.
	; *NOTE* users of Paradise and possibly other VGA
	; cards will need to modifify this routine because
	; Paradise extended character modes set this byte to
	; to the value of the mode you selected.  Nicer cards
	; (Genoa and VEGA, that I know of) leave this byte at
	; "3" and all works fine!
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm

if DOSV
card_id	macro
	db	'DOS/V'
endm

gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 70h			; DOS/V V-Text (03h compatible)
	je	not_graphics
	cmp	al, 71h			; DOS/V V-Text (73h compatible)
	je	not_graphics
	cmp	al, 73h			; DOS/V enhanced CGA mode
	je	not_graphics
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
endif					; DOSV

IF IBMXGA
card_id	macro
	db	'XGA'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 14H			; 132x25
	jb	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm

ENDIF

IF PARA480
; From Arend van den Brug
card_id	macro
	db	'Paradise EGA 480'
endm

gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 50h	; 640x480, 16 color EGA mode
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 51h			; 51: 80x30 text 16 colors 
	je	not_graphics
	cmp	al, 54h			; 54: 132x43 text 16 colors 
	je	not_graphics
	cmp	al, 55h			; 55: 132x25 text 16 colors 
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

IF PARADISE
card_id macro
	db	'Paradise VGA'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 58h	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 54h			; modes 54 and 55 are text!
	je	not_graphics
	cmp	al, 55h
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

IF TSENG4000
BAD_ERASE = TRUE			; can't erase the display properly
card_id	macro
	db	'TSENG LABS 4000'
endm

gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 25h	; 640x480, 16 color
	je	isgraphic
	cmp	cs:video_mode, 29h	; 800x600, 16 color
	je	isgraphic
	cmp	cs:video_mode, 6ah	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 17h			; 80x43 Bios 9/14/90
	je	not_graphics
	cmp	al, 21h			; 132x60, 44, 25, 28
	jb	is_graphics
	cmp	al, 24h
	jbe	not_graphics
	cmp	al, 26h			; 80x60
	je	not_graphics
	cmp	al, 2Ah			; 100x40
	je	not_graphics
is_graphics:
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF


IF ATT600
card_id macro
	db	'AT&T VDC600'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 47h	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp	al, 54h			; modes 54 and 55 are text!
	je	not_graphics
	cmp	al, 55h
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

IF STBVGA
card_id	macro
	db	'STB VGA Extra'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp	al, 22h			; modes 22 and 23 are text!
	je	not_graphics
	cmp	al, 23h
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

IF TVGA16
card_id	macro
	db	'Tatung VGA-16'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp	al, 56h			; modes 56 and 57 are text!
	jb	not_graphics
	cmp	al, 57h
	jb	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF


IF	VEGA
card_id	macro
	db	'Video-Seven/Headland VGA'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 14h	; 752x410
	je	isgraphic
	cmp	cs:video_mode, 15h	; 720x540
	je	isgraphic
	cmp	cs:video_mode, 16h	; 800x600
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF


IF	EGAWIZ
card_id	macro
	db	'EGA Wizard Deluxe'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 26h	; 640x480, 60 line
	je	isgraphic
	cmp	cs:video_mode, 70h	; 740x396
	je	isgraphic
	cmp	cs:video_mode, 71h	; 800x600
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp	al, 22h			; 22-24 are nongraphic
	jb	is_graphics
	cmp	al, 24h
	jbe	not_graphics
	cmp	al, 32h			; 32-34 are nongraphic
	jb	is_graphics
	cmp	al, 34h
	jbe	not_graphics
	cmp	al, 38h			; 38 is nongraphic
	je	not_graphics
is_graphics:
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

IF TridentVGA
card_id	macro
	db	'Trident VGA'
endm
; contributed by Nadav Horesh  CFNADAV%WEIZMANN.BITNET@CUNYVM.CUNY.EDU
gmode_test macro isgraphic
        cmp     cs:video_mode, 10h      ; 640x350, 16 color mode
        je      isgraphic
        cmp     cs:video_mode, 12h      ; 640x480, 16 color VGA mode
        je      isgraphic
        cmp     cs:video_mode, 5bh      ; 800x600, 16 color TVGA mode
        je      isgraphic
        cmp     cs:video_mode, 5fH      ; 1024x768 16 color TVGA mode
        jnb     isgraphic
endm
gmode_code macro
        mov     cs:gmode_flag,0         ; assume character mode (zero flag)
        cmp     al, 4
        jb      not_graphics            ; modes >=4 are assumed to be graphic
        cmp     al, 050H
        jb      is_graphics
        cmp     al, 5Bh
        jb      not_graphics
is_graphics:
	mov     cs:gmode_flag,al        ; non-zero value
not_graphics:
endm
ENDIF

IF MAGICVGA
; Contributed by:



;In-Real-Life: Andrew A. Chernov  |  Domain: ache@hq.demos.su,
;Zodiac-Sign:  Virgo              |          ache%hq.demos.su@relay.eu.net
;Organization: DEMOS Coop.,       |  Phone:  +7 095 2312129
;              Moscow, Russia     |  Fax:    +7 095 2335016

card_id	macro
	db	'Magic VGA'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 63h	; 720x540, 16 color
	je	isgraphic
	cmp	cs:video_mode, 64h	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 40h 		; modes 40-43 are text!
	je	not_graphics
	cmp	al, 41h
	je	not_graphics
	cmp	al, 42h
	je	not_graphics
	cmp	al, 43h
	je	not_graphics
	cmp	al, 50h 		; modes 50-53 are text!
	je	not_graphics
	cmp	al, 51h
	je	not_graphics
	cmp	al, 52h
	je	not_graphics
	cmp	al, 53h
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF
IF	CHIPS
; From Arend van den Brug
card_id	macro
	db	'Chips SVGA'
endm

gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 6Ah	; 800x600, 16 color
	je	isgraphic
	cmp	cs:video_mode, 70h	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp	al, 60h			; 60: 132x25 text 16 colors (char 8x14)
	jb	is_graphics		; 61: 132x50 text 16 colors (char 8x8)
	cmp	al, 62h			; 62: 132x43 text 16 colors (char 8x8)
	jbe	not_graphics
	cmp	al, 64h			; 80x43 text 16 colors (char 9x8)
	je	not_graphics
	cmp	al, 65h			; 80x50 text 16 colors (char 9x8)
	je	not_graphics
is_graphics:
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF


IF ATI
; Contributed by Yaron Keren 

card_id	macro
    db  'VGAWonder'
endm

gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp 	cs:video_mode, 53h  	; 800x560, 16 color
	je	isgraphic
	cmp 	cs:video_mode, 54h  	; 800x600, 16 color
	je  	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes >=4 are assumed to be graphic
	cmp 	al, 23h             	; 132x25
	je 	not_graphics
	cmp 	al, 33h			; 132x44
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF


IF FAHREN1280
card_id macro
	db	'1280',248,'F'
endm
gmode_test macro isgraphic
	cmp	cs:video_mode, 10h	; 640x350, 16 color mode
	je	isgraphic
	cmp	cs:video_mode, 12h	; 640x480, 16 color VGA mode
	je	isgraphic
	cmp	cs:video_mode, 6Ah	; 800x600, 16 color
	je	isgraphic
endm
gmode_code macro
	mov	cs:gmode_flag,0		; assume character mode (zero flag)
	cmp	al, 4
	jb	not_graphics		; modes =>4 are assumed to be graphic
	cmp	al, 54h			; 132x43 text
	je	not_graphics
	cmp	al, 55h			; 132x25 text
	je	not_graphics
	mov	cs:gmode_flag,al	; non-zero value
not_graphics:
endm
ENDIF

