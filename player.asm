SECTION "MAIN", ROM0[$0150]

InitPlayer:
    CopyConst8Bit DIR_DOWN, playerFacing
    ld HL, playerFlags
    set PLAYER_FLAG_VISIBLE, [HL]
    set PLAYER_FLAG_HASIO, [HL]

    ;load starting map
    CopyConst8Bit 3, mapBank
    CopyConst8Bit 6, mapTilePatternBank ;start of bg patters
    ld A, 1
    ld [playerNpcMapX], A
    ld [playerNpcMapY], A
    call LoadMap

    ret

;players overworld code
;======================
PlayerStep:
    PushAllRegs

    ;
    ;move player sprite x/y to map x/y
    ld A, [playerFlags]
    ld D, A ;temp hold flags
    res PLAYER_FLAG_MOVING, D

    ;x
    ld HL, playerSpriteX
    ;get tile x
    ld A, [playerNpcMapX]
    ;apply offsets
    MultAby16
    add SPRITE_X_OFFSET
    ;test which way to move if any
    cp [HL]
    jp z, .moveY ;if same value skip moving on x
    set PLAYER_FLAG_MOVING, D ;set is moving
    jp c, .moveXLeft ;find out what way its moving
    ;move right
    inc [HL]
    ;CopyConst8Bit DIR_RIGHT, playerFacing
    jp .moveY
.moveXLeft
    ;CopyConst8Bit DIR_LEFT, playerFacing
    dec [HL]

    ;y
.moveY
    ld HL, playerSpriteY
    ;get tile cord
    ld A, [playerNpcMapY]
    ;apply offsets
    MultAby16
    add SPRITE_Y_OFFSET
    ;test which way to move if any
    cp [HL]
    jp z, .exitMoving
    set PLAYER_FLAG_MOVING, D 
    jp c, .moveYUp 
    ;move down
    inc [HL]
    ;CopyConst8Bit DIR_DOWN, playerFacing
    jp .exitMoving
.moveYUp
    dec [HL]
    ;CopyConst8Bit DIR_UP, playerFacing
.exitMoving
    ld A, D ;copy flags back
    ld [playerFlags], A
    ;end of moving
    ;

    ;
    ;user io moving
    ld A, [playerFlags]
    bit PLAYER_FLAG_MOVING, A ;only move when done moving
    jp nz, .userIOMovingExit
    bit PLAYER_FLAG_HASIO, A ;only move if user had IO
    jp z, .userIOMovingExit
    ;load joypad
    ld A, [joyPad]
    and PAD_MASK_DIR
    jp z, .userIOMovingExit ;only can move if pressing on dpad
    ld D, A ;hold pad in D as tmp

    ;set that the player is moving
    ld HL, playerFlags
    set PLAYER_FLAG_MOVING, [HL]

    ;up/down
    ld A, [playerNpcMapY]
    ;up
    bit PAD_UP_BIT, D
    jp z, .skipUpKey
    dec A
    CopyConst8Bit DIR_UP, playerFacing
.skipUpKey
    ;down
    bit PAD_DOWN_BIT, D
    jp z, .skipDownKey
    inc A
    CopyConst8Bit DIR_DOWN, playerFacing
.skipDownKey
    ;map change code
    ld [playerNpcMapY], A ;save y
    ld HL, mapY
    ;check if at left edge of map
    CCTZ
    jp nz, .skipUpIoCheck
    ;move player to bottom side
    ld A, NPC_MAP_HEIGHT - 2
    ld [playerNpcMapY], A
    swap A
    add SPRITE_Y_OFFSET
    ld [playerSpriteY], A
    ;load new map
    dec [HL]
    call LoadMap
    jp .userIOMovingExitX
.skipUpIoCheck
    ;test if you shoud move to next map
    cp NPC_MAP_HEIGHT - 1
    jp nz, .userIOMovingExitX
    ld A, 1
    ld [playerNpcMapY], A
    swap A
    add SPRITE_Y_OFFSET
    ld [playerSpriteY], A
    ;load new map
    inc [HL]
    call LoadMap
.userIOMovingExitX

    ;==left/right==
    ld A, [playerNpcMapX]
    ;left
    bit PAD_LEFT_BIT, D
    jp z, .skipLeftKey
    dec A
    CopyConst8Bit DIR_LEFT, playerFacing
.skipLeftKey
    ;right
    bit PAD_RIGHT_BIT, D
    jp z, .skipRightKey
    inc A
    CopyConst8Bit DIR_RIGHT, playerFacing
.skipRightKey
    ;map change code
    ld [playerNpcMapX], A ;save x
    ld HL, mapX
    ;check if at left edge of map
    CCTZ
    jp nz, .skipLeftIoCheck
    ;move player to right side
    ld A, NPC_MAP_WIDTH - 2
    ld [playerNpcMapX], A
    swap A
    add SPRITE_X_OFFSET
    ld [playerSpriteX], A
    ;load new map
    dec [HL]
    call LoadMap
    jp .userIOMovingExit
.skipLeftIoCheck
    ;test if you shoud move to next map
    cp NPC_MAP_WIDTH - 1
    jp nz, .userIOMovingExit
    ld A, 1
    ld [playerNpcMapX], A
    swap A
    add SPRITE_X_OFFSET
    ld [playerSpriteX], A
    ;load new map
    inc [HL]
    call LoadMap
.userIOMovingExit
    ;end user io moving
    ;
    





    ;
    ;drawing the player
    ld A, [playerFlags]
    bit PLAYER_FLAG_VISIBLE, A
    jp z, .exitDrawing

    ;facing
    ld A, [playerFacing]
    ld [NpcSpriteFacingReg], A
    ;speed
    CopyConst8Bit SPRITE_SPEED_SLOW, NpcSpriteSpeed ;default speed is slow
    ld A, [playerFlags]
    bit PLAYER_FLAG_MOVING, A
    jp z, .skipDrawFastWalk
    CopyConst8Bit SPRITE_SPEED_MED, NpcSpriteSpeed
.skipDrawFastWalk
    ;x/y
    CopyR16Pointer L, H, playerSpriteX
    SetR16Pointer H, L, NpcSpriteXY
    call DrawNpcSprite

.exitDrawing
    ;end of drawing
    ;

    ;exit
    PopAllRegs
    ret
