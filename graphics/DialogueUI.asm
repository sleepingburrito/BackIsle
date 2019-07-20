SECTION "MAIN", ROM0[$0150]

;Start Dialog
;=============
;freezes the game to show dialog
;Place text bank in dialogTextBank
;Place pointer to start of string in dialogTextStart
StartDialog:
    ;start
    push AF
    push BC
    push DE
    push HL
    ;switch to bank
    ld A, [dialogTextBank]
    RomBankSwitchMacro
    ;point hl to start of text
    CopyR16Pointer H, L, dialogTextStart
    ;point text to are string buffer
    ld DE, dialogStringBuffer
    ld A, E
    ld [drawTextPointer], A
    ld A, D
    ld [drawTextPointer+1], A
    ;load x/y
    ld A, DILOG_DRAW_X
    ld [drawTextX], A
    ld A, DILOG_DRAW_Y
    ld [drawTextY], A
    ;skip user input
    jp .FirstTimer 

.ResetScreen
    call PauseAnyKey
.FirstTimer
    ;zero string buffer/clear screen
    call ZeroOutdialogStringBuffer
    call ClearDialogArea
    call DrawDialogExpr
    ;set up loop
    ld C, DILOG_CHANGE_MAX_TEXT_ON_SCREEN
    ld DE, dialogStringBuffer
.loop:
    ;copy next char
    ld A, [HL+]
    ld [DE], A ;save to buffer
    

    ;check if expresstion
    cp DILOG_CHANGE_EXPRESSION
    jp nz, .skipCheckExpres
    ;update expres
    ld A, [HL+]
    ld [dialogExpressIndex], A
    call DrawDialogExpr
    jp .loop
.skipCheckExpres
    
    ;move to next char in string buffer
    inc DE
    ;draw text to screen at vblank
    HaltCounter
    call DrawText
    ;exit if null char
    cp CHAR_NULL
    jp z, .loopLastInput
    ;loop upkeep
    dec C
    jp z, .ResetScreen
    jp .loop

    ;wait for last user input
.loopLastInput:
    call PauseAnyKey
    call ClearDialogArea
    
    ;exit
.ExitDialog
    call DrawMapDialogExit
    pop HL
    pop DE
    pop BC
    pop AF
    ret


;Fill dialogStringBuffer with zero
;=================================
ZeroOutdialogStringBuffer:
    push AF
    push HL
    push BC
    ld C, DILOG_CHANGE_MAX_TEXT_ON_SCREEN
    ZeroA
    ld HL, dialogStringBuffer
.loop:
    ld [HL+], A
    dec C
    jp nz, .loop
    pop BC
    pop HL
    pop AF
    ret
