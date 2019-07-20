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

;testing map loading
;=============================

;=============================


GameLoop:
	;frame upkeep
	;=============
	call ReadJoypad
	

	ld D, 80
	ld E, 80
	ld B, $95
	ld C, 0
	call AddSprite



	;drawing
	;=======
	HaltCounter ;wait for start of vblank
	OAMCopyMacro
	call HideAllSprites
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

;other bank includes
;====================
;text/ui graphics data 
include "graphics/Graphics.asm"
;dialog/text data
include "data/DialogData.asm"
;tile map/map meta data
include "maps/MapData.asm"