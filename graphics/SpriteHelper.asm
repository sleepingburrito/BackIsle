SECTION "MAIN", ROM0[$0150]

;DE is X/Y
;BC is Tile/Att
AddSprite:
    push HL
    push AF
    
    ;get index
    ld H, SPRITE_START_HIGHBYTE
    ld A, [spriteIndex]
    ld L, A

    ;set sprite
    ld A, E
    ld [HL+], A ;y
    ld A, D
    ld [HL+], A ;x
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
    pop AF
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


;load Npc sprite patterns
;=========================
;place bank in spriteBank
;HL CopyFrom
;DE CopyTo
;make sure the screen is off
LoadNpcSprites:
    PushAllRegs

    ;get to start of sprite sheet
    ld A, [spriteBank]
    RomBankSwitchMacro
    ld B, NPC_SPRITE_HEIGHT_TILES
.resetRowCopy
    ld C, NPC_SPRITE_WIDTH_BYTES
.loop
    ld A, [HL+]
    ld [DE], A
    inc DE

    dec C
    jp nz, .loop

    push HL
    ld HL, NPC_SPRITE_EXTRA
    add HL, DE
    push HL
    pop DE
    pop HL

    dec B
    jp nz, .resetRowCopy


    PopAllRegs
    ret


;===============
;draw npc sprite
;set regs in 'npc sprites'
DrawNpcSprite:
    PushAllRegs


    ;get sprite start
    CopyR16Pointer D,E,NpcSpriteXY
    ZeroA ;set attrib
    ld C, A

    ;no dir
    ld A, [NpcSpriteFacingReg]
    CCTZ
    jp z, .animation
    
    ;up
    cp DIR_UP
    jp nz, .skipUp
    ld A, [NpcSpriteTileStart]
    add NPC_SPRITE_UP_OFFSET
    jp .animation
.skipUp
    ;up end

    ;down
    cp DIR_DOWN
    jp nz, .skipDown
    ld A, [NpcSpriteTileStart]
    add NPC_SPRITE_DOWN_OFFSET
    jp .animation
.skipDown
    ;up end

    ;right
    cp DIR_RIGHT
    jp nz, .skipRight
    ld A, [NpcSpriteTileStart]
    add NPC_SPRITE_LEFT_RIGHT_OFFSET
    jp .animation
.skipRight
    ;up end
    
    ;left
    cp DIR_LEFT
    jp nz, .skipLeft
    ld A, %00100000 ;flip sprite
    ld C, A
    ld A, [NpcSpriteTileStart]
    add NPC_SPRITE_LEFT_RIGHT_OFFSET
    jp .animation
.skipLeft
    ;up end

    ;default
    jp .exit

    ;draw rest of sprite
.animation
    
    ;animation
    ld H, A

    ;find/test speed
    ld A, [NpcSpriteSpeed]
    CCTZ
    jp z, .skipAnimation
    ld L, A
    ld A, [frameCounter]
    and A, L
    jp z, .skipAnimation
    inc H
    inc H
.skipAnimation
    
    ld A, C
    CCTZ
    jp nz, .walkLeft
    ;
    ;top left
    ;
    ld A, H
    ld B, A
    call AddSprite

    ;top right
    inc A
    ld B, A
    rept 8
    inc D
    endr
    call AddSprite
    ;bottom left
    add $F
    ld B, A
    rept 8
    dec D
    endr
    rept 8
    inc E
    endr
    call AddSprite
    ;bottom right
    inc A
    ld B, A
    rept 8
    inc D
    endr
    call AddSprite
    jp .exit

    ;
    ;walk left code
    ;
.walkLeft
    ;top left
    ld A, H
    inc A
    ld B, A
    call AddSprite
    ;top right
    dec A
    ld B, A
    rept 8
    inc D
    endr
    call AddSprite
    ;bottom left
    add $11
    ld B, A
    rept 8
    dec D
    endr
    rept 8
    inc E
    endr
    call AddSprite
    ;bottom right
    dec A
    ld B, A
    rept 8
    inc D
    endr
    call AddSprite

.exit
    PopAllRegs
    ret