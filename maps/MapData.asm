;maps are 6x6 screen
;screen is 20x18 tiles
;map data has meta data for walls and tile pattern id and bank

SECTION "MapData",ROMX,BANK[3]
include "maps/Floor0TileMap.asm"
include "maps/Floor0MetaData.asm"

;SECTION "MapData",ROMX,BANK[4]
;include "maps/Floor1TileMap.asm"
;include "maps/Floor1MetaData.asm"

;SECTION "MapData",ROMX,BANK[5]
;include "maps/Floor2TileMap.asm"
;include "maps/Floor2MetaData.asm"