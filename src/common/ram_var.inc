; ------------------------------------------------------------------------------

; [ macros for reserving RAM variables ]

::_ram_offset .set 0
::_ram_verbose .set 0
::_ram_scope_start .set 0

.define ram_org(offset) ::_ram_offset .set offset
.define ram_verbose(value) ::_ram_verbose .set value

::_ram_verbose_stack .set 0

.mac push_ram_verbose
        ::_ram_verbose_stack .set ::_ram_verbose
        ::_ram_verbose .set 0
.endmac

.mac pop_ram_verbose
        ::_ram_verbose .set ::_ram_verbose_stack
.endmac

::_ram_offset_stack .set -1

.mac push_ram_offset
        .assert ::_ram_offset_stack = -1, error, "use pop_ram_offset first"
        ::_ram_offset_stack .set ::_ram_offset
.endmac

.mac pop_ram_offset
        .assert ::_ram_offset_stack <> -1, error, "use push_ram_offset first"
        ::_ram_offset .set ::_ram_offset_stack
        ::_ram_offset_stack .set -1
.endmac

.mac ram_label label, namespace
        .ifblank namespace
                label := ::_ram_offset
        .else
                namespace::label := ::_ram_offset
        .endif
.endmac

.mac ram_res size, label
        ; define the label
        .ifnblank label
                ram_label label

                ; define labels for array items
                .if .defined(COUNT) && .defined(ITEM_SIZE)
                        .local old_offset
                        old_offset = ::_ram_offset
                        .repeat COUNT, i
                                ram_label label, .ident(.sprintf("_%d", i))
                                ::_ram_offset .set ::_ram_offset + BLOCK_SIZE
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
        ram_res 1, label
.endmac

.mac ram_word label
        .ifnblank label
        ram_res 0, label
        push_ram_verbose
        ram_byte .ident(.concat(.string(label), "_L"))
        ram_byte .ident(.concat(.string(label), "_H"))
        pop_ram_verbose
        .else
        ram_res 2, label
        .endif
.endmac

.mac ram_faraddr label
        .ifnblank label
        ram_res 0, label
        push_ram_verbose
        ram_byte .ident(.concat(.string(label), "_L"))
        ram_byte .ident(.concat(.string(label), "_H"))
        ram_byte .ident(.concat(.string(label), "_B"))
        pop_ram_verbose
        .else
        ram_res 3, label
        .endif
.endmac

.mac ram_dword label
        ram_res 4, label
.endmac

.mac ram_scope label
        ram_res 0, label
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

.mac ram_array label, count, item_size, block_size
        ram_scope label
        ITEM_SIZE = item_size
        COUNT = count
        SIZE = ITEM_SIZE * COUNT
        .ifnblank block_size
                ; array with more than 1 block
                .assert item_size .mod block_size = 0, error, "Item size must be divisible by block size"
                BLOCK_SIZE = block_size
                NUM_BLOCKS = item_size / block_size
                ::_block_start .set START
        .else
                BLOCK_SIZE = item_size
                NUM_BLOCKS = 1
        .endif

        ; create namespaces for each array item
        .repeat COUNT, i
                .scope .ident(.sprintf("_%d", i))
                .endscope
                ::_ram_offset .set START + i * ITEM_SIZE / NUM_BLOCKS
                ram_label .ident(.sprintf("_%d", i)), label
        .endrep
        ::_ram_offset .set START

        .repeat NUM_BLOCKS, i
                ::_ram_offset .set START + i * BLOCK_SIZE * COUNT
                ram_label .ident(.sprintf("BLOCK_%d", i)), label
                .repeat COUNT, j
                        ram_label .ident(.sprintf("BLOCK_%d", i)), label::.ident(.sprintf("_%d", j))
                        ::_ram_offset .set ::_ram_offset + ITEM_SIZE / NUM_BLOCKS
                .endrep
        .endrep
        ::_ram_offset .set START
.endmac

.mac end_ram_array
        ; make sure we didn't overflow
        .local bytes_over
        .if NUM_BLOCKS > 1
                bytes_over = ::_ram_offset - ::_block_start - BLOCK_SIZE
                .assert bytes_over <= 0, error, .sprintf("Array block too large by %d bytes", bytes_over)
        .else
                bytes_over = ::_ram_offset - START - ITEM_SIZE
                .assert bytes_over <= 0, error, .sprintf("Array item too large by %d bytes", bytes_over)
        .endif

        ; increment the RAM offset
        ::_ram_offset .set START + SIZE
        end_ram_scope
.endmac

.mac ram_byte_array label, length
        ram_array label, length, 1
        end_ram_array
.endmac

.mac ram_word_array label, length
        ram_array label, length, 2
        end_ram_array
.endmac

.mac ram_faraddr_array label, length
        ram_array label, length, 3
        end_ram_array
.endmac

.mac ram_dword_array label, length
        ram_array label, length, 4
        end_ram_array
.endmac

.mac end_ram_block
        ; check if the block overflowed
        .local bytes_over
        bytes_over = ::_ram_offset - ::_block_start - BLOCK_SIZE
        .assert bytes_over <= 0, error, .sprintf("Array block too large by %d bytes", bytes_over)

        ; go to the next block
        ::_ram_offset .set ::_block_start + BLOCK_SIZE * COUNT
        ::_block_start .set ::_ram_offset
.endmac

; ------------------------------------------------------------------------------
