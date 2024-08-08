
; ------------------------------------------------------------------------------

.if LANG_EN
        BG1_BLANK_CHAR                  = $c8
        ZERO_CHAR                       = $b4
        COLON_CHAR                      = $c1
        GAUGE_EMPTY_CHAR                = $f0
        GAUGE_FULL_CHAR                 = $f8
        GAUGE_LEFT_CHAR                 = $f9
        GAUGE_RIGHT_CHAR                = $fa
.else
        GAUGE_EMPTY_CHAR                = $10
        GAUGE_FULL_CHAR                 = $18
        GAUGE_LEFT_CHAR                 = $19
        GAUGE_RIGHT_CHAR                = $1a
        ZERO_CHAR                       = $53
        BG1_BLANK_CHAR                  = $67
        COLON_CHAR                      = $cf
.endif

; ------------------------------------------------------------------------------

ram_verbose 0
ram_addr_size NEAR

; battle graphics variables (bank $7e)

ram_org $7e4000

ram_byte        w7e4000
ram_byte        w7e4001
ram_byte        w7e4002
ram_byte        w7e4003
ram_byte        w7e4004
ram_array       wItemList, 256, 3
                ram_byte        Index
                ram_byte        Qty
                ram_byte        Flags
end_ram_array

; .out .sprintf("wItemList::SIZE %d", wItemList::SIZE)
; .out .sprintf("wItemList::ITEM_SIZE %d", wItemList::ITEM_SIZE)
; .out .sprintf("wItemList::Index::SIZE %d", wItemList::Index::SIZE)
; .out .sprintf("wItemList             %06x", wItemList)
; .out .sprintf("wItemList::Index      %06x", wItemList::Index)
; .out .sprintf("wItemList::Flags      %06x", wItemList::Flags)
; .out .sprintf("wItemList::_0::Index  %06x", wItemList::_0::Index)
; .out .sprintf("wItemList::_1::Index  %06x", wItemList::_1::Index)
; .out .sprintf("wItemList::_2::Index  %06x", wItemList::_2::Index)
; .out .sprintf("wItemList::_3::Index  %06x", wItemList::_3::Index)
; .out .sprintf("wItemList::_3::Flags  %06x", wItemList::_3::Flags)
; .out .sprintf("wItemList::_255::Flags %06x", wItemList::_255::Flags)
ram_res         w7e4305, 240
ram_res         w7e43f5, 151 * 4
ram_res         w7e4651, 73 * 4
ram_res         w7e4775, 151 * 4
ram_res         w7e49d1, 73 * 4
ram_res         w7e4af5, 151 * 4
ram_res         w7e4d51, 73 * 4
ram_res         w7e4e75, 64 * 4
ram_res         w7e4f75, 72 * 4
ram_res         w7e5095, 80 * 4
ram_res         w7e51d5, 128 * 4
ram_res         w7e53d5, 40 * 4
ram_res         w7e5475, 48 * 4
ram_res         w7e5535, 40 * 4
ram_res         w7e55d5, 256
ram_res         w7e56d5, 64
ram_res         w7e5715, 64
ram_res         w7e5755, 128
ram_res         w7e57d5, 128
ram_res         w7e5855, 640
ram_res         w7e5ad5, 24 * 8
ram_res         w7e5b95, 14 * 8
ram_res         w7e5c05, 8 * 8
ram_res         w7e5c45, 12 * 8
ram_res         w7e5ca5, 28 * 4
ram_res         w7e5d15, 14 * 2
ram_res         w7e5d31, 14 * 5
ram_res         w7e5d77, 14 * 5
ram_res         w7e5dbd, 24 * 6
ram_res         w7e5e4d, 128
.if LANG_EN
ram_res         w7e5ecd, 20 * 8
.else
ram_res         w7e5ecd, 14 * 8
.endif

ram_res         w7e5f6d, 16
ram_res         w7e5f7d, 16
ram_res         w7e5f8d, 16
ram_res         w7e5f9d, 16

ram_res         w7e5fad, 128

ram_res         w7e602d, 16 * 5

ram_byte        w7e607d
ram_byte        w7e607e
ram_byte        w7e607f
ram_byte        w7e6080
ram_byte        w7e6081
ram_byte        w7e6082
ram_byte        w7e6083
ram_byte        w7e6084
ram_res         w7e6085, 16
ram_byte        w7e6095
ram_byte        w7e6096
ram_byte        w7e6097
ram_byte        w7e6098
ram_byte        w7e6099
ram_byte        w7e609a
ram_byte        w7e609b
ram_byte        w7e609c
ram_byte        w7e609d
ram_byte        w7e609e
ram_byte        w7e609f
ram_byte        w7e60a0
ram_byte        w7e60a1
ram_byte        w7e60a2
ram_byte        w7e60a3
ram_byte        w7e60a4
ram_byte        w7e60a5
ram_byte        w7e60a6
ram_byte        w7e60a7
ram_byte        w7e60a8
ram_byte        w7e60a9
ram_byte        w7e60aa
ram_byte        w7e60ab
ram_byte        w7e60ac
ram_byte        w7e60ad
ram_byte        w7e60ae
ram_byte        w7e60af
ram_byte        w7e60b0
ram_byte        w7e60b1
ram_byte        w7e60b2
ram_res         w7e60b3, 128
ram_res         w7e6133, 10
ram_byte        w7e613d
ram_byte        w7e613e
ram_byte        w7e613f
ram_byte        w7e6140
ram_byte        w7e6141
ram_res         w7e6142, 10
ram_byte        w7e614c
ram_byte        w7e614d
ram_byte        w7e614e
ram_byte        w7e614f
ram_byte        w7e6150
ram_byte        w7e6151
ram_byte        w7e6152
ram_byte        w7e6153
ram_byte        w7e6154
ram_byte        w7e6155
ram_byte        w7e6156
ram_byte        w7e6157
ram_byte        w7e6158
ram_byte        w7e6159
ram_byte        w7e615a
ram_byte        w7e615b
ram_byte        w7e615c
ram_byte        w7e615d
ram_byte        w7e615e
ram_byte        w7e615f
ram_byte        w7e6160
ram_byte        w7e6161
ram_byte        w7e6162
ram_byte        w7e6163
ram_byte        w7e6164
ram_byte        w7e6165
ram_byte        w7e6166
ram_byte        w7e6167
ram_byte        w7e6168
ram_word        w7e6169
ram_byte        w7e616b
ram_byte        w7e616c
ram_byte        w7e616d
ram_byte        w7e616e
ram_byte        w7e616f
ram_byte        w7e6170
ram_byte        w7e6171
ram_byte        w7e6172
ram_byte        w7e6173
ram_byte        w7e6174
ram_byte        w7e6175
ram_byte        w7e6176
ram_byte        w7e6177
ram_byte        w7e6178
ram_byte        w7e6179
ram_byte        w7e617a
ram_byte        w7e617b
ram_byte        w7e617c
ram_byte        w7e617d
ram_res         w7e617e, 12
ram_byte        w7e618a
ram_res         w7e618b, 6
ram_byte        w7e6191
ram_byte        w7e6192
ram_byte        w7e6193
ram_byte        w7e6194
ram_byte        w7e6195
ram_byte        w7e6196
ram_byte        w7e6197
ram_byte        w7e6198
ram_byte        w7e6199
ram_byte        w7e619a
ram_byte        w7e619b
ram_byte        w7e619c
ram_byte        w7e619d
ram_res         w7e619e, 4
ram_res         w7e61a2, 4
ram_res         w7e61a6, 4
ram_byte        w7e61aa
ram_byte        w7e61ab
ram_byte        w7e61ac
ram_byte        w7e61ad
ram_res         w7e61ae, 4
ram_res         w7e61b2, 4

ram_array       wCharGfxData, 4, 32
        ram_byte
        ram_word        w7e61b7
        ram_word        w7e61b9
        ram_byte        w7e61bb
        ram_byte        w7e61bc
        ram_byte        w7e61bd
        ram_byte        w7e61be
        ram_byte        w7e61bf
        ram_byte        w7e61c0
        ram_byte        w7e61c1
        ram_byte        w7e61c2
        ram_byte        w7e61c3
        ram_byte        w7e61c4
        ram_word        w7e61c5
        ram_word        w7e61c7
        ram_word        w7e61c9
        ram_word        w7e61cb
        ram_byte        w7e61cd
        ram_byte        w7e61ce
        ram_byte        w7e61cf
        ram_byte        w7e61d0
        ram_byte        w7e61d1
        ram_word        w7e61d2
        ram_word        w7e61d4
end_ram_array

.define wChar1GfxData wCharGfxData::_0
.define wChar2GfxData wCharGfxData::_1
.define wChar3GfxData wCharGfxData::_2
.define wChar4GfxData wCharGfxData::_3

; .out .sprintf("wCharGfxData               %06x", wCharGfxData)
; .out .sprintf("wCharGfxData_near          %06x", wCharGfxData_near)
; .out .sprintf("wCharGfxData_far           %06x", wCharGfxData_far)
; .out .sprintf("wCharGfxData::w7e61cf      %06x", wCharGfxData::w7e61cf)
; .out .sprintf("wCharGfxData::_0::w7e61cb  %06x", wCharGfxData::_0::w7e61cb)
; .out .sprintf("wCharGfxData::_1::w7e61cb  %06x", wCharGfxData::_1::w7e61cb)
; .out .sprintf("wCharGfxData::_2::w7e61cb  %06x", wCharGfxData::_2::w7e61cb)
; .out .sprintf("wCharGfxData::_3::w7e61cb  %06x", wCharGfxData::_3::w7e61cb)
; .out .sprintf("wChar4GfxData::w7e61cb     %06x", wChar4GfxData::w7e61cb)
ram_res         w7e6236, 4 * 4
ram_res         w7e6246, 4 * 4
                w7e6248 := w7e6246 + 2
ram_res         w7e6256, 4 * 4
ram_word        w7e6266
ram_word        w7e6268
ram_byte        w7e626a
ram_byte        w7e626b
ram_byte        w7e626c
ram_byte        w7e626d
ram_byte        w7e626e
ram_byte        w7e626f
ram_byte        w7e6270
ram_byte        w7e6271
ram_byte        w7e6272
ram_word        w7e6273
ram_word        w7e6275
ram_word        w7e6277
ram_byte        w7e6279
ram_byte        w7e627a
ram_byte        w7e627b
ram_byte        w7e627c
ram_byte        w7e627d
ram_word        w7e627e
ram_byte        w7e6280

ram_byte        w7e6281
ram_byte        w7e6282
ram_byte        w7e6283
ram_byte        w7e6284
ram_byte        w7e6285
ram_byte        w7e6286
ram_byte        w7e6287
ram_byte        w7e6288
ram_byte        w7e6289
ram_byte        w7e628a
ram_byte        w7e628b
ram_byte        w7e628c
ram_byte        w7e628d
ram_byte        w7e628e
ram_byte        w7e628f
ram_word        w7e6290
ram_word        w7e6292
ram_word        w7e6294
ram_word        w7e6296
ram_word        w7e6298
ram_byte        w7e629a
ram_byte        w7e629b
ram_byte        w7e629c
ram_byte        w7e629d
ram_byte        w7e629e
ram_byte        w7e629f
ram_res         w7e62a0, 4
ram_byte        w7e62a4
ram_res         w7e62a5, 4
ram_byte        w7e62a9
ram_byte        w7e62aa
ram_byte        w7e62ab
ram_byte        w7e62ac
ram_byte        w7e62ad
ram_byte        w7e62ae
ram_byte        w7e62af
ram_byte        w7e62b0
ram_byte        w7e62b1
ram_byte        w7e62b2
ram_byte        w7e62b3
ram_byte        w7e62b4
ram_byte        w7e62b5
ram_byte        w7e62b6
ram_byte        w7e62b7
ram_byte        w7e62b8
ram_byte        w7e62b9
ram_byte        w7e62ba
ram_word        w7e62bb
ram_byte        w7e62bd
ram_byte        w7e62be
ram_byte        w7e62bf
ram_byte        w7e62c0
ram_byte        w7e62c1
ram_byte        w7e62c2
ram_byte        w7e62c3
ram_byte        w7e62c4
ram_byte        w7e62c5
ram_byte        w7e62c6
ram_byte        w7e62c7
ram_byte        w7e62c8
ram_byte        w7e62c9
ram_word        w7e62ca
ram_byte        w7e62cc
ram_byte        w7e62cd
ram_byte        w7e62ce
ram_byte        w7e62cf
ram_byte        w7e62d0
ram_byte        w7e62d1
ram_byte        w7e62d2
ram_byte        w7e62d3
ram_byte        w7e62d4
ram_byte        w7e62d5
ram_res         w7e62d6, 8 * 8
ram_byte        w7e6316
ram_word        w7e6317
ram_byte        w7e6319
ram_res         w7e631a, 4
ram_res         w7e631e, 4
ram_res         w7e6322, 4
ram_res         w7e6326, 4
ram_res         w7e632a, 4
ram_byte        w7e632e
ram_byte        w7e632f
ram_res         w7e6330, 128
ram_res         w7e63b0, 256
ram_word        w7e64b0
ram_word        w7e64b2
ram_word        w7e64b4
ram_word        w7e64b6
ram_byte        w7e64b8
ram_byte        w7e64b9
ram_byte        w7e64ba
ram_byte        w7e64bb
ram_word        w7e64bc
ram_word        w7e64be
ram_word        w7e64c0
ram_word        w7e64c2
ram_word        w7e64c4
ram_word        w7e64c6
ram_word        w7e64c8
ram_word        w7e64ca
ram_byte        w7e64cc
ram_byte        w7e64cd
ram_byte        w7e64ce
ram_byte        w7e64cf
ram_res         w7e64d0, 4
ram_byte        w7e64d4
ram_byte        w7e64d5
ram_res         w7e64d6, 4
ram_byte        w7e64da
ram_byte        w7e64db
ram_word        w7e64dc

ram_array       wAnimThread, 85, 64, 4
        ram_byte w7e64de
        ram_word w7e64df
        ram_word w7e64e1
        ram_byte w7e64e3
        ram_word w7e64e4
        ram_byte w7e64e6
        ram_byte w7e64e7
        ram_word w7e64e8
        ram_word w7e64ea
        ram_word w7e64ec
        end_ram_block

        ram_byte w7e6a2e
        ram_byte w7e6a2f
        ram_byte w7e6a30
        ram_faraddr w7e6a31
        ram_byte w7e6a34
        ram_byte w7e6a35
        ram_byte w7e6a36
        ram_byte w7e6a37
        ram_byte w7e6a38
        ram_byte w7e6a39
        ram_word w7e6a3a
        ram_word w7e6a3c
        end_ram_block

        ram_word w7e6f7e
        ram_word w7e6f80
        ram_word w7e6f82
        ram_word w7e6f84
        ram_byte w7e6f86
        ram_byte w7e6f87
        ram_byte w7e6f88
        ram_word w7e6f89
        ram_byte w7e6f8b
        ram_byte w7e6f8c
        ram_byte w7e6f8d
        end_ram_block

        ram_word w7e74ce
        ram_word w7e74d0
        ram_byte w7e74d2
        ram_byte w7e74d3
        ram_byte w7e74d4
        ram_byte w7e74d5
        ram_byte w7e74d6
        ram_byte w7e74d7
        ram_byte w7e74d8
        ram_word w7e74d9
        ram_byte w7e74db
        ram_word w7e74dc
        end_ram_block
end_ram_array

.define wBG1AnimThread wAnimThread::_80
.define wBG3AnimThread wAnimThread::_81
.define wGenjuAnimThread1 wAnimThread::_82
.define wGenjuAnimThread2 wAnimThread::_83
.define wGenjuAnimThread3 wAnimThread::_84

; FIVE = 5
; .out .sprintf("wAnimThread::w7e6f84          %06x", wAnimThread::w7e6f84)
; .out .sprintf("wAnimThread::w7e6f84_far      %06x", wAnimThread::w7e6f84_far)
; .out .sprintf("wAnimThread::_5::w7e6f84      %06x", wAnimThread::_5::w7e6f84)
; .out .sprintf("wAnimThread::_5               %06x", wAnimThread::_5)
; .out .sprintf("array_item wAnimThread, FIVE  %06x", array_item wAnimThread, FIVE)
; .out .sprintf("array_member wAnimThread, FIVE, w7e6f84 %06x", array_member wAnimThread, FIVE, w7e6f84)
; .out .sprintf("wAnimThread::w7e6a31::SIZE    %d", wAnimThread::w7e6a31::SIZE)

ram_byte        w7e7a1e
ram_res         w7e7a1f, 40
ram_res         w7e7a47, 40
ram_res         w7e7a6f, 4
ram_res         w7e7a73, 8 * 2
ram_byte        w7e7a83
ram_byte        w7e7a84
ram_byte        w7e7a85
ram_res         w7e7a86, 6
ram_res         w7e7a8c, 6
ram_res         w7e7a92, 6
ram_res         w7e7a98, 6
ram_res         w7e7a9e, 6
ram_res         w7e7aa4, 6
ram_res         w7e7aaa, 6
ram_res         w7e7ab0, 6
ram_res         w7e7ab6, 6
ram_res         w7e7abc, 6
ram_res         w7e7ac2, 6
ram_res         w7e7ac8, 6
ram_byte        w7e7ace
ram_byte        w7e7acf
ram_res         w7e7ad0, 6 * 4
ram_byte        w7e7ae8
ram_byte        w7e7ae9
ram_byte        w7e7aea
ram_byte        w7e7aeb
ram_word        w7e7aec
ram_byte        w7e7aee
ram_byte        w7e7aef
ram_byte        w7e7af0
ram_byte        w7e7af1
ram_byte        w7e7af2
ram_byte        w7e7af3
ram_byte        w7e7af4
ram_byte        w7e7af5
ram_word        w7e7af6
ram_word        w7e7af8
ram_word        w7e7afa
ram_byte        w7e7afc
ram_byte        w7e7afd
ram_word        w7e7afe

ram_byte        w7e7b00
ram_byte        w7e7b01
ram_byte        w7e7b02
ram_word        w7e7b03
ram_word        w7e7b05
ram_res         w7e7b07, 5
ram_byte        w7e7b0c
ram_byte        w7e7b0d
ram_byte        w7e7b0e
ram_byte        w7e7b0f
ram_byte        w7e7b10
ram_byte        w7e7b11
ram_byte        w7e7b12
ram_byte        w7e7b13
ram_byte        w7e7b14
ram_byte        w7e7b15
ram_word        w7e7b16
ram_word        w7e7b18
ram_faraddr     w7e7b1a
ram_word        w7e7b1d
ram_word        w7e7b1f
ram_byte        w7e7b21
ram_word        w7e7b22
ram_word        w7e7b24
ram_faraddr     w7e7b26
ram_word        w7e7b29
ram_word        w7e7b2b
ram_word        w7e7b2d
ram_word        w7e7b2f
ram_word        w7e7b31
ram_word        w7e7b33
ram_word        w7e7b35
ram_word        w7e7b37
ram_byte        w7e7b39
ram_byte        w7e7b3a
ram_byte        w7e7b3b
ram_byte        w7e7b3c
ram_byte        w7e7b3d
ram_byte        w7e7b3e
ram_res         w7e7b3f, 10
ram_res         w7e7b49, 10
ram_res         w7e7b53, 10
ram_res         w7e7b5d, 10
ram_byte        w7e7b67
ram_byte        w7e7b68
ram_byte        w7e7b69
ram_byte        w7e7b6a
ram_byte        w7e7b6b
ram_res         w7e7b6c, 4
ram_res         w7e7b70, 4
ram_res         w7e7b74, 4
ram_byte        w7e7b78
ram_byte        w7e7b79
ram_byte        w7e7b7a
ram_byte        w7e7b7b
ram_byte        w7e7b7c
ram_byte        w7e7b7d
ram_byte        w7e7b7e
ram_byte        w7e7b7f
ram_byte        w7e7b80
ram_byte        w7e7b81
ram_byte        w7e7b82
ram_byte        w7e7b83
ram_byte        w7e7b84
ram_byte        w7e7b85
ram_res         w7e7b86, 4
ram_byte        w7e7b8a
ram_byte        w7e7b8b
ram_byte        w7e7b8c
ram_byte        w7e7b8d
ram_byte        w7e7b8e
ram_byte        w7e7b8f
ram_byte        w7e7b90
ram_byte        w7e7b91
ram_byte        w7e7b92
ram_byte        w7e7b93
ram_byte        w7e7b94
ram_byte        w7e7b95
ram_byte        w7e7b96
ram_byte        w7e7b97
ram_byte        w7e7b98
ram_byte        w7e7b99
ram_byte        w7e7b9a
ram_byte        w7e7b9b
ram_byte        w7e7b9c
ram_byte        w7e7b9d
ram_byte        w7e7b9e
ram_word        w7e7b9f
ram_word        w7e7ba1
ram_byte        w7e7ba3
ram_byte        w7e7ba4
ram_byte        w7e7ba5
ram_byte        w7e7ba6
ram_byte        w7e7ba7
ram_byte        w7e7ba8
ram_byte        w7e7ba9
ram_word        w7e7baa
ram_byte        w7e7bac
ram_byte        w7e7bad
ram_byte        w7e7bae
ram_byte        w7e7baf
ram_byte        w7e7bb0
ram_word        w7e7bb1
ram_word        w7e7bb3
ram_byte        w7e7bb5
ram_byte        w7e7bb6
ram_byte        w7e7bb7
ram_byte        w7e7bb8
ram_byte        w7e7bb9
ram_byte        w7e7bba
ram_byte        w7e7bbb
ram_word        w7e7bbc
ram_word        w7e7bbe
ram_word        w7e7bc0
ram_byte        w7e7bc2
ram_res         w7e7bc3, 7
ram_byte        w7e7bca
ram_byte        w7e7bcb
ram_byte        w7e7bcc
ram_res         w7e7bcd, 4
ram_byte        w7e7bd1
ram_word        w7e7bd2
ram_word        w7e7bd4
ram_byte        w7e7bd6
ram_word        w7e7bd7
ram_word        w7e7bd9
ram_word        w7e7bdb
ram_byte        w7e7bdd
ram_word        w7e7bde
ram_word        w7e7be0
ram_word        w7e7be2
ram_word        w7e7be4
ram_byte        w7e7be6
ram_word        w7e7be7
ram_word        w7e7be9
ram_byte        w7e7beb
ram_word        w7e7bec
ram_byte        w7e7bee
ram_byte        w7e7bef
ram_res         w7e7bf0, 16
ram_array       w7e7c00, 16, 32
        ram_word Color0
        ram_word Color1
        ram_word Color2
        ram_word Color3
        ram_word Color4
        ram_word Color5
        ram_word Color6
        ram_word Color7
        ram_word Color8
        ram_word Color9
        ram_word Color10
        ram_word Color11
        ram_word Color12
        ram_word Color13
        ram_word Color14
        ram_word Color15
end_ram_array
ram_array       w7e7e00, 16, 32
        ram_word Color0
        ram_word Color1
        ram_word Color2
        ram_word Color3
        ram_word Color4
        ram_word Color5
        ram_word Color6
        ram_word Color7
        ram_word Color8
        ram_word Color9
        ram_word Color10
        ram_word Color11
        ram_word Color12
        ram_word Color13
        ram_word Color14
        ram_word Color15
end_ram_array
; ram_res         w7e7c00, 16 * 32
; ram_res         w7e7e00, 16 * 32
ram_byte        w7e8000
ram_faraddr     w7e8001
ram_word        w7e8004
ram_word        w7e8006
ram_word        w7e8008
ram_byte        w7e800a
ram_byte        w7e800b
ram_byte        w7e800c
ram_byte        w7e800d
ram_byte        w7e800e
ram_res         w7e800f, 6 * 2
ram_res         w7e801b, 6 * 2
ram_res         w7e8027, 6 * 2
ram_res         w7e8033, 4 * 2
ram_res         w7e803b, 4 * 2
ram_res         w7e8043, 4 * 2
ram_res         w7e804b, 6 * 2
ram_res         w7e8057, 6 * 2
ram_res         w7e8063, 6 * 2
ram_res         w7e806f, 6 * 2
ram_res         w7e807b, 6 * 2
ram_res         w7e8087, 6 * 2
ram_res         w7e8093, 6 * 2
ram_res         w7e809f, 6 * 2
ram_res         w7e80ab, 6 * 2
ram_res         w7e80b7, 6 * 2
ram_res         w7e80c3, 6 * 2
ram_res         w7e80cf, 6 * 2
ram_res         w7e80db, 6 * 2
ram_res         w7e80e7, 6 * 2
ram_res         w7e80f3, 6 * 2
ram_res         w7e80ff, 6 * 2
ram_res         w7e810b, 6 * 2
ram_res         w7e8117, 6 * 2
ram_res         w7e8123, 6 * 2
ram_res         w7e812f, 6 * 2
ram_res         w7e813b, 4 * 4
ram_res         w7e814b, 8 * 4
ram_res         w7e816b, 60
ram_byte        w7e81a7
ram_word        w7e81a8
ram_byte        w7e81aa
ram_byte        w7e81ab
ram_byte        w7e81ac
ram_res         w7e81ad, 4 * 32
ram_res         w7e822d, 32
ram_byte        w7e824d
ram_byte        w7e824e
ram_byte        w7e824f
ram_byte        w7e8250
ram_byte        w7e8251
ram_byte        w7e8252
ram_byte        w7e8253
ram_word        w7e8254
ram_byte        w7e8256
ram_byte        w7e8257
ram_byte        w7e8258
ram_res         w7e8259, 6 * 17 * 4
ram_res         w7e83f1, 6 * 17 * 4
ram_res         w7e8589, 6 * 17 * 4
ram_res         w7e8721, 6 * 17 * 4
ram_res         w7e88b9, 6
ram_res         w7e88bf, 6 * 3
ram_byte        w7e88d1
ram_byte        w7e88d2
ram_byte        w7e88d3
ram_byte        w7e88d4
ram_word        w7e88d5
ram_word        w7e88d7
ram_byte        w7e88d9
ram_byte        w7e88da
ram_byte        w7e88db
ram_byte        w7e88dc
ram_word        w7e88dd
ram_word        w7e88df
ram_byte        w7e88e1
ram_byte        w7e88e2
ram_res         w7e88e3, 4
ram_res         w7e88e7, 4
ram_res         w7e88eb, 4
ram_res         w7e88ef, 4
ram_res         w7e88f3, 4
ram_res         w7e88f7, 4
ram_res         w7e88fb, 4
ram_res         w7e88ff, 4
ram_res         w7e8903, 4
ram_res         w7e8907, 4
ram_byte        w7e890b
ram_byte        w7e890c
ram_byte        w7e890d
ram_byte        w7e890e
ram_res         w7e890f, 4
ram_res         w7e8913, 4
ram_res         w7e8917, 4
ram_res         w7e891b, 4
ram_res         w7e891f, 4
ram_res         w7e8923, 4
ram_res         w7e8927, 4
ram_res         w7e892b, 4
ram_res         w7e892f, 4
ram_res         w7e8933, 4
ram_res         w7e8937, 4
ram_res         w7e893b, 4
ram_res         w7e893f, 4
ram_res         w7e8943, 4
ram_res         w7e8947, 4
ram_res         w7e894b, 4
ram_res         w7e894f, 4
ram_res         w7e8953, 4
ram_res         w7e8957, 4
ram_res         w7e895b, 4
ram_res         w7e895f, 4
ram_res         w7e8963, 4
ram_res         w7e8967, 4
ram_res         w7e896b, 4
ram_byte        w7e896f
ram_byte        w7e8970
ram_byte        w7e8971
ram_byte        w7e8972
ram_byte        w7e8973
ram_byte        w7e8974
ram_byte        w7e8975
ram_byte        w7e8976
ram_byte        w7e8977
ram_byte        w7e8978
ram_byte        w7e8979
ram_byte        w7e897a
ram_byte        w7e897b
ram_byte        w7e897c
ram_byte        w7e897d
ram_byte        w7e897e
ram_byte        w7e897f
ram_byte        w7e8980
ram_byte        w7e8981
ram_byte        w7e8982
ram_byte        w7e8983
ram_byte        w7e8984
ram_byte        w7e8985
ram_byte        w7e8986
ram_byte        w7e8987
ram_byte        w7e8988
ram_byte        w7e8989
ram_byte        w7e898a
ram_byte        w7e898b
ram_byte        w7e898c
ram_byte        w7e898d
ram_byte        w7e898e
ram_byte        w7e898f
ram_byte        w7e8990
ram_byte        w7e8991
ram_byte        w7e8992
ram_res         w7e8993, 224 * 4

ram_res         w7e8d13, $0300
ram_res         w7e9013, $0200
ram_res         w7e9213, $0200
ram_res         w7e9413, $0200

ram_byte        w7e9613
ram_byte        w7e9614
ram_byte        w7e9615
ram_byte        w7e9616
ram_byte        w7e9617
ram_byte        w7e9618
ram_byte        w7e9619
ram_byte        w7e961a
ram_byte        w7e961b
ram_byte        w7e961c
ram_byte        w7e961d
ram_byte        w7e961e
ram_res         w7e961f, $0100
ram_res         w7e971f, $0100
ram_res         w7e981f, $0200
ram_res         w7e9a1f, 152 * 4
ram_res         w7e9c7f, 72 * 4
ram_res         w7e9d9f, 128
ram_res         w7e9e1f, 256
ram_res         w7e9f1f, 152 * 4
ram_res         w7ea17f, $0200
ram_res         w7ea37f, $0200
ram_res         w7ea57f, $0200
ram_res         w7ea77f, $0200
ram_res         w7ea97f, $04c0
ram_res         w7eae3f, $1000
ram_res         w7ebe3f, $1000
ram_res         w7ece3f, $0a80
ram_res         w7ed8bf, $0a80
ram_res         w7ee33f, $0400
ram_res         w7ee73f, $0080
ram_res         w7ee7bf, 64
ram_res         w7ee7ff, 64
ram_res         w7ee83f, 64
ram_res         w7ee87f, 64
ram_res         w7ee8bf, 64
ram_res         w7ee8ff, 64
ram_res         w7ee93f, 64
ram_res         w7ee97f, 64

ram_word        w7ee9bf
ram_byte        w7ee9c1
ram_byte        w7ee9c2
ram_byte        w7ee9c3
ram_word        w7ee9c4
ram_word        w7ee9c6
ram_word        w7ee9c8
ram_word        w7ee9ca
ram_word        w7ee9cc
ram_word        w7ee9ce
ram_word        w7ee9d0
ram_res         w7ee9d2, 4 * 2
ram_byte        w7ee9da
ram_byte        w7ee9db
ram_byte        w7ee9dc
ram_byte        w7ee9dd
ram_byte        w7ee9de
ram_byte        w7ee9df
ram_byte        w7ee9e0
ram_byte        w7ee9e1
ram_word        w7ee9e2
ram_byte        w7ee9e4
ram_byte        w7ee9e5
ram_byte        w7ee9e6
ram_byte        w7ee9e7
ram_byte        w7ee9e8
ram_byte        w7ee9e9
ram_byte        w7ee9ea
ram_byte        w7ee9eb
ram_byte        w7ee9ec
ram_byte        w7ee9ed
ram_byte        w7ee9ee
ram_byte        w7ee9ef
ram_byte        w7ee9f0
ram_byte        w7ee9f1
ram_faraddr     w7ee9f2
ram_byte        w7ee9f5
ram_byte        w7ee9f6
ram_byte        w7ee9f7
ram_byte        w7ee9f8
ram_byte        w7ee9f9
ram_byte        w7ee9fa
ram_byte        w7ee9fb
ram_byte        w7ee9fc
ram_byte        w7ee9fd
ram_res         w7ee9fe, 16 * 2
ram_res         w7eea1e, 10 * 2
ram_res         w7eea32, 228 * 2
ram_byte        w7eebfa
ram_byte        w7eebfb
ram_byte        w7eebfc
ram_byte        w7eebfd
ram_byte        w7eebfe
ram_res         w7eebff, 4 * 2
ram_res         w7eec07, 4 * 2
ram_byte        w7eec0f
ram_byte        w7eec10
ram_array       wBattleBGPal, 3, 32
        ram_word Color0
        ram_word Color1
        ram_word Color2
        ram_word Color3
        ram_word Color4
        ram_word Color5
        ram_word Color6
        ram_word Color7
        ram_word Color8
        ram_word Color9
        ram_word Color10
        ram_word Color11
        ram_word Color12
        ram_word Color13
        ram_word Color14
        ram_word Color15
end_ram_array
ram_array       wBattleBGPalBuf, 2, 32
        ram_word Color0
        ram_word Color1
        ram_word Color2
        ram_word Color3
        ram_word Color4
        ram_word Color5
        ram_word Color6
        ram_word Color7
        ram_word Color8
        ram_word Color9
        ram_word Color10
        ram_word Color11
        ram_word Color12
        ram_word Color13
        ram_word Color14
        ram_word Color15
end_ram_array
ram_byte        w7eecb1
ram_byte        w7eecb2
ram_byte        w7eecb3
ram_word        w7eecb4
ram_word        w7eecb6
ram_word        w7eecb8
ram_byte        w7eecba
ram_byte        w7eecbb
ram_res         w7eecbc, 16
ram_res         w7eeccc, 16
ram_res         w7eecdc, 16
ram_word        w7eecec
ram_byte        w7eecee
ram_byte        w7eecef
.if LANG_EN
ram_byte        w7eecf0
.endif

.assert _ram_offset <= $7ef800, error, "Insufficient battle graphics RAM"

ram_org $7ef800

ram_res         wHypotenuseTbl, $0800
