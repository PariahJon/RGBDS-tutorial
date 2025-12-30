
INCLUDE "galactic-armada/src/main/utils/hardware.inc"

SECTION "Interrupts", ROM0

DisableInterrupts::
    xor a
    ldh [rSTAT], a
    di 
    ret 

InitStateInterrupts::

    ld a, IEF_STAT
    ldh [rIE], a
    xor a
    ldh [rIF], a
    ei 

    ; This makes our stat interrupts occur when the current scanline is equal to the rLYC register
    ld a, STATF_LYC
    ldh [rSTAT], a

    ; We'll start wit the first scanline
    ; The first stat interrupt will call the next time rLY = 0
    xor a
    ldh [rLYC], a

    ret 

; Define a new section and hard-code it to be at $0048.
SECTION "Stat Interrupt", ROM0[$0048]
StatIntterupt:

    push af

    ; Check if we are on the first scanline
    ldh a, [rLYC]
    and a
    jp z, LYCEqualsZero

LYCEquals8:

    ; Don't call the next stat intterupt until scanline 8
    xor a
    ldh [rLYC], a

    ; Turn the LCD on include sprites. But no window
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINOFF | LCDCF_WIN9C00
    ldh [rLCDC], a

    jp EndStatInterrupts

LYCEqualsZero:

    ; Don't call the next stat interrupt until scanline 8
    ld a, 8
    ldh [rLYC], a

    ; Turn the LCD on including the window. But no sprites
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
    ldh [rLCDC], a


EndStatInterrupts:

    pop af

    reti