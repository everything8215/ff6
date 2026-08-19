_bitlist_size .set 0

.mac bitlist size
; allow up to 1024 bits (thirty-two 32-bit variables)
        .assert size <= 1024, error, "Too many bits in bitlist"
        ::_bitlist_size .set size
; reset all bitlist variables
        .repeat 32, i
                ::.ident(.sprintf("_bitlist_%d", i)) .set 0
        .endrep
.endmac

.mac bitlist_set bit_index
        .assert (bit_index) < ::_bitlist_size, error, "Invalid bit_index"
        .local bit_mask
        .local var_index
        .local old_var
        bit_mask = 1 << ((bit_index) & %11111)
        var_index = (bit_index) >> 5
        old_var = ::.ident(.sprintf("_bitlist_%d", var_index))
        ::.ident(.sprintf("_bitlist_%d", var_index)) .set old_var | bit_mask
.endmac

.mac bitlist_clr bit_index
        .assert (bit_index) < ::_bitlist_size, error, "Invalid bit_index"
        .local bit_mask
        .local var_index
        .local old_var
        bit_mask = 1 << ((bit_index) & %11111)
        var_index = (bit_index) >> 5
        old_var = ::.ident(.sprintf("_bitlist_%d", var_index))
        ::.ident(.sprintf("_bitlist_%d", var_index)) .set old_var & ~bit_mask
.endmac

.mac end_bitlist
        .local num_vars
        .local leftover_bytes
        num_vars = (::_bitlist_size + 7) / 32
        .repeat num_vars, ii
                .dword ::.ident(.sprintf("_bitlist_%d", ii))
        .endrep
        leftover_bytes = ((::_bitlist_size + 7) / 8) .mod 4
        .if leftover_bytes = 1
                .byte ::.ident(.sprintf("_bitlist_%d", num_vars))
        .elseif leftover_bytes = 2
                .word ::.ident(.sprintf("_bitlist_%d", num_vars))
        .elseif leftover_bytes = 3
                .faraddr ::.ident(.sprintf("_bitlist_%d", num_vars))
        .endif
        ::_bitlist_size .set 0
.endmac
