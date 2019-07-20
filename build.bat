..\Z80GBTools\rgbds\win64\rgbasm -o build\main.o Main.asm
..\Z80GBTools\rgbds\win64\rgblink -d -m build\main.map -n build\main.sym -o build\main.gb build\main.o
..\Z80GBTools\rgbds\win64\rgbfix -v -p 0 build\main.gb
pause