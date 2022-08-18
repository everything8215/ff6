
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: const.inc                                                            |
; |                                                                            |
; | description: global constant definitions                                   |
; |                                                                            |
; | created: 8/2/2022                                                          |
; |                                                                            |
; | author: everything8215@gmail.com                                           |
; +----------------------------------------------------------------------------+

.list off  ; disable listing

; define a config constant if it's not already defined
.macro def_config _const, _value
        .ifndef _const
        _const = _value
        .endif
.endmacro

def_config DEBUG,0
def_config LANG_EN,0

.if LANG_EN
.define LANG_SUFFIX "en"
.else
.define LANG_SUFFIX "jp"
.endif

.list on
