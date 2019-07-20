SECTION "MAIN", ROM0[$0150]
;set the game boy to known consistent state
;jmps to 

InitSystem:
	;disable interrupts
	di

	;display settings
	;set interrups (only vblank is on)
	ld A, %00000001
	ld [$FFFF], A
	;disable display
	halt
	ZeroA
	ld [$FF40], a
	;clean interrups flags
	ld A, %00000000
	ld [$FF0F], A

	;reset scroll regs
	ZeroA
	ld [VRAM_SCROLL_Y], A
	ld [VRAM_SCROLL_X], A

	;tmp move stack to hram while zeroing ram
	ld SP, STACK_TMP_START
	
	;zero out WRAM0
	ld HL, WRAM0_START ;prime start wram
	call StartingStateZeroRam
	
	;zero out vram
	ld HL, VRAM_TILE_START
	call StartingStateZeroRam

	;set default pallets
	ResetAllPallets

	;move stack pointer to ram
	ld sp, stack + STACK_SIZE_MAX

	;copy oam copyer
	call DMA_COPY
	OAMCopyMacro ;zero out OAM

	;disable sound
	ZeroA
	ld [SOUND_REG_SWITCH], A
	
	;init cart banks
	;ROM Banking Mode (up to 8KByte RAM, 2MByte ROM)
	ZeroA
	ld [$6000], A ;set reg rom bank mode regs
	;select rom bank 1
	ld A, 1
	RomBankSwitchMacro
		
	;enable display
	EnableDisplayMacro
	;exit out of starting state
	jp  ExitStartingState

;Zero out Ram
;============
StartingStateZeroRam:
	;load start into HL
	;clobber BC
	ld BC, RAM_SIZE_MAX ;8k of ram
	ZeroA
.loop
	ld [HL+], a
	dec C
	jp nz, .loop
	dec B
	jp nz, .loop
	ret

;exit dont initing
;=================
ExitStartingState: