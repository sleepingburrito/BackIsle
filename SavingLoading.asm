SECTION "MAIN", ROM0[$0150]
;save game at the start of walking though a door and let the door code rebuild the room
;load game at start of game

SaveGame:
    PushAllRegs
    LD [StackPointer], SP
    ld HL, WRAM0_START
    ld DE, SRAM_START
    ld BC, RAM_SIZE_MAX
    EnableSramMacro
.loop
    ld A, [HL+]
    ld [DE], A
    inc DE
    dec C
    jp nz, .loop
    dec B
    jp nz, .loop
    DisableSramMacro
    PopAllRegs
    ret

LoadGame:
    ld HL, SRAM_START
    ld DE, WRAM0_START
    ld BC, RAM_SIZE_MAX
    EnableSramMacro
.loop
    ld A, [HL+]
    ld [DE], A
    inc DE
    dec C
    jp nz, .loop
    dec B
    jp nz, .loop
    DisableSramMacro
    CopyR16Pointer H, L, StackPointer
    LD SP, HL
    PopAllRegs
    ret