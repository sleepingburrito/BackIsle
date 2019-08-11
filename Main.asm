;Back Isle
;2019 (C) SleepingBurrito MIT
;
include "Constants.asm"
include "GloableVarirables.asm"
include "MacroTools.asm"

SECTION "Interrupt Vblank", ROM0[$0040]
reti

include "RomHeader.asm"

;main
;====
SECTION "MAIN", ROM0[$0150]
	
	;init code
	include "StartingState.asm"
	call InitGraphics
	call InitPlayer

	;=======
	CopyConst8Bit DIR_LEFT,NpcSpriteFacingReg

	CopyConst8Bit 20,NpcSpriteXY
	CopyConst8Bit 26,NpcSpriteXY + 1
	CopyConst8Bit SPRITE_SPEED_SLOW, NpcSpriteSpeed
	;=======


GameLoop:
	;frame upkeep
	;=============
	call ReadJoypad
	call HideAllSprites
	
	call PlayerStep

	;drawing
	;=======
	HaltCounter ;wait for start of vblank
	OAMCopyMacro
	
	;end of main game loop
	jp GameLoop

;=================
NewGame:
	;what to do for a new game (aka no save data)
	ret


;more bank 0 code
;================
include "Tools.asm"
include "DAM.asm"
include "Timers.asm"
include "Joypad.asm"
include "Drawing.asm"
include "Map.asm"
include "Prng.asm"
include "SavingLoading.asm"
include "player.asm"

;other bank includes
;====================
;text/ui graphics data 
include "graphics/Graphics.asm"
;dialog/text data
include "text/DialogData.asm"
;tile map/map meta data
include "maps/MapData.asm"