SECTION "MAIN", ROM0[$0150]

;Clear Dialog area
;=================
;clears top 3ed of the screen
;clobbers a 
;Warning, loop unrolling, keep in mind when modifing
ClearDialogArea:
    push HL
    push BC
    push DE
    ld A, DILOG_CLEAR_TILEID
    ld HL, DILOG_BOX_START
    ld B, DILOG_BOX_LENGTH / 2 ;/2 loop unrolled
    ld D, 0
    ld E, TILE_WIDTH_OFFSCREEN
    HaltCounter ;wait for vsynce
.resetY
    ld C, TILE_WIDTH_COUNT / 2 ;/2 loop unrolled
.loop
    ld [HL+], A
    ld [HL+], A ;loop unrolled
    ;exit after 80 tiles
    dec B
    jp z, .Exit
    ;colum test
    dec C
    jp z, .moveDownColum
    ;loop
    jp .loop
.moveDownColum
    add HL, DE
    jp .resetY
.Exit
    pop DE
    pop BC
    pop HL
    ret


;Draw Dialog Expression
;======================
;set dialogExpressIndex to the Expression you want to show
;Note: this switches rom bank back to the dialogTextBank
;clobbers A
DrawDialogExpr:
    ;copy tile map
    push HL
    push DE
    push BC

    ;setup the copy to
    ld HL, DILOG_EXPRESS_TILES_COPYTO

    ;set up bank
    ld A, VRAM_TEXT0_BANK
    RomBankSwitchMacro

    ;decode expr id
    ;copy from
    ld A, [dialogExpressIndex]
    ;add A, 1 ;start at the end
    ld DE, DIALOG_EXPRESS_GFX
    add A, D ;mult by A * 255
    ld D, A

    ;set up copy loop
    ld B, 2 ;do the copy over 2 frames
.CopySecondFrame
    ld C, DILOG_EXPRESS_SIZE_BYTES / 4 ;/4 because we are unrolling
    HaltCounter ;wait for vsynce
.CopyTilePatternLoop:
    rept 2
    ld A, [DE]
    inc DE
    ld [HL+], A
    endr
    dec C
    jp nz, .CopyTilePatternLoop
    dec B
    jp nz, .CopySecondFrame

    ;set tile map below
    ld A,  DILOG_EXPRESS_TILES_STARTINGID
    ld HL, DILOG_EXPRESS_BG_TILEMAP_START
    ld C, DILOG_EXPRESS_WIDTH
    ld D, 0
    ld E, TILE_WIDTH_TOTAL - DILOG_EXPRESS_WIDTH
    HaltCounter ;wait for vsynce 
.loopTileMap
    ;copy tile map
    ld [HL+], A
    inc A
    ;column check
    dec C
    jp nz, .SkipNewColum
    ld C, DILOG_EXPRESS_WIDTH
    add HL, DE
.SkipNewColum:
    ;loop upkeep
    cp DILOG_EXPRESS_TILES_STARTINGID + DILOG_EXPRESS_SIZE_TILES
    jp nz, .loopTileMap

    ;exit
    ld A, [dialogTextBank]
    RomBankSwitchMacro
    pop BC
    pop DE
    pop HL
    ret


;clear dialog by drawing map
;===========================
;used when exiting dialog to get the map back
;clobbers A
DrawMapDialogExit:
    push HL
    push DE
    push BC

    ;switch to map bank
    ld A, [mapBank]
    RomBankSwitchMacro

    ;loading tile map
    CopyR16Pointer H, L, mapTileMapStart ;copy from
    ld DE, VRAM_TILEMAP_BG_START ;copy too
    ld B, DILOG_EXPRESS_WIDTH ;y count
    ld A, 1 ;slow copy
    ld [tmpVars], A 
    call CopyMapTileMap
    
    pop BC
    pop DE
    pop HL
    ret


;Hide sprites in Dialog area
;===========================
;clobbers A
;make sure to update OAM
DrawMapHideSprites:
    push HL

    ld H, SPRITE_START_HIGHBYTE
    ld L, SPRITE_OAM_SIZE_MAX_BYTES - 4 ;-4 to start at y in OAM 
    ZeroA
.loop
    ld A, [HL]
    cp DILOG_DRAW_Y_HIGHT
    jp nc, .skipHide
    ZeroA 
    ld [HL], A
.skipHide:
    dec L
    dec L
    dec L
    dec L
    jp nz, .loop
    ld [HL], A

    pop HL
    ret