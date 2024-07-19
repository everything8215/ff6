
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

hDMA0 := $4300
.scope hDMA0
        CTRL    := $4300
        HREG    := $4301
        ADDR    := $4302
        ADDR_L  := $4302
        ADDR_H  := $4303
        ADDR_B  := $4304
        SIZE    := $4305
        SIZE_L  := $4305
        SIZE_H  := $4306
        HDMA_B  := $4307
.endscope

hDMA1 := $4310
.scope hDMA1
        CTRL    := $4310
        HREG    := $4311
        ADDR    := $4312
        ADDR_L  := $4312
        ADDR_H  := $4313
        ADDR_B  := $4314
        SIZE    := $4315
        SIZE_L  := $4315
        SIZE_H  := $4316
        HDMA_L  := $4315
        HDMA_H  := $4316
        HDMA_B  := $4317
.endscope

hDMA2 := $4320
.scope hDMA2
        CTRL    := $4320
        HREG    := $4321
        ADDR    := $4322
        ADDR_L  := $4322
        ADDR_H  := $4323
        ADDR_B  := $4324
        SIZE    := $4325
        SIZE_L  := $4325
        SIZE_H  := $4326
        HDMA_B  := $4327
.endscope

hDMA3 := $4330
.scope hDMA3
        CTRL    := $4330
        HREG    := $4331
        ADDR    := $4332
        ADDR_L  := $4332
        ADDR_H  := $4333
        ADDR_B  := $4334
        SIZE    := $4335
        SIZE_L  := $4335
        SIZE_H  := $4336
        HDMA_B  := $4337
.endscope

hDMA4 := $4340
.scope hDMA4
        CTRL    := $4340
        HREG    := $4341
        ADDR    := $4342
        ADDR_L  := $4342
        ADDR_H  := $4343
        ADDR_B  := $4344
        SIZE    := $4345
        SIZE_L  := $4345
        SIZE_H  := $4346
        HDMA_B  := $4347
.endscope

hDMA5 := $4350
.scope hDMA5
        CTRL    := $4350
        HREG    := $4351
        ADDR    := $4352
        ADDR_L  := $4352
        ADDR_H  := $4353
        ADDR_B  := $4354
        SIZE    := $4355
        SIZE_L  := $4355
        SIZE_H  := $4356
        HDMA_B  := $4357
.endscope

hDMA6 := $4360
.scope hDMA6
        CTRL    := $4360
        HREG    := $4361
        ADDR    := $4362
        ADDR_L  := $4362
        ADDR_H  := $4363
        ADDR_B  := $4364
        SIZE    := $4365
        SIZE_L  := $4365
        SIZE_H  := $4366
        HDMA_B  := $4367
.endscope

hDMA7 := $4370
.scope hDMA7
        CTRL    := $4370
        HREG    := $4371
        ADDR    := $4372
        ADDR_L  := $4372
        ADDR_H  := $4373
        ADDR_B  := $4374
        SIZE    := $4375
        SIZE_L  := $4375
        SIZE_H  := $4376
        HDMA_B  := $4377
.endscope

; ------------------------------------------------------------------------------

; [ joypad button masks ]

JOY_A           = %0000000010000000
JOY_X           = %0000000001000000
JOY_L           = %0000000000100000
JOY_R           = %0000000000010000

JOY_B           = %1000000000000000
JOY_Y           = %0100000000000000
JOY_SELECT      = %0010000000000000
JOY_START       = %0001000000000000
JOY_UP          = %0000100000000000
JOY_DOWN        = %0000010000000000
JOY_LEFT        = %0000001000000000
JOY_RIGHT       = %0000000100000000

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
