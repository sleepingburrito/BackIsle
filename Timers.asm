SECTION "MAIN", ROM0[$0150]

;frame counter
;=============
FrameCounter:
    push HL
    push AF
    ld hl, frameCounter
    inc [hl]
    jp nz, .Exit
    ;byte 1/2
    REPT 2
    inc hl
    inc [hl]
    jp nz, .Exit
    ENDR
    ;byte 3
    inc hl
    inc [hl]
.Exit
    pop AF
    pop HL
    ret
