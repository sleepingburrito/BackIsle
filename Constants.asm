;game version number VN
GAME_VN = "0"

;sram init
;=========
GAME_NAME_LENGTH = 10
SRAM_CHECKSOME_SIZE = 1
SRAM_HEADER_MAX = SRAM_CHECKSOME_SIZE + GAME_NAME_LENGTH ;number of bytes to check for same file

;drawing
;=======
SCREEN_ON_STATE = %10000011

;text
;====
CHAR_NEW_LINE = 13
CHAR_NULL = 0
CHAR_SPACE = 32
CHAR_OFFSET = $60 ;offset for bg tile map to get to text

;for decoding a byte, ascii value with no offset
CHAR_NUMBER_START = 48 
CHAT_LETTER_START = 65

;stack
;=====
STACK_SIZE_MAX = 2 * 128 ;2 bytes per push
STACK_TMP_START = $FFFE ;only used when initing system

;mem map
;=======
;rom
ROM_BANK_START = $4000
ROM_BANK_SIZE = $4000

;hiram
HI_RAM_START = $FF80
HI_RAM_LENGTH = $80

;ram
WRAM0_START = $C000
SRAM_START = $A000
RAM_SIZE_MAX = $2000 ;8k, both SRAM and WRAM

;video
VRAM_TILE_START = $8000 ;8000 - 97F0, 8000 - 8FFF sprites only
VRAM_TILE_SIZE = $1800;$17F0

VRAM_BG_TILE_START = $8800 ;8800-97FF
VRAM_BG_TILE_LENGTH = $1000

VRAM_TILEMAP_BG_START = $9800 ;9800-9BFF
VRAM_TILEMAP_BG_LENGTH = $400

VRAM_SCROLL_Y = $FF42
VRAM_SCROLL_X = $FF43


;sprites start/end
VRAM_SPRITE_START = VRAM_TILE_START
VRAM_SPRITE_LENGTH = $800

;text/ui start/length
VRAM_TEXT_PARTITION = $8800
VRAM_TEXT_PARTITION_LENGTH = 1536

;bg tiles start/length
VRAM_BG_TILES_PARTITION = $9000
VRAM_BG_TILES_PARTITION_LENGTH = VRAM_SPRITE_LENGTH

;joypad
JOY_PAD_REG = $FF00

;sound
SOUND_REG_SWITCH = $ff26

;color pallet regaster bg
BG_COLOR_PALLET = $FF47
OBP0_PALLET = $FF48
OBP1_PALLET = $FF49

;joypad button mapping
;=====================
PAD_UP = %01000000
PAD_UP_BIT = 6
PAD_DOWN = %10000000
PAD_DOWN_BIT = 7
PAD_LEFT = %00100000
PAD_LEFT_BIT = 5
PAD_RIGHT = %00010000
PAD_RIGHT_BIT = 4
PAD_A = %00000010
PAD_A_BIT = 1
PAD_B = %00000001
PAD_B_BIT = 0
PAD_START = %00001000
PAD_START_BIT = 3
PAD_SELECT = %00000100
PAD_SELECT = 2

;tiles
;======
TILE_WIDTH_COUNT = 20 ;on screen
TILE_HEIGHT_COUNT = 18 ;on screen
TILE_WIDTH_OFFSCREEN = 12
TILE_WIDTH_TOTAL = 32 ;on and offscreen


TILE_WIDTH_PIXEL = 8
TILE_HEIGHT_PIXEL = TILE_WIDTH_PIXEL

TILE_SIZE_BYTES = 16


;timers
;======
TIMER_COUNT_MAX = 30


;temps
;=====
;used to give different names to tmpVars


;directions
;==========
DIR_NON = 0
DIR_UP = 1
DIR_DOWN = 2
DIR_LEFT = 3
DIR_RIGHT = 4
DIR_COUNT = 5

;Rom Banks
;=============
VRAM_TEXT0_BANK = 1
DIALOG_DATA_BANK = 2


;dialogue
;=========
DILOG_CHANGE_EXPRESSION = 1 ;followed by an id of what expression
DILOG_CHANGE_MAX_TEXT_ON_SCREEN = 32
DILOG_TIMER_WAIT = 0 ;number of frames till user and see the next text

DILOG_DRAW_X = 4
DILOG_DRAW_Y = 1

DILOG_STATE_NON = 0
DILOG_STATE_ANIMATING = 1
DILOG_STATE_WAITING_FOR_USER = 2

DILOG_BOX_START = $9800 ;start of tile map in bg
DILOG_BOX_LENGTH = 80 ;in tiles, all of them for the box. its width x height
DILOG_CLEAR_TILEID = 32 + CHAR_OFFSET

DILOG_EXPRESS_WIDTH = 4 ;in tiles
DILOG_EXPRESS_HEIGHT = DILOG_EXPRESS_WIDTH
DILOG_EXPRESS_SIZE_TILES = DILOG_EXPRESS_WIDTH * DILOG_EXPRESS_WIDTH
DILOG_EXPRESS_SIZE_BYTES = 16 * DILOG_EXPRESS_SIZE_TILES ;how many bytes to load into the tile map
DILOG_EXPRESS_TILES_COPYTO = $8E00 ;copy pattern to here
DILOG_EXPRESS_BG_TILEMAP_START = DILOG_BOX_START 
DILOG_EXPRESS_TILES_STARTINGID = $E0 ;tile id for the tile map

;map
;===
MAP_WIDTH_SCREEN_TILES = TILE_WIDTH_COUNT
MAP_HEIGHT_SCREEN_TILES = TILE_HEIGHT_COUNT
MAP_WIDTH_SCREENS = 6
MAP_HEIGHT_SCREENS = MAP_WIDTH_SCREENS

;SameStates
;==========
GAME_STATE_OVERWORLD = 0
GAME_STATE_BATTLE = 1


;map
;===
MAP_WIDTH_SCREEN_TILES = TILE_WIDTH_COUNT
MAP_HEIGHT_SCREEN_TILES = TILE_HEIGHT_COUNT

MAP_SCREEN_TOTAL_TILES = MAP_WIDTH_SCREEN_TILES * MAP_HEIGHT_SCREEN_TILES
MAP_WIDTH_SCREENS = 6
MAP_HEIGHT_SCREENS = MAP_WIDTH_SCREENS

TOTAL_MAP_WIDTH_TILES = MAP_WIDTH_SCREEN_TILES *  MAP_WIDTH_SCREENS

;Rom bank code location to set map meta data
MAP_MAP_META_DATA = $72A0


;bg color pallet
;===============
DEFAULT_PALLET = %11100100


;sprites
;=======
SPRITE_MAX = 40
SPRITE_BYTES = 4
SPRITE_OAM_SIZE_MAX_BYTES = SPRITE_MAX * SPRITE_BYTES
SPRITE_START_HIGHBYTE = $C0

;add this to get to top/left of screen
SPRITE_X_OFFSET = 8
SPRITE_Y_OFFSET = 16


SPRITE_MAX_Y = 160
SPRITE_MAX_X = 168