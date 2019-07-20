SECTION "MAIN", ROM0[$0150]

;pull joypad state
;=================
;saves to joyPad in wram and A with flags set cp 0 (used to test if any key press)
ReadJoypad:
    push HL
    
    ;http://gbdev.gg8.se/wiki/articles/Joypad_Input
    ld HL, joyPad

    ;set to buttons
    ld A, %00100000
    ld [JOY_PAD_REG], A
    ;read button
    ld A, [JOY_PAD_REG] ;read to stabilize
    ld A, [JOY_PAD_REG]
    ;filter buttons and swap it, then save it
    and A, %00001111
    swap A
    ld [HL], A

    ;switch to dpad
    ld A, %00010000
    ld [JOY_PAD_REG], A
    ;read dpad
    ld A, [JOY_PAD_REG] ;read to stabilize
    ld A, [JOY_PAD_REG]
    ;combining with buttons and save
    and A, %00001111
    or A, [HL]
    xor a, %11111111
    ld [HL], a

    ;exit
    pop HL
    CCTZ
    ret z
    ld [joyPadLast], A ;save last key press if not zero
    ret


;Pause game till user presses a key
;==================================
;clobbers A
PauseAnyKey:
    HaltCounter
    call ReadJoypad
    CCTZ
    jp z, PauseAnyKey
    ret