INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "Background Variables", WRAM0

mBackgroundScroll:: dw

SECTION "Gameplay Background Section", ROM0

starFieldMap: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd:

starFieldTileData: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd:

InitializeBackground::

    ; Copy the tile data
    ld de, starFieldTileData ; de contains the address where data will be copied from ;
    ld hl, $9340 ; hl contains the address where the data will bec opied to;
    ld bc, starFieldTileDataEnd - starFieldTileData ; bc contains how many bytes we have to copy.
    call CopyDEintoMemoryAtHL

    ; Copy the tilemap
    ld de, starFieldMap
    ld hl, $9800
    ld bc, starFieldMapEnd - starFieldMap
    call CopyDEintoMemoryAtHL_With52Offset

    xor a
    ld [mBackgroundScroll], a
    ld [mBackgroundScroll + 1], a
    ret 

; This is called during gameplay state on every frame
UpdateBackground::

    ; Increase our scaled integer by 5
    ; Get our true (non-scaled) value, and save it for later usage in bc
    ld a, [mBackgroundScroll]
    add a, 5
    ld b, a
    ld [mBackgroundScroll], a
    ld a, [mBackgroundScroll + 1]
    adc 0
    ld c, a
    ld [mBackgroundScroll + 1], a

    ; Descale our scaled integer
    ; shift bits to the right 4 spaces
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    ; Use the de-scaled low byte as the backgrounds position
    ld a, b
    ld [rSCY], a
    ret 