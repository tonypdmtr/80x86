;*******************************************************************************
; Program: SYSTEM
; Version: 1.08 (rewritten from scratch)
; Written: July 4, 1990
; Updated: October 5, 1990
; Author : Tony G. Papadimitriou <tonyp@acm.org>
; Purpose: Display system specific information
;*******************************************************************************

           IDEAL
           %TITLE  "SYSTEM ver. 1.08"
           MODEL   SMALL
           STACK   1024

           if1
include    "dos.inc"
include    "bios.inc"
include    "kbd.inc"
           endif

           DATASEG
IntFlag    db      0                   ; 1 if non-zero numbers already
IntDblFlag db      0                   ; 1 if non-zero numbers already
CPUType    dw      0                   ; Type of CPU
EMMSTRING  db      "EMMXXXX0"          ; device name to compare to for EMS
Msg1       db      "SYSTEM 1.08, Copyright (c) 1990-2019",RETURN,LINEFEED
           db      "by Tony G. Papadimitriou (",??date,")",RETURN,LINEFEED
           db      "(Placed in the public domain)",RETURN,LINEFEED,RETURN,LINEFEED
Msg1Len    =       $ - Msg1
Msg2       db      "MS-DOS version...........  "
Msg2Len    =       $ - Msg2
Msg3       =       $
Msg3Major  db      ?                   ; DOS version major
           db      "."
Msg3Minor  db      ?,?                 ; DOS version minor
           db      RETURN,LINEFEED
Msg3Len    =       $ - Msg3
Msg4       =       $
           db      "Current video mode.......   "
Msg4VidMod db      3 dup('0')          ; video mode
           db      RETURN,LINEFEED
           db      "Screen width.............   "
Msg4ScrWdt db      3 dup('0')          ; screen width
           db      " chars",RETURN,LINEFEED
           db      "Screen length............   "
Msg4ScrLen db      3 dup('0')
           db      " lines",RETURN,LINEFEED
           db      "Active video page........   "
Msg4ActPag db      3 dup('0')          ; display mode
           db      RETURN,LINEFEED
Msg4Len    =       $ - Msg4
Msg5       db      "Disk drive installed",RETURN,LINEFEED
Msg5Len    =       $ - Msg5
Msg6       db      "Coprocessor installed",RETURN,LINEFEED
Msg6Len    =       $ - Msg6
Msg7       db      "Initial video mode.......   "
Msg7InMode db      3 dup('0')          ; initial video mode
           db      RETURN,LINEFEED
Msg7Len    =       $ - Msg7
Msg8       db      "Disk drives supported....   "
Msg8Drives db      3 dup('0')          ; disk drives attached
           db      RETURN,LINEFEED
Msg8Len    =       $ - Msg8
Msg9       db      "DMA circuit installed",RETURN,LINEFEED
Msg9Len    =       $ - Msg9
Msg10      db      "Serial ports supported...   "
Msg10Ports db      3 dup('0')          ; serial ports available
           db      RETURN,LINEFEED
Msg10Len   =       $ - Msg10
Msg11      db      "Found serial printer",RETURN,LINEFEED
Msg11Len   =       $ - Msg11
Msg12      db      "Printer ports supported..   "
Msg12Ports db      3 dup('0')
           db      RETURN,LINEFEED
Msg12Len   =       $ - Msg12
Msg13      db      "Main memory.............. "
Msg13Main  db      5 dup('0')          ; main memory in KB
           db      " KB",RETURN,LINEFEED
Msg13Len   =       $ - Msg13
Msg14      db      "Extended memory.......... "
Msg14Ext   db      5 dup('0')          ; extended memory in KB
           db      " KB",RETURN,LINEFEED
Msg14Len   =       $ - Msg14
Msg15      db      "CPU...................... "
Msg15Len   =       $ - Msg15
Msg86      db      " 8086/8088",RETURN,LINEFEED
Msg86Len   =       $ - Msg86
Msg286     db      "80286",RETURN,LINEFEED
Msg286Len  =       $ - Msg286
Msg386     db      "80386",RETURN,LINEFEED
Msg386Len  =       $ - Msg386
MsgNone    db      "Unknown",RETURN,LINEFEED
MsgNoneLen =       $ - MsgNone
Msg16      db      "Computer model (ID)......    "
Msg16Model db      ?,?                 ; HEX model number
           db      " hex",RETURN,LINEFEED
           db      "Computer submodel........    "
Msg16Sub   db      ?,?                 ; HEX submodel number
           db      " hex",RETURN,LINEFEED
           db      "BIOS revision level......   "
Msg16Rev   db      3 dup('0')          ; BIOS revision level
           db      RETURN,LINEFEED
Msg16Len   =       $ - Msg16
Msg17      db      "PC Bus I/O channel",RETURN,LINEFEED
Msg17Len   =       $ - Msg17
Msg18      db      "Micro channel architecture",RETURN,LINEFEED
Msg18Len   =       $ - Msg18
Msg19      db      "EBDA allocated",RETURN,LINEFEED
Msg19Len   =       $ - Msg19
Msg20      db      "Wait for external event is supported",RETURN,LINEFEED
Msg20Len   =       $ - Msg20
Msg21      db      "Keyboard intercept called by INT 09h",RETURN,LINEFEED
Msg21Len   =       $ - Msg21
Msg22      db      "Real-time clock present",RETURN,LINEFEED
Msg22Len   =       $ - Msg22
Msg23      db      "Second interrupt chip present",RETURN,LINEFEED
Msg23Len   =       $ - Msg23
Msg24      db      "DMA channel 3 used by hard disk BIOS",RETURN,LINEFEED
Msg24Len   =       $ - Msg24
Msg25      db      " but emulated by software",RETURN,LINEFEED
Msg25Len   =       $ - Msg25
Msg26      db      "Machine is in Virtual 8086 Mode",RETURN,LINEFEED
Msg26Len   =       $ - Msg26
Msg27      db      "Expanded memory present",RETURN,LINEFEED
Msg27Len   =       $ - Msg27
Msg28      db      Bell,"Internal error in EMS software",RETURN,LINEFEED
Msg28Len   =       $ - Msg28
Msg29      db      Bell,"Malfunction in EMS hardware",RETURN,LINEFEED
Msg29Len   =       $ - Msg29
Msg30      db      Bell,"Undefined EMS function",RETURN,LINEFEED
Msg30Len   =       $ - Msg30
Msg31      db      "EMS free 16K pages....... "
Msg31U     db      5 dup('0')          ; EMS unallocated pages
           db      RETURN,LINEFEED
           db      "EMS total 16K pages...... "
Msg31A     db      5 dup('0')          ; EMS total pages
           db      RETURN,LINEFEED
Msg31Len   =       $ - Msg31
Msg32      db      "EMS version number.......   "
Msg32Ver   db      ?,?,?               ; EMS version
           db      RETURN,LINEFEED
Msg32Len   =       $ - Msg32
Msg33      db      "Mouse driver installed",RETURN,LINEFEED
Msg33Len   =       $ - Msg33
Msg34      db      "Number of mouse buttons.. "
Msg34Num   db      5 dup('0')          ; number of mouse buttons
           db      RETURN,LINEFEED
Msg34Len   =       $ - Msg34
Msg35      db      "BIOS release date..... "
Msg35Date  db      8 dup('?')          ; BIOS date
           db      RETURN,LINEFEED
Msg35Len   =       $ - Msg35
Msg36      db      "DesqView is currently active",RETURN,LINEFEED
Msg36Len   =       $ - Msg36
Msg37      db      "DesqView version.........  "
Msg37Major db      ?                   ; DV version major
           db      "."
Msg37Minor db      ?,?                 ; DV version minor
           db      RETURN,LINEFEED
Msg37Len   =       $ - Msg37
BMsg1      db      "IBM/AWARD BIOS",RETURN,LINEFEED
BMsg1Len   =       $ - BMsg1
BMsg2      db      "DEC BIOS",RETURN,LINEFEED
BMsg2Len   =       $ - BMsg2
BMsg3      db      "Phoenix/AMI BIOS",RETURN,LINEFEED
BMsg3Len   =       $ - BMsg3

           CODESEG

           P8086

;*******************************************************************************
; Purpose: Call the various functions of the program
; Input  : None
; Output : None

proc       Main
           mov     ax,@data            ; initialize DS
           mov     ds,ax
           call    ShwCprght
           call    ShwCPU
           call    ShwDosVer
           call    ShwDspMode
           call    ShwMemory
           call    ShwConfig
           call    DesqView
           mov     ah,DOS_TERMINATE_EXE
           mov     al,0
           int     DOS_FUNCTION
endp       Main

;*******************************************************************************
; Purpose: Display the program copyright message
; Input  : None
; Output : None

proc       ShwCprght
           mov     dx,offset Msg1
           mov     cx,Msg1Len
           call    Write
           ret
endp       ShwCprght

;*******************************************************************************
; Purpose: Display the type of CPU of the machine
; Input  : None
; Output : None

proc       ShwCPU
           mov     dx,offset Msg15
           mov     cx,Msg15Len
           call    Write
           call    TestCPU             ; AX holds type of processor
           mov     [CPUType],ax        ; save it for later use
           cmp     ax,86               ; is it a 8086/8088?
           jne     @@10                ; no, check next
           mov     dx,offset Msg86
           mov     cx,Msg86Len
           call    Write
           jmp     short @@exit
@@10:      cmp     ax,286              ; is it a 80286?
           jne     @@20                ; no, check next
           mov     dx,offset Msg286
           mov     cx,Msg286Len
           call    Write
           jmp     short @@exit
@@20:      cmp     ax,386              ; is it a 80386?
           jne     @@30                ; no, check next
           mov     dx,offset Msg386
           mov     cx,Msg386Len
           call    Write
           call    V8086
           jmp     short @@exit
@@30:      mov     dx,offset MsgNone
           mov     cx,MsgNoneLen
           call    Write
@@exit:    ret
endp       ShwCPU

;*******************************************************************************
; Purpose: Display the version of MS-DOS and OEM BIOS
; Input  : None
; Output : None

proc       ShwDosVer
           mov     dx,offset Msg2
           mov     cx,Msg2Len
           call    Write
           mov     ah,DOS_GET_DOS_VERSION
           int     DOS_FUNCTION
           add     al,'0'              ; convert major to ASCII
           mov     [Msg3Major],al
           mov     al,ah               ; copy AH to AL
           mov     ah,0                ; zero high byte
           mov     bl,10               ; divisor is 10
           div     bl                  ; divide minor version by 10
           add     ax,3030h            ; convert both numbers to ASCII
           mov     [Msg3Minor],al      ; put first digit
           mov     [Msg3Minor+1],ah    ; put second digit
           mov     dx,offset Msg3
           mov     cx,Msg3Len
           call    Write
; OEM BIOS determination
           cmp     bh,0                ; IBM?
           jne     @@1
           mov     dx,offset BMsg1
           mov     cx,BMsg1Len
           call    Write
           jmp     short @@exit
@@1:       cmp     bh,16h              ; DEC?
           jne     @@2
           mov     dx,offset BMsg2
           mov     cx,BMsg2Len
           call    Write
           jmp     short @@exit
@@2:       cmp     bh,0FFh             ; Phoenix?
           jne     @@exit
           mov     dx,offset BMsg3
           mov     cx,BMsg3Len
           call    Write
@@exit:    ret
endp       ShwDosVer

;*******************************************************************************
; Purpose: Display the current video display mode
; Input  : None
; Output : None

proc       ShwDspMode
           mov     ah,INT10_GET_MODE
           int     VIDEO_SERVICE
           mov     di,offset Msg4VidMod
           call    IntToStr
           mov     al,ah
           mov     di,offset Msg4ScrWdt
           call    IntToStr
           mov     al,bh
           mov     di,offset Msg4ActPag
           call    IntToStr
           push    ds
           mov     ax,40h
           mov     ds,ax
           mov     al,[84h]            ; get screen length from BIOS data area
           pop     ds
           inc     al
           mov     di,offset Msg4ScrLen
           call    IntToStr
           mov     dx,offset Msg4
           mov     cx,Msg4Len
           call    Write
           ret
endp       ShwDspMode

;*******************************************************************************
; Purpose: Display the amounts of main and extended memory
; Input  : None
; Output : None

proc       ShwMemory
           int     12h                 ; call BIOS memory determination
           mov     di,offset Msg13Main
           call    IntToStrDbl
           mov     dx,offset Msg13
           mov     cx,Msg13Len
           call    Write
           mov     ah,88h              ; call BIOS extended memory inquiry
           int     15h
           jc      @@10                ; no extended, skip
           mov     di,offset Msg14Ext
           call    IntToStrDbl
           mov     dx,offset Msg14
           mov     cx,Msg14Len
           call    Write
           call    TestExpanded        ; check for expanded memory
@@10:      ret
endp       ShwMemory

;*******************************************************************************
; Purpose: Display the systen configuration as given by INT 11h
; Input  : None
; Output : None

proc       ShwConfig
           call    TestMouse           ; check for mouse driver
           int     11h                 ; Call BIOS equipment determination
           test    ax,1                ; is bit 0 set?
           jz      @@10                ; no, skip
           mov     dx,offset Msg5
           mov     cx,Msg5Len
           call    Write
@@10:      test    ax,2                ; is coprocessor installed?
           jz      @@20                ; no, skip
           mov     dx,offset Msg6
           mov     cx,offset Msg6Len
           call    Write
           call    CoTest              ; a few extra tests about the 386
@@20:      mov     cl,3
           mov     bx,ax               ; copy AX to BX
           shr     bx,cl               ; shift BX right 3 bits
           and     bx,3                ; mask all but lower 2 bits
           push    ax                  ; save AX
           mov     al,bl               ; argument must be in AL
           mov     di,offset Msg7InMode
           call    IntToStr
           pop     ax                  ; restore AX
           mov     dx,offset Msg7
           mov     cx,Msg7Len
           call    Write
           test    ax,1                ; is bit 0 set?
           jz      @@25                ; no, skip
           mov     cl,5
           mov     bx,ax               ; copy AX to BX
           shr     bx,cl               ; shift BX right 5 bits
           and     bx,3                ; mask all but lower 2 bits
           push    ax                  ; save AX
           mov     al,bl               ; argument must be in AL
           inc     al                  ; drives = number + 1
           mov     di,offset Msg8Drives
           call    IntToStr
           pop     ax                  ; restore AX
           mov     dx,offset Msg8
           mov     cx,Msg8Len
           call    Write
@@25:      test    ax,0100h            ; if 0, DMA is installed
           jne     @@30                ; DMA not present, skip
           mov     dx,offset Msg9
           mov     cx,Msg9Len
           call    Write
@@30:      mov     cl,8
           mov     bx,ax               ; copy AX to BX
           shr     bx,cl               ; shift BX right 8 bits
           and     bx,7                ; mask all but lower 3 bits
           push    ax                  ; save AX
           mov     al,bl               ; argument must be in AL
           mov     di,offset Msg10Ports
           call    IntToStr
           pop     ax                  ; restore AX
           mov     dx,offset Msg10
           mov     cx,Msg10Len
           call    Write
           test    ax,2000h            ; check for serial printer
           jz      @@40                ; not found, skip
           mov     dx,offset Msg11
           mov     cx,Msg11Len
           call    Write
@@40:      mov     cl,13
           mov     bx,ax               ; copy AX to BX
           shr     bx,cl               ; shift BX right 13 bits
           and     bx,3                ; mask all but lower 2 bits
           push    ax                  ; save AX
           mov     al,bl               ; argument must be in AL
           mov     di,offset Msg12Ports
           call    IntToStr
           pop     ax                  ; restore AX
           mov     dx,offset Msg12
           mov     cx,Msg12Len
           call    Write
           mov     ah,0C0h             ; Return System-Configuration Parms
           int     15h                 ; call BIOS function
           jnc     @@sk1               ; call not supported by BIOS
@@quit:    jmp     @@50                ; go to exit
@@sk1:     mov     cx,[es:bx]          ; get number of bytes that follow
           cmp     cx,8                ; must be at least 8
           jl      @@quit              ; if less than 8, skip next part
           mov     al,[es:bx+2]        ; get model number
           mov     di,offset Msg16Model
           call    HexVal
           mov     al,[es:bx+3]        ; get submodel number
           mov     di,offset Msg16Sub
           call    HexVal
           mov     al,[es:bx+4]        ; get BIOS revision level
           mov     di,offset Msg16Rev
           call    IntToStr
           mov     dx,offset Msg16
           mov     cx,Msg16Len
           call    Write
; get BIOS date
           push    ds                  ; save Data Segment
           push    es                  ; and Extra Segment
           push    ds                  ; transfer DS
           pop     es                  ;   to ES
           mov     ax,0F000h           ; new segment
           mov     ds,ax               ;   in DS
           mov     si,0FFF5h           ; offset within segment
           mov     di,offset Msg35Date
           mov     cx,8                ; 8 characters for MM/DD/YY
           rep movsb
           pop     es                  ; restore Extra  Segment
           pop     ds                  ; and Data Segment
           mov     dx,offset Msg35
           mov     cx,Msg35Len
           call    Write
; end get BIOS date
           mov     al,[es:bx+5]        ; get feature information
           test    al,00000010b        ; bus type?
           jnz     @@MicroCh
           mov     dx,offset Msg17
           mov     cx,Msg17Len
           jmp     short @@WrBus
@@MicroCh: mov     dx,offset Msg18     ; Micro channel architecture
           mov     cx,Msg18Len
@@WrBus:   call    Write
           test    ax,00000100b        ; check EBDA allocation
           jz      @@T3                ; no, go to next test
           mov     dx,offset Msg19
           mov     cx,Msg19Len
           call    Write
@@T3:      test    ax,00001000b        ; check external event support
           jz      @@T4                ; no, go to next test
           mov     dx,offset Msg20
           mov     cx,Msg20Len
           call    Write
@@T4:      test    ax,00010000b        ; check keyboard intercept
           jz      @@T5                ; no, go to next test
           mov     dx,offset Msg21
           mov     cx,Msg21Len
           call    Write
@@T5:      test    ax,00100000b        ; check real-time clock presence
           jz      @@T6                ; no, go to next test
           mov     dx,offset Msg22
           mov     cx,Msg22Len
           call    Write
@@T6:      test    ax,01000000b        ; check second interrupt chip
           jz      @@T7                ; no, go to next test
           mov     dx,offset Msg23
           mov     cx,Msg23Len
           call    Write
@@T7:      test    ax,10000000b        ; check DMA channel 3 usage
           jz      @@50                ; no, exit tests
           mov     dx,offset Msg24
           mov     cx,Msg24Len
           call    Write
@@50:      ret
endp       ShwConfig

;*******************************************************************************
; Purpose: If EMS is present, show information about it
; Input  : None
; Output : None

proc       TestExpanded
INT67_GET_PAGE_COUNT = 42h
INT67_GET_VERSION    = 46h
           mov     ah,DOS_GET_VECTOR
           mov     al,LIM_SERVICE
           int     DOS_FUNCTION
           mov     cx,8                ; compare all 8 characters of EMS name
           mov     di,10               ; set up destination index
           mov     si,offset EMMSTRING ; point to comparison string
           cld                         ; make sure direction is upward
           repe cmpsb
           jcxz    @@001               ; if all 8 bytes compare, found
           jmp     short @@exit        ; else, get out
@@001:     mov     dx,offset Msg27
           mov     cx,Msg27Len
           call    Write
           mov     ah,INT67_GET_PAGE_COUNT
           int     LIM_SERVICE
           cmp     ah,0                ; do we have errors?
           je      @@CONT              ; no, continue
           call    Errors
           jmp     short @@exit
@@CONT:    mov     ax,bx               ; unallocated pages
           mov     di,offset Msg31U
           call    IntToStrDbl
           mov     ax,dx               ; total EMS pages
           mov     di,offset Msg31A
           call    IntToStrDbl
           mov     dx,offset Msg31
           mov     cx,Msg31Len
           call    Write
           mov     ah,INT67_GET_VERSION
           int     LIM_SERVICE
           cmp     ah,0                ; do we have errors?
           je      @@CONT1             ; no, continue
           call    Errors
           jmp     short @@exit
@@CONT1:   mov     di,offset Msg32Ver
           call    HexVal
           mov     al,[Msg32Ver+1]
           mov     [Msg32Ver+2],al
           mov     [Msg32Ver+1],'.'
           mov     dx,offset Msg32
           mov     cx,Msg32Len
           call    Write
@@exit:    ret
Errors:    cmp     ah,80h              ; internal error?
           jne     @@E1                ; no, check next
           mov     dx,offset Msg28
           mov     cx,Msg28Len
           call    Write
@@E1:      cmp     ah,81h              ; hardware malfunction?
           jne     @@E2                ; no, check next
           mov     dx,offset Msg29
           mov     cx,Msg29Len
           call    Write
@@E2:      cmp     ah,84h              ; undefined function?
           jne     @@Done              ; no, exit
           mov     dx,offset Msg30
           mov     cx,Msg30Len
           call    Write
@@Done:    ret
endp       TestExpanded

;*******************************************************************************
; Purpose: If mouse is present, show information about it
; Input  : None
; Output : None

proc       TestMouse
MOUSE_DEVICE          = 33h
INT33_GET_MOUSE_PARMS = 0
           mov     ax,INT33_GET_MOUSE_PARMS
           int     MOUSE_DEVICE
           cmp     ax,0                ; is driver installed?
           je      @@exit              ; no, get out
           mov     dx,offset Msg33
           mov     cx,Msg33Len
           call    Write
           mov     di,offset Msg34Num
           mov     ax,bx
           call    IntToStrDbl
           mov     dx,offset Msg34
           mov     cx,Msg34Len
           call    Write
@@exit:    ret
endp       TestMouse

;*******************************************************************************
; Purpose: Determine whether DesqView is loaded
; Input  : None
; Output : None

proc       DesqView
           mov     cx,'DE'             ; check for the presence of DV
           mov     dx,'SQ'
           mov     ax,2B01h
           int     DOS_FUNCTION
           cmp     al,0FFh             ; if invalid not in DV
           je      @@exit              ; so, exit routine
           mov     dx,offset Msg36
           mov     cx,Msg36Len
           call    Write
           mov     ax,bx               ; get DV version in AX
           add     ah,'0'              ; convert major to ASCII
           mov     [Msg37Major],ah
           mov     ah,0                ; zero high byte
           mov     bl,10               ; divisor is 10
           div     bl                  ; divide minor version by 10
           add     ax,3030h            ; convert both numbers to ASCII
           mov     [Msg37Minor],al     ; put first digit
           mov     [Msg37Minor+1],ah   ; put second digit
           mov     dx,offset Msg37
           mov     cx,Msg37Len
           call    Write
@@exit:    ret
endp       DesqView

;*******************************************************************************
; Purpose: Write a string to standard output
; Input  : DS:DX points to string to print
;        : CX holds number of characters to print
; Output : none

proc       Write
           push    ax                  ; save registers
           push    bx
           mov     ah,DOS_WRITE_TO_HANDLE
           mov     bx,STDOUT
           int     DOS_FUNCTION
           pop     bx                  ; restore registers
           pop     ax
           ret
endp       Write

;*******************************************************************************
; Purpose: Convert a byte value to an ASCII string
; Input  : AL holds number to convert (0-255)
;        : DS:DI points to a 3-byte string space
; Output : Nothing

proc       IntToStr
           push    ax                  ; save registers
           push    bx
           push    cx
           push    di
           mov     [IntFlag],0         ; initialize flag
           mov     cx,3                ; initialize counter
           mov     ah,0                ; zero high byte
           mov     bh,100              ; starting value to divide
@@10:      div     bh
           add     al,'0'              ; convert quotient to ASCII
           cmp     cx,1                ; is this the last digit?
           je      @@11                ; yes, continue
           cmp     al,'0'              ; is the digit a '0'?
           jne     @@101               ; no, go on
           cmp     [IntFlag],1         ; is flag set?
           je      @@11                ; yes, go on
           mov     al,SPACE            ; yes, make it a SPACE
           jmp     short @@11          ; go on
@@101:     mov     [IntFlag],1         ; set flag
@@11:      mov     [di],al             ; put it in string
           inc     di                  ; point to next character
           push    ax                  ; save remainder
           mov     ah,0                ; zero high AX
           mov     al,bh               ; get divisor
           mov     bh,10               ; get local divisor
           div     bh                  ; divide by 10
           mov     bh,al               ; get quotient in BH
           pop     ax                  ; restore remainder
           mov     al,ah               ; continue with remainder
           mov     ah,0                ; zero high byte
           loop    @@10
           pop     di                  ; pop registers
           pop     cx
           pop     bx
           pop     ax
           ret
endp       IntToStr

;*******************************************************************************
; Purpose: Convert a word value to an ASCII string
; Input  : AX holds number to convert (0-65535)
;        : DS:DI points to a 5-byte string space
; Output : Nothing

proc       IntToStrDbl
           push    ax                  ; save registers
           push    bx
           push    cx
           push    dx
           push    di
           mov     [IntDblFlag],0      ; initialize flag
           mov     cx,5                ; initialize counter
           mov     dx,0                ; zero high word
           mov     bx,10000            ; starting value to divide
@@10:      div     bx
           add     al,'0'              ; convert quotient to ASCII
           cmp     cx,1                ; is this the last digit?
           je      @@11                ; yes, continue
           cmp     al,'0'              ; is the digit a '0'?
           jne     @@101               ; no, go on
           cmp     [IntDblFlag],1      ; is flag set?
           je      @@11                ; yes, go on
           mov     al,SPACE            ; yes, make it a SPACE
           jmp     short @@11          ; go on
@@101:     mov     [IntDblFlag],1      ; set flag
@@11:      mov     [di],al             ; put it in string
           inc     di                  ; point to next character
           push    dx                  ; save remainder
           mov     dx,0                ; zero high AX
           mov     ax,bx               ; get divisor
           mov     bx,10               ; get local divisor
           div     bx                  ; divide by 10
           mov     bx,ax               ; get quotient in BH
           pop     dx                  ; restore remainder
           mov     ax,dx               ; continue with remainder
           mov     dx,0                ; zero high byte
           loop    @@10
           pop     di                  ; pop registers
           pop     dx
           pop     cx
           pop     bx
           pop     ax
           ret
endp       IntToStrDbl

;*******************************************************************************
; Purpose: Convert a binary number to a 2-byte ASCII hex string
; Input  : DS:DI points to 2-byte string
;        : AL holds the number
; Output : None

proc       HexVal
           push    ax                  ; save registers
           push    di
           mov     [di+1],al           ; save number
           and     al,0f0h             ; reset LSNibble
           shr     al,1                ; shift MSN to LSN
           shr     al,1
           shr     al,1
           shr     al,1
           call    @@000               ; convert to ASCII character
           mov     [di],al             ; save it in string
           inc     di                  ; increment buffer pointer
           mov     al,[di]             ; get next value
           and     al,0fh              ; reset MSNibble
           call    @@000               ; convert to ASCII character
           mov     [di],al             ; save it in string
           pop     di                  ; restore registers
           pop     ax
           ret                         ; return to caller
@@000:     cmp     al,9                ; is character >9?
           ja      @@001               ; yes, it is A-F
           add     al,'0'              ; else, convert to ASCII
           ret
@@001:     sub     al,0ah              ; if A-F, subtract 10
           add     al,'A'              ; and convert to ASCII letter
           ret
endp       HexVal

           P386
;*******************************************************************************
; Purpose: Return a unique value indicating the type of CPU used
; Input  : None
; Output : AX holds 86, 286, or 386 depending on processor used

proc       TestCPU
           push    sp                  ; start checks
           pop     ax
           cmp     sp,ax
           je      @@286
           mov     ax,86               ; CPU is an 8086 or equivalent
           ret
@@286:     pushf
           pop     ax
           or      ax,4000H
           push    ax
           popf
           pushf
           pop     ax
           test    ax,4000H
           jnz     @@386
           mov     ax,286              ; CPU is an 80286 or equivalent
           ret
@@386:     mov     ax,386              ; CPU is an 80386 or equivalent
@@exit:    ret
endp       TestCPU

;*******************************************************************************
; Purpose: Check whether in Virtual 8086 mode
; Input  : None
; Output : None

proc       V8086
           smsw    ax                  ; store machine status word in AX
           test    al,1
           jz      @@exit              ; not in virtual mode
           mov     dx,offset Msg26
           mov     cx,Msg26Len
           call    Write
@@exit:    ret
endp       V8086

;*******************************************************************************
; Purpose: Display information specific to the 386 processor environment
; Input  : None
; Output : None

proc       CoTest
           cmp     [CPUType],386       ; is the CPU a 386 or higher?
           jl      @@exit              ; no, exit routine
           mov     eax,cr0             ; get control register of 386 machines
           test    eax,4h              ; check emulator bit
           jz      @@exit              ; no emulation
           mov     dx,offset Msg25
           mov     cx,Msg25Len
           call    Write
@@exit:    ret
endp       CoTest

           end     main
