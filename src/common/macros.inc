
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: macros.inc                                                           |
; |                                                                            |
; | description: macro definitions                                             |
; |                                                                            |
; | created: 8/2/2022                                                          |
; |                                                                            |
; | author: everything8215@gmail.com                                           |
; +----------------------------------------------------------------------------+

.list off
.ifndef MACROS_INC
MACROS_INC = 1

; ------------------------------------------------------------------------------

; [ clr_a/x/y ]

; clear accumulator, x, y registers
; note: don't use if dp register is nonzero

.mac clr_a
        tdc
.endmacro

.mac clr_ax
        clr_a
        tax
.endmacro

.mac clr_ay
        clr_a
        tay
.endmacro

.mac clr_axy
        clr_a
        tax
        tay
.endmacro

.mac clr_ayx
        clr_a
        tay
        tax
.endmacro

; ------------------------------------------------------------------------------

; [ set the size of accumulator/index registers ]

PSW_A = %00100000
PSW_I = %00010000
PSW_C = %00000001

.mac longa
        .a16
        rep #PSW_A
.endmacro

.mac shorta
        .a8
        sep #PSW_A
.endmacro

.mac shorta0                          ; battle code almost always clears
        clr_a                           ; accumulator before a shorta
        shorta
.endmacro

.mac longi
        .i16
        rep #PSW_I
.endmacro

.mac shorti
        .i8
        sep #PSW_I
.endmacro

.mac longai
        .a16
        .i16
        rep #PSW_A|PSW_I
.endmacro

.mac shortai
        .a8
        .i8
        sep #PSW_A|PSW_I
.endmacro

; ------------------------------------------------------------------------------

; [ set the size of accumulator/index registers and carry ]

.mac longa_clc
        .a16
        rep #PSW_A|PSW_C
.endmacro

.mac shorta_sec
        .a8
        sep #PSW_A|PSW_C
.endmacro

.mac longi_clc
        .i16
        rep #PSW_I|PSW_C
.endmacro

.mac shorti_sec
        .i8
        sep #PSW_I|PSW_C
.endmacro

.mac longai_clc
        .a16
        .i16
        rep #PSW_A|PSW_I|PSW_C
.endmacro

.mac shortai_sec
        .a8
        .i8
        sep #PSW_A|PSW_I|PSW_C
.endmacro

; ------------------------------------------------------------------------------

; [ repeated operation ]

.mac op_n op, n
        .repeat n
        op
        .endrep
.endmac

; no operation
.define nop2 op_n nop, 2
.define nop3 op_n nop, 3
.define nop4 op_n nop, 4
.define nop5 op_n nop, 5
.define nop6 op_n nop, 6
.define nop7 op_n nop, 7
.define nop8 op_n nop, 8

; shift left
.define asl2 op_n asl, 2
.define asl3 op_n asl, 3
.define asl4 op_n asl, 4
.define asl5 op_n asl, 5
.define asl6 op_n asl, 6
.define asl7 op_n asl, 7
.define asl8 op_n asl, 8

; shift right
.define lsr2 op_n lsr, 2
.define lsr3 op_n lsr, 3
.define lsr4 op_n lsr, 4
.define lsr5 op_n lsr, 5
.define lsr6 op_n lsr, 6
.define lsr7 op_n lsr, 7
.define lsr8 op_n lsr, 8

; rotate left
.define rol2 op_n rol, 2
.define rol3 op_n rol, 3
.define rol4 op_n rol, 4
.define rol5 op_n rol, 5
.define rol6 op_n rol, 6
.define rol7 op_n rol, 7
.define rol8 op_n rol, 8

; rotate right
.define ror2 op_n ror, 2
.define ror3 op_n ror, 3
.define ror4 op_n ror, 4
.define ror5 op_n ror, 5
.define ror6 op_n ror, 6
.define ror7 op_n ror, 7
.define ror8 op_n ror, 8

; increment
.define inc2 op_n inc, 2
.define inc3 op_n inc, 3
.define inc4 op_n inc, 4
.define inc5 op_n inc, 5
.define inc6 op_n inc, 6
.define inc7 op_n inc, 7
.define inc8 op_n inc, 8

; decrement
.define dec2 op_n dec, 2
.define dec3 op_n dec, 3
.define dec4 op_n dec, 4
.define dec5 op_n dec, 5
.define dec6 op_n dec, 6
.define dec7 op_n dec, 7
.define dec8 op_n dec, 8

; increment x
.define inx2 op_n inx, 2
.define inx3 op_n inx, 3
.define inx4 op_n inx, 4
.define inx5 op_n inx, 5
.define inx6 op_n inx, 6
.define inx7 op_n inx, 7
.define inx8 op_n inx, 8

; decrement x
.define dex2 op_n dex, 2
.define dex3 op_n dex, 3
.define dex4 op_n dex, 4
.define dex5 op_n dex, 5
.define dex6 op_n dex, 6
.define dex7 op_n dex, 7
.define dex8 op_n dex, 8

; increment y
.define iny2 op_n iny, 2
.define iny3 op_n iny, 3
.define iny4 op_n iny, 4
.define iny5 op_n iny, 5
.define iny6 op_n iny, 6
.define iny7 op_n iny, 7
.define iny8 op_n iny, 8

; decrement y
.define dey2 op_n dey, 2
.define dey3 op_n dey, 3
.define dey4 op_n dey, 4
.define dey5 op_n dey, 5
.define dey6 op_n dey, 6
.define dey7 op_n dey, 7
.define dey8 op_n dey, 8

; ------------------------------------------------------------------------------

; [ invert and negate the A register ]

; bitwise inverse, i.e. logical not (1's complement)
.mac not_a
        .if .asize = 8
                eor #$ff
        .else
                eor #$ffff
        .endif
.endmac

; negate (2's complement)
.mac neg_a
        not_a
        inc
.endmac

; ------------------------------------------------------------------------------

.include "src/common/longbranch.inc"

; ------------------------------------------------------------------------------

; [ define near address (16-bit) ]

.define near(label) .loword(label)

; ------------------------------------------------------------------------------

; [ define bank start address ]

.define bank_start(label) .bankbyte(label) << 16

; ------------------------------------------------------------------------------

; [ combine two bytes to make a word ]

.define make_word(low, high) ((<low) | (<high << 8))

; ------------------------------------------------------------------------------

; [ array / pointer table macros ]

.define array_item(array, index) ::array::.ident(.sprintf("_%d", index))
.define array_member(array, index, member) array_item array, {index}::member
.define array_offset(array, index) (array_item array, {index} - array)
.define array_member_offset(array, index, member) (array_member array, index, {member} - array)

.mac array_label array, index
        array_item array, {index} := *
.endmac

.mac array_op op, array, index
        op array_item array, index
.endmac

; PTR_OFFSET gets added to every pointer
; BASE_PTR gets subtracted from every pointer
.mac _ptr_tbl op, label, count
        .local offset
        .ifdef ::label::PTR_OFFSET
                offset = ::label::PTR_OFFSET
        .elseif .defined(::label::BASE_PTR)
                offset = -::label::BASE_PTR
        .else
                offset = 0
        .endif
        .ifnblank count
                .repeat count, i
                        op offset + array_item label, i
                .endrep
        .else
                .repeat ::label::COUNT, i
                        op offset + array_item label, i
                .endrep
        .endif
.endmac

.mac _end_ptr op, label
        .ifdef ::label::PTR_OFFSET
                op ::label::END + ::label::PTR_OFFSET
        .elseif .defined(::label::BASE_PTR)
                op ::label::END - ::label::BASE_PTR
        .else
                op ::label::END
        .endif
.endmac

.mac ptr_tbl label, count
        _ptr_tbl .addr, label, count
.endmacro

.mac end_ptr label
        _end_ptr .addr, label
.endmac

.mac ptr_tbl_far label, count
        _ptr_tbl .faraddr, label, count
.endmacro

.mac end_ptr_far label
        _end_ptr .faraddr, label
.endmac

; ------------------------------------------------------------------------------

; [ calculate the size of assembled bytecode ]

; place this macro at the end of a block to define a symbol "sizeof_<labal>"
; equal to the size of the block (i.e. the distance from the label to the
; current program counter).

.mac calc_size label
        .ident(.concat("sizeof_", .string(label))) = * - label
.endmac

; ------------------------------------------------------------------------------

; ; [ include with language suffix ]

; .define inc_lang(_path) .include .sprintf(_path, LANG_SUFFIX)
; .define incbin_lang(_path) .incbin .sprintf(_path, LANG_SUFFIX)

; ------------------------------------------------------------------------------

.include "src/common/fixed_block.inc"
.include "src/common/bitmask.inc"
.include "src/common/hdma.inc"
.include "src/common/ram_var.inc"
.include "src/common/bitlist.inc"

; ------------------------------------------------------------------------------

.endif
.list on

; ------------------------------------------------------------------------------
