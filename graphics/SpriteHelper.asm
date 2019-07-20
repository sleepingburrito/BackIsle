SECTION "MAIN", ROM0[$0150]

;DE is X/Y
;BC is Tile/Att
;clobbers A, rest are left alone
AddSprite:
    push HL
    
    ;get index
    ld H, SPRITE_START_HIGHBYTE
    ld A, [spriteIndex]
    ld L, A

    ;set sprite
    ld A, E
    ld [HL+], A ;x
    ld A, D
    ld [HL+], A ;y
    ld A, B
    ld [HL+], A ;tile
    ld A, C
    ld [HL+], A ;attb

    ;save index
    ld A, L
    ;test if at limit
    cp SPRITE_OAM_SIZE_MAX_BYTES
    jp nz, .skipReset
    ZeroA
.skipReset
    ld [spriteIndex], A
    
    ;exit
    pop HL
    ret


;clobbers A
HideAllSprites:
    push HL

    ld H, SPRITE_START_HIGHBYTE
    ld L, SPRITE_OAM_SIZE_MAX_BYTES - 4 ;-4 to start at y in OAM 
    ZeroA
.loop
    ld [HL-], A
    dec L
    dec L
    dec L
    jp nz, .loop
    ld [HL], A

    pop HL
    ret


;place bank in spriteBank
;place start of sprite in spritePatternStart
;make sure the screen is off
LoadFullSpritePatternsSlow:
    PushAllRegs
    ;get to start of sprite sheet
    ld A, [spriteBank]
    RomBankSwitchMacro
    ;copy to vram
    CopyR16Pointer H, L, spritePatternStart
    ld DE, VRAM_TILE_START
    ld BC, VRAM_SPRITE_LENGTH
    call Copy
    PopAllRegs
    ret