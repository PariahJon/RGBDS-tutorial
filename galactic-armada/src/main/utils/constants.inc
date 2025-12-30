


























; from https://rgbds.gbdev.io/docs/v0.6.1/rgbasm.5#EXPRESSIONS
; The RS group of commands is a handy way of defining structure offsets:
RSRESET 
DEF bullet_activeByte           RB      1
DEF bullet_xByte                RB      1
DEF bullet_yLowByte             RB      1
DEF bullet_yHighByte            RB      1
DEF PER_BULLET_BYTES_COUNT      RB      0

RSRESET 
DEF spriteTilesStart            RB      _VRAM
DEF PLAYER_TILES_START          RB      4*16
DEF ENEMY_TILES_START           RB      4*16
DEF BULLET_TILES_START          RB      0

