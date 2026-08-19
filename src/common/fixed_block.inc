; [ begin/end fixed length block ]

::_fixed_block_size .set 0
::_fixed_block_seq .set 0

.mac fixed_block size
        .assert ::_fixed_block_size = 0, error, "Fixed blocks can't be nested"
        .assert size > 0, error, "Invalid fixed block size"
        ::_fixed_block_size .set size
        ::.ident(.sprintf("_fixed_block_%d", ::_fixed_block_seq)) := *
.endmac

.mac big_res pad_size, pad_val
        .local max_block, curr_pad_size
        max_block = $8000
        curr_pad_size .set pad_size .mod max_block
        .repeat (pad_size + max_block - 1) / max_block
                .ifnblank pad_val
                        .res curr_pad_size, pad_val
                .else
                        .res curr_pad_size
                .endif
                curr_pad_size .set $8000
        .endrep
.endmac

.mac end_fixed_block pad_val
        .assert ::_fixed_block_size <> 0, error, "Invalid fixed block"
        .local pad_size, start
        start := ::.ident(.sprintf("_fixed_block_%d", ::_fixed_block_seq))
        pad_size = (start - *) + ::_fixed_block_size
        .if pad_size < 0
                .error .sprintf("Fixed block too large by %d bytes", -pad_size)
        .elseif pad_size > 0
                .ifnblank pad_val
                        big_res pad_size, pad_val
                .else
                        big_res pad_size
                .endif
        .endif
        ::_fixed_block_size .set 0
        ::_fixed_block_seq .set ::_fixed_block_seq + 1
.endmac
