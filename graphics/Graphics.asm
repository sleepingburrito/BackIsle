SECTION "Gfx0",ROMX,BANK[1]
TEXT0_GFX:
INCBIN "graphics/font.2bpp" ;size 1536

DIALOG_EXPRESS_GFX:
INCBIN "graphics/express.2bpp"


SECTION "bgTilePatterns",ROMX,BANK[6]
BgTilePat0:
INCBIN "graphics/bgTilePat0.2bpp"

BgTilePat1:
INCBIN "graphics/bgTilePat1.2bpp"


SECTION "sprites",ROMX,BANK[8]
PlayerSprite:
INCBIN "graphics/playeranimted.2bpp"