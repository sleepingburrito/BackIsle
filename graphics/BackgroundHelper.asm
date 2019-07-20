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


;Set HL tile bg
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


;plot tile bg
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
