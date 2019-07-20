SECTION "MAIN", ROM0[$0150]

;draw text
;=========
;Set drawTextX/Y for X/Y
;Set drawTextPointer to start of text
;make sure screen is ready to be drawn on
DrawText:
    push AF
    push DE
    push HL
    push BC
    ;load x
    ld A, [drawTextX]
    ld B, A
    ;load y
    ld A, [drawTextY]
    ld C, A
    push BC
    ;set starting tile map pointer
    call OffsetHlBgTilemap
    ;load string pointer
    CopyR16Pointer D, E, drawTextPointer
    ;copy text
.loopCopyText:
    ;load char
    ld A, [DE]
    
    ;test if null term
    cp CHAR_NULL
    jp z, .jumpToEnd

    ;move ponter to next char
    inc DE

    ;test if new line
    cp CHAR_NEW_LINE
    jp nz, .notNewLine
    ;load start, inc y, reset HL to new y
    pop BC ;get start
    inc C ;inc y
    push BC ;save for next new line
    call OffsetHlBgTilemap ;set hl to new pos
    jp .loopCopyUpkeep

.notNewLine:
    ;offset and save to screen
    add A, CHAR_OFFSET
    ld [HL+], A

    ;copy text loop upkeep
.loopCopyUpkeep
    jp .loopCopyText

    ;exit
.jumpToEnd
    pop BC
    pop BC
    pop HL
    pop DE
    pop AF
    ret


;decode a byte to 2 hex numbers as string
;========================================
;Input A, num to decode, clobbered
;Output BC, String decode to acii
ByteToHexString:
    ;bottom nibbel
    push AF
    call ByteToHexStringHelper
    ld C, A
    ;top nibbel
    pop AF
    swap A
    call ByteToHexStringHelper
    ld B, A
    ret

ByteToHexStringHelper:
    ;used only with ByteToString
    and A, %00001111
    cp 10
    jp nc, .letter
    ;number, if less than 10
    add A, CHAR_NUMBER_START
    ret
.letter
    sub A, 10
    add A, CHAT_LETTER_START
    ret


;print num
;=========
;HL: where to output ascii, moves pointer forward also
;A: what number to conver, clobbers
ByteToDecString:
    push BC
    ld B, 0
    ld C, A
    ;200
    cp 200
    jp c, .test100
    sub 200
    ld C, A
    ld A, 50 ;2 in ascii
    ld [HL+], A
    jp .test10s
    ;100
.test100
    cp 100
    jp c, .test10s
    sub 100
    ld C, A
    ld A, 49 ;1 in ascii
    ld [HL+], A
    ;10s
.test10s
    ld A, C
    cp 10
    jp c, .lessThan10
.loop10s
    sub 10
    inc B
    cp 10
    jp nc, .loop10s
    ld C, A
    ld A, B
    add CHAR_NUMBER_START
    ld [HL+], A
    jp .test1s
    ;1s
.lessThan10
    ;write zero
    ld A, CHAR_NUMBER_START
    ld [HL+], A
.test1s
    ld A, C
    add CHAR_NUMBER_START
    ld [HL+], A 
.exit
    pop BC
    ret