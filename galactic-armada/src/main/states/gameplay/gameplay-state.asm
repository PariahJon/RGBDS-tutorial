INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "Gameplay Variables", WRAM0 

wScore:: ds 6
wLives:: db

SECTION "Gameplay State", ROM0

wScoreText:: db "score", 255
wLivesText:: db "lives", 255

InitGameplayState::

    ld a, 3
    ld [wLives], a

    xor a
    ld [wScore], a
    ld [wScore + 1], a
    ld [wScore + 2], a
    ld [wScore + 3], a
    ld [wScore + 4], a
    ld [wScore + 5], a

    call InitializeBackground
    call InitializePlayer
    call InitializeBullets
    call InitializeEnemies

    ; Initiate STAT interrupts
    call InitStatInterrupts

    ;;;;;
    ;;;;;

    ; Call Our function that draws text onto background/window tiles
    ld de, $9C00
    ld hl, wScoreText
    call DrawTextTilesLoop

    ; Call Our function that draws text onto background/window tiles
    ld de, $9C0D
    ld hl, wLivesText
    call DrawTextTilesLoop

    ;;;;;
    ;;;;;

    call DrawScore
    call DrawLives

    ld a, 0
    ld [rWY], a

    ld a, 7
    ld [rWX], a

    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00 | LCDCF_BG9800
    ld [rLCDC], a

    ret 

UpdateGameplayState::

    ; save the keys last frame
    ld a, [wCurKeys]
    ld [wLastKeys], a

    ; This is in input.asm
    ; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
    ; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
    ; So it's best to use some tested code
    call Input

    ; from: https://github.com/eievui5/gb-sprobj-lib
    ; Then put a call to ResetShadowOAM at the beginning of your main loop.
    call ResetShadowOAM
    call ResetOAMSpriteAddress

    call UpdatePlayer
    call UpdateEnemies
    call UpdateBullets
    call UpdateBackground

    ; Clear remaining sprites to avoid lingering rogue sprites
    call ClearRemainingSprites

    ld a, [wLives]
    cp 250 
    jp nc, EndGamplay

    ;;;;;
    ; Call our function that performs the code
    call WaitForOneVBlank
    ;;;;;

    ; from: https://github.com/eievui5/gb-sprobj-lib
    ; Finally, run the following code during VBlank:
    ld a, HIGH(wShadowOAM)
    call hOAMDMA

    ;;;;;
    ; Call our function that performs the code
    call WaitForOneVBlank
    ;;;;;

    jp UpdateGameplayState

EndGameplay:

    ld a, 0
    ld [wGameState], a
    jp NextGameState