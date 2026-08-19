.include "src/text/dlg.inc"

.export DTETbl, DlgBankInc, DlgPtrs

; ------------------------------------------------------------------------------

; c0/dfa0
.segment "dte_tbl"

DTETbl:
.if LANG_EN
        .incbin "assets/text/dte_tbl.bin"
.else
        .res $0100
.endif

; ------------------------------------------------------------------------------

; cc/e600
.segment "dialogue_ptrs"

; find the first dialogue index in the second bank
DlgBankInc:
        @first_bank .set 1
        .repeat DLG::COUNT, i
                .if @first_bank .and $ffff <= array_item DLG, i
                .word i
                @first_bank .set 0
                .endif
        .endrep
        .if @first_bank
                .word $ffff
                ; .out "Only one dialogue bank needed"
        .endif

DlgPtrs:
        ptr_tbl DLG

; ------------------------------------------------------------------------------

; cd/0000
.segment "dialogue"

.if LANG_EN
        fixed_block $01f100
.else
        fixed_block $01b000
.endif

Dlg:   .incbin "assets/text/dlg.bin"
        end_fixed_block

; ------------------------------------------------------------------------------
