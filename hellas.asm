Page 66,132
Title     Hellas -- Enables display of Greek characters on a CGA screen

;*******************************************************************************
; Program name : HELLAS
; Written by   : Tony G. Papadimitriou
; Description  : Enables display of Greek characters on a CGA screen
; Date Started : May 14, 1989
; Date Finished: May 27, 1989
; Date Updated : May 31, 1989
; Installation : At the DOS prompt, type HELLAS
; Usage        : ALT-G will toggle from normal to Greek and back
; Version History:
; 1989.05.27 1.00: Original
; 1989.05.28 1.01: Added capability of printing Latin and Greek together
; 1989.05.29 1.02: Corrected letters C,c,J,j,U,u (order was changed)
; 1989.05.31 1.03: Allowed for original characters 128-254 to display
;                : (255 is reserved for swapping English/Greek and v.v.)
;*******************************************************************************
; Header last updated: January 10, 1989

bios equ  10h
dos  equ  21h
CR   equ  13
LF   equ  10
CNTRLZ    equ  1Ah
HotKey    equ  2200h          ; ALT-G

;
; ______________________ M A I N   R O U T I N E _________________________
;
vectors segment at 0h
     org  9h*4      ; intercept keyboard interrupt
old_int_vector label     dword
     org  07Ch      ; Graphics character set table
table_int label     dword
vectors ends

rom_bios_data  segment at 40h
     org  1ah
head dw   ?         ; Unread chars go from Head to Tail
tail dw   ?
buffer    dw   16 dup(?) ; the keyboard buffer itself
buffer_end     label     word
rom_bios_data  ends

code segment para
     assume    cs:code,ds:code

     org  100h      ; make sure it's a COM file.
; make program memory resident -- TSR
entry:    jmp  install   ; skip over data and make program TSR
     db   'Copyright (c) 1989-2019 by Tony Papadimitriou',CR,LF,CNTRLZ
old_keyboard_int    dd   ?    ; Location of old kbd interrupt

my_table     label     byte
     include greek.chr   ; load table in memory

; This is the main procedure of the program
greek     proc near
; save all registers we will use
     push ax
     push bx
     push cx
     push dx
     push di
     push si
     push ds
     push es
; call original interrupt routine
     pushf
     call cs:old_keyboard_int
; check the key pressed by looking at the buffer
     assume    ds:rom_bios_data
     mov  bx,rom_bios_data
     mov  ds,bx
     mov  bx,tail
     cmp  bx,head
     je   Main_Exit
     sub  bx,2      ; point to just read in character
     cmp  bx,offset buffer    ; Did we undershoot the buffer?
     jae  no_wrap   ; Nope
     mov  bx,offset buffer_end     ; Yes_move to buffer top
     sub  bx,2      ; And point to character
no_wrap:
     mov  dx,[bx]   ; character in DX now
     cmp  dx,HotKey ; is it the Hot Key character?
     je   go_on
     jmp  Main_Exit
; we got the right key, let's do some work
go_on:
     assume    ds:code
     push cs        ; first, point DS to CS
     pop  ds
     cmp  active,0  ; is flag 0? (inactive)
     je   SetMode
; restore the video mode
     mov  ah,0      ; set original video mode
     mov  al,defmode
     int  bios
     jmp  GetOut         ; exit and change flag
SetMode:
     mov  ah,0Fh         ; get current mode
     int  bios
     mov     defmode,al  ; save old video mode
;
     mov  ah,0      ; set new mode
     mov  al,6      ; select graphics mode 80x25
     int  bios
GetOut:
     not  active         ; toggle the flag

; _____________ T O   B E   C O N T I N U E D _______________________

; restore all registers we used and return from interrupt
Main_Exit:
     pop  es
     pop  ds
     pop  si
     pop  di
     pop  dx
     pop  cx
     pop  bx
     pop  ax
     iret
greek     endp

active    db   0         ; activity flag -- 0=inactive, FFh=active
language  db   0    ; language flag -- 0=Greek, FFh=English
defmode db     ?         ; default video mode

print_vector   dd   ?    ; INT 10h vector

main proc near
     assume    ds:code
     pushf
     push ds
     push cs        ; DS=CS
     pop  ds
     cmp  active,0  ; is the routine active?
     je   m_out          ; nope, don't do a thing
; check if we got the right functions
;next_check:
     cmp  ah,9      ; is it the right functions?
     jb   m_out
     cmp  ah,10
     ja   m_out
; check if character is SWAP character (ASCII 255)
     cmp  al,255
     jne  do_orring
     not  language  ; swap language flag
     jmp  m_out
; do ORring only for letters unless we need to swap table vectors
do_orring:
     cmp  al,128
     jb   goon      ; no need to swap vectors
     call    SetThem     ; else swap them
     jmp     m_out
goon:
     cmp  language,0     ; is it Greek? (0)
     jne  m_out
     cmp  al,'A'
     jb   m_out
     cmp  al,'z'
     ja   m_out
     cmp  al,'Z'
     jbe  OK
     cmp  al,'a'
     jae  OK
     jmp  short m_out
OK:
     or   al,80h         ; set high bit of character
m_out:
     pop  ds
     popf
     pushf
     call cs:print_vector
     mov  al,cs:tflag
        cmp    al,0FFh
     jne  quick_out
     call SetThem
quick_out:
     iret
main endp

; Set the vectors in INT 1Fh with the "original" below
original  dd   ?    ; original table vector is here after install
tflag     db   0         ; table flag (0=our table, FF=original)
SetThem proc   near
     assume    ds:vectors
     push ax
     push bx
     mov  ax,vectors     ; set up DS to vector segment
     mov  ds,ax
; transfer offset
     mov  ax,word ptr table_int
     mov  bx,word ptr cs:original
     mov  word ptr table_int,bx
     mov  word ptr cs:original,ax
; transfer segment
     mov  ax,word ptr table_int[2]
     mov  bx,word ptr cs:original[2]
     mov  word ptr table_int[2],bx
     mov  word ptr cs:original[2],ax
; swap the tflag status
     not  cs:tflag
     pop  bx
     pop  ax
     ret
SetThem endp

;
; __________ The following part is destroyed after installation ________
;                (add any permanent code above this point)
;

install proc   near
; print a short message with my copyright and startup instructions
     assume    ds:code
     push cs        ; make sure DS points to code segment
     pop  ds
     mov  dx,offset copyright
     call print
; set graphics characters vectors to our own table
     assume    ds:vectors
     mov  ax,vectors
     mov  ds,ax
     mov  dx,offset cs:my_table
; save original vector
     mov  ax,word ptr table_int
     mov  word ptr cs:original,ax
     mov  ax,word ptr table_int[2]
     mov  word ptr cs:original[2],ax
; end save
     mov  word ptr table_int,dx
     mov  word ptr table_int[2],cs
; intercept INT 9H -- keyboard interrupt
     mov  ax,word ptr old_int_vector
     mov  word ptr cs:old_keyboard_int,ax
     mov  ax,word ptr old_int_vector[2]
     mov  word ptr cs:old_keyboard_int[2],ax
; and put our program's address there
     mov  dx,offset cs:greek
     mov  word ptr old_int_vector,dx
     mov  word ptr old_int_vector[2],cs
; intercept bios INT 10h, functions 9 and 10
; first, get the original vectors
     mov  ah,35h         ; get int vector function
     mov  al,bios   ; for int 10h
     int  dos
     mov  word ptr cs:print_vector,bx    ; save it, offset first
     mov  word ptr cs:print_vector[2],es    ; segment last
; second, set the new vectors to our own routine
     assume    ds:code
     push cs
     pop  ds
     mov  dx,offset main
     mov  ah,25h         ; set int vector function
     mov  al,bios   ; for int 10h
     int  dos
; deallocate memory and stay in memory
     mov  dx,offset cs:install     ; load point of following programs
     int  27h            ; Terminate and Stay Resident
copyright label     byte
     db   'HELLAS ver. 1.03 * Copyright (c) 1989-2019 by Tony G. Papadimitriou',CR,LF
     db   'The Greek character set for CGA has been installed.',CR,LF
     db   'The hot key is ALT-G.',CR,LF,'$'
install endp

Print      proc
           push    ax
           push    dx
           mov     ah,9h
           int     21h
           pop     dx
           pop     ax
           ret
Print      endp

code ends
     end  entry
