



























































ResetOAMSpriteAddress::

    xor a
    ld [wSpritesUsed], a
    
    ld a, LOW(wShadowOAM)
    ld [wLastOAMAddress], a
    lda, HIGH(wShadowOAM)
    ld [wLastOAMAddress + 1], a

    ret

NextOAMSprite::

    ld a, [wSpritesUsed]
    inc a
    ld [wSpritesUsed], a

    ld a, [wLastOAMAddress]
    add sizeof_OAM_ATTRS
    ld [wLastOAMAddress], a
    ld a, HIGH(wShadowOAM)
    ld [wLastOAMAddress + 1], a


    ret 