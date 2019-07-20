;Nintendo header
Header:
SECTION "HEADER", ROM0[$0100]
	nop ;Entry point (start of program)
	jp	InitSystem

	;0104	0133	Nintendo logo (must match rom logo)	
	 DB $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	 DB $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	 DB $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	 DB "BACK ISLE",GAME_VN,0,0,0,0,0 ;Game Name (Uppercase)
	 DB $80 ;gb + gbc game
	 DB 0,0     ;0144	0145	Game Manufacturer code
	 DB $0       ;0146	0146	Super GameBoy flag (&00=normal, &03=SGB)
	 DB $3	  	  ;0147	0147	Cartridge type 
	 DB $4        ;0148	0148	Rom size (0=32k, 1=64k,2=128k etc)
	 DB $2        ;0149	0149	Cart Ram size (0=none,1=2k 2=8k, 3=32k)
	 DB $1        ;014A	014A	Destination Code (0=JPN 1=EU/US)
	 DB $0       ;014B	014B	Old Licensee code (must be &33 for SGB)
	 DB GAME_VN   ;014C	014C	Rom Version Number (usually 0)
	 DB 0         ;014D	014D	Header Checksum - ‘ones complement’ checksum of bytes 0134-014C… not needed for emulators
	 DW 0         ;014E	014F	Global Checksum – 16 bit sum of all rom bytes (except 014E-014F)… unused by gameboy
