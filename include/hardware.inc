
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: hardware.inc                                                         |
; |                                                                            |
; | description: snes hardware register definitions                            |
; |                                                                            |
; | created: 8/2/2022                                                          |
; |                                                                            |
; | author: everything8215@gmail.com                                           |
; +----------------------------------------------------------------------------+

.list off
.ifndef HARDWARE_INC
HARDWARE_INC = 1

; ------------------------------------------------------------------------------

; [ ppu registers ]

hINIDISP        := $2100
hOBJSEL         := $2101
hOAMADDL        := $2102
hOAMADDH        := $2103
hOAMDATA        := $2104
hBGMODE         := $2105
hMOSAIC         := $2106
hBG1SC          := $2107
hBG2SC          := $2108
hBG3SC          := $2109
hBG4SC          := $210a
hBG12NBA        := $210b
hBG34NBA        := $210c
hBG1HOFS        := $210d
hBG1VOFS        := $210e
hBG2HOFS        := $210f
hBG2VOFS        := $2110
hBG3HOFS        := $2111
hBG3VOFS        := $2112
hBG4HOFS        := $2113
hBG4VOFS        := $2114
hVMAINC         := $2115
hVMADDL         := $2116
hVMADDH         := $2117
hVMDATAL        := $2118
hVMDATAH        := $2119
hM7SEL          := $211a
hM7A            := $211b
hM7B            := $211c
hM7C            := $211d
hM7D            := $211e
hM7X            := $211f
hM7Y            := $2120
hCGADD          := $2121
hCGDATA         := $2122
hW12SEL         := $2123
hW34SEL         := $2124
hWOBJSEL        := $2125
hWH0            := $2126
hWH1            := $2127
hWH2            := $2128
hWH3            := $2129
hWBGLOG         := $212a
hWOBJLOG        := $212b
hTM             := $212c
hTS             := $212d
hTMW            := $212e
hTSW            := $212f
hCGSWSEL        := $2130
hCGADSUB        := $2131
hCOLDATA        := $2132
hSETINI         := $2133
hMPYL           := $2134
hMPYM           := $2135
hMPYH           := $2136
hSLHV           := $2137
hROAMDATA       := $2138
hRVMDATAL       := $2139
hRVMDATAH       := $213a
hRCGDATA        := $213b
hOPHCT          := $213c
hOPVCT          := $213d
hSTAT77         := $213e
hSTAT78         := $213f
hAPUIO0         := $2140
hAPUIO1         := $2141
hAPUIO2         := $2142
hAPUIO3         := $2143
hWMDATA         := $2180
hWMADDL         := $2181
hWMADDM         := $2182
hWMADDH         := $2183

; ------------------------------------------------------------------------------

; [ cpu registers ]

hNMITIMEN       := $4200
hWRIO           := $4201
hWRMPYA         := $4202
hWRMPYB         := $4203
hWRDIVL         := $4204
hWRDIVH         := $4205
hWRDIVB         := $4206
hHTIMEL         := $4207
hHTIMEH         := $4208
hVTIMEL         := $4209
hVTIMEH         := $420a
hMDMAEN         := $420b
hHDMAEN         := $420c
hMEMSEL         := $420d
hRDNMI          := $4210
hTIMEUP         := $4211
hHVBJOY         := $4212
hRDIO           := $4213
hRDDIVL         := $4214
hRDDIVH         := $4215
hRDMPYL         := $4216
hRDMPYH         := $4217
hSTDCNTRL1L     := $4218
hSTDCNTRL1H     := $4219
hSTDCNTRL2L     := $421a
hSTDCNTRL2H     := $421b
hSTDCNTRL3L     := $421c
hSTDCNTRL3H     := $421d
hSTDCNTRL4L     := $421e
hSTDCNTRL4H     := $421f

; ------------------------------------------------------------------------------

; [ dma registers ]

hDMAP0          := $4300
hDMAB0          := $4301
hDMAAL0         := $4302
hDMAAH0         := $4303
hDMAAB0         := $4304
hDMADL0         := $4305
hDMADH0         := $4306
hDMADB0         := $4307
hDMATL0         := $4308
hDMATH0         := $4309
hDMAL0          := $430a
hDMAP1          := $4310
hDMAB1          := $4311
hDMAAL1         := $4312
hDMAAH1         := $4313
hDMAAB1         := $4314
hDMADL1         := $4315
hDMADH1         := $4316
hDMADB1         := $4317
hDMATL1         := $4318
hDMATH1         := $4319
hDMAL1          := $431a
hDMAP2          := $4320
hDMAB2          := $4321
hDMAAL2         := $4322
hDMAAH2         := $4323
hDMAAB2         := $4324
hDMADL2         := $4325
hDMADH2         := $4326
hDMADB2         := $4327
hDMATL2         := $4328
hDMATH2         := $4329
hDMAL2          := $432a
hDMAP3          := $4330
hDMAB3          := $4331
hDMAAL3         := $4332
hDMAAH3         := $4333
hDMAAB3         := $4334
hDMADL3         := $4335
hDMADH3         := $4336
hDMADB3         := $4337
hDMATL3         := $4338
hDMATH3         := $4339
hDMAL3          := $433a
hDMAP4          := $4340
hDMAB4          := $4341
hDMAAL4         := $4342
hDMAAH4         := $4343
hDMAAB4         := $4344
hDMADL4         := $4345
hDMADH4         := $4346
hDMADB4         := $4347
hDMATL4         := $4348
hDMATH4         := $4349
hDMAL4          := $434a
hDMAP5          := $4350
hDMAB5          := $4351
hDMAAL5         := $4352
hDMAAH5         := $4353
hDMAAB5         := $4354
hDMADL5         := $4355
hDMADH5         := $4356
hDMADB5         := $4357
hDMATL5         := $4358
hDMATH5         := $4359
hDMAL5          := $435a
hDMAP6          := $4360
hDMAB6          := $4361
hDMAAL6         := $4362
hDMAAH6         := $4363
hDMAAB6         := $4364
hDMADL6         := $4365
hDMADH6         := $4366
hDMADB6         := $4367
hDMATL6         := $4368
hDMATH6         := $4369
hDMAL6          := $436a
hDMAP7          := $4370
hDMAB7          := $4371
hDMAAL7         := $4372
hDMAAH7         := $4373
hDMAAB7         := $4374
hDMADL7         := $4375
hDMADH7         := $4376
hDMADB7         := $4377
hDMATL7         := $4378
hDMATH7         := $4379
hDMAL7          := $437a

; ------------------------------------------------------------------------------

; [ joypad button masks ]

JOY_A           = %10000000
JOY_X           = %01000000
JOY_L           = %00100000
JOY_R           = %00010000

JOY_B           = %10000000
JOY_Y           = %01000000
JOY_SELECT      = %00100000
JOY_START       = %00010000
JOY_UP          = %00001000
JOY_DOWN        = %00000100
JOY_LEFT        = %00000010
JOY_RIGHT       = %00000001

; ------------------------------------------------------------------------------

; [ fixed color components ]

.enum FIXED_CLR
        BLACK                           = %00000000
        RED                             = %00100000
        GREEN                           = %01000000
        YELLOW                          = %01100000
        BLUE                            = %10000000
        MAGENTA                         = %10100000
        CYAN                            = %11000000
        WHITE                           = %11100000
        MASK                            = %11100000
.endenum

; ------------------------------------------------------------------------------

.endif
.list on
