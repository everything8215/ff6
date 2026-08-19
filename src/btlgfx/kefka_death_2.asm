; ------------------------------------------------------------------------------

last_vram_offset:
_c2e4c3:
@e4c3:  .word   $3c00,$3800,$3400,$3000,$0c00,$0800,$0400,$0000

last_get_offset:
_c2e4d3:
@e4d3:  .addr   w7ebe3f+$0800
        .addr   w7ebe3f
        .addr   w7eae3f+$0800
        .addr   w7eae3f
        .addr   $7fdc00,$7fd400,$7fcc00,$7fc400

last_get_bank:
_c2e4e3:
@e4e3:  .bankbytes w7ebe3f+$0800
        .bankbytes w7ebe3f
        .bankbytes w7eae3f+$0800
        .bankbytes w7eae3f
        .bankbytes $7fdc00,$7fd400,$7fcc00,$7fc400

; ------------------------------------------------------------------------------
