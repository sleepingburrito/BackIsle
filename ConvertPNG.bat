del graphics\font.2bpp
del graphics\express.2bpp
del graphics\bgTilePat0.2bpp
del graphics\bgTilePat1.2bpp

..\Z80GBTools\rgbds\win64\rgbgfx -o graphics\font.2bpp graphics\font0.png
..\Z80GBTools\rgbds\win64\rgbgfx -o graphics\express.2bpp graphics\express.png
..\Z80GBTools\rgbds\win64\rgbgfx -o graphics\bgTilePat0.2bpp graphics\bgTilePat0.png
..\Z80GBTools\rgbds\win64\rgbgfx -o graphics\bgTilePat1.2bpp graphics\bgTilePat1.png

pause