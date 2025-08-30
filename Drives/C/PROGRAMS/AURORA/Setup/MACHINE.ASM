;---------------------------------------------------------------------
; MACHINE.ASM
; Assembly Language Source for Machine.aml Examples
;
; This is an assembly language code sample called by the 'machine'
; function from within the Machine.aml macro. It shows how to access
; arguments passed by the macro language, and how to return values.
;
; The following arguments are passed to this assembly code from
; achine.amlL:
;
;   arg 1: a far pointer to a string
;   arg 2: a long numeric value
;   arg 3: a long numeric value passed by reference (a far pointer to
;          a long numeric value)
;
; This code will modify the first character of arg 1, replace the
; numeric value in arg 3 with arg 2 (returning arg 2 by reference), and
; return the previous contents of arg 3 as the return value of the
; 'machine' function. The Machine.aml macro will display the results.
;
; Machine.asm can be assembled and linked with the /T (TINY) option to
; generate a Machine.bin file. For example:
;
;   tasm machine.asm machine.obj
;   link /T machine.obj,machine.bin,,,,
;
; When Machine.aml is compiled, Machine.bin will be embedded in the
; resulting Machine.x executable macro file.
;-----------------------------------------------------------------------

_TEXT           segment byte
                assume  cs:_TEXT

String          equ      6 [bp]                 ; arg 1: string
Numeric         equ     10 [bp]                 ; arg 2: number
NumericRef      equ     14 [bp]                 ; arg 3: pointer to a number

                push    bp                      ; only bp must be saved
                mov     bp,sp                   ; address the stack

; On entry:
;               ax = number of arguments passed
;               bx = type mask

; If the number of arguments passed is not equal to 3,
; fail and return the number of arguments passed.

                cmp     ax,3
                je      start
                xor     dx,dx
                retf
start:

; Arg 1: String argument passed by reference

; Note: strings are always passed by reference, whether or not the ref
; keyword is specified in the calling macro. If the string length is
; needed, it must be passed as a separate numeric argument. Strings are
; not automatically zero-terminated. If zero-terminated string is
; required, the binary zero should be added here or in the calling macro.

                ; get far pointer to arg 1 and modify the first char
                les     di,dword ptr String
                mov     byte ptr es:[di],'!'

; Arg 2: Numeric argument passed by value
; (numerics are always passed as long integers)

                ; get the value of arg 2 in cx:bx
                mov     bx,Numeric
                mov     cx,Numeric + 2

; Arg 3: Numeric argument passed by reference

                ; get a far pointer to arg 3
                lds     si,dword ptr NumericRef

                ; get the value of arg 3 in dx:ax
                mov     ax,ds:[si]
                mov     dx,ds:[si + 2]

                ; return arg 2 by reference (in arg 3)
                mov     ds:[si],bx
                mov     ds:[si + 2],cx

                ; restore bp
                pop     bp

                ; return dx:ax (previous arg 3) to the 'machine' function
                retf

_TEXT           ends
                end
