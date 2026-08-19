; ------------------------------------------------------------------------------

; [ bitmask macro ]

; Combines a set of boolean values in a given namespace via boolean OR and
; and performs a given operation (prefix) on the result. Up to 16 values
; may be combined in this way. The result is also combined with the
; base_val parameter which may be an integer or any integer-valued constant.
; This macro is ideally used within another macro, so that a list of values
; can be provided to the outer macro inside braces {}, which will then be
; expanded out when that parameter is passed to this macro.

.mac make_bitmask prefix, base_val, namespace, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16
        .local @val
        @val .set 0
        .ifnblank b1
                @val .set (@val | ::namespace::b1)
        .endif
        .ifnblank b2
                @val .set (@val | ::namespace::b2)
        .endif
        .ifnblank b3
                @val .set (@val | ::namespace::b3)
        .endif
        .ifnblank b4
                @val .set (@val | ::namespace::b4)
        .endif
        .ifnblank b5
                @val .set (@val | ::namespace::b5)
        .endif
        .ifnblank b6
                @val .set (@val | ::namespace::b6)
        .endif
        .ifnblank b7
                @val .set (@val | ::namespace::b7)
        .endif
        .ifnblank b8
                @val .set (@val | ::namespace::b8)
        .endif
        .ifnblank b9
                @val .set (@val | ::namespace::b9)
        .endif
        .ifnblank b10
                @val .set (@val | ::namespace::b10)
        .endif
        .ifnblank b11
                @val .set (@val | ::namespace::b11)
        .endif
        .ifnblank b12
                @val .set (@val | ::namespace::b12)
        .endif
        .ifnblank b13
                @val .set (@val | ::namespace::b13)
        .endif
        .ifnblank b14
                @val .set (@val | ::namespace::b14)
        .endif
        .ifnblank b15
                @val .set (@val | ::namespace::b15)
        .endif
        .ifnblank b16
                @val .set (@val | ::namespace::b16)
        .endif
        prefix @val | base_val
.endmac

; ------------------------------------------------------------------------------

; [ bitflag opcode macro ]

; as an example, the two lines below are functionally equivalent:
;       ldaflg NAMESPACE, {FLAG1, FLAG2, FLAG3}
;       lda #NAMESPACE::FLAG1 | NAMESPACE::FLAG2 | NAMESPACE::FLAG3

.mac opflg op, namespace, flags
        make_bitmask op, 0, namespace, flags
.endmac

.define ldaflg opflg lda #,
.define ldxflg opflg ldx #,
.define ldyflg opflg ldy #,
.define setflg opflg ora #,
.define andflg opflg and #,
.define eorflg opflg eor #,
.define bitflg opflg bit #,
.define peaflg opflg pea,

.mac clrflg namespace, flags
        .if .asize = 8
                opflg and #$ff^, namespace, {flags}
        .else
                opflg and #$ffff^, namespace, {flags}
        .endif
.endmac

; ------------------------------------------------------------------------------
