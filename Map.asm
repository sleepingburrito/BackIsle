SECTION "MAIN", ROM0[$0150]


;copy tile map from rom to vram
;mapX/mapY/mapBank regs is the map that will be loaded
;clobber Bank
;turn off display first then call
LoadTileMap:
    push AF
    push HL
    push DE
    push BC
    
    ;ready bank to tile map/meta data
    ld A, [mapBank]
    RomBankSwitchMacro
    call TileMapStartOffset ;set mapTileMapStart

    ;loading tile map
    ;================
    ;copy tile map, setup
    CopyR16Pointer H, L, mapTileMapStart
    ld DE, VRAM_TILEMAP_BG_START ;copy too
    ld B, MAP_HEIGHT_SCREEN_TILES ;y count
    ld A, 0
    ld [tmpVars], A ;fast copy
    call CopyMapTileMap

    ;get pattern pointer
    ;=================
    call SetMapTilePatternPointer

    ;copy tile pattern data
    ;======================
    ;bank map tile patterns
    ld A, 6 
    RomBankSwitchMacro
    ;copy pattern to vram
    CopyR16Pointer H, L, mapTilePattern
	ld DE, VRAM_BG_TILES_PARTITION
	ld BC, VRAM_BG_TILES_PARTITION_LENGTH
	call Copy

.exit
    pop BC
    pop DE
    pop HL
    pop AF
    ret


;=============================================
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


;============
;uses map's mapX/mapY/mapBank and a x/y provide to give a pointer to that location 
;BC is X/Y provide
;clobbers A
;return vaule in HL
TileMapOffset:
    CopyR16Pointer H, L, mapTileMapStart
    push DE
    ld A, C
    CCTZ
    jp z, .setX
    ld DE, TOTAL_MAP_WIDTH_TILES
.loopY
    add HL, DE
    dec C
    jp nz, .loopY 
.setX
    ld A, B
    ld E, A
    ld D, 0
    add HL, DE
    pop DE
    ret


;offset tile pattern pointer table for map
;==========================================
;mapX/Y
;return value in mapTilePattern
;clobbers a
SetMapTilePatternPointer:
    push HL
    push BC
    ;move HL to start of table
    ld HL, MAP_MAP_META_DATA
    ;y
    ld A, [mapY]
    CCTZ
    jp z, .setX
    ld BC, MAP_WIDTH_SCREENS * 2 ;2 bytes per pointer
.loopY
    add HL, BC
    dec a
    jp nz, .loopY

    ;x
.setX
    ;setup x
    ld A, [mapX]
    CCTZ
    jp z, .exit
    rlca ;2 bytes per pointer
    ld B, 0
    ld C, A
    add HL, BC
    
    ;end
.exit
    ;save pointer to mapTilePattern
    ld A, [HL+]
    ld C, A
    ld A, [HL]
    ld B, A
    SetR16Pointer B, C, mapTilePattern
    pop BC
    pop HL
    ret


;loading tile map to screen
;================
;HL: copy from
;DE: copy to
;B: y count
;tmpVars: set zero for fast copy and anything else for slow vsynce copy
;clobbers all
CopyMapTileMap:
.setXCount
    ld C, MAP_WIDTH_SCREEN_TILES; x count
    ;copy speed
    ld A, [tmpVars]
    CCTZ
    jp z, .copyMapLoop
    HaltCounter
.copyMapLoop:
    
    ld A, [HL+]
    and A, %01111111 ;keep in 0-127, top bit it for walls
    ld [DE], A
    inc DE

    dec C
    jp nz, .copyMapLoop

    ;save bc
    push BC

    ;big jump y map copy
    ld BC, TOTAL_MAP_WIDTH_TILES - MAP_WIDTH_SCREEN_TILES
    add HL, BC
    ;small screen y jump
    ld BC, TILE_WIDTH_OFFSCREEN
    ;save HL
    push HL
    ;copy
    push DE
    pop HL
    ;offset
    add HL, BC
    ;copy
    push HL
    pop DE
    ;restore hl
    pop HL
    ;restore bc
    pop BC
 
    ;loop upkeep
    dec B
    jp nz, .setXCount
    ret