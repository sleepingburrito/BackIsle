;A: what bank
RomBankSwitchMacro equs "ld [romBank], a\nld [$2000], a\n"

;Clear Carry Test Zero for A
CCTZ equs "or a\n"

;mult a by 16
MultAby16 equs "swap A\n"

;Zeros a
ZeroA equs "xor a"

;clobbers a
DisableSramMacro equs "ZeroA\nld [$0000], a\n"
EnableSramMacro equs "ld a, $0a\nld [$0000], a\n"

;clobbers a
DisableDisplayMacro equs "HaltCounter\nZeroA\nld [$FF40], a\n"
EnableDisplayMacro equs "ld a, SCREEN_ON_STATE\nld [$FF40], a\n"

;uses nothing
OAMCopyMacro equs "call $FF80\n"
BreakMacro equs "ld b,b\n" ;sets a breakpoint in the emulator

;frame counter and vsynce wait
HaltCounter equs "call FrameCounter\nhalt\n"

;clobbers A
ResetAllPallets: macro
    ld A, DEFAULT_PALLET
    ld [BG_COLOR_PALLET], A
	ld [OBP0_PALLET], A
	ld [OBP1_PALLET], A
    endm

;push pop all
PushAllRegs: macro
    push AF
    push HL
    push DE
    push BC
    endm

PopAllRegs: macro
    pop BC
    pop DE
    pop HL
    pop AF
    endm

;test if 2 16bit regs are =
;==========================
;arg1: reg 0 height
;arg2: reg 0 low
;arg3: reg 1 height
;arg4: reg 1 low
;clobbers a
TestEq16Bit: macro
    ld A, \1
    cp \3
    jp nz, .exit\@
    ld A, \2
    cp \4
.exit\@
    endm

;Copy a constant pointer to an address little endian
;arg0: constant address
;arg1: copy to
;clobbers A
CopyN16Pointer: macro
    push HL
    ld HL, \1
    ld A, L
    ld [\2], A
    ld A, H
    ld [\2 + 1], A
    pop HL
    endm

;Copy 16 ram pointer to 16bit reg little endian
;arg0: high byte
;arg1: low byte
;arg2: copy from
;clobbers A
CopyR16Pointer: macro
    ld A, [\3]
    ld \2, A
    ld A, [\3 + 1]
    ld \1, A
    endm

;Copy 16bit reg to ram pointer
;arg0: high byte
;arg1: low byte
;arg2: copy to
;clobber a
SetR16Pointer: macro
    ld A, \2
    ld [\3], A
    ld A, \1
    ld [\3 + 1], A
    endm


;copy a constant 16bit value int adress
;arg0 16 value
;arg1 copy to
;clobbers A
CopyConst16: macro
    push HL
    ld HL, \1
    SetR16Pointer H,L,\2
    pop HL
    endm

;arg0 value
;arg1 copy to
CopyConst8Bit: macro
    push AF
    ld A, \1
    ld [\2], A
    pop AF
    endm