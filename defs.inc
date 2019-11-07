; DEFS -- Copyright 1989 by Tony G. Papadimitriou
;         Last Updated: January 10, 1989

; LEGEND
; I$ --- All interrupts except for the commonly used BIOS and DOS
;        start with the prefix I$
; B$ --- All BIOS functions start with the prefix B$
; D$ --- All DOS functions start with the prefix D$
; DD$ -- All DOS subfunctions start with the prefix DD$
; A$ --- All ASCII characters start with the prefix A$

; ------------------------ BIOS definitions ----------------------------
bios                    equ     10h     ; BIOS multi-function INT
B$SetVideoMode          equ     0
B$SetCursorType         equ     1
B$SetCursorPos          equ     2
B$ReadCursorPos         equ     3
B$SelectVideoPage       equ     5
B$ScrollWindowUp        equ     6
B$ScrollWindowDn        equ     7
B$ReadCharAttr          equ     8
B$WriteCharAttr         equ     9
B$WriteAtCursor         equ     10
B$SetColorPalette       equ     11
B$WriteGraphicPix       equ     12
B$ReadGraphicPix        equ     13
B$WriteTextTTY          equ     14
B$GetVideoMode          equ     15
B$SetPaletteRegs        equ     16
B$WriteString           equ     19
I$GetEquipment          equ     11h     ; Equipment Determination (INT)
I$GetMemorySize         equ     12h     ; Memory Size Determination (INT)
I$ExecROMBASIC          equ     18h     ; Execute ROM BASIC/other (INT)
I$SystemWarmBoot        equ     19h     ; System Warm Boot (INT)
I$TerminateProgram      equ     20h     ; .COM exit for version 1 and up

; ------------------------ DOS definitions -----------------------------
dos                     equ     21h     ; DOS multi-function INT
D$TerminateVer1         equ     0
D$KeyInputEcho          equ     1
D$DisplayOutput         equ     2
D$AuxInput              equ     3
D$AuxOutput             equ     4
D$PrinterOutput         equ     5
D$DirectConsoleIO       equ     6
D$DirectSTDIN           equ     7
D$STDINInput            equ     8
D$DisplayString         equ     9
D$BufferedSTDIN         equ     10
D$CheckSTDINStatus      equ     11
D$ClearBufferInput      equ     12
D$ResetDisk             equ     13
D$SelectDisk            equ     14
D$OpenFileFCB           equ     15
D$CloseFileFCB          equ     16
D$SearchFirstEntry      equ     17
D$SearchNextEntry       equ     18
D$DeleteFileFCB         equ     19
D$ReadSeqFileFCB        equ     20
D$WriteSeqFileFCB       equ     21
D$CreateFileFCB         equ     22
D$RenameFileFCB         equ     23
D$GetDefaultDrive       equ     25
D$SetDTAAddress         equ     26
D$GetAllocationTable    equ     27
D$GetAllocationTableDr  equ     28
D$GetDefaultDiskPrmBlk  equ     31
D$RandomFileReadFCB     equ     33
D$RandomFileWriteFCB    equ     34
D$GetFileSizeFCB        equ     35
D$SetRandomRecFieldFCB  equ     36
D$SetInterruptVector    equ     37
D$CreatePSPVer1         equ     38
D$RandomBlockReadFCB    equ     39
D$RandomBlockWriteFCB   equ     40
D$ParseFileName         equ     41
D$GetSystemDate         equ     42
D$SetSystemDate         equ     43
D$GetSystemTime         equ     44
D$SetSystemTime         equ     45
D$SetVerifyFlag         equ     46
D$GetDTAAddress         equ     47
D$GetDOSVersion         equ     48
D$TerminateStayRes      equ     49
D$GetDrivePrmBlk        equ     50
D$GetSetCBreakFlag      equ     51
D$ReturnAddressInDOS    equ     52
D$GetInterruptVector    equ     53
D$GetFreeDiskSpace      equ     54
D$GetSetSwitchchar      equ     55
D$GetSetCountryInfo     equ     56
D$CreateSubdirectory    equ     57
D$RemoveSubdirectory    equ     58
D$SetDirectory          equ     59
D$CreateTruncateFile    equ     60
D$OpenFile              equ     61
D$CloseFile             equ     62
D$ReadFileOrDevice      equ     63
D$WriteFileOrDevice     equ     64
D$DeleteFile            equ     65
D$MoveFilePointer       equ     66
D$GetSetFileAttributes  equ     67
D$DeviceDriverControl   equ     68
DD$GetDeviceInfo        equ     0
DD$SetDeviceInfo        equ     1
DD$CharacterDeviceRead  equ     2
DD$CharacterDeviceWrite equ     3
DD$BlockDriverRead      equ     4
DD$BlockDriverWrite     equ     5
DD$GetInputStatus       equ     6
DD$GetOutputStatus      equ     7
D$DuplicateHandle       equ     69
D$ForceDuplicateHandle  equ     70
D$GetCurrentDirectory   equ     71
D$AllocateMemory        equ     72
D$ReleaseMemory         equ     73
D$ModifyMemoryAlloc     equ     74
D$ExecuteProgram        equ     75
D$TerminateReturnCode   equ     76
D$GetReturnCode         equ     77
D$SearchForFirstMatch   equ     78
D$SearchForNextMatch    equ     79
D$SetPSPSegment         equ     80
D$GetPSPSegment         equ     81
D$GetDiskList           equ     82
D$TranslateBPBtoDPB     equ     83
D$GetVerifyFlag         equ     84
D$CreatePSP             equ     85
D$RenameFile            equ     86
D$GetSetFileDateTime    equ     87
D$GetCriticalErrorFlag  equ     93
I$TerminateStayRes      equ     39

; ----------------------- ASCII definitions ----------------------------
A$NUL                   equ     0
A$SOH                   equ     1
A$STX                   equ     2
A$ETX                   equ     3
A$EOT                   equ     4       ; End of Transmission
A$ENQ                   equ     5
A$ACK                   equ     6       ; Positive Acknowledge
A$BEL                   equ     7
A$BS                    equ     8       ; Backspace
A$TAB                   equ     9
A$LF                    equ     10      ; Line Feed
A$VT                    equ     11      ; Vertical Tab
A$FF                    equ     12      ; Form Feed
A$CR                    equ     13      ; Carriage Return
A$SO                    equ     14
A$SI                    equ     15
A$DLE                   equ     16
A$DC1                   equ     17
A$DC2                   equ     18
A$DC3                   equ     19
A$DC4                   equ     20
A$NAK                   equ     21      ; Negative Acknowledge
A$SYN                   equ     22
A$ETB                   equ     23
A$CAN                   equ     24
A$EM                    equ     25
A$SUB                   equ     26
A$ESC                   equ     27
A$FS                    equ     28
A$GS                    equ     29
A$RS                    equ     30
A$US                    equ     31

; ----------------------- Color definitions ----------------------------
Black                   equ     0
Blue                    equ     1
Green                   equ     2
Cyan                    equ     3
Red                     equ     4
Magenta                 equ     5
Brown                   equ     6
Gray                    equ     7
DarkGray                equ     8
LightBlue               equ     9
LightGreen              equ     10
LightCyan               equ     11
LightRed                equ     12
LightMagenta            equ     13
Yellow                  equ     14
White                   equ     15
