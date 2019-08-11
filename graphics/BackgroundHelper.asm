SECTION "MAIN", ROM0[$0150]
include "graphics/DialogueUI.asm"
include "graphics/DialogHelper.asm"
include "graphics/TextHelper.asm"

;copy tile map
;=============
;copy a full tile map to bg tile map
;BC: form, start of tilemap to copy
;HL: to, where in the bg tile map you want to start
;Clobbers all regs
CopyTileMap:
	;ld HL, VRAM_TILEMAP_BG_START
    ld D, TILE_WIDTH_COUNT
    ld E, TILE_HEIGHT_COUNT
.loop:
    ;copy to tile map
    ld a, [BC]
    inc BC
	ld [HL+], a
	;width loop
	dec D
	jp nz, .loop
    ;reset D
    ld D, TILE_WIDTH_COUNT
    ;move pointer 12 tiles to next line
    push BC
    ld B, 0
    ld C, TILE_WIDTH_OFFSCREEN
    add hl, bc
    pop BC
    ;hight loop
    dec E
    jp nz, .loop
    ;exit
    ret


;Set HL to XY for tile bg
;===============
;moves HL to x/y for bg tile map
;BC: XY, clobbers
OffsetHlBgTilemap:
    push DE
    push AF
    ;set up HL
    ld HL, VRAM_TILEMAP_BG_START
    ;test if zero, if not setup DE
    ld A, C
    CCTZ
    jp z, .setX
    ld DE, TILE_WIDTH_TOTAL
    ;set y pos
.loopy:
    add HL, DE
    dec c
    jp nz, .loopy
.setX:
    ;set x
    ld D, 0
    ld E, B
    add HL, DE
    ;exit
    POP AF
    pop DE
    ret


;plot single tile bg
;============
;plot a single tile (slow)
;BC: XY
;A: tile Id
;make sure screen is ready to be drawn on
PlotTileBg:
    push HL
    call OffsetHlBgTilemap
    ;set tile
    ld [HL], a
    ;exit
    pop HL
    ret

;copy tile map from rom to vram
;fill in map regs for args
;turn off display first then call
LoadTileMapBg:
    PushAllRegs
    
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
    ld A, [mapTilePatternBank]
    RomBankSwitchMacro
    ;copy pattern to vram
    CopyR16Pointer H, L, mapTilePattern
	ld DE, VRAM_BG_TILES_PARTITION
	ld BC, VRAM_BG_TILES_PARTITION_LENGTH
	call Copy

.exit
    PopAllRegs
    ret


;offset tile pattern pointer table for map meta data
;===================================================
;args are mapX/Y
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
    and A, %01111111 ;keep in 0-127, top bit is for walls
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