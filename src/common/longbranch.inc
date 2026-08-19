; [ long branch instructions ]

.mac  jeq     addr
        bne     *+5
        jmp     addr
.endmacro

.mac  jne     addr
        beq     *+5
        jmp     addr
.endmacro

.mac  jmi     addr
        bpl     *+5
        jmp     addr
.endmacro

.mac  jpl     addr
        bmi     *+5
        jmp     addr
.endmacro

.mac  jcs     addr
        bcc     *+5
        jmp     addr
.endmacro

.mac  jcc     addr
        bcs     *+5
        jmp     addr
.endmacro

.mac  jvs     addr
        bvc     *+5
        jmp     addr
.endmacro

.mac  jvc     addr
        bvs     *+5
        jmp     addr
.endmacro
