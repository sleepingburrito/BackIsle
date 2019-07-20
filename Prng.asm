SECTION "MAIN", ROM0[$0150]

;returns in A
Prng:
    push HL
    ;rng index upkeep
    ld A, [rngIndex]
    inc A
    or $80
    ld [rngIndex], A
    ;add hiram byte
    ld H, $FF
    ld L, A
    add A, [HL]
    ;whatever is in the regs
    add HL, SP
    add HL, BC
    add HL, DE
    add A, H
    add A, L
    ;what frame your on
    ld HL, frameCounter
    add A, [HL] 
    ;the keys the user last pressed
    ld HL, joyPadLast
    add A, [HL]
    pop HL
    ret