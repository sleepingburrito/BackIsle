SECTION "MAIN", ROM0[$0150]
include "graphics/BackgroundHelper.asm"
include "graphics/SpriteHelper.asm"

;inti graphics
;==============
;clobbers all regs
InitGraphics:
    ;disable display
	DisableDisplayMacro
    
    ;load font
    ld A, VRAM_TEXT0_BANK
    RomBankSwitchMacro
    ld HL, TEXT0_GFX
	ld DE, VRAM_TEXT_PARTITION
	ld BC, VRAM_TEXT_PARTITION_LENGTH
	call Copy

    ;end
    EnableDisplayMacro

    ret


;fade screen then turn LCD off
;=============================
;fade out animation ends with LCD disabled
FadeDisplayOff:
    push AF

    HaltCounter
    ld A, %10010000
    ld [BG_COLOR_PALLET], A
    ld [OBP0_PALLET], A
    ld [OBP1_PALLET], A
    rept 2
    HaltCounter
    endr

    ld A, %01000000
    ld [BG_COLOR_PALLET], A
    ld [OBP0_PALLET], A
    ld [OBP1_PALLET], A
    rept 2
    HaltCounter
    endr

    DisableDisplayMacro
    pop AF
    ret


;turn LCD On than fade in
;=========================
;opposite of FadeDisplayOff
FadeDisplayOn:
    push AF
    EnableDisplayMacro
    HaltCounter

    ld A, %01000000
    ld [BG_COLOR_PALLET], A
    ld [OBP0_PALLET], A
    ld [OBP1_PALLET], A
    rept 2
    HaltCounter
    endr
    ld A, %10010000
    ld [BG_COLOR_PALLET], A
    ld [OBP0_PALLET], A
    ld [OBP1_PALLET], A
    rept 2
    HaltCounter
    endr
    ResetAllPallets

    pop AF
    ret
