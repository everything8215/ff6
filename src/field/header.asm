
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: header.asm                                                           |
; |                                                                            |
; | description: snes cartridge header                                         |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.segment "interrupt"

begin_block JmpReset, $10
@ff00:  sei
        clc
        xce
        jml     Reset
end_block JmpReset

; ------------------------------------------------------------------------------

; [ nmi ]

JmpNMI:
@ff10:  jml     $001500

; ------------------------------------------------------------------------------

; [ irq ]

JmpIRQ:
@ff14:  jml     $001504

; ------------------------------------------------------------------------------

.segment "snes_header_ext"

.if LANG_EN

begin_block SnesHeaderExt, $10
@ffb0:
        .byte   "C3"                    ; publisher: squaresoft
        .byte   "F6  "                  ; game code
end_block SnesHeaderExt, 0
.endif

; ------------------------------------------------------------------------------

.segment "snes_header"

SnesHeader:
@ffc0:
.if LANG_EN
        .byte   "FINAL FANTASY 3      " ; rom title (U)
.else
        .byte   "FINAL FANTASY 6      " ; rom title (J)
.endif
        .byte   $31                     ; HiROM, FastROM
        .byte   $02                     ; rom + ram + sram
        .byte   $0c                     ; rom size: 48 Mbit
        .byte   $03                     ; sram size: 64 kbit
.if LANG_EN
        .byte   $01                     ; destination: north america
        .byte   $33                     ; use extended header
.else
        .byte   $00                     ; destination: japan
        .byte   $c3                     ; publisher: squaresoft
.endif
        .byte   ROM_VERSION             ; revision number (0 or 1)
        .word   0                       ; checksum (calculate later)
HeaderChecksum:
        .word   $ffff                   ; inverse checksum

; ------------------------------------------------------------------------------

.segment "vectors"

@ffe0:  .res    10
@ffea:  .addr   JmpNMI
        .res    2
@ffee:  .addr   JmpIRQ
        .res    12
@fffc:  .addr   JmpReset
        .res    2

; ------------------------------------------------------------------------------
