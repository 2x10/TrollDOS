%title	"NNANSI Terminal Driver Version 5/93"
%pagesize	60, 132
%noconds
JUMPS	; clarify branches -- TASM V2.0 or V3.1 recommended
; With MASM, delete the preceeding four lines.
;--- nnansi.asm ----------------------------------------------------------
; New, New ANSI terminal driver.
; Optimized for speed in the case of multi-character write requests.
; Original NANSI terminal driver (C) 1986 Daniel Kegel
;    Bellevue, Washington & Pasadena, California
; Modifications by Tom Almy without restrictions.
; May be distributed as specified in the GNU General Public License,
;   which is supplied hera as file GPL.TXT

; Revision history:
; 5  july 85: brought up non-ANSI portion except forgot backspace
; 6  july 85: split off ANSI stuff into other files, added backspace
; 11 july 85: fixed horrible bug in getchar; changed dosfns to subroutines
; 12 july 85: fixed some scrolling bugs, began adding compaq flag
; 9  aug 85:  added cursor position reporting
; 10 aug 85:  added output character translation
; 11 aug 85:  added keyboard redefinition, some EGA 80x43 support
; 19 Aug 85:  Fixed horrible bug in insert/delete line.
; 26 Aug 85:  Fixed simple limit-to-one-too-few-lines bug in ins/del line;
;  anyway, it inserts 24 lines when on line 2 now.  Whether it's fixed...
; 4 Sept 85:  Fixed bug created on 26 Aug 85; when limiting ins/del line
;  count, we are clearing, not scrolling; fixed BIOS call to reflect this.
; 10 sept 85: Tandy 2000 support via compaq flag (finding refresh buffer)
; 30 Jan 86:  removed Tandy 2000 stuff, added graphics mode support
; 12 feb 86:  added int 29h handler, added PUSHA/POPA, added direct beep,
;	      direct cursor positioning, takeover of BIOS write_tty,
;	      noticed & squashed 2 related bugs in tab expansion
; 30 Jan 86:  Added EGA cursor patch
; 31 Jan 86:  Disabled insert/delete char in graphics modes
;	      Implemented keyboard redefinition reset
;  1 Feb 86:  added video_mode and max_x test after mode set
; 13 feb 86:  Squashed them again, harder
; 24 feb 86:  There is a bug in the timing code used by the BEEP routine.
;	      If the addition of the beep period to the
;	      BIOS low timer word results in an overflow, the beep will be
;	      supressed. Also made code compatible eith earlier versions
;	      of assembler.

; Tom Almy, Tualatin, Oregon (toma@sail.labs.tek.com) modified the NANSI 
;  version ; 2.2 code for use in EGA/VGA environments only:
; 8 Jan 89:   Additional compilation options
;             Scrolling via reprogramming display start (*MUCH* faster)
;	      INT29 updates display directly if not control character.
;	      Various cleanups
; Nov 89:     Some bug fixes, customization for various cards enhanced
;             display modes, better handling of graphic cursor, graphic
;             characters in 16 color modes are drawn by NNANSI rather
;             than BIOS (much faster).
; Sept 90:    Color backgrounds and XOR mode (as BLINK) in 16 color graphic
;	      modes. VGA has 43 or 50 line modes (instead of producing 50
;	      (when 43 selected). FAST mode can be toggled via escape 
;	      sequences. Lots of code clean up. Some old options incorporated
;	      (extra ANSI sequences) or deleted (output conversion).
;             The fast graphic draw routine has been speeded up, since it
;	      was slower than some BIOSes (!). The BIOS TTY call has been
;             redirected to the INT29 routine which has some efficiency
;	      speedups; this also saved code space.
; May 1991:   Restored CGA and MDA support. MDA is optional. Added 
;	      DOS 4.x compatibility. Added 40x43 and 40x50 text mode support.
;	      Added VESA support. Fixed bug allowing either = or ? or nothing
;	      in all set mode commands. Added enable/disable for bios 
;	      write_tty takeover. Added drivers for new cards and changed
;	      some defaults. Merged source code into one file.
; 	      Card id printout idea by Arend van den Brug.
; Sept 1991:  Now installable as TSR (which can be removed) or device driver
;	      with the same binary! Installation code now uses proper
;	      system calls to set interrupt vectors
;             Added Desqview compatability
;             Removed changing modes without clearing screen -- it seems
;	       to cause later crashing with some programs, particularly
;	       Zortech ZWB and Doorway.
;	****Credit and thanks to Ralf Brown and is interrupt list, without
;           which most of the recent changes would have been impossible****
; Sept 1992:  Minor bug fixes. Changes as noted below

; Nov  1992   Support DOS/V by Akira Kikuchi (kiku@yuichi.ee.sophia.ac.jp)

; Jan  1993   Added extended keyboard support, reworked ANSI state machine
;             Changed config.inc to use "=" rather than "EQU"

; May  1993   Fixed bug when extended keyboard support turned off
;	      Added BIOS_ONLY mode for use by the blind and other applications
;	      Enhancements to DOS/V support by Akira Kikuchi

page
TRUE	equ	1
FALSE	equ	0

	INCLUDE CONFIG.INC
page
; Option dependent definitions
if BIOS_ONLY
card_id macro
	db	'BIOS access only'
endm
else
if VGA
if EGA
card_id macro
	db	'Generic EGA/VGA'
endm
else
card_id macro
	db	'Generic VGA'
endm
endif
else
if EGA
card_id macro
	db	'Generic EGA'
endm
else
card_id macro
	db	'Generic NANSI Clone'
endm
endif
endif
endif

IF key_redef
buf_size	equ	init_buf_size	; size of parameter/redef buffer
ELSE
buf_size	equ	20		; size of parameter/redef buffer 
ENDIF


IF	cheap_pc
	.8086
ELSE
	.286c
ENDIF

page
	INCLUDE DRIVERS.INC
page
; Some Useful Macros

IF	cheap_pc
push_all	macro
	push	ax
	push	bx
	push	cx
	push	dx
	push	bp
	push	si
	push	di
	endm
ELSE
push_all	macro
	pusha
	endm
ENDIF

IF	cheap_pc
pop_all macro
	pop	di
	pop	si
	pop	bp
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	endm
ELSE
pop_all macro
	popa
	endm
ENDIF

call_video macro
			; call original video interrupt by
			; faking a SWI
	pushf		; push flags
	call	dword ptr old_vid_bios
endm

draw_gcursor macro		; draw graphic cursor
if quick_char
if DOSV
	mov	ax, 8f5fh
else
	mov	ax, 8f16h
endif
	call	quick_graph
else
if DOSV
	mov	ax, 095fh		; draw cursor at location
else
	mov	ax, 0916h		; draw cursor at location
endif
	mov	bx, 8fh
	mov	cx, 1
	call_video
endif
endm

if DOSV
; If dos4 symbol is not set, always assume DOS/V J mode, because DBCS
; vector pointer can not be get from DOS3

check_env	macro			; if DOS/V J mode, non zero AX
if dos4
	push	ds
	push	si
	lds	si, cs:dbcs_vector
	mov	ax, [si]
	pop	si
	pop	ds
else
	mov	ax, 1			; always DOS/V J mode
endif
endm
endif					; DOSV
	page

keybuf	struc				; Used in getchar
len	dw	?
adr	dw	?
keybuf	ends


ABS40	segment at 40h
	org	1ah
buffer_head	dw	?	; Used in 'flush input buffer' dos call.
buffer_tail	dw	?

	org	49h
crt_mode	db	?
crt_cols	dw	?
crt_len		dw	?
crt_start	dw	?
cursor_posn	dw	8 dup (?)
cursor_mode	dw	?
active_page	db	?
addr_6845	dw	?
crt_mode_set	db	?	; = 7 only if monochrome display adaptor
crt_palette	db	?
	org	6ch
timer_low	dw	?	; low word of time-of-day counter (18.2 hz)
	org	84h
ega_rows	db	?	; #rows-1 on display
ega_points	dw	?	; bytes per character

ABS40	ends

	page

CODE	segment word public 'CODE'
assume	cs:CODE, ds:CODE

	; Device Driver Header

	org	0
start:
if TSR
nextdev	label	dword
	jmp	realstart
	db	0
else
nextdev dd	-1			; next device
endif
if dos4
	dw	8053h			; attributes
else
	dw	8013h			; attributes
endif
	dw	strategy		; request header pointer entry
	dw	interrupt		; request entry point
	db	'CON'			; device name (8 char)
	db	5 dup (20h)		;  ... and 5 blanks)

	; Identification- in case somebody TYPEs the assembled driver
	db	27,'[2J'
IDLOC:	db	"NNANSI.SYS 5/93 for "
	card_id
	ife	cheap_pc
	db	"(80286)"
	else
	db	"(80x86)"
	endif
	db	13, 10
	db	'by Tom Almy based on code (C) 1986 Daniel Kegel.'
if DOSV
	db	13, 10
	db	'Modified for DOS/V by Akira Kikuchi. '
	db	'(02/14/93 version)'
endif
	db	13, 10, 26

	even
;----- variable area --------------------
	org	$-34		; overlay id string with uninitialized data
if key_redef
	org	$-2
endif
if MONO
	org	$-2
endif
if TSR
	org	$-14
endif
req_ptr label	dword
req_off dw	?
req_seg dw	?
f_cptr_seg	dw	?	; part of fastout write buffer pointer
cur_parm_ptr	dw	?	; last byte of parm area now used
saved_coords	dw	?	; holds XY after a SCP escape sequence
temp_val	dw	?	; just a temporary
param_buffer	dw	?	; address of first byte free for new params
param_end	dw	?	; address of end of free area
if key_redef
redef_end	dw	?	; address of end of redefinition area
endif
if TSR
old_brk		dd	?	; original break handler
old_int29	dd	?	; original int29 handler
savecon		dd	?	; original console driver
parsize		dw	?	; size of TSR in segments
endif
if MONO
our_6845	dw	?
endif
no_c_flag	db	?	; there is no graphic cursor on the screen.
max_y		db	?	; lines-1
max_cur_x	label	word	; used to get both max & cur at once
max_x		db	?	; line width (79 for 80x25 modes)
cur_coords	label	word
cur_x		db	?	; cursor position (0 = left edge)
cur_y		db	?	;		  (0 = top edge)
video_mode	db	?	; ROM BIOS video mode (2=BW, 3=color, etc)
string_term	db	?	; either escape or double quote
int_29_buf	db	?	; character buffer for int 29 calls
fnkeybuf	db	?	; holds second byte of fn key codes
eat_key		db	?	; Eaten key (bug fix)
cpr_buf		db	8 dup (?), '['
cpr_esc		db	1bh	; descending buffer for cpr function

	even	; this should be redundant, if I did it right

; following four keybufs hold information about input
; Storage order determines priority- since the characters making up a function
; key code must never be separated (say, by a Control-Break), they have the
; highest priority, and so on.	Keyboard keys (except ctrl-break) have the
; lowest priority.

fnkey	keybuf	<0, fnkeybuf>	; fn key string (0 followed by scan code)
cprseq	keybuf	<0>		; CPR string (ESC [ y;x R)
brkkey	keybuf	<0, brkkeybuf>	; ^C
if key_redef
xlatseq keybuf	<0>		; keyboard reassignment string
endif

escvector	dw	0	; state vector of ESCape sequencor
if DESQVIEW
disppage	dw	0b800h	; address of display page
if BIOS_ONLY
dvactive	db	1	; to put NNANSI on its good behavior
else
dvactive	db	0	; is desqview active?
endif
endif
brkkeybuf	db	3	; control C
wrap_flag	db	1	; 0 = no wrap past line end
cur_attrib	db	7	; current char attributes
gmode_flag	db	0	; true if in graphics mode
				; <0 for mono card
gcursor		db	initgc	; true if graphic cursor enabled
fmode		db	initfast	; in fast mode?
bmode		db	initbiosw	; ANSI write_tty BIOS command?
atr_flag	db	0	; 80h - blink, 8 - bright
				; 4 - invisible 2 - reverse 1 underline
color_flag	db	7h	; fg and bg colors

if TSR
fulldvr		db	1	; Full driver installation
endif
port_6845	equ	3d4h
page
if DOSV AND dos4
; DBCS vector pointer is returned from DOS call (ax = 6300h). It is
; supported by DOS4 or higher (not only Japanese DOS). It is a pointer
; to null terminated word array. This word indicates 1st byte of DBCS
; (Double Byte Code Set) character range. (high byte is start, low byte
; is end). NNANSI DOS/V extension refers this value to know current
; environment (Japanese mode or not). If first word is null, it must
; not be Japanese mode.
dbcs_vector	dd	0	; DBCS vector pointer
endif

;------ putchar_dosv --------------------------------------------
; In DOS/V Japanese environment, issue software interrupt to write
; character on the screen. If not, write it to VRAM.
if DOSV
putchar_dosv	proc	near
	push	ax
	check_env
	or	ax, ax
	pop	ax
	jz	e_env
j_env:
	call	putchar
	jmp	pc_leave
e_env:
	STOSW
pc_leave:
	ret
putchar_dosv	endp
endif					; DOSV

page
;------ xy_to_regs --------------------------------------------
; on entry: x in cur_x, y in cur_y
; on exit:  dx = chars left on line, di = address
; Alters ax, bx.
xy_to_regs	proc	near
	; Find number of chars 'till end of line, keep in DX
	mov	ax, max_cur_x
	mov	bx, ax			; save max_x & cur_x for next block
	xor	ah, ah			; ax = max_x
	xchg	dx, ax
	mov	al, bh
	xor	ah, ah			; ax = cur_x
	sub	dx, ax
	inc	dx			; dx is # of chars till EOL
	; Calculate DI = current address in text buffer
	mov	al, bl			; al = max_x
	inc	al
	mul	cur_y
	add	al, bh			; al += cur_x
	adc	ah, 0			; AX is # of chars into buffer
	add	ax, ax
	xchg	di, ax			; DI is now offset of cursor.

	push	ds
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40
	add	di, crt_start		; crt offset
					; the offset could be non-zero because
					; of video pages or fast scrolling.
	pop	ds
	assume	ds:nothing
	ret
xy_to_regs	endp

page
;------- dos_fn_tab -------------
; This table is used in "interrupt" to call the routine that handles
; the requested function.

if dos4
max_cmd equ	24
dos_fn_tab:
	dw	dosfn0, nopcmd, nopcmd, badcmd, dosfn4, dosfn5, dosfn6
	dw	dosfn7, dosfn8, dosfn8, nopcmd, nopcmd
	dw	badcmd, badcmd, badcmd, nopcmd, badcmd ; 12-16 
	dw	badcmd, badcmd	; 17-18 unassigned
	dw	dosfn19
	dw	badcmd, badcmd, badcmd	; 20-22 unassigned
	dw	nopcmd, nopcmd
else
max_cmd equ	12
dos_fn_tab:
	dw	dosfn0, nopcmd, nopcmd, badcmd, dosfn4, dosfn5, dosfn6
	dw	dosfn7, dosfn8, dosfn8, nopcmd, nopcmd
endif
;------- strategy ----------------------------------------------------
; DOS calls strategy with a request which is to be executed later.
; Strategy just saves the request.

strategy	proc	far
	mov	cs:req_off,BX
	mov	cs:req_seg,ES
	ret
strategy	endp

;------ interrupt -----------------------------------------------------
; This is where the request handed us during "strategy" is
; actually carried out.
; Calls one of 12 subroutines depending on the function requested.
; Each subroutine returns with exit status in AX.

interrupt	proc	far

	sti
	push_all			; preserve caller's registers
	push	ds
	push	es
	

	; Read requested function information into registers
	lds	bx,cs:req_ptr
	xor	ah,ah			; clear upper part of ax
	mov	al,ds:[BX+02h]		; al = function code
;
; The next instruction blows up MASM 1.0 but who cares!!
;
	les	si,[BX+0Eh]		; ES:SI = input/output buffer addr
	mov	cx,[BX+12h]		; cx = input/output byte count

	cmp	al, max_cmd
	ja	unk_command		; too big, exit with error code

	xchg	bx, ax
	shl	bx, 1			; form index to table of words
	mov	ax, cs
	mov	ds, ax
	call	word ptr dos_fn_tab[bx]
int_done:
	lds	bx,cs:req_ptr		; report status
	or	ax, 100h		; (always set done bit upon exit)
	mov	[bx+03],ax

	pop	ES			; restore caller's registers
	pop	DS
	pop_all
	ret				; return to DOS.

unk_command:
	call	badcmd
	jmp	int_done

interrupt	endp
	page
;----- BIOS break handler -----------------------------------------
; Called by BIOS when Control-Break is hit (vector was set up in Init).
; Simply notes that a break was hit.  Flag is checked during input calls.

break_handler	proc
	mov	cs:brkkey.len, 1
	iret
break_handler	endp

	page

;------ badcmd -------------------------------------------------------
; Invalid function request by DOS.
badcmd	proc	near
	mov	ax, 813h		; return "Error: invalid cmd"
	ret
badcmd	endp


;------ nopcmd -------------------------------------------------------
; Unimplemented or dummy function request by DOS.
nopcmd	proc	near
	xor	ax, ax			; No error, not busy.
	ret
nopcmd	endp
	page
;------- dos function #4 ----------------------------------------
; Reads CX characters from the keyboard, places them in buffer at
; ES:SI.
dosfn4	proc	near
	jcxz	dos4done
	mov	di, si
dos4lp: push	cx
	call	getchar
	pop	cx
	stosb
	loop	dos4lp
dos4done:
	xor	ax, ax			; No error, not busy.
	ret
dosfn4	endp
	page
;-------- dos function #5: non-destructive input, no wait ------
; One-character lookahead into the keyboard buffer.
; If no characters in buffer, return BUSY; otherwise, get value of first
; character of buffer, stuff into request header, return DONE.
dosfn5	proc	near
	call	peekchar
	jz	dos5_busy

	lds	bx,req_ptr
	mov	[bx+0Dh], al
	xor	ax, ax			; No error, not busy.
	jmp	short dos5_exit
dos5_busy:
	MOV	ax, 200h		; No error, busy.
dos5_exit:
	ret

dosfn5	endp
	page
;-------- dos function #6: input status --------------------------
; Returns "busy" if no characters waiting to be read.
dosfn6	proc	near
	call	peekchar
	mov	ax, 200h		; No error, busy.
	jz	dos6_exit
	xor	ax, ax			; No error, not busy.
dos6_exit:
	ret
dosfn6	endp
	page
;-------- dos function #7: flush input buffer --------------------
; Clears the IBM keyboard input buffer.	 Since it is a circular
; queue, we can do this without knowing the beginning and end
; of the buffer; all we need to do is set the tail of the queue
; equal to the head (as if we had read the entire queue contents).
; Also resets all the device driver's stuffahead buffers.
dosfn7	proc	near
	xor	ax, ax
	mov	fnkey.len, ax		; Reset the stuffahead buffers.
	mov	cprseq.len, ax
	mov	brkkey.len, ax
if key_redef
	mov	xlatseq.len, ax
endif

	mov	ax, ABS40
	mov	es, ax
	mov	ax, es:buffer_head	; clear queue by making the tail
	mov	es:buffer_tail, ax	; equal to the head

	xor	ax, ax			; no error, not busy.
	ret
dosfn7	endp
	page
IF dos4
;------- dos function #19: Generic IOCTL
; DOS4 way of setting display size using MODE command.
; We will do more than necessary.
;
dosfn19	proc	near
	les	bx, req_ptr	; get request block
	mov	ax, es:[BX+13]	; get function code
	cmp	ax, 5f03h	; is it set information?
	jz	setinfo
	cmp	ax, 7f03h	; is it get information?
	jz	getinfo
	mov	ax, 8003h	; return bad command
	ret
getinfo: 
	les	bx, es:[bx+19]	; data packet to set
	push	ds
	mov	ax, ABS40	; address ABS40 area
	mov	ds, ax
	assume ds:ABS40
	mov	word ptr es:[bx+0], 0	; level and reserved fields
	mov	word ptr es:[bx+2], 14	; length field
	mov	word ptr es:[bx+4], 0	; flags
	mov	al, crt_mode
	call	set_gmode
	mov	ax, 1
	cmp	cs:gmode_flag, 0	; see if graphics mode
	jz	fn19txt
	inc	ax
if MONO
	cmp	cs:gmode_flag, -7	; check for mono mode
	jne	fn19txt
	dec	ax
	mov	word ptr es:[bx+8], 0	; monochrome
	jmp	short fn19mono
endif
fn19txt:
	mov	word ptr es:[bx+8], 4	; say 16 colors
fn19mono:
	mov	word ptr es:[bx+6], ax	; store mode
	mov	ax, crt_cols
	mov	word ptr es:[bx+0eh], ax	; character columns
	mov	dx, 8			; all characters are 8 pixels wide
	mul	dx
	mov	word ptr es:[bx+0ah], ax	; pixel columns
	xor	ax, ax
	mov	al, ega_rows
	inc	ax
	mov	word ptr es:[bx+10h], ax	; character rows
	mov	dx, ega_points
	mul	dx
	mov	word ptr es:[bx+0ch], ax	; pixel rows
	pop	ds
	assume ds:CODE
	xor	ax, ax
	ret
fn19fail:
	mov	ax, 8003h	; unknown mode, failure
	ret
setinfo: 
	les	bx, es:[bx+19]	; data packet to read
;	mov	dx, 80h		; monochrome, don't clear screen
	xor	dx, dx		; monochrome
	cmp	word ptr es:[bx+8], 0	; set to monochrome?
	je	setismono
	inc	dx
setismono:
	mov	ax, es:[bx+0eh]	; character columns
	cmp	ax, 40		; 40 columns?
	je	fn1940col
	cmp	ax, 80
	jne	fn19fail
	add	dx, 2		; mode 2 or 3
fn1940col:
	mov	ax, es:[bx+10h]	; character rows
	cmp	ax, 25
	je	fn1925lin
IF VGA
	cmp	ax, 50
	je	fn1950lin
ENDIF
	cmp	ax, 43
	jne	fn19fail

IF VGA
	mov	ax, 1201h	; 350 lines
	jmp	short ln50join
fn1950lin:
	mov	ax, 1202h	; 400 lines
ln50join:
	push	dx
	mov	bl, 30h		; set scan lines
	int 	10h
	pop	ax		; the mode
ELSE
	mov	ax, dx
ENDIF
	int	10h		; set video mode

	mov	ax, 1112h	; set 8x8 font
	mov	bl, 0
	int 	10h

	mov	ax, 1200h	; load new printscreen
	mov	bl, 20h
	int 	10h
IF EGA	; set the EGA cursor
	mov	dx, port_6845	; '6845' command reg
	mov	ax, 070ah	; start on line 7
	out	dx, ax
	mov	al, 0bh		; end on line 7
	out	dx, ax
ENDIF
	jmp     short clrs

fn1925lin:
IF VGA
	push	dx
	mov	ax, 1202h	; select 400 scan lines
	mov	bl,30h		; this call ignored on EGA
	int	10h
	pop	ax
ELSE
	mov	ax, dx
ENDIF
	int	10h		; set video mode

clrs:	push	ds		; address abs40 area
	mov	ax, ABS40
	mov	ds, ax
	ASSUME	ds:ABS40
	mov	ax, 600h		; clear display area
	xor	cx, cx			; upper left corner
	mov	dx, crt_cols
	dec	dl			; right column
	mov	dh, ega_rows		; lower row
	mov	bh, cs:cur_attrib	; character attribute
	int	10h
	pop	ds
	ASSUME	ds:CODE
	xor	ax, ax			; return success
	ret

dosfn19	endp
ENDIF
	page
if dos4
;--- new_mpx ------------------------------------------------
; This routine acknoledges that an ansi driver is installed.
;

new_mpx	proc
	cmp	ax, 1a00h	; is this for us?
	jz	ackansi		;  
	db	0eah		; if not, jump (far) to old_mpx
old_mpx dd	0	
ackansi:
	mov	al, 0ffh	; say we are installed
	iret
new_mpx endp
endif
	page
;--- new_vid_bios -------------------------------------------
; new_vid_bios takes the set cursor, get display mode, change mode, and
; get mode calls.

; If bios_write_tty defined, new_vid_bios replaces the write_tty call.
; This gives BIOS ANSI capability.
; However, it takes away the escape character.
; If this is not desired, just tell init to not take over the vector.
; 
; All other calls get sent to the old video bios.

new_vid_bios	proc
	STI
IF bios_write_tty
	cmp	ah, 0Eh
	je	nvb_write_tty
ENDIF
	cmp	Ah, 02h 	; set cursor position command?
	je	nvb_setcursor
	cmp	Ah,0		; change mode command?
	je	nvb_smode
	cmp	cs:fmode,0	; slow mode?
	je	new_vid_pass	; then pass it on
	cmp	Ah, 0Fh 	; get display mode command?
	je	nvb_display
	cmp	Ah, 06h		; clear screen command?
	je	nvb_scroll
	cmp	Ah, 07h		; alternative cls command?
	je	nvb_scroll
IF VESA	
	cmp	AX, 4f02h	; set extended display mode?
	je	nvb_smode
	cmp	AX, 4f03h	; get extended display mode?
	je	nvb_display
ENDIF
	jmp	new_vid_pass	; everything else

IF bios_write_tty
; WRITE TTY SUBCOMMAND
nvb_write_tty:
	cmp	cs:bmode, 0	; don't write with our driver?
	jz	new_vid_pass
	push	cx		; save register
	mov	cl, cs:cur_attrib
	; If in graphics mode, BL is new color
	cmp	cs:gmode_flag, 0
	jle	nvb_wt_text
	mov	cs:cur_attrib, bl	; ja?
nvb_wt_text:
	int	29h
	mov	cs:cur_attrib, cl
	pop	cx
	iret
ENDIF

; GET DISPLAY MODE SUBCOMMAND
nvb_display:
	cmp	cs:gmode_flag,0	; Graphic mode? Mono?
	jnz	new_vid_pass
	push	ds
	push	ax
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40
	cmp	crt_start,0	; At start of mem?
	jz	nvb_pass
if BAD_ERASE
nvb_clean:
	call	move_back
else
	call	move_back
nvb_clean:
endif
nvb_pass:
	pop	ax		; restore registers
	pop	ds
	assume	ds:nothing
new_vid_pass:
	db	0eah		; jump (far) to old video bios routine
old_vid_bios	dd	?	; pointer to old video bios routine

; SCROLL DISPLAY SUBCOMMAND
nvb_scroll:
	push	ds
	push	ax
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40
	mov	cs:no_c_flag, 1	; if graphic, don't draw cursor afterwards
	cmp	cs:gmode_flag,0	; graphic mode?
	jnz	nvb_pass
	cmp	crt_start,0	; not at start of mem
	jz	nvb_pass
	pop	ax		; restore ax
	push	ax
	cmp	al, 0		; scroll, not erase
	jnz	nvb_clean
	or	cx, cx		; not entire screen?
	jnz	nvb_clean
	push	dx		; (logic fixed 9/92)
	inc	dl
	cmp	dl, byte ptr crt_cols	; same question, max columns
	pop	dx
	jb	nvb_clean		; >size is full screen, though
	cmp	dh, ega_rows		; same question, max rows
	jb	nvb_clean		; >size is full screen, though
	xor	ax,ax		; erase is easier since we don't move screen
	mov	crt_start,0	; reset offsets
	push	dx
	mov	dx,port_6845
	mov	al,0ch
	out	dx,ax
	inc	al
	out	dx,ax
	pop	dx
	jmp	nvb_pass

; SET CURSOR SUBCOMMAND
nvb_setcursor:
	cmp	cs:gmode_flag,0	; Alpha mode?, Mono mode?
	jle	new_vid_pass
	cmp	cs:no_c_flag, 0	; inhibited cursor?
	jnz	new_vid_pass	; then keep inhibited
	cmp	cs:gcursor, 0	; no cursor?
	jz	new_vid_pass	; then don't want one now!
	push_all
	draw_gcursor
	pop_all
	call_video			; original int 10h
	push_all
	draw_gcursor			; redraw the cursor
	pop_all
	iret				; return from interrupt

; SET DISPLAY MODE SUBCOMMAND
nvb_smode:
	call_video
	push	ds
	push	ax
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40
	mov	al, crt_mode	; get mode and check for being graphic
	call	set_gmode
	mov	cs:no_c_flag, al ; if graphic, then no cursor is on screen.
	pop	ax
	pop	ds
	assume	ds:nothing
	iret
new_vid_bios	endp

	page
;------ int_29 ----------------------------------------------
; Int 29 handles DOS quick-access putchar.
; Last device loaded with attribute bit 4 set gets accessed for
; single-character writes via int 29h instead of via interrupt.
; Must preserve all registers.
; Installed as int 29h by dosfn0 (init).

int_29	proc	near
	sti
	push	ds
	push	es
	push_all
if DOSV
	push	ax
	check_env
	or	ax, ax
	pop	ax
	jnz	slow_way
endif
if fast29
	cmp	al, 20h			; control char?
	jb	slow_way
	cmp	cs:escvector, 0		; middle of an escape sequence?
	jnz	slow_way
	mov	dx, ABS40
	mov	ds, dx			; set addressability
	assume	ds:ABS40
	mov	cx, word ptr crt_mode	; mode in cl, columns in ch
	push	ax
	mov	al, cl
	call	set_gmode		; check for graphics mode
	pop	ax
	cmp	cs:gmode_flag, 0	; slow if graphics
	jg	slow_way
;	cmp	cl, 3			; graphics mode?
;	ja	slow_way
	xor	bx, bx			; get cursor position
	mov	bl, active_page
	add	bx, bx
	mov	dx, cursor_posn[bx]		; dh has y, dl has x
	inc	dl			; point to next location
	cmp	dl, ch			; at edge?
	jnb	slow_way
					; we can go with it!
	mov	cursor_posn[bx], dx	; update pointer
	xchg	ax, bx
	mov	al, dh
	mul	ch			; ax has line offset
	add	al, dl
	adc	ah, 0			; total offset
	mov	cx, bx
	mov	bx, ax			; cl has character, bx offset

if DESQVIEW
	cmp	dvactive, 0		; Desqview running?
	jz	dv_not_on			; if not, update cursor directly
	push	bx			; if  so, update via BIOS call
	xor	bx, bx
	mov	ah, 2
	call_video
	pop	bx
	jmp	dv_was_on
dv_not_on:
endif

	mov	ax, crt_start
	shr	ax, 1
	add	bx, ax			; corrected cursor offset, either
					; because of fast scroll or
					; page<>0

if MONO
	mov	dx, addr_6845		; update cursor location
else
	mov	dx, port_6845		; update cursor location
endif
	mov	al,0eh		; more effective to write two bytes at a time
	mov	ah,bh
	out	dx,ax
	inc	al
	mov	ah,bl
	out	dx,ax

dv_was_on:
	mov	al, cl			; get back character

	dec	bx
	add	bx, bx			; byte offset
if DESQVIEW
	mov	dx, disppage
else
	mov	dx, 0b800h		; address screen
endif
if MONO
	cmp	crt_mode, 7
	jne	int29_not_mono
	mov	dh, 0b0h
int29_not_mono:
endif
	mov	ds, dx
	assume	ds:nothing
	mov	ah, cs:cur_attrib
	mov	ds:[bx], ax		; write character
	jmp	short int_fin
endif
slow_way:
	mov	cx, 1
	mov	bx, cs
	mov	es, bx
	mov	si, offset int_29_buf
	mov	byte ptr es:[si], al
	call	dosfn8
int_fin:
	pop_all
	pop	es
	pop	ds
	iret
int_29	endp

	page
;------ dosfn8 -------------------------------------------------------
; Handles writes to the device (with or without verify).
; Called with
;  CX	 = number of bytes to write
;  ES:SI = transfer buffer
;  DS	 = CS, so we can access local variables.  NOT ANY MORE

dosfn8	proc	near

	mov	cs:f_cptr_seg, es	; save segment of char ptr

if DOSV
	; Check DOS/V environment (Japanese/English)
	mov	cs:dvactive, 1
	mov	cs:fmode, 0
	check_env
	or	ax, ax
	jnz	dosv_j
	mov	cs:dvactive, 0
	mov	cs:fmode, 1
dosv_j:
endif
	; Read the BIOS buffer address/cursor position variables.
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40

	; Find current video mode and screen size.
	mov	ax,word ptr crt_mode	; al = crt mode; ah = # of columns
	mov	cs:video_mode, al
	dec	ah			; ah = max column
	mov	cs:max_x, ah

	; Save graphics mode flag
	call	set_gmode

	mov	al, ega_rows		; number of display rows
	mov	cs:max_y, al		; set maxy value

	; Find current cursor coordinates.

	mov	al, active_page
	cbw
	add	ax, ax
	xchg	bx, ax
	mov	ax, cursor_posn[bx]
	mov	cs:cur_coords, ax

if MONO
	mov	ax, addr_6845		; get the right 6845
	mov	cs:our_6845, ax
endif

	; Find video buffer segment address; adjust it
	; so the offset is zero; return in AX.

if DESQVIEW
	mov	ax, cs:disppage
else
	mov	ax, 0B800H		; this gets corrected in xy_to_regs
					; if we are not screen 0
endif
if MONO
	cmp	crt_mode, 7
	jne	not_mono_mode
	mov	ah, 0b0h
not_mono_mode:
endif
	push	cs
	pop	ds
	assume	ds:CODE
	mov	es, ax
	call	xy_to_regs		; Set DX, DI according to cur_coords.

	; | If in graphics mode, clear old pseudocursor

	cmp	gmode_flag, 0
	jle	d8_no_cp
	cmp	no_c_flag, 0	; cursor not previously drawn?
	mov	no_c_flag, 0	; (reset flag, will be drawn from now on)
	jnz	d8_no_cp	; not drawn -- don't clear
	cmp	gcursor, 0	; don't clear if cursor is off, either
	jz	d8_no_cp
	push	cx
	push	dx
	push	di
	draw_gcursor
	pop	di
	pop	dx
	pop	cx

d8_no_cp:

	mov	ah, cur_attrib
	mov	ds, f_cptr_seg		; get segment of char ptr
	assume	ds:nothing
	cld				; make sure we'll increment

	; The Inner Loop: 12+4+4+11+14+2+19= 66 cycles/loop
	; on 8088; at 4.77 MHz, that gives 16.1 microseconds/loop.
	; At that speed, it takes 32 milliseconds to fill a screen.

	; Get a character, put it on the screen, repeat 'til end of line
	; or no more characters.
	jcxz	f_loopdone		; if count = 0, we're already done.
	cmp	cs:escvector, 0		; If in middle of an escape sequence,
	jz	f_tloop
	jmp	f_in_escape		; jump to escape sequence handler.

f_tloop:; | If in graphics mode, jump to alternate loop
	; | What a massive kludge!  A better approach would have been
	; | to collect characters for a "write n chars" routine
	; | which would handle both text and graphics modes.
	cmp	cs:gmode_flag,0
	jle	f_t_cloop
	jmp	f_g_cloop

	even				; tiny performance boost
f_t_cloop:
	LODSB				; get char! (al = ds:[si++])
	cmp	al, 28			; is it a control char?
	jb	f_control		;  maybe...
f_t_nctl:
if BIOS_ONLY
if DOSV
	call	putchar_dosv
else
	call	putchar
endif
else
	STOSW				; Put Char! (es:[di++] = ax)
endif
	dec	dx			; count down to end of line
	loopnz	f_t_cloop		; and go back for more.
	jnz	f_loopdone		; finished execution
f_t_at_eol:
	jmp	f_at_eol		; at end of line, maybe do a crlf.


f_looploop:
f_ansi_exit:				; in case we switched into
	loopnz	f_tloop			; a graphics mode
	jz	f_t_at_eol
;	jmp	f_loopdone

f_loopdone:

	;--------- All done with write request -----------
	; DI is cursor address, cursor position in cur_y, dl

	assume	ds:ABS40
	mov	ax, ABS40
	mov	ds, ax

	; Set cursor position in low memory.

	mov	al, active_page
	cbw
	add	ax, ax
	xchg	bx, ax
	mov	al, max_x
	inc	al
	sub	al, dl
	mov	ah, cur_y
	mov	cursor_posn[bx],ax

	cmp	gmode_flag,0
	jg	pseudocursor		; In graphics mode, there is
					; a pseudo cursor to draw.

if DESQVIEW
	cmp	dvactive,0		; Desqview running?
	jz	dv_off
	mov	dx, ax			; call bios to set position
	xor	bx, bx
	mov	ah, 2
if DOSV                                 ; for Windowed command.com
	int	10h
else
	call_video
endif
	xor	ax, ax			; finished
	ret
dv_off:
endif
	; Write directly to 6845 cursor address register.
	mov	bx, di
	shr	bx, 1			; convert word index to byte index

if MONO
	mov	dx, our_6845	; either mono or color card
else
	mov	dx, port_6845	; color card
endif
	mov	al,0eh		; more effective to write two bytes at a time
	mov	ah,bh
	out	dx,ax
	inc	al
	mov	ah,bl
	out	dx,ax


	; Return to DOS.
	xor	ax, ax			; No error, not busy.
	ret

pseudocursor:
	cmp	gcursor, 0	; graphics cursor off?
	jz	nopseudo
	mov	no_c_flag,0	; there is a cursor now!
	draw_gcursor
nopseudo:
	xor	ax, ax
	ret

	;---- handle control characters ----
	; Note: cur_x is not kept updated in memory, but can be
	; computed from max_x and dx.
	; Cur_y is kept updated in memory.
f_escapex:				; far jump
	jmp	f_escape

f_control:
	cmp	al, 27			; Is it an escape?
	jz	f_escapex
	cmp	al, 13			; carriage return?
	jz	f_cr
	cmp	al, 10			; line feed?
	jz	f_lf
	cmp	al, 8			; backspace?
	jz	f_bs
	cmp	al, 9			; tab?
	jz	f_tab
	cmp	al, 7			; bell
	jz	f_bell
	jmp	f_nctl			; then it is not a control char.

f_bell: ;----- Handle bell ----------------------
	; Use BIOS to do the beep.  DX is not changed, as bell is nonprinting.
	call	beep
	or	al, al			; clear z
	jmp	f_looploop		; Let main loop decrement cx.

f_bs:	;----- Handle backspace -----------------
	; Moves cursor back one space without erasing.	No wraparound.
	cmp	dl, cs:max_x		; wrap around to previous line?
	ja	fbs_wrap		; yep; disallow it.
	dec	di			; back up one char & attrib,
	dec	di
	inc	dx			; and note one more char left on line.
fbs_wrap:
	jmp	f_looploop

f_cr:	;----- Handle carriage return -----------
	; di -= cur_x<<1;		set di= address of start of line
	; dx=max_x+1;			set bx= chars left in line
	mov	al, cs:max_x
	inc	al
	sub	al, dl			; Get cur_x into ax.
	mov	ah, 0
	sub	di, ax
	sub	di, ax
	mov	dl, cs:max_x		; Full line ahead of us.
	inc	dx
	mov	ah, cs:cur_attrib	; restore current attribute
	or	al, 1			; clear z
	jmp	f_looploop		; and let main loop decrement cx

f_at_eol:
	;----- Handle overrunning right end of screen -------
	; cx++;				compensate for double loop
	; if (!wrap_flag) { dx++; di-=2; }
	; else do_crlf;
	inc	cx
	test	cs:wrap_flag, 1
	jnz	feol_wrap
		dec	di
		dec	di
		inc	dx
		jmp	f_looploop
feol_wrap:
	; dx=max_x+1;			set bx= chars left in line
	; di -= 2*(max_x+1);
	; do_lf
	mov	dl, cs:max_x
	inc	dx
	sub	di, dx
	sub	di, dx
	; fall thru to line feed routine

f_lf:	;----- Handle line feed -----------------
	; if (cur_y >= max_y) scroll;		scroll screen up if needed
	; else { cur_y++; di += max_x<<1;	else increment Y

	mov	al, cs:max_y
	cmp	cs:cur_y, al
	jb	flf_noscroll
		call	scroll_up		; preserves bx,cx,dx,si,di
		jmp	short flf_done
flf_noscroll:
	inc	cs:cur_y
	mov	al, cs:max_x
	mov	ah, 0
	inc	ax
	add	ax, ax
	add	di, ax
flf_done:
	mov	ah, cs:cur_attrib		; restore current attribute
	or	al, 1			; clear z
	jmp	f_looploop		; and let main loop decrement cx

f_tab:	;----- Handle tab expansion -------------
	; Get cur_x into al.
	mov	al, cs:max_x
	inc	al
	sub	al, dl
	; Calculate number of spaces to output.
	push	cx			; save cx
	mov	ch, 0
	mov	cl, al			; get zero based x coordinate
	and	cl, 7
	neg	cl
	add	cl, 8			; 0 -> 8, 1 -> 8, ... 7 -> 1
	sub	dx, cx			; update chars-to-eol, maybe set z
	pushf				; || save Z for main loop
	; ah is still current attribute.  Move CX spaces to the screen.
	mov	al, ' '
	cmp	cs:gmode_flag,0
	jg	f_tab_putc

	REP	STOSW
	popf				; || restore Z flag for main loop test
	pop	cx			; restore cx
	jmp	f_looploop		; Let main loop decrement cx.

;--------------- graphics mode support -----------------------

;---- Alternate main loop for graphics mode ----
f_g_cloop:
	LODSB				; get char! (al = ds:[si++])
	cmp	al, 28			; is it a control char?
	jb	f_g_control		;  maybe...
f_g_nctl:
	call	putchar
	dec	dx			; count down to end of line
	loopnz	f_g_cloop		; and go back for more.
	jz	f_at_eol		; at end of line; maybe do a crlf.
	jmp	f_loopdone

f_g_control:	jmp	f_control

; Tabs in graphic mode
f_tab_putc:	; graphics mode- call putc to put the char
	add	dx, cx			; move back to start of tab
f_tp_lp:
	call	putchar
	dec	dx			; go to next cursor position
	loop	f_tp_lp
	popf				; Z set if wrapped around EOL
	pop	cx
	jmp	f_looploop

;---- Where to go when a character turns out not to be special
f_nctl:
f_not_ansi:
	cmp	cs:gmode_flag,0
	jg	f_g_nctl
	jmp	f_t_nctl		; text mode

page
;---- putchar ------------------------------------------------
; Writes char AL, attribute AH to screen at (max_x+1-dl), cur_y.
; On entry, registers set up as per xy_to_regs.
; Preserves all registers.
putchar proc	near
	push	dx
	push	cx
	push	bx
	push	ax
	; 1. Set cursor position.
	mov	al, cs:max_x
	inc	al
	sub	al, dl
	mov	cs:cur_x, al
	mov	dx, cs:cur_coords	; get X & Y into DX
	push	ds
	mov	ax, 40h
	mov	ds, ax
	assume	ds:ABS40
	mov	cursor_posn,dx
	pop	ds
	assume	ds:nothing
	xor	bx, bx			; choose dpy page 0
	mov	ah, 2			; chose "Set Cursor Position"
if DOSV					; for Windowed command.com
	int	10h
else
	call_video
endif
	; 2. Write char & attribute.
IF quick_char
	pop	ax
	push	ax			; character and attribute
	call	quick_graph
ELSE
	mov	cx, 1
	pop	ax			; get char in AL
	push	ax
	mov	bl, ah			; attribute in BL
	mov	bh, 0
	mov	ah, 9
if DOSV					; for Windowed command.com
	int	10h
else
	call_video
endif
ENDIF
	pop	ax
	pop	bx
	pop	cx
	pop	dx
	ret
putchar endp
page
IF quick_char
quick_graph	proc	near
; this code has been reworked for much greater speed.

; ah= mode, al= char, ax,bx,cx,dx destroyed
	gmode_test yesQuick

	mov	bl,ah
	xor	bh,bh
	mov	cx, 1
	mov	ah, 9
if DOSV				; for Windowed command.com
	int	10h
else
	call_video		; do it the old way
endif
	ret

yesQuick:
	push	ds
	mov	bx, 40h
	mov	ds, bx
	assume	ds:ABS40		; address abs segment
	push	es
	push	bp
	push	si
	push	di			; save some registers
	push	ax			; save char and mode
	
	mov	ax, crt_cols
	mov	cx, ega_points		; pixel rows in character
	mov	bp, ax			; save number of columns=#bytes
	mul	byte ptr (cursor_posn+1)
	mul	cx			; (ignore upper product in DX)
	add	al, byte ptr (cursor_posn)	; y*#cols*#rows + x
	adc	ah, 0			; take care of carry
	mov	si, ax			; save address in si
	xor	ax, ax
	mov	es, ax			; absolute zero
	les	di, es: dword ptr (43h * 4)	; contents of vector 43h
	pop	ax
	push	ax			; get char and mode
	mul	cl			; offset to character in table
	add	di,ax			; di has character bit pattern start
	mov	ax, 0a000h		; address of display segment
	mov	ds, ax
	assume	ds:nothing

; to recap: cx=#rows, bp=#columns, ds:si=display address, es:di=character addr
	mov	dx, 3ceh
	mov	ax, 0a05h
	out	dx,ax			; set write mode 2, read mode 1

	mov	ax, 7			; set color dontcare register to zero
	out	dx,ax

	pop	bx			; character mode in bh
IF gbackground
	mov	bl,bh			; extract background color
IF cheap_pc
	shr	bl,1
	shr	bl,1
	shr	bl,1
	shr	bl,1
ELSE
	shr	bl,4
ENDIF
	or	bh, bh
	jns	overMode
	mov	ax, 1803h		; exor mode
	out	dx,ax

	and	bx, 0f07h		; xor=blink bit
ELSE
	or	bh, bh
	jns	overMode
	mov	ax, 1803h		; exor mode
	out	dx,ax

	and	bx, 7f00h		; mask off xor bit
ENDIF
	mov	al, 8			; bit mask register
	out	dx, al
	inc	dx
chLoop:
	mov	al, es:[di]		; get pixel pattern
	out	dx, al
	and	[si],bh			; update foreground
	not	al
	out	dx, al		     	; and background
	and	[si],bl
	inc	di
	add	si, bp			; go to next character byte and line
	loop	chLoop
	
joinret:
	dec	dx
	mov	ax, 0ff08h		; bit mask
	out	dx, ax
	mov	ax, 5			; mode register
	out	dx, ax
	mov	al, 3			; (ah is zero)
	out	dx, ax
	mov	ax, 0f07h
	out	dx, ax

	pop	di
	pop	si
	pop	bp
	pop	es
	pop	ds
	ret

overMode:
IF gbackground
	and	bx, 0f07h		; xor=blink bit
ELSE
	and	bx, 7f00h		; mask off xor bit
ENDIF
	mov	al, 8			; bit mask register
	out	dx, al
	inc	dx
	; we need to load the internal buffer with a solid
	; background. By writing a solid background and then
	; reading it back, we can do the job.
	mov	al, 0ffh		; force set background
	out	dx, al
	mov	[si], bl
	mov	al, [si]		; read reset pattern
chLoop2:
	mov	al, es:[di]		; get pixel pattern
	out	dx, al
	mov	[si],bh			; update foreground
	inc	di
	add	si, bp			; go to next character byte and line
	loop	chLoop2
	jmp	joinret

quick_graph endp
ENDIF


;--------------- end of graphics mode support --------------------

dosfn8	endp
page
;--- get_blank_attrib ------------------------------------------------
; Determine new attribute and character for a new blank region.
; Use current attribute, just disallow blink and underline.
; Returns result in AH, preserves all other registers.
get_blank_attrib	proc	near
IF gbackground
	cmp	cs:gmode_flag,0
	jle	get_attrib		; if alpha mode
	gmode_test get_attribg		; or good graphic mode, get attrib
	xor	ah,ah
	ret
get_attribg:
	mov	ah, cs:cur_attrib	; must do different technique
IF cheap_pc
	shr	ah,1			; color must be shifted into position
	shr	ah,1
	shr	ah,1
	shr	ah,1
ELSE
	shr	ah,4
ENDIF
	and	ah,07
	ret
get_attrib:
	mov	ah, cs:cur_attrib	; the attribute
;	and	ah, 7fh			;  but disallowing blink
IF MONO
	cmp	cs:video_mode, 7	; monochrome?
	jne	gb_aok
	cmp	ah, 7			; underline?
	jnz	gb_aok
	mov	ah, 7
gb_aok:
ENDIF
	ret
ELSE
	mov	ah, 0			; 0 is background if graphics mode
	cmp	cs:gmode_flag,0
	jg	gb_aok

	mov	ah, cs:cur_attrib
;	and	ah, 7fh			; disallow blink
IF MONO
	cmp	cs:video_mode, 7	; monochrome?
	jne	gb_aok
	cmp	ah, 7			; underline?
	jnz	gb_aok
	mov	ah, 7
ENDIF
gb_aok: ret
ENDIF
get_blank_attrib	endp

page
;---- scroll_up ---------------------------------------------------
; Scroll screen up- preserves ax, bx, cx, dx, si, di, ds, es.
; Moves screen up 1 line, fills the last line with blanks.
; Attribute of blanks is the current attribute sans blink and underline.

scroll_up	proc	near
		push_all
if BIOS_ONLY
if DOSV
		check_env
		or	ax, ax
		jz	fast_scroll
endif
		push	ds

		mov	ax, ABS40	; address low mem via ds
		mov	ds, ax
		assume	ds:ABS40

		call	get_blank_attrib
		mov	bh, ah
		mov	dh, byte ptr ega_rows
					; Get max rows of display
		mov	dl, byte ptr crt_cols
		dec	dl		; lower right in dx

		xor	cx, cx		; upper left of the screen
		mov	al, 1		; 1 line scroll
		mov	ah, 06h		; Scroll up

		call_video

		assume	ds:nothing
		pop	ds
		pop_all
		ret
fast_scroll:
endif
if DOSV OR (BIOS_ONLY EQ 0)

	cmp	cs:gmode_flag,0
	jz	scroll_char
if MONO
	jl	mono_scroll
endif
	jmp	scroll_graphic
scroll_char:
	push	es
	push	ds			; save all!
	mov	ax, ABS40		; address low mem via ds
	mov	ds, ax
if DESQVIEW
	mov	ax, cs:disppage
else
	mov	ax, 0b800h		; address display via es
endif
	mov	es, ax
	assume	ds:ABS40
	cmp	cs:fmode,0		; see if in fast mode
	jz	slow_scroll_up
	xor	ax,ax			; calc addresses
	mov	al, cs:max_x
	inc	ax
	mov	cx, ax			; save (word) count for fill
	mov	bx, ax			; and save byte count
	shl	bx, 1			; byte count
	mov	cs:temp_val, bx
	mul	cs:max_y		; address offset of last line (words)
	shl	ax, 1			; address offset in bytes
	mov	di, ax
	
	mov	ax, crt_start		; start of display
	add	ax, bx			; add line size in bytes
	add	di, ax			; di is now address of new last line
	cmp	di, 7fffh - 264		; is there room here?
	ja	no_room_here

	mov	crt_start, ax
	shr	ax, 1			; make into word offset
	mov	bx, ax			; and put into 6845
	mov	dx, port_6845
	mov	al, 0ch
	out	dx, ax
	inc	al
	mov	ah, bl
	out	dx, ax
	
	mov	ah, cs:cur_attrib
;	and	ah, 7fh			; disallow blink
	mov	al, 20h			; blank
	rep stosw			; clear line

	assume	ds:nothing
	pop	ds
	pop	es
	pop_all
	
	add	di, cs:temp_val
	ret

no_room_here:
	pop	ds			; restore registers
	pop	es
	pop_all
	call	move_back		; go to buffer start
	sub	di, cs:temp_val
	jmp	scroll_up		; try again

if MONO
mono_scroll:
	push	es
	push	ds			; save all!
	mov	ax, ABS40		; address low mem via ds
	mov	ds, ax
	mov	ax, 0b000h		; address display via es
	mov	es, ax
endif
slow_scroll_up:
	assume	ds:ABS40
	mov	di, crt_start		; offset of display (because of
					;   different page)
	mov	ds, ax			; ds is now display
	assume	ds:nothing
	xor	ax,ax			; calc addresses
	mov	al, cs:max_x
	inc	ax
	mov	bx, ax			; save (word) count
	shl	ax, 1			; byte count
	mov	si, ax			; start address is second line
	add	si, di			; adjust start address by any offset
	mov	ax, bx
	mul	cs:max_y		; number of words to move
	mov	cx, ax
	rep movsw			; move them!
	mov	cx, bx			; words to clear
      	mov	ah, cs:cur_attrib
;	and	ah, 7fh			; disallow blink
	mov	al, 20h			; blank
	rep stosw			; clear line
	pop	ds
	pop	es
	pop_all
	ret

scroll_graphic:
	
	gmode_test scrOurself
	mov	bh, 0
	mov	al, 1			; AL is number of lines to scroll.
	mov	ah, 6			; BIOS: scroll up
	xor	cx, cx
	mov	dl, cs:max_x		; lower-rite-x
	mov	dh, cs:max_y		; lower-rite-y (zero based)
	call_video			; call BIOS to scroll a rectangle.

scrret:
	pop_all
	ret

scrOurself:	; try scrolling screen ourself!
	push	es
	push	ds

	mov	dx, 3ceh		; set write mode 1
	mov	ax, 105h
	out	dx, ax

	mov	ax, 40h			; address abs40 segment
	mov	ds, ax
	assume	ds:ABS40
	mov	ax, crt_cols		; calculate length of line in bytes
	mul	byte ptr ega_points
	mov	si, ax			; source of move
	xor	dx,dx
	mov	dl, ega_rows
	mul	dx			; number of bytes to move
	mov	cx, ax
	mov	ax, si			; save bytes in line for later

	mov	bx, 0a000h		; address display
	mov	ds, bx
	mov	es, bx

	xor	di, di			; destination of move
	rep movsb			; scroll
	
	mov	cx, ax			; bytes in line = bytes to clear

	mov	dx, 3ceh
	mov	ax, 05h			; return to write mode 0
	out	dx, ax

IF gbackground
	mov	ah, cs:cur_attrib
IF cheap_pc
	shr	ah,1
	shr	ah,1
	shr	ah,1
	shr	ah,1
ELSE
	shr	ah,4
ENDIF
	and	ah,07			; background color
	mov	al,0
	out	dx,ax			; set color to write

	mov	ax,0f01h		; set mask
	out	dx,ax

	rep	stosb			; clear the line

	mov	ax,0001			; reset mask
	out	dx,ax
ELSE
	xor	ax, ax
	rep stosb			; clear the line
ENDIF

	pop	ds			; restore registers and return
	pop	es
	jmp	scrret
endif
scroll_up	endp


page
;-----move_back --------------------------------------------
; This routine moves the display to offset zero.
; alters:
; cs:temp_val = original crt_start value
; crt_start = 0
; controller reset properly
move_back proc near
	push	ds
	push	es
	push_all
	mov	ax, ABS40
	mov	ds, ax

	assume	ds:ABS40
	mov	al, ega_rows
	inc	al
	mul	byte ptr crt_cols	; words to move
	mov	cx, ax
	mov	si, crt_start
	mov	cs:temp_val, si		; save this value
	xor	di, di
	mov	crt_start, di
	mov	bx, cursor_posn		; y in bh, x in bl
	mov	al, byte ptr crt_cols
	mul	bh
	add	al, bl
	adc	ah, 0
	xchg	bx, ax			; save cursor position in bx
	
if DESQVIEW
	mov	ax, cs:disppage
else
	mov	ax, 0B800h
endif
	mov	es, ax
	mov	ds, ax

	mov	dx, cx
	add	dx, cx			; see if overlapping
	cmp	dx, si
	ja	slow_move
join_move:
	cld
	rep movsw			; move data
	
	mov	dx, port_6845
	mov	al, 0ch			; reset offset
	xor	ah,ah
	out	dx, ax
	inc	al
	out	dx, ax
	inc	al
	mov	ah, bh
	out	dx, ax
	inc	al
	mov	ah, bl
	out	dx, ax
	assume	ds:nothing
	pop_all
	pop	es
	pop	ds
	ret

slow_move:	; we gotta move to another spot first
	push	cx		; save length
	dec	dx		; length-2
	dec	dx
	add	si, dx		; point to end
	mov	di, 7FFEh	; safe location -- as safe as we can get
	std
	rep movsw		; move from far end in case of overlap
				; (may happen on large displays)
	mov	dx, port_6845
	mov	si, di		; source becomes destination
	inc	si		; take care of last decrement
	inc	si
	mov	cx, si
	shr	cx, 1		; word offset to start of new area
	mov	al, 0Ch		; display at this new location
	mov	ah, ch
	out	dx, ax
	inc	al
	mov	ah, cl
	out	dx, ax
	pop	cx		; reset all registers
	xor	di, di		; destination is zero
; The following four lines contributed by Bruce L. Hicks
	add	dx, 6
slow_wait:
	in	al, dx		; wait for retrace
	test	al, 08h
	jz	slow_wait
	jmp	join_move	; NOW move to destination
	
move_back	endp
page
if key_redef
;---- lookup -----------------------------------------------
; Called by getchar, peekchar, and key to see if a given key has
; been redefined.
; Sets AH to zero if AL is not zero (i.e. if AX is not a function key).
; Returns with Z cleared if no redefinition; otherwise,
; Z is set, SI points to redefinition string, CX is its length.
; Preseves AL, all but CX and SI.
; Redefinition table organization:
;  Strings are stored in reversed order, first char last.
;  The word following the string is the character to be replaced;
;  the next word is the length of the string sans header.
; param_end points to the last byte used by the parameter buffer;
; redef_end points to the last word used by the redef table.

lookup	proc	near
	mov	si, redef_end		; Start at end of table, move down.
	or	al, al
	jz	lu_lp
if ext_keybd
	cmp	ax, 224			; keyboard code (Alt 224)?
	jz 	lu_224
	cmp	al, 224			; extended code?
	jz	lu_lp
lu_224:
endif
	mov	ah, 0			; clear extraneous scan code
lu_lp:	cmp	si, param_end
	jbe	lu_notfound		; If below redef table, exit.
	mov	cx, [si]
	cmp	ax, [si-2]		; are you my mommy?
	jz	lu_gotit
	sub	si, 4
	sub	si, cx			; point to next header
	jmp	lu_lp
lu_notfound:
	or	si, si			; clear Z
	jmp	short lu_exit
lu_gotit:
	sub	si, 2
	sub	si, cx			; point to lowest char in memory
	cmp	al, al			; set Z
lu_exit:
	ret
lookup	endp
endif
page
;---- searchbuf --------------------------------------------
; Called by getchar and peekchar to see if any characters are
; waiting to be gotten from sources other than BIOS.
; Returns with Z set if no chars found, BX=keybuf & SI=keybuf.len otherwise.
searchbuf	proc	near
	; Search the stuffahead buffers.
if key_redef
	mov	cx, 4			; number of buffers to check for chars
else
	mov	cx, 3
endif
	mov	bx, offset fnkey - 4
sbloop: add	bx, 4			; point to next buffer record
	mov	si, [bx].len
	or	si, si			; empty?
	loopz	sbloop			; if so, loop.
	ret
searchbuf	endp
page
;---- getchar -----------------------------------------------
; Returns AL = next char.
; Trashes AX, BX, CX, BP, SI.
getchar proc	near
gc_searchbuf:
	; See if any chars are waiting in stuffahead buffers.
	call	searchbuf
	jz	gc_trykbd		; No chars?  Try the keyboard.
	; A nonempty buffer was found.
	dec	[bx].len
	dec	si
	mov	bp, [bx].adr		; get pointer to string
	mov	al, byte ptr ds:[bp][si]; get the char
	; Recognize function key sequences, move them to highest priority
	; queue.
	sub	si, 1			; set carry if si=0
	jc	gc_nofnkey		; no chars left -> nothing to protect.
	cmp	bx, offset fnkey
	jz	gc_nofnkey		; already highest priority -> done.
	or	al, al
	jnz	gc_nofnkey		; nonzero first byte -> not fnkey.
	; Found a function key; move it to highest priority queue.
	dec	[bx].len
	mov	ah, byte ptr ds:[bp][si]; gec	  [bx].len
	mov	ah, byte ptr ds:[bp][si]; get the second byte of fn key code
gc_fnkey:
	mov	fnkey.len, 1
	mov	fnkeybuf, ah		; save it.
gc_nofnkey:
	; Valid char in AL.  Return with it.
	ret

gc_trykbd:
	; Actually get a character from the keyboard.
if ext_keybd
	mov	ah, 10h
else
	mov	ah, 0
endif
	int	16h			; BIOS returns with char in AX
	; If it's Ctrl-break, it has already been taken care of.
	or	ax, ax
	jz	gc_trykbd

if key_redef
	; Look in the reassignment table to see if it needs translation.
	call	lookup			; Z=found; CX=length; SI=ptr
	jnz	gc_noredef
	; Okay; set up the reassignment, and run thru the translation code.
	mov	xlatseq.len, cx
	mov	xlatseq.adr, si
	jmp	gc_searchbuf
endif
gc_noredef:
	; Is it a function key?
	cmp	al, 0
	jz	gc_fnkey		; yep- special treatment.
if ext_keybd
	cmp	al, 224			; check for extended special
	jnz	gcdone
	cmp	ax, 224			; alt-224?
	jz	gcdone
	xor	al, al			; if so, make it normal special
	jmp	gc_fnkey
endif
gcdone: ret	; with character in AL.
getchar endp
page
;---- peekchar -----------------------------------------------
; Returns Z if no character ready, AL=char otherwise.
; Trashes AX, BX, CX, BP, SI.
peekchar	proc	near
	call	searchbuf
	jz	pc_trykbd		; No chars?  Try the keyboard.
	; A nonempty buffer was found.
	dec	si
	mov	bp, [bx].adr		; get pointer to string
	mov	al, byte ptr ds:[bp][si]; get the char
	; Valid char from buffer in AL.	 Return with it.
	jmp	short pcdone
pc_trykbd:
	; Actually peek at the keyboard.
if ext_keybd
	mov	ah, 11h
else
	mov	ah, 1
endif
	int	16h			; BIOS returns with char in AX
	jz	pcexit
	; If it's control-break, it's already been taken care of.
	or	ax, ax
	jnz	pc_notbrk
if ext_keybd
	mov	ah, 10h
else
	mov	ah, 0
endif
	int	16h			; so get rid of it!
	jmp	short pc_trykbd
pc_notbrk:
if key_redef
	; Look in the reassignment table to see if it needs translation.
	call	lookup			; Z=found; CX=length; SI=ptr
	jnz	pcdone			; Nope; just return the char.
	; Okay; get the first code to be returned.
	add	si, cx
	mov	al, [si-1]
endif
pcdone: or	ah, 1			; NZ; char ready!
pcexit: ret	; with character in AL, Z true if no char waiting.
peekchar	endp
page
;----- set_gmode ------------------------------------------------
; Set gmode_flag based on mode byte in register al
set_gmode proc  near
if MONO
	cmp	al, 7			; mono?
	je	gmode_mono
	gmode_code
	ret
gmode_mono:
	neg	al
	mov	cs:gmode_flag, al	; set gmode_flag to neg value
	ret
else
	gmode_code			; a macro in nnansi_d.asm
	ret
endif
set_gmode	endp


;---- beep ------------------------------------------------------
; Beep speaker; period given by beep_div, duration by beep_len.
; Preserves all registers.

beep_div	equ	1300		; fairly close to IBM beep
beep_len	equ	3		; 3/18 sec- shorter than IBM

beep	proc	near
	push_all

	mov	al, 10110110b		; select 8253
	mov	dx, 43h			; control port address
	out	dx, al
	dec	dx			; timer 2 address
	mov	ax, beep_div
	jmp	$+2
	out	dx, al			; low byte of divisor
	xchg	ah, al
	jmp	$+2
	out	dx, al			; high byte of divisor
	mov	dx, 61h
	jmp	$+2
	in	al, dx			; get current value of control bits
	push	ax
	or	al, 3
	jmp	$+2
	out	dx, al			; turn speaker on

	; Wait for desired duration by monitoring time-of-day 18 Hz clock
	push	es
	mov	ax, ABS40
	mov	es, ax
	assume	es:ABS40
	mov	bx, timer_low
	mov	cx, -1
beeplp: mov	ax, timer_low
	sub	ax, bx
	cmp	ax, 	beep_len
	jg	beepover
	loop	beeplp
beepover:
	pop	es
	assume	es:CODE

	; Turn off speaker
	pop	ax
	and	al, not 3		; turn speaker off
	out	dx, al
	pop_all
	ret
	assume	es:nothing
beep	endp

	page
; A state machine implementation of the mechanics of ANSI terminal control
; string parsing.
;
; Entered with a jump to f_escape when driver finds an escape, or
; to f_in_escape when the last string written to this device ended in the
; middle of an escape sequence.
;
; Exits by jumping to f_ANSI_exit when an escape sequence ends, or
; to f_not_ANSI when a bad escape sequence is found, or (after saving state)
; to f_loopdone when the write ends in the middle of an escape sequence.
;
; Parameters are stored as bytes in param_buffer.  If a parameter is
; omitted, it is stored as zero.  Each character in a keyboard reassignment
; command counts as one parameter.
;
; When a complete escape sequence has been parsed, the address of the
; ANSI routine to call is found in ansi_fn_table.
;
; Register usage during parsing:
;  DS:SI points to the incoming string.
;  CX holds the length remaining in the incoming string.
;  ES:DI points to the current location on the memory-mapped screen.
;  DX is number of characters remaining on the current screen line.
;  BX points to the current paramter byte being assembled from the incoming
;  string.  (Stored in cur_parm_ptr between device driver calls, if needed.)
;
; The registers are set as follows before calling the ANSI subroutine:
;  AX = max(1, value of first parameter)
;  CX = number of paramters
;  SI = offset of second parameter from CS
;  DS = CS
;  ES:DI points to the current location on the memory-mapped screen.
;  DX is number of characters remaining on the current screen line.
; The subroutine is free to trash AX, BX, CX, SI, and DS.
; It must preserve ES, and can alter DX and DI if it wants to move the
; cursor.
;
;------------------------------------------------------------------------

	assume	cs:code, ds:code

;----- next_is -------------------------------------------------------
; Next_is is used to advance to the next state.	 If there are characters
; left in the input string, we jump immediately to the new state;
; otherwise, we shut down the recognizer, and wait for the next call
; to the device driver.
next_is macro	statename
	loop	statename
	mov	ax, offset statename
	jmp	sleep
	endm

;----- f_in_escape ---------------------------------------------------
; Main loop noticed that escvector was not zero.
; Recall value of BX saved when sleep was jumped to, and jump into parser.
f_in_escape:
	mov	bx, cs:cur_parm_ptr
	jmp	word ptr cs:escvector

fbr_syntax_error_gate:		; jumped to from inside f_bracket
	jmp	syntax_error

;----- sleep --------------------------------------------------------
; Remember bx and next state, then jump to device driver exit routine.
; Device driver will re-enter at f_in_escape upon next invocation
; because escvector is nonzero; parsing will then be resumed.
sleep:	mov	cs:cur_parm_ptr, bx
	mov	cs:escvector, ax
	jmp	f_loopdone

;----- f_escape ------------------------------------------------------
; We found an escape.  Next character should be a left bracket.
f_escape:
	next_is f_bracket

;----- f_bracket -----------------------------------------------------
; Last char was an escape.  This one should be a [; if not, print it.
; Next char should begin a parameter string.
f_bracket:
	lodsb
	cmp	al, '['
	jnz	fbr_syntax_error_gate
	; Set up for getting a parameter string.
	mov	bx, cs:param_buffer
	xor	al,al			; zero
	mov	byte ptr cs:[bx], al	; default first char
	dec	bx			; point buffer before start
	mov	cs:eat_key, al		; no eaten key
	next_is f_get_args

;----- f_get_args ---------------------------------------------------
; Last char was a [.  If the current char is a '=' or a '?', save
; it for SET/RESET MODE, and then proceed to f_get_param.
f_get_args:
	lodsb
	cmp	al, '='
	je	fga_ignore
	cmp	al, '?'
	jne	f_get_param2
fga_ignore:
	mov	cs:eat_key, al		; save = or ?
	next_is f_get_param

;----- f_get_param ---------------------------------------------------
; Last char was one of the four characters "]?=;".
; We are getting the first digit of a parameter, a quoted string,
; a ;, or a command.
f_get_param:
	lodsb
f_get_param2:	; jump to here if no fetch of character
	cmp	al, '0'
	jb	fgp_may_quote
	cmp	al, '9'
	ja	fgp_may_quote
		cmp	bx, cs:param_end	; if bx <param_end bx++
		adc	bx, 0
		; It's the first digit.	 Initialize parameter with it.
		sub	al, '0'
		mov	byte ptr cs:[bx], al
		next_is f_in_param
fgp_may_quote:
	cmp	al, '"'
	je	fgp_isquote
	cmp	al, "'"
	jne	fgp_semi_or_cmd		; jump to code shared with f_in_param
fgp_isquote:
	mov	cs:string_term, al	; save it for end of string
	next_is f_get_string		; and read string into param_buffer

fgp_semi_or_cmd:
	cmp	al, ';'			; is it a semi?
	jnz	fgp_cmd			; no, then it's a command
	xor	ax, ax			; zero
	cmp	bx, cs:param_end	; if bx < param_end bx++
	adc	bx, ax
	mov	byte ptr cs:[bx], al	; it is a zero parameter
f_goto_next:
	next_is	f_get_param

;----- f_get_string -------------------------------------
; Last character was a quote or a string element.
; Get characters until ending quote found.
f_get_string:
	lodsb
	cmp	al, cs:string_term
	je	fgs_init_next_param
	cmp	bx, cs:param_end
	adc	bx, 0			; if bx<param_end bx++;
	mov	byte ptr cs:[bx], al
	next_is f_get_string
; Ending quote was found.
fgs_init_next_param:
	next_is f_eat_semi

;----- f_eat_semi -------------------------------------
; Last character was an ending quote.
; If this char is a semi, eat it
; Then goto f_get_param
f_eat_semi:
	lodsb
	cmp	al, ';'
	jnz	f_get_param2
	jmp	f_goto_next

;----- syntax_error ---------------------------------------
; A character was rejected by the state machine.  Exit to
; main loop, and print offending character.  Let main loop
; decrement CX (length of input string).
syntax_error:
	mov	cs:escvector, 0
	mov	ah, cs:cur_attrib
	jmp	f_not_ANSI	; exit, print offending char

;------ f_in_param -------------------------------------
; Last character was a digit.
; Looking for more digits, a semicolon, or a command character.
f_in_param:
	lodsb
	cmp	al, '0'
	jb	fgp_not_digit
	cmp	al, '9'
	ja	fgp_not_digit
		; It's another digit.  Add into current parameter.
		sub	al, '0'
		xchg	byte ptr cs:[bx], al
		push	dx
		mov	dl, 10
		mul	dl
		pop	dx
		add	byte ptr cs:[bx], al
		next_is f_in_param
fgp_not_digit:
	cmp	al, ';'
	je	f_goto_next
fgp_cmd:
	; It must be a command letter.
	cmp	al, '@'
	jb	syntax_error
	cmp	al, 'z'
	ja	syntax_error
	cmp	al, 'Z'
	jbe	fgp_is_cmd
	cmp	al, 'a'
	jb	syntax_error
		; It's a lower-case command letter.
		; Remove hole between Z and a to save space in table.
		sub	al, 'a'-'['
fgp_is_cmd:
	; It's a command letter.  Save registers, convert letter
	; into address of routine, set up new register usage, call routine.
	push	si			; These three registers hold info
	push	cx			; having to do with the input string,
	push	ds			; which has no interest at all to the
					; control routine.

	push	cs
	pop	ds			; ds is now cs

	cbw
	add	ax, ax			; table offset

	mov	cx, bx
	mov	si, param_buffer	; si is now pointer to parameters
	sub	cx, si			
	inc	cx			; cx is now # of parameters
	xchg	ax, bx			; save pointer to routine in bx

	; Calculate cur_x from DX.
	mov	al, max_x
	inc	ax
	sub	al, dl
	mov	cur_x, al

	; Get first parameter into AX; if defaulted, set it to 1.
	xor	ax, ax
	lodsb
	cmp	cx, 1		; no args?
	adc	al, ah		; if cx=0, then ax=1
	; Finally, call the command subroutine.
	call	word ptr (ansi_fn_table-2*'@') [bx]

	pop	ds
	pop	cx
	pop	si

	mov	ah, cs:cur_attrib	; Prepare for STOSW.
	mov	cs:escvector, 0		; No longer parsing escape sequence.
	; Set flags for reentry at loopnz
	or	dx, dx			; "Any columns left on line?"
	; Re-enter at bottom of main loop.
	jmp	f_ANSI_exit

	page
; The ANSI control subroutines.

; Each routine is called with the following register usage:
;  AX = max(1, value of first parameter)
;  Z flag is set if first parameter is zero.
;  CX = number of paramters
;  SI = offset of second parameter from CS
;  DS = CS
;  ES:DI points to the current location on the memory-mapped screen.
;  DX is number of characters remaining on the current screen line.
; The control routine is free to trash AX, BX, CX, SI, and DS.
; It must preserve ES, and can alter DX and DI if it wants to move the
; cursor.

;----------------------------------------------------------------

	assume	cs:code, ds:code

;----- byteout ---------------------------------------------------
; Converts al to a decimal ASCII string (in 0..99),
; stores it at ES:DI++.	 Returns DI pointing at byte after last digit.
; Destroys DL.

byteout proc	near
	cmp	al, 100		; check for >99 case -- TAA mod
	jb	goodbyteout
	push	ax
	mov	al, '1'		; assume value <200!
	stosb
	pop	ax
	sub	ax, 100
goodbyteout:
	aam
	add	ax, 3030h
	xchg	ah, al
	stosb
	xchg	ah, al
	stosb
	ret
byteout endp

;----- ansi_fn_table -----------------------------------
; Table of offsets of terminal control subroutines in order of
; the character that invokes them, @..Z, a..z.	Exactly 53 entries.
; All the subroutines are defined below in this module.
ansi_fn_table	label	word
if DOSV
	dw	nul, cup, cdn, cfw, cbk		; @, A, B, C, D
else
	dw	ic,  cup, cdn, cfw, cbk		; @, A, B, C, D
endif
	dw	nul, nul, nul, hvp, nul		; E, F, G, H, I
	dw	eid, eil, il,  d_l, nul		; J, K, L, M, N
if DOSV
	dw	nul, nul, nul, nul, nul		; O, P, Q, R, S
else
	dw	nul, dc,  nul, nul, nul		; O, P, Q, R, S
endif
	dw	nul, nul, nul, nul, nul		; T, U, V, W, X
	dw	nul, nul			; Y, Z
	dw	nul, nul, nul, nul, nul		; a, b, c, d, e
	dw	hvp, nul, sm,  nul, nul		; f, g, h, i, j
	dw	nul, rm,  sgr, dsr, nul		; k, l, m, n, o
if key_redef
	dw	key, nul, nul, scp, nul		; p, q, r, s, t
else
	dw	nul, nul, nul, scp, nul		; p, q, r, s, t
endif
	dw	rcp, nul, nul, nul, nul		; u, v, w, x, y
	dw	nul				; z

ansi_functions	proc	near		; set return type to NEAR


;----- Cursor Motion -----------------------------------------------

;-- cursor to y,x
hvp:	dec	ax		; Convert Y to zero-based coordinates.
	mov	cur_y, al
	; Get second parameter, if it is there, and set X with it.
	xor	ax, ax
	cmp	cx, 2		; was there a second parameter?
	jb	hvp_xok
	lodsb			; yes.
	or	al, al
	jz	hvp_xok
	dec	ax		; convert to zero-based coordinates.
hvp_xok:mov	cur_x, al

	; Clip to maximum coordinates.
hvp_set:
	mov	ax, cur_coords		; al = x, ah = y
	cmp	al, max_x
	jbe	hvp_sxok
	mov	al, max_x
	mov	cur_x, al
hvp_sxok:
	cmp	ah, max_y
	jbe	hvp_syok
	mov	al, max_y
	mov	cur_y, al
hvp_syok:
	; Set values of DX and DI accordingly.
	call	xy_to_regs
	ret

;-- cursor forward --
cfw:	add	cur_x, al
	jmp	hvp_set

;-- cursor back -----
cbk:	sub	cur_x, al
	jae	hvp_set
	mov	cur_x, 0
	jmp	hvp_set

;-- cursor down -----
cdn:	add	cur_y, al
	jmp	hvp_set

;-- cursor up -------
cup:	sub	cur_y, al
	jae	hvp_set
	mov	cur_y, 0
	jmp	hvp_set

;-- save cursor position --------------------------------------
scp:	mov	ax, cur_coords
	mov	saved_coords, ax
	ret

;-- restore cursor position -----------------------------------
rcp:	mov	ax, saved_coords
	mov	cur_coords, ax
	jmp	hvp_set		; Clip in case we have switched video modes.

;-- set graphics rendition ------------------------------------
; Modifies the color in which new characters are written.


sgr:	dec	si		; get back pointer to first parameter
	or	cx, cx		; Did he give any parameters?
	jnz	sgr_loop
	mov	byte ptr [si], 0	; no parameters, so fake
	inc	cx			; one with the default value.
	; For each parameter
sgr_loop:
	lodsb				; al = next parameter
	; Search color table
	push	cx

	cmp	al, 0			; not reset?
	jnz	sgr_continue
	mov	color_flag, 7		; finish up normally
sgr_continue:
	mov	cx, colors
	mov	bx, offset color_table-3
sgr_search:
	add	bx, 3
	cmp	al, byte ptr [bx]
	loopnz	sgr_search	; until match found or done
	jnz	sgr_loopx

	; If parameter named a known color, set the current
	; color variable.
	cmp	al, 30
	jge	sgr_color
	mov	ax, [bx+1]
	and	atr_flag, al
	or	atr_flag, ah
	jmp	short sgr_loopx
sgr_color:
	mov	ax, [bx+1]
	and	color_flag, al
	or	color_flag, ah
sgr_loopx:
	pop	cx
	loop	sgr_loop		; until no more parameters.

	mov	al, color_flag
	mov	ah, atr_flag
	test	ah, 4			; invisible
	jz	sgr_notinv
	mov	ah, al			; then fade to background
if cheap_pc
	ror	al,1			; swap nibbles
	ror	al,1
	ror	al,1
	ror	al,1
else
	ror	al,4
endif
	and	ax, 7007h
	or	al, ah
	jmp	short sgr_done
sgr_notinv:
	test	ah, 2			; reverse?
	jz	sgr_notrev
if cheap_pc
	ror	al,1			; swap nibbles
	ror	al,1
	ror	al,1
	ror	al,1
else
	ror	al,4
endif
sgr_notrev:
	test	ah, 1			; underline?
	jz	sgr_notund
	cmp	gmode_flag, 0		; monochrome display?
	jl	sgr_mono_und
	and	al, 0f0h
	or	al, 1			; blue chars on color display
	jmp	short sgr_notund
	
sgr_mono_und:
	cmp	al, 7			; can only underline if white on black
	jne	sgr_notund
	mov	al, 1
sgr_notund:
	and	ah, 88h			; get bold and blink attributes
	or	al, ah			; and  merge them in
sgr_done:
	mov	cur_attrib, al		; save the new attribute
;	ret	

;----- nul ---------------------------------------------
; No-action ansi sequence; called when unknown command given.
nul:	ret


;-- erase in line ----------------------------------------
; Uses BIOS to scroll away a one-line rectangle
eil:	push	dx
	mov	cx, cur_coords
	mov	dh, ch
	jmp	short scrollem

;-- erase in display -------------------------------------
; Uses BIOS to scroll away all of display
eid:	
	or	cx,cx		; no args?
	jz	eid_toend	;  then erase to end
	cmp	byte ptr -1[si], 0
	je	eid_toend	; first parms=0 -- erase to end
	cmp	al, 1		; erase to beginning?
	je	eid_tostart
	cmp	al, 2
	jne	eid_ignore	; param must be two
	mov	cur_coords, 0
	call	xy_to_regs
	cmp	fmode,0		; see if running in fast mode
	je	eid_slow
	xor	di, di		; reset pointer to start
eid_slow:
	push	dx
	xor	cx, cx
	mov	dh, max_y
scrollem:
	call	get_blank_attrib
	mov	bh, ah
	mov	dl, max_x
eid_process:
	mov	ax, 600h
	int	10h		; don't do call-video here
eid_done:
	pop	dx
eid_ignore:
	ret

eid_toend:	; erase following lines then go back and erase in line
	push	dx
	call	get_blank_attrib
	mov	bh,ah
	mov	ax, 600h
	mov	dh, max_y
	mov	dl, max_x
	mov	ch, cur_y
	inc	ch
	cmp	ch, dh			; don't erase if no following
	ja	eid_nopost
	xor	cl,cl
if BAD_ERASE
	int 	10h
else
	call_video
endif
eid_nopost:
	mov	cx, cur_coords
	mov	dh, ch
	jmp	short scrollem


eid_tostart:	; erase preceeding lines then go back and erase in line
	push	dx
	call	get_blank_attrib
	mov	bh,ah
	mov	dh, cur_y
	dec	dh
	js	eid_nopre		; don't erase if no preceeding
	mov	ax,600h
	xor	cx,cx
	mov	dl, max_x
if BAD_ERASE
	int	10h
else
	call_video
endif
eid_nopre:
	mov	dx, cur_coords
	dec	dl
	js	eid_done
	mov	ch, dh
	xor	cl, cl
	jmp	eid_process
	
;-- device status report --------------------------------
; Stuffs an escape, a left bracket, current Y, semicolon, current X,
; a capital R, and a carriage return into input stream.
; The coordinates are 1 to 3 decimal digits each.

dsr:	push	di
	push	dx
	push	es
	mov	ax, cs
	mov	es, ax
	std			; Store string in reversed order for fun
	mov	di, offset cpr_esc - 2
	mov	al, cur_y
	inc	al		; convert to one-based coords
	call	byteout		; row
	mov	al, ';'		; ;
	stosb
	mov	al, cur_x
	inc	al		; convert to one-based coords
	call	byteout		; column
	mov	al, 'R'		; R ANSI function 'Cursor Position Report'
	stosb
	mov	al, 13
	mov	word ptr cprseq.adr, di ; save pointer to last char in string
	stosb				; send a carriage return, too
	mov	ax, offset cpr_esc
	sub	ax, di			; ax is # of characters in string
	mov	word ptr cprseq.len, ax ; pass info to the getchar routine
	cld
	pop	es
	pop	dx
	pop	di
	ret
if key_redef
;-- keyboard reassignment -------------------------------
; Key reassignment buffer is between param_end and redef_end+2, exclusive.
; When it shrinks or grows, param_end is moved.
; Format of an entry is as follows:
;   highest address -> length:word (may be 0)
;		       key to replace:word     (either hi or low byte is zero)
;			   .
;			   .	new key value, "length" bytes long
;			   .
;   lowest address  -> next entry, or free space.
; If no arguments are given, keyboard is reset to default condition.
; Otherwise, first parameter (or first two, if first is 0 or 224) defines
; the key whose value is to be changed, and the following parameters
; define the key's new, possibly zero-length, value.

key:
	; Is this a reset?
	or	cx, cx
	jz	key_init
	; Get the first (or first two) parameters
	cld
	dec	si	; point to first param
	dec	cx	; Assume it's a fn key, get two params
	dec	cx
	lodsw
	or	al, al	; Is it a function key?
	jz	key_fnkey
if ext_keybd
	cmp	al, 224	; check for extended key
	je	key_fnkey	; yes -- extended function key
; Note -- ALT 224 cannot be redefined since it would cause ambiguities.
endif
		; It's not a function key- put second param back
		inc	cx
		dec	si
key_fnkey:
	; Key to redefine now in AX.  If it's already redefined,
	; lookup will set Z, point SI to redef string, set CX to its length.
	push	di
	push	es
	push	cx
	push	si

	std			; moving up, must move from top down
	push	ds
	pop	es		; string move must have ES=DS
	call	lookup		; rets Z if redefined...
	jnz	key_newkey
	; It's already defined.	 Erase its old definition- i.e., move
	; region param_end+1..SI-1 upwards CX+4 bytes, add CX+4 to param_end.
	add	cx, 4
	mov	bp, param_end	; save old value in bp...
	add	param_end, cx
	dec	si		; start at (SI-1)
	mov	di, si
	add	di, cx		; move to (start + CX+4)
	mov	cx, si
	sub	cx, bp		; length of region old_param_end+1..start
	rep	movsb
key_newkey:
	; Key not redefined.  See if there's enough room to redefine it.
	pop	si		; get back pointer to redef string
	pop	cx		; get back number of bytes in redef string
; The following four lines represent a bug fix provided by Chaim Frenkel,
; chaim@nlk.com
;	cmp	cx,1
;	jle	key_noadjust
;	dec	cx
;key_noadjust:
	mov	di, param_end	; hi byte of new redef record, hi byte of len
	sub	di, 4		; hi byte of new data field
	mov	bx, di
	sub	bx, cx		; hi byte of remaining buffer space
	sub	bx, 16		; better be at least 16 bytes room
	cmp	bx, param_buffer
	jb	key_popem	; nope- forget it.
	; Nothing in the way now!
	mov	[di+3], cx	; save length field
	mov	[di+1], ax	; save name field
	jcxz	key_nullstring
key_saveloop:			; save data field
	movsb
	add	si, 2		; input string ascending, output descending
	loop	key_saveloop
key_nullstring:
	mov	param_end, di	; save adr of new hi byte of free area
key_popem:
	pop	es
	pop	di

key_exit:
	cld
	ret

key_init:
	; Build the default redefinition table:
	;	control-printscreen -> control-P
	push	es
	push	ds
	pop	es
	cld			; rewritten routine courtesy of
				; mccreary@ucsu.colorado.edu
	mov	di, param_buffer
	add	di, buf_size
	mov	param_end, di
	inc	di
	mov	al, 16		; control p
	stosb
	mov	ax, 7200h	; control-printscreen
	stosw
	mov	ax, 1
	mov	redef_end, di
	stosw
	pop	es
	jmp	key_exit
endif


;---- Delete/Insert Lines -------------------------------
; AL is number of lines to delete/insert.
; Preserves DX, DI; does not move cursor.

d_l:	; Delete lines.
	mov	ah, 6			; BIOS: scroll up
	jmp	short il_open

il:	; Insert lines.
	mov	ah, 7			; BIOS: scroll down

il_open:
	; Whether inserting or deleting, limit him to (max_y - cur_y) lines;
	; if above that, we're just clearing; set AL=0 so BIOS doesn't burp.
	mov	bh, max_y
	sub	bh, cur_y
	cmp	al, bh
	jbe	il_ok			; DRK 9/4...
		mov	al, 0		; he tried to move too far
il_ok:
	push	ax
	call	get_blank_attrib
	mov	bh, ah			; color to use on new blank areas
	pop	ax			; AL is number of lines to scroll.

	mov	cl, 0			; upper-left-x of data to scroll
	mov	ch, cur_y		; upper-left-y of data to scroll
	push	dx
	mov	dl, max_x		; lower-rite-x
	mov	dh, max_y		; lower-rite-y (zero based)
if BAD_ERASE
	int	10h
else
	call_video			; call BIOS to scroll a rectangle.
endif
	pop	dx
	ret				; done.

;-- Insert / Delete Characters ----------------------------
; AL is number of characters to insert or delete.
; Preserves DX, DI; does not move cursor.

ic:	mov	ch, 1			; 1 => swap dest & source below
	jmp	short dc_ch

dc:	mov	ch, 0

dc_ch:
	cmp	cs:gmode_flag,0
	jg	dc_ret			; | if in graphics mode, ignore.


	; AL = number of chars to ins or del (guarenteed nonzero).
	; Limit him to # of chars left on line.
	cmp	al, dl
	jbe	dc_cok
		mov	al, dl
dc_cok:
	push	di			; DI is current address of cursor
	xchg	ax, cx			; CX gets # of chars to ins/del
	mov	bp, cx			; BP gets # of columns to clear.

	; Set up source = destination + cx*2, count = dx - cx
	mov	ch, 0			; make it a word
	mov	si, di
	add	si, cx
	add	si, cx
	neg	cl
	add	cl, dl
	mov	ch, 0			; CX = # of words to transfer
	cld				; REP increments si & di

	; If this is an insert, then flip transfer around in both ways.
	test	ah, 1
	jz	dc_noswap
		xchg	di, si		; source <-> dest
		std			; up <-> down
		mov	ax, cx		; make move over same range
		dec	ax
		add	ax, ax		; AX=dist from 1st to last byte.
		add	di, ax		; Start transfer at high end of block
		add	si, ax		;  instead of low end.
dc_noswap:
	; Move those characters.
	push	es
	pop	ds
	rep	movsw
	mov	cx, bp
	; Figure out what color to make the new blanks.
	call	get_blank_attrib
	mov	al, ' '
	; Blank out vacated region.
	rep	stosw

	; All done.
	cld				; restore normal REP state and
	pop	di			;  cursor address.
dc_ret: ret


;---- set / reset mode ---------------------------------------
; Sets graphics/text mode; also sets/resets "no wrap at eol" mode.
; also set/reset graphic cursor mode
rm:	mov	cl, 0		; reset
	jmp	short sm_rs

sm:	mov	cl, 0ffh	; set
sm_rs:
	; Is it "wrap at eol" ?
	cmp	al, 7
	jnz	sm_notwrap
	mov	wrap_flag, cl	; true = wrap at EOL
	ret
sm_notwrap:
; We will make this smarter by requiring the correct lead character,
; except for wrap at eol, which has been badly documented in the MSDOS
; manuals.
	cmp	eat_key, '='	; set mode -- display mode
	jz	sm_notbios
	cmp	eat_key, '?'	; set mode of togglable attribute?
	jnz	sm_done
	; Is it set/reset graphic cursor mode?
	cmp	al,99
	jnz	sm_notgcursor
	mov	gcursor, cl
	ret
sm_notgcursor:
	; Is it set/reset fast mode?
	cmp	al,98
	jnz	sm_notspeedy
if DESQVIEW
	cmp	dvactive, 0	; desqview active?
	jne	sm_done		; then do nothing
endif
	mov	fmode, cl
	or	cl,cl		; mode now fast?	(was cmp cl,0)
	jnz	sm_done
	call	move_back
sm_done:	ret
sm_notspeedy:
	; Is it set/reset bios write?
	cmp	al,97
	jnz	sm_done
if bios_write_tty
		mov	bmode, cl
endif
		ret
sm_notbios:
	; we can now do 43 lines on a VGA display, if desired, as well as 50.
	; of course an EGA display will only do 43.
IF MONO
	cmp	video_mode, 7		; mono mode?
	je	sm_done
ENDIF	
IF VGA
	cmp	al, 43
	je	is43or50
	cmp	al, 50
	jne	sm_video		; set to whatever it happens to be
is43or50:
	dec	al
	cmp	al, max_y
	je	sm_done			; no change in # lines
	cmp	video_mode, 3		; display mode > 3?
	ja	sm_done
	cmp	al, 49			; 50 line mode?
	mov	ax, 1201H		; set 350 lines on EGA
	jne	sm_is43
	mov	ax, 1202h		; select 400 scan lines
sm_is43:
	mov	bl,30h			; this call ignored on EGA
	call_video
		
ELSE
	cmp	al, 43
	jne	sm_video		; set to whatever it happens to be

	cmp	max_y, 42		; no change in # lines?
	je	sm_done
	cmp	video_mode, 3		; must be currently mode <= 3
	ja	sm_done
ENDIF
	mov	ah,0
	mov	al, video_mode		; select the video mode.
	call_video
		
	mov	ax,1112h		; Load 8x8 font
	mov	bl,0			; (instead of 8x14 or 8x16)
	call_video

	mov	ax, 1200h		; Load new printscreen
	mov	bl, 20h
	call_video

IF EGA	; set the EGA cursor
	mov	dx, port_6845		; '6845' command reg
	mov	ax, 070ah		; start on line 7
	out	dx, ax
	mov	al, 0bh			; end on line 7
	out	dx, ax
ENDIF
	jmp	short sm_home


sm_video:
	; It must be a video mode.  Call BIOS.
	; Save graphics mode flag
IF VGA
	cmp	al, 3		; On VGA, modes 0-3, set 400 scan lines
	ja	no_scan_change
	push	ax
	mov	ax, 1202h		; select 400 scan lines
	mov	bl,30h			; this call ignored on EGA
	call_video
	pop	ax
no_scan_change:
ENDIF	
IF VESA
	cmp	al, 80h		; not a vesa mode?
	jb	normal_mode
	xor	bx, bx
	mov	bl, al
	add	bx, 8080h	; set msb and put mode in range
	mov	ax, 4f02h
	int	10h		; can't use call_video, because often
				; VESA compatibility driver is used and
				; loaded after us.
	jmp	short sm_home
normal_mode:	
ENDIF	
	mov	ah, 0		; "set video mode"
;	or	al, 80h		;  but don't erase screen, since colors wrong.
	call_video
sm_home:
	; Read the BIOS buffer address/cursor position variables.
	mov	ax, ABS40
	push	ds
	mov	ds, ax
	assume	ds:ABS40

	; Find current video mode and screen size.
	mov	ax,word ptr crt_mode	; al = crt mode; ah = # of columns
	mov	cl, ega_rows		; cl = max row
	pop	ds
	assume	ds:code
	call	set_gmode		; set gmode based on video mode
	mov	video_mode, al
	dec	ah			; ah = max column
	mov	max_x, ah
	mov	max_y, cl

	; Since cursor may end up in illegal position, it's best to
	; just go home after switching video modes.
	mov	cur_coords, 0
	call	xy_to_regs

	jmp	eid_slow		; then clear the screen

ansi_functions	endp	; end dummy procedure block



;-------- Color table -----------------------------------------
; Used in "set graphics rendition"

colors	equ	28			; number of colors in table

color_table:
; The first set attributes rather than colors
	db	0, 000h,00h		; all attribs off; normal.
	db	1, 0ffh,08h		; bold
	db	2, 0f7h,00h		; dim (not bold)
	db	4, 0ffh,01h		; underline
	db	5, 0ffh,80h		; blink
	db	7, 0ffh,02h		; reverse
	db	8, 0ffh,04h		; invisible
	
	db	22,0f7h,00h		; un-bold, un-dim
	db	24,0feh,00h		; un-underline
	db	25,07fh,00h		; un-blink
	db	27,0fdh,00h		; unreverse
	db	28,0fbh,00h		; un-invisible

; These set the colors
	db	30,0f8h,00h		; black foreground
	db	31,0f8h,04h		; red
	db	32,0f8h,02h		; green
	db	33,0f8h,06h		; yellow
	db	34,0f8h,01h		; blue
	db	35,0f8h,05h		; magenta
	db	36,0f8h,03h		; cyan
	db	37,0f8h,07h		; white

	db	40,08fh,00h		; black background
	db	41,08fh,40h		; red
	db	42,08fh,20h		; green
	db	43,08fh,60h		; yellow
	db	44,08fh,10h		; blue
	db	45,08fh,50h		; magenta
	db	46,08fh,30h		; cyan
	db	47,08fh,70h		; white

	page
;-------- dos function # 0 : init driver ---------------------
; Initializes device driver interrupts and buffers, then
; passes ending address of the device driver to DOS.
; Since this code is only used once, the buffer can be set up on top
; of it to save RAM. Placed at end so that any excess can be deleted
; after running

dosfn0	proc	near
	assume	cs:code, ds:code
if TSR
	mov	word ptr nextdev, -1	; fix up next device pointer
	mov	word ptr nextdev+2, -1
joindosfn0:
endif
	mov	byte ptr cs:IDLOC+10, '*' ; make us look different

; The following check for MDA/CGA courtesy of Arend van den Brug
					; initialise ega_rows to normal value
					; to enable MDA/CGA support
	mov	ax, ABS40
	mov	ds, ax
	assume	ds:ABS40
	mov	al, ega_rows
	or	al, al			; not already filled in ?
	jnz	set_kb
	mov	ega_rows, 24		; then set it to the normal 25 lines

set_kb:
if 0
	; this is old, ugly code that DOS manuals say would be necessary
	; but I've found not to be the case. But if I'm wrong, and the system
	; hangs during boot, then here is the ugly alternative.

	; Install BIOS keyboard break handler.
	xor	ax, ax
	mov	ds, ax
	assume	ds:NOTHING
	mov	bx, 1bh * 4
if TSR
	cmp	cs:fulldvr, 0
	je	nosetbrk
	mov	ax, [bx]
	mov	word ptr cs:old_brk, ax
	mov	ax, [bx+2]
	mov	word ptr cs:old_brk[2], ax
endif
	mov	word ptr [BX],offset break_handler
	mov	[BX+02], cs
nosetbrk:

	; Install INT 29 quick putchar.
	mov	bx, 029h * 4
if TSR
	mov	ax, [bx]			; save in case of unload
	mov	word ptr cs:old_int29, ax
	mov	ax, [bx+2]
	mov	word ptr cs:old_int29[2], ax
endif
	mov	word ptr [bx], offset int_29
	mov	[bx+2], cs
IF dos4
	; Install INT 2Fh multiplex interrupt, saving old vector.
	mov	bx, 02fh * 4
	mov	ax, [bx]
	mov	word ptr cs:old_mpx, ax
	mov	ax, [bx+2]
	mov	word ptr cs:old_mpx[2], ax
	mov	word ptr [bx], offset new_mpx
	mov	word ptr [bx+2],  cs
ENDIF
	
	; Install INT 10h video bios replacement, saving old vector.
	mov	bx, 10h * 4
	mov	ax, [bx]
	mov	word ptr cs:old_vid_bios, ax
	mov	ax, [bx+2]
	mov	word ptr cs:old_vid_bios[2], ax
	mov	word ptr [bx], offset new_vid_bios
	mov	word ptr [bx+2], cs

	push	cs
	pop	ds
else
	; use INT 21 function 35 and 25 to read and set interrupt handlers.
	; Technically this doesn't work for device driver initialization.
	; but practice shows otherwise.

	; Install BIOS keyboard break handler.
	push	cs			
	pop	ds			; get addressability
	assume	ds:code
if TSR
	cmp	fulldvr, 0		; partial driver?
	je	nosetbrk
	mov	ax, 351bh		; save old handler first
	int	21h
	mov	word ptr old_brk, bx
	mov	word ptr old_brk+2, es
endif
	mov	ax, 251bh
	mov	dx,offset break_handler
	int	21h
nosetbrk:

	; Install INT 29 quick putchar.
if TSR
	mov	ax, 3529h		; save old handler first
	int	21h
	mov	word ptr old_int29, bx
	mov	word ptr old_int29+2, es
endif
	mov	ax, 2529h
	mov	dx,offset int_29
	int	21h
IF dos4
	; Install INT 2Fh multiplex interrupt, saving old vector.
	mov	ax, 352fh
	int	21h
	mov	word ptr old_mpx, bx
	mov	word ptr old_mpx+2, es
	mov	ax, 252fh
	mov	dx,offset new_mpx
	int	21h
ENDIF
	
	; Install INT 10h video bios replacement, saving old vector.
	mov	ax, 3510h
	int	21h
	mov	word ptr old_vid_bios, bx
	mov	word ptr old_vid_bios+2, es
	mov	ax, 2510h
	mov	dx,offset new_vid_bios
	int	21h

endif
if DOSV AND dos4
	push	ds
	mov	ax, 6300h
	int	21h		; Get DBCS vector

	mov	ax, ds
	mov	word ptr cs:dbcs_vector+2, ax
	mov	word ptr cs:dbcs_vector, si
	pop	ds
endif ; DOSV AND dos4
	push	cs
	pop	es			; es=cs so we can use stosb

	cld				; make sure stosb increments di

	; Calculate addresses of start and end of parameter/redef buffer.
	; The buffer occupies the same area of memory as this code!
	; ANSI parameters are accumulated at the lower end, and
	; keyboard redefinitions are stored at the upper end; the variable
	; param_end is the last byte used by params (changes as redefs added);
	; redef_end is the last word used by redefinitions.
	mov	di, offset dosfn0
	mov	param_buffer, di
	add	di, buf_size
	mov	param_end, di	; addr of last byte in free area
	inc	di

	; Announce our presence
	mov	ax,cs
	mov	bx,offset Ident1
	call hexcnv

	mov	si, offset welcome
msg_loop:
	lodsb	
	cmp	al,0
	je	msg_done
	int	29h
	jmp	msg_loop

msg_done:

IF key_redef
	; Build the default redefinition table:
	;	control-printscreen -> control-P
	; (Must be careful not to write over ourselves here!)
	mov	al, 16		; control P
	stosb
	mov	ax, 7200h	; control-printscreen
	stosw
	mov	ax, 1		; length field
	mov	redef_end, di	; address of last used word in table
	stosw
endif

	; Return ending address of this device driver.
	; Status is in AX.
	lds	si, req_ptr
	mov	word ptr [si+0Eh], di
	mov	[si+10h], cs

	xor	ax, ax
	; Return exit status in ax.
	ret

welcome:
	db	27,'[33;1m'
	db	"NNANSI.SYS for "
	card_id
	if	cheap_pc
	db	" (XT class processor)"
	else
	db	" (AT class processor)"
	endif
	db	13, 10
	db	'By Tom Almy, version 5/93'
	db	13,10,10
	db	'Based on NANSI.SYS V2.2'
	db	13,10
	db	'Copyright 1986, Daniel Kegel.'
	db	13,10
	db	'May be distributed per GNU General Public License'
	db	13,10
	db	'(see file GPL.TXT in distribution)'
	db	13, 10, 13, 10
	db	'NNANSI driver loaded at '
Ident1	db	'XXXX:0000'
	db	13, 10, 27, '[0m'
if DESQVIEW
dvset	db	0
	db	13, 10, 27, '[36mDESQVIEW DETECTED!'
	db	13, 10, 27, '[0m'
endif
	db	0
dosfn0	endp

hexcnv	proc	near
; AX= value
; BX= pointer to destination string
; AX, BX destroyed, all other registers intact.
	push	cx
	push	dx
	mov	cx, 4
hexcnv_loop:
if cheap_pc
	rol	ax, 1
	rol	ax, 1
	rol	ax, 1
	rol	ax, 1
else
	rol	ax, 4
endif
	mov	dl, al
	and	dl, 0fh
	add	dl, '0'
	cmp	dl, '9'
	jbe	hexcnv_isdigit
	add	dl, 'A'-'9'-1
hexcnv_isdigit:
	mov	[bx], dl
	inc	bx
	loop	hexcnv_loop
	pop	dx
	pop	cx
	ret

hexcnv	endp

if TSR
realstart	proc	near
; Startup code when run as a COM file rather than a device driver
	assume	cs:code, ds:nothing
	mov	ax, cs		; correct CS  value
	add	ax, 10h
	push	ax
	mov	ax, offset cs:jumploc
	push	ax
	retf
;	db	0cbh	; MASM doesn't define retf
jumploc:
	mov	byte ptr cs:IDLOC+10, '*' ; make us look different
	mov	bx, 81h		; check the command line for argument
argloop:
	mov	al, ds:[bx]	; get a character
	inc	bx
	cmp	al, 0dh		; carriage return means "install"
	je	install
	cmp	al, 'd'		; d or D is full installation
	je	finstall
	cmp	al, 'D'
	je	finstall
	cmp	al, 'U'		; U or u is uninstall
	je	uninstall
	cmp	al, 'u'
	je	uninstall
	cmp	al, ' '		; blanks ok
	je	argloop
	mov	dx, offset cs:oopsmsg	; quit with help message
	push	cs		; print message
	pop	ds
abortdeath:
	mov	ah, 09h
	int	21h
	mov	ax, 4c01h	; terminate with error return code 1
	int	21h

uninstall:
; The uninstall process is somewhat different than what I've seen in 
; other TSRs. It ok's an uninstall based on the TSR being directly
; below in memory the current program. Other programs check for
; the interrupt vectors being correct. Both techniques are generally
; reliable, and both can be fooled.


	push	word ptr ds:2ch	; Environment pointer, saved in PSP
	call	findus		; find a clone of ourself
	pop	cx		; get back envp
	mov	ax, es
	or	ax, ax
	jnz	foundus
	mov	dx, offset cs:nocpymsg
	jmp	abortdeath
foundus:
	add	ax, word ptr es:parsize	; get original paragraph size
	inc	ax		; memory block header is another paragraph
	mov	bx, cs		; and compare with this cs
	cmp	ax, bx
	jz	goodloc
				; When unloading from a batch file using
				; COMMAND.COM, or with 4DOS.COM if the
				; environment has been enlarged,
				; our environment copy will be in the way,
				; so compensate and compare again
	add	cx, 10h		; compensate for PSP size
	cmp	ax, cx
	jz	goodloc
	mov	dx, offset cs:badlocmsg
	jmp	abortdeath
goodloc:
	mov	al, 27		; clear the screen
	int	29h
	mov	al, '['
	int	29h
	mov	al, '2'
	int	29h
	mov	al, 'J'
	int	29h
	mov	ax, 2529h	; restore int29 handler
	lds	dx, es:old_int29	; from original image's saved copy
	int	21h

if dos4
	mov	ax, 252fh	; restore mpx handler
	lds	dx, es:old_mpx
	int	21h
endif
	mov	ax, 2510h	; restore video bios handler
	lds	dx, es:old_vid_bios
	int	21h

	cmp	es:fulldvr, 0	; full driver installation?
	jz	nounlink	; no -- skip following

	mov	ax, 251bh	; restore keyboard break handler
	lds	dx, es:old_brk
	int	21h

	push	es		; unlink us from device driver list
	pop	ds
	assume	ds:code		; actually code of other copy!
	mov	ah, 52h		; get "list of lists" into es:bx
	int	21h
	mov	ax, word ptr savecon
	mov	word ptr es:0ch[bx], ax	; direct pointer to CON driver
	mov	ax, word ptr savecon+2
	mov	word ptr es:0eh[bx], ax
	push	bx
	mov	ah, 30h		; get DOS version
	int	21h
	pop	bx
	add	bx, 17h		; offset of 17h to NULL in DOS 2.x
	cmp	al, 2
	je	got_nullp
	add	bx, 28h-17h	; offset of 28h in DOS 3.0
	cmp	ax, 3
	je	got_nullp
	add	bx, 22h-28h	; offset of 22h in DOS 3.1 and later
got_nullp:
	; We are making the assumption that no other drivers have
	; been linked in. This should be reasonable since I know of no
	; other drivers that link themselves in as a TSR, and if one did
	; it would have to have been loaded "high" after NNANSI was loaded
	; "low", a very unlikely situation.

	mov	ax, word ptr nextdev
	mov	word ptr es:[bx], ax	; restore pointer to next in chain
	mov	ax, word ptr nextdev+2
	mov	word ptr es:2[bx], ax
	push	ds
	pop	es

nounlink:
	mov	byte ptr es:IDLOC+10, ' '	; unmark old image
				; If old image is not unmarked, it can 
				; appear as a ghost, preventing nnansi
				; from being reloaded.
	mov	ax, es		; point at old psp
	sub	ax, 10h		
	mov	es, ax
	mov	ah, 49h		; release old memory block
	int	21h
	push	cs
	pop	ds
	mov	dx, offset cs:failedmsg
	jc	abortdeath
	mov	dx, offset cs:successmsg
	mov	ah, 9
	int	21h
	mov	ax, 4c00h	; finished!
	int	21h

install:
	mov	cs:fulldvr, 0	; driver is partial
finstall:
	push	word ptr ds:2ch	; Environment pointer, saved in PSP
	push	cs		; establish addressability
	pop	ds
	assume	ds:code
if dos4				; use mpx vector for dos4 con driver check
	mov	ax, 1a00h
	int	2fh
	cmp	al, 0ffh	; is an ansi driver installed?
	je	yesansidvr
endif
	mov	ax, 3529h	; check int29 vector in either case
	int	21h
	cmp	word ptr es:10, "OC"	; see if hooked to an ANSI driver
	jne	noansidvr
	cmp	byte ptr es:12, 'N'
	je	yesansidvr
noansidvr:
if DESQVIEW
	mov	ax, 0b800h	; check for Desqview being present
	mov	es, ax
	xor	di, di
	mov	cx, "DE"
	mov	dx, "SQ"
	mov	ax, 2b01h
	int	21h
	cmp	al, 0ffh
	je	no_desqview	; not loaded
	mov	dvactive, bh	; say we are running Desqview
	mov	dvset, 13	; change message
	mov	fmode, 0	; disable fast mode -- would be a disaster!
	mov	ah, 0feh	; get display page
	int	10h
	mov	disppage, es	; es is display page to use
no_desqview:
endif
	cmp	fulldvr, 0	; partial driver?
	je	nolink
	mov	ah, 52h		; get "list of lists"
	int	21h
	mov	ax, word ptr es:0ch[bx] 	; save existing CON driver
	mov	word ptr savecon, ax
	mov	ax, word ptr es:0eh[bx]
	mov	word ptr savecon+2, ax
	mov	word ptr es:0ch[bx], 0	; new con driver header
	mov	word ptr es:0eh[bx], cs
	push	bx
	mov	ah, 30h		; get DOS version
	int	21h
	pop	bx
	add	bx, 17h		; offset of 17h to NULL in DOS 2.x
	cmp	al, 2
	je	got_null
	add	bx, 28h-17h	; offset of 28h in DOS 3.0
	cmp	ax, 3
	je	got_null
	add	bx, 22h-28h	; offset of 22h in DOS 3.1 and later
got_null:
	mov	ax, word ptr es:[bx]	; our driver points to what NULL was
	mov	word ptr nextdev, ax
	mov	ax, word ptr es:2[bx]	; next driver
	mov	word ptr nextdev+2, ax
	mov	word ptr es:[bx], 0	; point NULL to us
	mov	word ptr es:2[bx], cs
nolink:
	mov	word ptr req_seg, cs 	; set dummy request pointer
	mov	word ptr req_off, 020h
	call	joindosfn0	; original initialization
	pop	es		; get back Environment pointer
	mov	ah, 49h
	int	21h		; and free it since we don't need it

	mov	bx, 4		; close handles 0-4
closeloop:
	mov	ah, 3eh
	int	21h
	dec	bx
	jns	closeloop	; loop while >= 0

	mov	dx, di	; offset to end of resident code
	add	dx, 15+256	; page align plus size of PSP
	shr	dx, 1	; shift right to get # pages
	shr	dx, 1
	shr	dx, 1
	shr	dx, 1
	mov	cs:parsize, dx	; save this size
	mov	ax, 3100h	; Terminate and stay resident
	int	21h
abortinst:
	mov	dx, offset cs:abortmsg
	jmp	abortdeath
yesansidvr:
	mov	dx, offset cs:dvrmsg
	jmp	abortdeath
oopsmsg db "NNANSI -- no arguments mean 'install',"
	db 13,10,"          'D' means install as full driver,"
	db 13,10,"          'U' means 'uninstall'$"
abortmsg db "NNANSI -- already loaded. 'NNANSI U' to uninstall$"
dvrmsg	db "NNANSI -- another ANSI driver is already loaded$"
nocpymsg db "NNANSI -- NNANSI not loaded$"
badlocmsg db "NNANSI -- cannot unload -- not last loaded TSR$"
failedmsg db "NNANSI -- cannot unload -- memory error$"
successmsg db "NNANSI -- unloaded!$"
realstart	endp


findus	proc	near
	assume  cs:code,ds:code
	push	cs		; make us addressable
	pop	ds
	xor	dx, dx		; set es to 0 for search
fulup:	
	mov	es, dx
	mov	cx, 6		; compare for 12 bytes, 6 words
	mov	si, offset cs:IDLOC
	mov	di, si
	repe cmpsw
	jz	fulfound	; found if result equal
fulnext:
	inc	dx		; try next segment
	cmp	dx, 0fff0h	; reached end?
	jne	fulup		; no--try again
	xor	ax, ax		; return 0 in es
	mov	es, ax
	ret
fulfound:			; check for seeing ourself
	mov	ax, cs
	cmp	ax, dx
	je	fulnext		; yep--increment and try again
	ret			; return with segment in es
findus	endp
endif
code	ends
	end	start

