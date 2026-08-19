; [ hdma macros ]

.mac hdma_byte lines, value
        .byte lines
        .byte value
.endmac

.mac hdma_word lines, value
        .byte lines
        .if value < 0
                .word .loword(value)
        .else
                .word value
        .endif
.endmac

.mac _hdma_2byte lines, value1, value2
        .byte lines
        .byte value1, value2
.endmac

.mac hdma_2byte lines, values
        _hdma_2byte lines, values
.endmac

.mac _hdma_4byte lines, value1, value2, value3, value4
        .byte lines
        .byte value1, value2, value3, value4
.endmac

.mac hdma_4byte lines, values
        _hdma_4byte lines, values
.endmac

.mac hdma_addr lines, value
        .byte lines
        .addr value
.endmac

.mac hdma_end
        .byte 0
.endmac
