SECTION "MAIN", ROM0[$0150]

;copy data
;========
Copy:
    ;hl: pointer from
    ;de: point to
    ;bc: size
    ;a is clobbered

    ;check if b is alreay zero
    ;if so inc by 1 to not break loop upkeep for B
    ld a, B
    CCTZ
    jp nz, .loop
    inc B

.loop:
	;copy
    ld a, [hl+]
	ld [de], a
    inc de

    ;loop upkeep c
	dec c
	jp nz, .loop
    
    ;loop upkeep B
	dec B
	jp nz, .loop

	ret


;Map to tile cords
;===============
;arg/return a
MapCordsToTile: ;mult by 8
    rept 3
    add A
    endr
    ret 
    
