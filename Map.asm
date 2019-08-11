SECTION "MAIN", ROM0[$0150]

;fill in non read only map regs for args
LoadMap:
    PushAllRegs
    call FadeDisplayOff
    OAMCopyMacro
    call LoadTileMapBg
    call FadeDisplayOn
    PopAllRegs
    ret

;finds starting of tile map in rom of mapX/map
;returns in mapTileMapStart
;clobbers A
TileMapStartOffset:
    push HL
    push BC
    ;set map starting point
    ld HL, ROM_BANK_START
    ;set y setup
    ld A, [mapY]
    CCTZ
    jp z, .SetX
    ld BC, TOTAL_MAP_WIDTH_TILES * MAP_HEIGHT_SCREEN_TILES ;move one map down worth of tiles
    ;set y math
.loopY
    add HL, BC
    dec A
    jp nz, .loopY
.SetX
    ld A, [mapX]
    CCTZ
    jp z, .exit
    ld B, 0
    ld C, MAP_WIDTH_SCREEN_TILES
.loopX
    add HL, BC
    dec A
    jp nz, .loopX
.exit
    SetR16Pointer H, L, mapTileMapStart
    pop BC
    pop HL
    ret