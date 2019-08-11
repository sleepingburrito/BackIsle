SECTION "RAM", WRAM0
spriteOAMBuffer: DS SPRITE_OAM_SIZE_MAX_BYTES
stack: ds STACK_SIZE_MAX
StackPointer: dw ;used for saving
romBank: ds 1 ;(read only) of what bank you are in
frameCounter: dl ;number of frames the game has ran
gameState: ds 1
joyPad: ds 1
joyPadLast: ds 1
tmpVars: ds 16 ;must managed yourself
rngIndex: ds 1

;dialog
;======
dialogTextBank: ds 1 ;set
dialogTextStart: dw ;set
dialogStringBuffer: ds DILOG_CHANGE_MAX_TEXT_ON_SCREEN
dialogStringNull: ds 1 ;null to stop text drawing, never used
dialogExpressIndex: ds 1 ;id of expression to draw

;drawing
;=======
drawTextX: ds 1
drawTextY: ds 1
drawTextPointer: dw

;map
;===
mapBank: ds 1 ;set for floor
mapX: ds 1 ;set for x/y
mapY: ds 1
mapTilePatternBank: ds 1 

mapTilePattern: dw ;read only, set with SetMapTilePatternPointer
mapTileMapStart: dw ;read only, set with TileMapStartOffset

;sprites
;=======
spriteIndex: ds 1
spriteBank: ds 1

;npc sprites
;===========
NpcSpriteTileStart: ds 1
NpcSpriteFacingReg: ds 1
NpcSpriteXY: dw
NpcSpriteSpeed: ds 1

;npc Map
;======
mapNpc: ds NPC_MAP_SIZE

;player
;======
playerNpcMapX: ds 1 ;where the player is
playerNpcMapY: ds 1
playerSpriteX: ds 1 ;where to draw the player
playerSpriteY: ds 1

playerFlags: ds 1
playerFacing: ds 1




SECTION "CART RAM", SRAM
;========================
;for save data
gameName: ds GAME_NAME_LENGTH ;used to init cart ram for new game
saveChecksum: ds SRAM_CHECKSOME_SIZE ;check save corruption

