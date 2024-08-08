; ------------------------------------------------------------------------------

; c5/1ec9
spc_block SfxBRR
        .incbin "src/sound/sfx_brr/sfx_0000.brr"
        .incbin "src/sound/sfx_brr/sfx_0001.brr"
        .incbin "src/sound/sfx_brr/sfx_0002.brr"
        .incbin "src/sound/sfx_brr/sfx_0003.brr"
        .incbin "src/sound/sfx_brr/sfx_0004.brr"
        .incbin "src/sound/sfx_brr/sfx_0005.brr"
        .incbin "src/sound/sfx_brr/sfx_0006.brr"
        .incbin "src/sound/sfx_brr/sfx_0007.brr"
end_spc_block

; ------------------------------------------------------------------------------

; c5/2018
spc_block SfxLoopStart
        .word $4800,$4800
        .word $4824,$4824
        .word $4848,$4848
        .word $486c,$4887
        .word $48ab,$48c6
        .word $48d8,$48d8
        .word $48ea,$48ea
        .word $48fc,$4917
end_spc_block

; c5/203a
spc_block SfxADSR
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
        make_adsr 15,7,7,0
end_spc_block

; c5/204c
spc_block SfxFreqMult
        .byte $e1,$a0
        .byte $e1,$a0
        .byte $e1,$a0
        .byte $e1,$a0
        .byte $00,$00
        .byte $e1,$a0
        .byte $e1,$a0
        .byte $00,$00
end_spc_block

; ------------------------------------------------------------------------------

; c5/205e
SfxPtrs:
spc_block Sfx

.repeat 256, i
        .addr .ident(.sprintf("SfxScript_%04x_1", i)) - SfxStart + $3000
        .addr .ident(.sprintf("SfxScript_%04x_2", i)) - SfxStart + $3000
.endrep

; c5/245e
SfxStart:
        .scope SfxScript_0000
        .include "sfx_script/sfx_script_0000.asm"
        .endscope
        .scope SfxScript_0001
        .include "sfx_script/sfx_script_0001.asm"
        .endscope
        .scope SfxScript_0002
        .include "sfx_script/sfx_script_0002.asm"
        .endscope
        .scope SfxScript_0003
        .include "sfx_script/sfx_script_0003.asm"
        .endscope
        .scope SfxScript_0004
        .include "sfx_script/sfx_script_0004.asm"
        .endscope
        .scope SfxScript_0005
        .include "sfx_script/sfx_script_0005.asm"
        .endscope
        .scope SfxScript_0006
        .include "sfx_script/sfx_script_0006.asm"
        .endscope
        .scope SfxScript_0007
        .include "sfx_script/sfx_script_0007.asm"
        .endscope
        .scope SfxScript_0008
        .include "sfx_script/sfx_script_0008.asm"
        .endscope
        .scope SfxScript_0009
        .include "sfx_script/sfx_script_0009.asm"
        .endscope
        .scope SfxScript_000a
        .include "sfx_script/sfx_script_000a.asm"
        .endscope
        .scope SfxScript_000b
        .include "sfx_script/sfx_script_000b.asm"
        .endscope
        .scope SfxScript_000c
        .include "sfx_script/sfx_script_000c.asm"
        .endscope
        .scope SfxScript_000d
        .include "sfx_script/sfx_script_000d.asm"
        .endscope
        .scope SfxScript_000e
        .include "sfx_script/sfx_script_000e.asm"
        .endscope
        .scope SfxScript_000f
        .include "sfx_script/sfx_script_000f.asm"
        .endscope
        .scope SfxScript_0010
        .include "sfx_script/sfx_script_0010.asm"
        .endscope
        .scope SfxScript_0011
        .include "sfx_script/sfx_script_0011.asm"
        .endscope
        .scope SfxScript_0012
        .include "sfx_script/sfx_script_0012.asm"
        .endscope
        .scope SfxScript_0013
        .include "sfx_script/sfx_script_0013.asm"
        .endscope
        .scope SfxScript_0014
        .include "sfx_script/sfx_script_0014.asm"
        .endscope
        .scope SfxScript_0015
        .include "sfx_script/sfx_script_0015.asm"
        .endscope
        .scope SfxScript_0016
        .include "sfx_script/sfx_script_0016.asm"
        .endscope
        .scope SfxScript_0017
        .include "sfx_script/sfx_script_0017.asm"
        .endscope
        .scope SfxScript_0018
        .include "sfx_script/sfx_script_0018.asm"
        .endscope
        .scope SfxScript_0019
        .include "sfx_script/sfx_script_0019.asm"
        .endscope
        .scope SfxScript_001a
        .include "sfx_script/sfx_script_001a.asm"
        .endscope
        .scope SfxScript_001b
        .include "sfx_script/sfx_script_001b.asm"
        .endscope
        .scope SfxScript_001c
        .include "sfx_script/sfx_script_001c.asm"
        .endscope
        .scope SfxScript_001d
        .include "sfx_script/sfx_script_001d.asm"
        .endscope
        .scope SfxScript_001e
        .include "sfx_script/sfx_script_001e.asm"
        .endscope
        .scope SfxScript_001f
        .include "sfx_script/sfx_script_001f.asm"
        .endscope
        .scope SfxScript_0020
        .include "sfx_script/sfx_script_0020.asm"
        .endscope
        .scope SfxScript_0021
        .include "sfx_script/sfx_script_0021.asm"
        .endscope
        .scope SfxScript_0022
        .include "sfx_script/sfx_script_0022.asm"
        .endscope
        .scope SfxScript_0023
        .include "sfx_script/sfx_script_0023.asm"
        .endscope
        .scope SfxScript_0024
        .include "sfx_script/sfx_script_0024.asm"
        .endscope
        .scope SfxScript_0025
        .include "sfx_script/sfx_script_0025.asm"
        .endscope
        .scope SfxScript_0026
        .include "sfx_script/sfx_script_0026.asm"
        .endscope
        .scope SfxScript_0027
        .include "sfx_script/sfx_script_0027.asm"
        .endscope
        .scope SfxScript_0028
        .include "sfx_script/sfx_script_0028.asm"
        .endscope
        .scope SfxScript_0029
        .include "sfx_script/sfx_script_0029.asm"
        .endscope
        .scope SfxScript_002a
        .include "sfx_script/sfx_script_002a.asm"
        .endscope
        .scope SfxScript_002b
        .include "sfx_script/sfx_script_002b.asm"
        .endscope
        .scope SfxScript_002c
        .include "sfx_script/sfx_script_002c.asm"
        .endscope
        .scope SfxScript_002d
        .include "sfx_script/sfx_script_002d.asm"
        .endscope
        .scope SfxScript_002e
        .include "sfx_script/sfx_script_002e.asm"
        .endscope
        .scope SfxScript_002f
        .include "sfx_script/sfx_script_002f.asm"
        .endscope
        .scope SfxScript_0030
        .include "sfx_script/sfx_script_0030.asm"
        .endscope
        .scope SfxScript_0031
        .include "sfx_script/sfx_script_0031.asm"
        .endscope
        .scope SfxScript_0032
        .include "sfx_script/sfx_script_0032.asm"
        .endscope
        .scope SfxScript_0033
        .include "sfx_script/sfx_script_0033.asm"
        .endscope
        .scope SfxScript_0034
        .include "sfx_script/sfx_script_0034.asm"
        .endscope
        .scope SfxScript_0035
        .include "sfx_script/sfx_script_0035.asm"
        .endscope
        .scope SfxScript_0036
        .include "sfx_script/sfx_script_0036.asm"
        .endscope
        .scope SfxScript_0037
        .include "sfx_script/sfx_script_0037.asm"
        .endscope
        .scope SfxScript_0038
        .include "sfx_script/sfx_script_0038.asm"
        .endscope
        .scope SfxScript_0039
        .include "sfx_script/sfx_script_0039.asm"
        .endscope
        .scope SfxScript_003a
        .include "sfx_script/sfx_script_003a.asm"
        .endscope
        .scope SfxScript_003b
        .include "sfx_script/sfx_script_003b.asm"
        .endscope
        .scope SfxScript_003c
        .include "sfx_script/sfx_script_003c.asm"
        .endscope
        .scope SfxScript_003d
        .include "sfx_script/sfx_script_003d.asm"
        .endscope
        .scope SfxScript_003e
        .include "sfx_script/sfx_script_003e.asm"
        .endscope
        .scope SfxScript_003f
        .include "sfx_script/sfx_script_003f.asm"
        .endscope
        .scope SfxScript_0040
        .include "sfx_script/sfx_script_0040.asm"
        .endscope
        .scope SfxScript_0041
        .include "sfx_script/sfx_script_0041.asm"
        .endscope
        .scope SfxScript_0042
        .include "sfx_script/sfx_script_0042.asm"
        .endscope
        .scope SfxScript_0043
        .include "sfx_script/sfx_script_0043.asm"
        .endscope
        .scope SfxScript_0044
        .include "sfx_script/sfx_script_0044.asm"
        .endscope
        .scope SfxScript_0045
        .include "sfx_script/sfx_script_0045.asm"
        .endscope
        .scope SfxScript_0046
        .include "sfx_script/sfx_script_0046.asm"
        .endscope
        .scope SfxScript_0047
        .include "sfx_script/sfx_script_0047.asm"
        .endscope
        .scope SfxScript_0048
        .include "sfx_script/sfx_script_0048.asm"
        .endscope
        .scope SfxScript_0049
        .include "sfx_script/sfx_script_0049.asm"
        .endscope
        .scope SfxScript_004a
        .include "sfx_script/sfx_script_004a.asm"
        .endscope
        .scope SfxScript_004b
        .include "sfx_script/sfx_script_004b.asm"
        .endscope
        .scope SfxScript_004c
        .include "sfx_script/sfx_script_004c.asm"
        .endscope
        .scope SfxScript_004d
        .include "sfx_script/sfx_script_004d.asm"
        .endscope
        .scope SfxScript_004e
        .include "sfx_script/sfx_script_004e.asm"
        .endscope
        .scope SfxScript_004f
        .include "sfx_script/sfx_script_004f.asm"
        .endscope
        .scope SfxScript_0050
        .include "sfx_script/sfx_script_0050.asm"
        .endscope
        .scope SfxScript_0051
        .include "sfx_script/sfx_script_0051.asm"
        .endscope
        .scope SfxScript_0052
        .include "sfx_script/sfx_script_0052.asm"
        .endscope
        .scope SfxScript_0053
        .include "sfx_script/sfx_script_0053.asm"
        .endscope
        .scope SfxScript_0054
        .include "sfx_script/sfx_script_0054.asm"
        .endscope
        .scope SfxScript_0055
        .include "sfx_script/sfx_script_0055.asm"
        .endscope
        .scope SfxScript_0056
        .include "sfx_script/sfx_script_0056.asm"
        .endscope
        .scope SfxScript_0057
        .include "sfx_script/sfx_script_0057.asm"
        .endscope
        .scope SfxScript_0058
        .include "sfx_script/sfx_script_0058.asm"
        .endscope
        .scope SfxScript_0059
        .include "sfx_script/sfx_script_0059.asm"
        .endscope
        .scope SfxScript_005a
        .include "sfx_script/sfx_script_005a.asm"
        .endscope
        .scope SfxScript_005b
        .include "sfx_script/sfx_script_005b.asm"
        .endscope
        .scope SfxScript_005c
        .include "sfx_script/sfx_script_005c.asm"
        .endscope
        .scope SfxScript_005d
        .include "sfx_script/sfx_script_005d.asm"
        .endscope
        .scope SfxScript_005e
        .include "sfx_script/sfx_script_005e.asm"
        .endscope
        .scope SfxScript_005f
        .include "sfx_script/sfx_script_005f.asm"
        .endscope
        .scope SfxScript_0060
        .include "sfx_script/sfx_script_0060.asm"
        .endscope
        .scope SfxScript_0061
        .include "sfx_script/sfx_script_0061.asm"
        .endscope
        .scope SfxScript_0062
        .include "sfx_script/sfx_script_0062.asm"
        .endscope
        .scope SfxScript_0063
        .include "sfx_script/sfx_script_0063.asm"
        .endscope
        .scope SfxScript_0064
        .include "sfx_script/sfx_script_0064.asm"
        .endscope
        .scope SfxScript_0065
        .include "sfx_script/sfx_script_0065.asm"
        .endscope
        .scope SfxScript_0066
        .include "sfx_script/sfx_script_0066.asm"
        .endscope
        .scope SfxScript_0067
        .include "sfx_script/sfx_script_0067.asm"
        .endscope
        .scope SfxScript_0068
        .include "sfx_script/sfx_script_0068.asm"
        .endscope
        .scope SfxScript_0069
        .include "sfx_script/sfx_script_0069.asm"
        .endscope
        .scope SfxScript_006a
        .include "sfx_script/sfx_script_006a.asm"
        .endscope
        .scope SfxScript_006b
        .include "sfx_script/sfx_script_006b.asm"
        .endscope
        .scope SfxScript_006c
        .include "sfx_script/sfx_script_006c.asm"
        .endscope
        .scope SfxScript_006d
        .include "sfx_script/sfx_script_006d.asm"
        .endscope
        .scope SfxScript_006e
        .include "sfx_script/sfx_script_006e.asm"
        .endscope
        .scope SfxScript_006f
        .include "sfx_script/sfx_script_006f.asm"
        .endscope
        .scope SfxScript_0070
        .include "sfx_script/sfx_script_0070.asm"
        .endscope
        .scope SfxScript_0071
        .include "sfx_script/sfx_script_0071.asm"
        .endscope
        .scope SfxScript_0072
        .include "sfx_script/sfx_script_0072.asm"
        .endscope
        .scope SfxScript_0073
        .include "sfx_script/sfx_script_0073.asm"
        .endscope
        .scope SfxScript_0074
        .include "sfx_script/sfx_script_0074.asm"
        .endscope
        .scope SfxScript_0075
        .include "sfx_script/sfx_script_0075.asm"
        .endscope
        .scope SfxScript_0076
        .include "sfx_script/sfx_script_0076.asm"
        .endscope
        .scope SfxScript_0077
        .include "sfx_script/sfx_script_0077.asm"
        .endscope
        .scope SfxScript_0078
        .include "sfx_script/sfx_script_0078.asm"
        .endscope
        .scope SfxScript_0079
        .include "sfx_script/sfx_script_0079.asm"
        .endscope
        .scope SfxScript_007a
        .include "sfx_script/sfx_script_007a.asm"
        .endscope
        .scope SfxScript_007b
        .include "sfx_script/sfx_script_007b.asm"
        .endscope
        .scope SfxScript_007c
        .include "sfx_script/sfx_script_007c.asm"
        .endscope
        .scope SfxScript_007d
        .include "sfx_script/sfx_script_007d.asm"
        .endscope
        .scope SfxScript_007e
        .include "sfx_script/sfx_script_007e.asm"
        .endscope
        .scope SfxScript_007f
        .include "sfx_script/sfx_script_007f.asm"
        .endscope
        .scope SfxScript_0080
        .include "sfx_script/sfx_script_0080.asm"
        .endscope
        .scope SfxScript_0081
        .include "sfx_script/sfx_script_0081.asm"
        .endscope
        .scope SfxScript_0082
        .include "sfx_script/sfx_script_0082.asm"
        .endscope
        .scope SfxScript_0083
        .include "sfx_script/sfx_script_0083.asm"
        .endscope
        .scope SfxScript_0084
        .include "sfx_script/sfx_script_0084.asm"
        .endscope
        .scope SfxScript_0085
        .include "sfx_script/sfx_script_0085.asm"
        .endscope
        .scope SfxScript_0086
        .include "sfx_script/sfx_script_0086.asm"
        .endscope
        .scope SfxScript_0087
        .include "sfx_script/sfx_script_0087.asm"
        .endscope
        .scope SfxScript_0088
        .include "sfx_script/sfx_script_0088.asm"
        .endscope
        .scope SfxScript_0089
        .include "sfx_script/sfx_script_0089.asm"
        .endscope
        .scope SfxScript_008a
        .include "sfx_script/sfx_script_008a.asm"
        .endscope
        .scope SfxScript_008b
        .include "sfx_script/sfx_script_008b.asm"
        .endscope
        .scope SfxScript_008c
        .include "sfx_script/sfx_script_008c.asm"
        .endscope
        .scope SfxScript_008d
        .include "sfx_script/sfx_script_008d.asm"
        .endscope
        .scope SfxScript_008e
        .include "sfx_script/sfx_script_008e.asm"
        .endscope
        .scope SfxScript_008f
        .include "sfx_script/sfx_script_008f.asm"
        .endscope
        .scope SfxScript_0090
        .include "sfx_script/sfx_script_0090.asm"
        .endscope
        .scope SfxScript_0091
        .include "sfx_script/sfx_script_0091.asm"
        .endscope
        .scope SfxScript_0092
        .include "sfx_script/sfx_script_0092.asm"
        .endscope
        .scope SfxScript_0093
        .include "sfx_script/sfx_script_0093.asm"
        .endscope
        .scope SfxScript_0094
        .include "sfx_script/sfx_script_0094.asm"
        .endscope
        .scope SfxScript_0095
        .include "sfx_script/sfx_script_0095.asm"
        .endscope
        .scope SfxScript_0096
        .include "sfx_script/sfx_script_0096.asm"
        .endscope
        .scope SfxScript_0097
        .include "sfx_script/sfx_script_0097.asm"
        .endscope
        .scope SfxScript_0098
        .include "sfx_script/sfx_script_0098.asm"
        .endscope
        .scope SfxScript_0099
        .include "sfx_script/sfx_script_0099.asm"
        .endscope
        .scope SfxScript_009a
        .include "sfx_script/sfx_script_009a.asm"
        .endscope
        .scope SfxScript_009b
        .include "sfx_script/sfx_script_009b.asm"
        .endscope
        .scope SfxScript_009c
        .include "sfx_script/sfx_script_009c.asm"
        .endscope
        .scope SfxScript_009d
        .include "sfx_script/sfx_script_009d.asm"
        .endscope
        .scope SfxScript_009e
        .include "sfx_script/sfx_script_009e.asm"
        .endscope
        .scope SfxScript_009f
        .include "sfx_script/sfx_script_009f.asm"
        .endscope
        .scope SfxScript_00a0
        .include "sfx_script/sfx_script_00a0.asm"
        .endscope
        .scope SfxScript_00a1
        .include "sfx_script/sfx_script_00a1.asm"
        .endscope
        .scope SfxScript_00a2
        .include "sfx_script/sfx_script_00a2.asm"
        .endscope
        .scope SfxScript_00a3
        .include "sfx_script/sfx_script_00a3.asm"
        .endscope
        .scope SfxScript_00a4
        .include "sfx_script/sfx_script_00a4.asm"
        .endscope
        .scope SfxScript_00a5
        .include "sfx_script/sfx_script_00a5.asm"
        .endscope
        .scope SfxScript_00a6
        .include "sfx_script/sfx_script_00a6.asm"
        .endscope
        .scope SfxScript_00a7
        .include "sfx_script/sfx_script_00a7.asm"
        .endscope
        .scope SfxScript_00a8
        .include "sfx_script/sfx_script_00a8.asm"
        .endscope
        .scope SfxScript_00a9
        .include "sfx_script/sfx_script_00a9.asm"
        .endscope
        .scope SfxScript_00aa
        .include "sfx_script/sfx_script_00aa.asm"
        .endscope
        .scope SfxScript_00ab
        .include "sfx_script/sfx_script_00ab.asm"
        .endscope
        .scope SfxScript_00ac
        .include "sfx_script/sfx_script_00ac.asm"
        .endscope
        .scope SfxScript_00ad
        .include "sfx_script/sfx_script_00ad.asm"
        .endscope
        .scope SfxScript_00ae
        .include "sfx_script/sfx_script_00ae.asm"
        .endscope
        .scope SfxScript_00af
        .include "sfx_script/sfx_script_00af.asm"
        .endscope
        .scope SfxScript_00b0
        .include "sfx_script/sfx_script_00b0.asm"
        .endscope
        .scope SfxScript_00b1
        .include "sfx_script/sfx_script_00b1.asm"
        .endscope
        .scope SfxScript_00b2
        .include "sfx_script/sfx_script_00b2.asm"
        .endscope
        .scope SfxScript_00b3
        .include "sfx_script/sfx_script_00b3.asm"
        .endscope
        .scope SfxScript_00b4
        .include "sfx_script/sfx_script_00b4.asm"
        .endscope
        .scope SfxScript_00b5
        .include "sfx_script/sfx_script_00b5.asm"
        .endscope
        .scope SfxScript_00b6
        .include "sfx_script/sfx_script_00b6.asm"
        .endscope
        .scope SfxScript_00b7
        .include "sfx_script/sfx_script_00b7.asm"
        .endscope
        .scope SfxScript_00b8
        .include "sfx_script/sfx_script_00b8.asm"
        .endscope
        .scope SfxScript_00b9
        .include "sfx_script/sfx_script_00b9.asm"
        .endscope
        .scope SfxScript_00ba
        .include "sfx_script/sfx_script_00ba.asm"
        .endscope
        .scope SfxScript_00bb
        .include "sfx_script/sfx_script_00bb.asm"
        .endscope
        .scope SfxScript_00bc
        .include "sfx_script/sfx_script_00bc.asm"
        .endscope
        .scope SfxScript_00bd
        .include "sfx_script/sfx_script_00bd.asm"
        .endscope
        .scope SfxScript_00be
        .include "sfx_script/sfx_script_00be.asm"
        .endscope
        .scope SfxScript_00bf
        .include "sfx_script/sfx_script_00bf.asm"
        .endscope
        .scope SfxScript_00c0
        .include "sfx_script/sfx_script_00c0.asm"
        .endscope
        .scope SfxScript_00c1
        .include "sfx_script/sfx_script_00c1.asm"
        .endscope
        .scope SfxScript_00c2
        .include "sfx_script/sfx_script_00c2.asm"
        .endscope
        .scope SfxScript_00c3
        .include "sfx_script/sfx_script_00c3.asm"
        .endscope
        .scope SfxScript_00c4
        .include "sfx_script/sfx_script_00c4.asm"
        .endscope
        .scope SfxScript_00c5
        .include "sfx_script/sfx_script_00c5.asm"
        .endscope
        .scope SfxScript_00c6
        .include "sfx_script/sfx_script_00c6.asm"
        .endscope
        .scope SfxScript_00c7
        .include "sfx_script/sfx_script_00c7.asm"
        .endscope
        .scope SfxScript_00c8
        .include "sfx_script/sfx_script_00c8.asm"
        .endscope
        .scope SfxScript_00c9
        .include "sfx_script/sfx_script_00c9.asm"
        .endscope
        .scope SfxScript_00ca
        .include "sfx_script/sfx_script_00ca.asm"
        .endscope
        .scope SfxScript_00cb
        .include "sfx_script/sfx_script_00cb.asm"
        .endscope
        .scope SfxScript_00cc
        .include "sfx_script/sfx_script_00cc.asm"
        .endscope
        .scope SfxScript_00cd
        .include "sfx_script/sfx_script_00cd.asm"
        .endscope
        .scope SfxScript_00ce
        .include "sfx_script/sfx_script_00ce.asm"
        .endscope
        .scope SfxScript_00cf
        .include "sfx_script/sfx_script_00cf.asm"
        .endscope
        .scope SfxScript_00d0
        .include "sfx_script/sfx_script_00d0.asm"
        .endscope
        .scope SfxScript_00d1
        .include "sfx_script/sfx_script_00d1.asm"
        .endscope
        .scope SfxScript_00d2
        .include "sfx_script/sfx_script_00d2.asm"
        .endscope
        .scope SfxScript_00d3
        .include "sfx_script/sfx_script_00d3.asm"
        .endscope
        .scope SfxScript_00d4
        .include "sfx_script/sfx_script_00d4.asm"
        .endscope
        .scope SfxScript_00d5
        .include "sfx_script/sfx_script_00d5.asm"
        .endscope
        .scope SfxScript_00d6
        .include "sfx_script/sfx_script_00d6.asm"
        .endscope
        .scope SfxScript_00d7
        .include "sfx_script/sfx_script_00d7.asm"
        .endscope
        .scope SfxScript_00d8
        .include "sfx_script/sfx_script_00d8.asm"
        .endscope
        .scope SfxScript_00d9
        .include "sfx_script/sfx_script_00d9.asm"
        .endscope
        .scope SfxScript_00da
        .include "sfx_script/sfx_script_00da.asm"
        .endscope
        .scope SfxScript_00db
        .include "sfx_script/sfx_script_00db.asm"
        .endscope
        .scope SfxScript_00dc
        .include "sfx_script/sfx_script_00dc.asm"
        .endscope
        .scope SfxScript_00dd
        .include "sfx_script/sfx_script_00dd.asm"
        .endscope
        .scope SfxScript_00de
        .include "sfx_script/sfx_script_00de.asm"
        .endscope
        .scope SfxScript_00df
        .include "sfx_script/sfx_script_00df.asm"
        .endscope
        .scope SfxScript_00e0
        .include "sfx_script/sfx_script_00e0.asm"
        .endscope
        .scope SfxScript_00e1
        .include "sfx_script/sfx_script_00e1.asm"
        .endscope
        .scope SfxScript_00e2
        .include "sfx_script/sfx_script_00e2.asm"
        .endscope
        .scope SfxScript_00e3
        .include "sfx_script/sfx_script_00e3.asm"
        .endscope
        .scope SfxScript_00e4
        .include "sfx_script/sfx_script_00e4.asm"
        .endscope
        .scope SfxScript_00e5
        .include "sfx_script/sfx_script_00e5.asm"
        .endscope
        .scope SfxScript_00e6
        .include "sfx_script/sfx_script_00e6.asm"
        .endscope
        .scope SfxScript_00e7
        .include "sfx_script/sfx_script_00e7.asm"
        .endscope
        .scope SfxScript_00e8
        .include "sfx_script/sfx_script_00e8.asm"
        .endscope
        .scope SfxScript_00e9
        .include "sfx_script/sfx_script_00e9.asm"
        .endscope
        .scope SfxScript_00ea
        .include "sfx_script/sfx_script_00ea.asm"
        .endscope
        .scope SfxScript_00eb
        .include "sfx_script/sfx_script_00eb.asm"
        .endscope
        .scope SfxScript_00ec
        .include "sfx_script/sfx_script_00ec.asm"
        .endscope
        .scope SfxScript_00ed
        .include "sfx_script/sfx_script_00ed.asm"
        .endscope
        .scope SfxScript_00ee
        .include "sfx_script/sfx_script_00ee.asm"
        .endscope
        .scope SfxScript_00ef
        .include "sfx_script/sfx_script_00ef.asm"
        .endscope
        .scope SfxScript_00f0
        .include "sfx_script/sfx_script_00f0.asm"
        .endscope
        .scope SfxScript_00f1
        .include "sfx_script/sfx_script_00f1.asm"
        .endscope
        .scope SfxScript_00f2
        .include "sfx_script/sfx_script_00f2.asm"
        .endscope
        .scope SfxScript_00f3
        .include "sfx_script/sfx_script_00f3.asm"
        .endscope
        .scope SfxScript_00f4
        .include "sfx_script/sfx_script_00f4.asm"
        .endscope
        .scope SfxScript_00f5
        .include "sfx_script/sfx_script_00f5.asm"
        .endscope
        .scope SfxScript_00f6
        .include "sfx_script/sfx_script_00f6.asm"
        .endscope
        .scope SfxScript_00f7
        .include "sfx_script/sfx_script_00f7.asm"
        .endscope
        .scope SfxScript_00f8
        .include "sfx_script/sfx_script_00f8.asm"
        .endscope
        .scope SfxScript_00f9
        .include "sfx_script/sfx_script_00f9.asm"
        .endscope
        .scope SfxScript_00fa
        .include "sfx_script/sfx_script_00fa.asm"
        .endscope
        .scope SfxScript_00fb
        .include "sfx_script/sfx_script_00fb.asm"
        .endscope
        .scope SfxScript_00fc
        .include "sfx_script/sfx_script_00fc.asm"
        .endscope
        .scope SfxScript_00fd
        .endscope
        .scope SfxScript_00fe
        .endscope
        .scope SfxScript_00ff
        .endscope

; set undefined sfx pointers to zero
.repeat 256, i
        .ifdef .ident(.sprintf("SfxScript_%04x", i))::Channel1
                .ident(.sprintf("SfxScript_%04x_1", i)) := .ident(.sprintf("SfxScript_%04x", i))::Channel1
        .else
                .ident(.sprintf("SfxScript_%04x_1", i)) := SfxStart - $3000
        .endif
        .ifdef .ident(.sprintf("SfxScript_%04x", i))::Channel2
                .ident(.sprintf("SfxScript_%04x_2", i)) := .ident(.sprintf("SfxScript_%04x", i))::Channel2
        .else
                .ident(.sprintf("SfxScript_%04x_2", i)) := SfxStart - $3000
        .endif
.endrep

; c5/3c4e
        .res $10

end_spc_block

; ------------------------------------------------------------------------------
