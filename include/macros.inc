
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

; [ long branch instructions ]

.mac  jeq     addr
        bne     *+5
        jmp     addr
.endmacro

.mac  jne     addr
        beq     *+5
        jmp     addr
.endmacro

.mac  jmi     addr
        bpl     *+5
        jmp     addr
.endmacro

.mac  jpl     addr
        bmi     *+5
        jmp     addr
.endmacro

.mac  jcs     addr
        bcc     *+5
        jmp     addr
.endmacro

.mac  jcc     addr
        bcs     *+5
        jmp     addr
.endmacro

.mac  jvs     addr
        bvc     *+5
        jmp     addr
.endmacro

.mac  jvc     addr
        bvs     *+5
        jmp     addr
.endmacro

; ------------------------------------------------------------------------------

; [ define near address (16-bit) ]

.define near(label) .loword(label)

; ------------------------------------------------------------------------------

; [ define bank start address ]

.define bank_start(label) .bankbyte(label) << 16

; ------------------------------------------------------------------------------

; ; [ define ROM array ]

; .mac rom_array label, array_length, item_size
;         .scope label
;         Start := label
;         _array_offset .set 0
;         .ifnblank array_length
;                 ARRAY_LENGTH = array_length
;         .endif
;         .ifnblank item_size
;                 ITEM_SIZE = item_size
;         .endif
; .endmac

; .mac end_rom_array
;         .endscope
; .endmac

; ------------------------------------------------------------------------------

; [ make jump table / label ]

.mac make_jump_tbl label, length
        .repeat length, id
        .addr   .ident(.sprintf("%s_%02x", .string(label), id))
        .endrep
.endmacro

.define make_jump_label(label, id) .ident(.sprintf("%s_%02x", .string(label), id)):

; ------------------------------------------------------------------------------

; [ make pointer table (near) ]

.mac ptr_tbl label
        .local offset
        .ifdef label::Start
                offset = label::Start
        .else
                offset = 0
        .endif
        .repeat label::ARRAY_LENGTH, i
                .addr label::.ident(.sprintf("_%d", i)) - offset
        .endrep
.endmacro

; ------------------------------------------------------------------------------

; [ make pointer table (far) ]

.mac ptr_tbl_far label
        .local offset
        .ifdef label::Start
                offset = label::Start
        .else
                offset = 0
        .endif
        .repeat label::ARRAY_LENGTH, i
                .faraddr label::.ident(.sprintf("_%d", i)) - offset
        .endrep
.endmacro

; ------------------------------------------------------------------------------

; [ make end pointer ]

.mac end_ptr label
        .ifdef label::Start
                .addr label::End - label::Start
        .else
                .addr label::End
        .endif
.endmac

.mac end_ptr_far label
        .ifdef label::Start
                .faraddr label::End - label::Start
        .else
                .faraddr label::End
        .endif
.endmac

; ------------------------------------------------------------------------------

; [ begin/end fixed length block ]

::_fixed_block_size .set 0
::_fixed_block_seq .set 0

.mac fixed_block size
        .assert ::_fixed_block_size = 0, error, "Fixed blocks can't be nested"
        .assert size > 0, error, "Invalid fixed block size"
        ::_fixed_block_size .set size
        .ident(.sprintf("_fixed_block_%d", ::_fixed_block_seq)) := *
.endmac

.mac end_fixed_block pad_val
        .assert ::_fixed_block_size <> 0, error, "Invalid fixed block"
        .local pad_size, start
        start := .ident(.sprintf("_fixed_block_%d", ::_fixed_block_seq))
        pad_size = (start - *) + ::_fixed_block_size
        .if pad_size < 0
                .error .sprintf("Fixed block too large by %d bytes", -pad_size)
        .elseif pad_size > 0
                .ifnblank pad_val
                        .res pad_size, pad_val
                .else
                        .res pad_size
                .endif
        .endif
        ::_fixed_block_size .set 0
        ::_fixed_block_seq .set ::_fixed_block_seq + 1
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

; [ include with language suffix ]

.define inc_lang(_path) .include .sprintf(_path, LANG_SUFFIX)
.define incbin_lang(_path) .incbin .sprintf(_path, LANG_SUFFIX)

; ------------------------------------------------------------------------------

.mac make_bitmask prefix, val, namespace, b1, b2, b3, b4, b5, b6, b7, b8
        .if .paramcount = 3
                prefix (val)
        .elseif .paramcount = 4
                make_bitmask prefix, val | namespace::b1, namespace
        .elseif .paramcount = 5
                make_bitmask prefix, val | namespace::b2, namespace, b1
        .elseif .paramcount = 6
                make_bitmask prefix, val | namespace::b3, namespace, b1, b2
        .elseif .paramcount = 7
                make_bitmask prefix, val | namespace::b4, namespace, b1, b2, b3
        .elseif .paramcount = 8
                make_bitmask prefix, val | namespace::b5, namespace, b1, b2, b3, b4
        .elseif .paramcount = 9
                make_bitmask prefix, val | namespace::b6, namespace, b1, b2, b3, b4, b5
        .elseif .paramcount = 10
                make_bitmask prefix, val | namespace::b7, namespace, b1, b2, b3, b4, b5, b6
        .elseif .paramcount = 11
                make_bitmask prefix, val | namespace::b8, namespace, b1, b2, b3, b4, b5, b6, b7
        .endif
.endmac

; ------------------------------------------------------------------------------

.mac opflg op, namespace, flags
        make_bitmask op, 0, namespace, flags
.endmac

.define ldaflg opflg lda #,
.define setflg opflg ora #,
.define andflg opflg and #,
.define eorflg opflg eor #,
.define bitflg opflg bit #,
.define peaflg opflg pea 0+,

.mac clrflg namespace, flags
        .if .asize = 8
                opflg and #$ff^, namespace, {flags}
        .else
                opflg and #$ffff^, namespace, {flags}
        .endif
.endmac

; ------------------------------------------------------------------------------

; [ macros for reserving RAM variables ]

.enum RAM_ADDR_SIZE
        ZP = 1
        NEAR = 2
        FAR = 3
.endenum

::_ram_offset .set 0
::_ram_verbose .set 0
::_ram_addr_size .set RAM_ADDR_SIZE::FAR
::_ram_scope_start .set 0

.define ram_org(offset) ::_ram_offset .set offset
.define ram_verbose(value) ::_ram_verbose .set value
.define ram_addr_size(size) ::_ram_addr_size .set RAM_ADDR_SIZE::size

.mac ram_label label, namespace
        .ifblank namespace
                .ident(.sprintf("%s_zp", .string(label))) := <::_ram_offset
                .ident(.sprintf("%s_near", .string(label))) := near ::_ram_offset
                .ident(.sprintf("%s_far", .string(label))) := ::_ram_offset
                .if ::_ram_addr_size = RAM_ADDR_SIZE::ZP
                        label := <::_ram_offset
                .elseif ::_ram_addr_size = RAM_ADDR_SIZE::NEAR
                        label := near ::_ram_offset
                .elseif ::_ram_addr_size = RAM_ADDR_SIZE::FAR
                        label := ::_ram_offset
                .endif
        .else
                namespace::.ident(.sprintf("%s_zp", .string(label))) := <::_ram_offset
                namespace::.ident(.sprintf("%s_near", .string(label))) := near ::_ram_offset
                namespace::.ident(.sprintf("%s_far", .string(label))) := ::_ram_offset
                .if ::_ram_addr_size = RAM_ADDR_SIZE::ZP
                        namespace::label := <::_ram_offset
                .elseif ::_ram_addr_size = RAM_ADDR_SIZE::NEAR
                        namespace::label := near ::_ram_offset
                .elseif ::_ram_addr_size = RAM_ADDR_SIZE::FAR
                        namespace::label := ::_ram_offset
                .endif
        .endif
.endmac

.mac ram_res label, size
        ; define the label
        .ifnblank label
                ram_label label

                ; define labels for array items
                .if .defined(ARRAY_LENGTH) && .defined(ITEM_SIZE)
                        .local old_offset
                        old_offset = ::_ram_offset
                        .repeat ARRAY_LENGTH, i
                                ram_label label, .ident(.sprintf("_%d", i))
                                .ifdef BLOCK_SIZE
                                        ::_ram_offset .set ::_ram_offset + BLOCK_SIZE
                                .else
                                        ::_ram_offset .set ::_ram_offset + ITEM_SIZE
                                .endif
                        .endrep
                        ::_ram_offset .set old_offset
                .endif

                ; print the label and address
                .if ::_ram_verbose
                        .if label <= $ff
                                .out .sprintf("$%02x %s", label, .string(label))
                        .elseif label <= $ffff
                                .out .sprintf("$%04x %s", label, .string(label))
                        .else
                                .out .sprintf("$%06x %s", label, .string(label))
                        .endif
                .endif

                ; define the size
                .if size <> 0
                        .scope label
                        .endscope
                        label::SIZE = size
                .endif
        .endif

        ; increment the ram offset
        ::_ram_offset .set ::_ram_offset + size
.endmac

.mac ram_byte label
        ram_res label, 1
.endmac

.mac ram_word label
        ram_res label, 2
.endmac

.mac ram_faraddr label
        ram_res label, 3
.endmac

.mac ram_dword label
        ram_res label, 4
.endmac

.mac ram_scope label
        ram_res label, 0
        .scope label
        START = ::_ram_offset
.endmac

.mac end_ram_scope
; define the size of this scope and end the scope
        .ifndef SIZE
                SIZE = ::_ram_offset - START
        .endif
        .endscope
.endmac

.mac ram_array label, array_length, item_size, num_blocks
        ram_scope label
        ITEM_SIZE = item_size
        ARRAY_LENGTH = array_length
        SIZE = ITEM_SIZE * ARRAY_LENGTH
        .ifnblank num_blocks
                ; array with more than 1 block
                .assert item_size .mod num_blocks = 0, error, "Item size must be divisible by the number of blocks"
                BLOCK_SIZE = item_size / num_blocks
                NUM_BLOCKS = num_blocks
                block_start .set START
        .endif

        ; create namespaces for each array item
        .repeat ARRAY_LENGTH, i
                .scope .ident(.sprintf("_%d", i))
                .endscope
                ::_ram_offset .set START + i * ITEM_SIZE
                ram_label .ident(.sprintf("_%d", i)), label
        .endrep
        ::_ram_offset .set START
.endmac

.mac end_ram_array
        ; make sure we didn't overflow
        .local bytes_over
        .ifdef BLOCK_SIZE
                bytes_over = ::_ram_offset - block_start - BLOCK_SIZE
                .assert bytes_over <= 0, error, .sprintf("Array block too large by %d bytes", bytes_over)
        .else
                bytes_over = ::_ram_offset - START - ITEM_SIZE
                .assert bytes_over <= 0, error, .sprintf("Array item too large by %d bytes", bytes_over)
        .endif

        ; increment the RAM offset
        ::_ram_offset .set START + SIZE
        end_ram_scope
.endmac

.mac end_ram_block
        ; check if the block overflowed
        .local bytes_over
        bytes_over = ::_ram_offset - block_start - BLOCK_SIZE
        .assert bytes_over <= 0, error, .sprintf("Array block too large by %d bytes", bytes_over)

        ; go to the next block
        ::_ram_offset .set block_start + BLOCK_SIZE * ARRAY_LENGTH
        block_start .set ::_ram_offset
.endmac

.define array_item(array, index) array::.ident(.sprintf("_%d", index))
.define array_member(array, index, member) array::.ident(.sprintf("_%d", index))::member
.define array_label(array, index) array_item array, {index} := *

; ------------------------------------------------------------------------------

.endif
.list on

; ------------------------------------------------------------------------------
