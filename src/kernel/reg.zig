/// RISC-V General Registers (including floating point)
const GenReg64 = enum { x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, zero, ra, sp, gp, tp, t0, t1, t2, s0, fp, s1, a0, a1, a2, a3, a4, a5, a6, a7, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, t3, t4, t5, t6 };

pub fn getRegisterValue(comptime reg: GenReg64, comptime T: type) T {
    return switch (reg) {
        .x0, .zero => asm (""
            : [ret] "={x0}" (-> T),
        ),
        .x1, .ra => asm (""
            : [ret] "={x1}" (-> T),
        ),
        .x2, .sp => asm (""
            : [ret] "={x2}" (-> T),
        ),
        .x3, .gp => asm (""
            : [ret] "={x3}" (-> T),
        ),
        .x4, .tp => asm (""
            : [ret] "={x4}" (-> T),
        ),
        .x5, .t0 => asm (""
            : [ret] "={x5}" (-> T),
        ),
        .x6, .t1 => asm (""
            : [ret] "={x6}" (-> T),
        ),
        .x7, .t2 => asm (""
            : [ret] "={x7}" (-> T),
        ),
        .x8, .s0, .fp => asm (""
            : [ret] "={x8}" (-> T),
        ),
        .x9, .s1 => asm (""
            : [ret] "={x9}" (-> T),
        ),
        .x10, .a0 => asm (""
            : [ret] "={x10}" (-> T),
        ),
        .x11, .a1 => asm (""
            : [ret] "={x11}" (-> T),
        ),
        .x12, .a2 => asm (""
            : [ret] "={x12}" (-> T),
        ),
        .x13, .a3 => asm (""
            : [ret] "={x13}" (-> T),
        ),
        .x14, .a4 => asm (""
            : [ret] "={x14}" (-> T),
        ),
        .x15, .a5 => asm (""
            : [ret] "={x15}" (-> T),
        ),
        .x16, .a6 => asm (""
            : [ret] "={x16}" (-> T),
        ),
        .x17, .a7 => asm (""
            : [ret] "={x17}" (-> T),
        ),
        .x18, .s2 => asm (""
            : [ret] "={x18}" (-> T),
        ),
        .x19, .s3 => asm (""
            : [ret] "={x19}" (-> T),
        ),
        .x20, .s4 => asm (""
            : [ret] "={x20}" (-> T),
        ),
        .x21, .s5 => asm (""
            : [ret] "={x21}" (-> T),
        ),
        .x22, .s6 => asm (""
            : [ret] "={x22}" (-> T),
        ),
        .x23, .s7 => asm (""
            : [ret] "={x23}" (-> T),
        ),
        .x24, .s8 => asm (""
            : [ret] "={x24}" (-> T),
        ),
        .x25, .s9 => asm (""
            : [ret] "={x25}" (-> T),
        ),
        .x26, .s10 => asm (""
            : [ret] "={x26}" (-> T),
        ),
        .x27, .s11 => asm (""
            : [ret] "={x27}" (-> T),
        ),
        .x28, .t3 => asm (""
            : [ret] "={x28}" (-> T),
        ),
        .x29, .t4 => asm (""
            : [ret] "={x29}" (-> T),
        ),
        .x30, .t5 => asm (""
            : [ret] "={x30}" (-> T),
        ),
        .x31, .t6 => asm (""
            : [ret] "={x31}" (-> T),
        ),
    };
}

pub fn setRegisterValue(comptime reg: GenReg64, comptime value: anytype) void {
    switch (reg) {
        .x0, .zero => asm volatile (""
            :
            : [value] "{x0}" (value),
        ),
        .x1, .ra => asm volatile (""
            :
            : [value] "{x1}" (value),
        ),
        .x2, .sp => asm volatile (""
            :
            : [value] "{x2}" (value),
        ),
        .x3, .gp => asm volatile (""
            :
            : [value] "{x3}" (value),
        ),
        .x4, .tp => asm volatile (""
            :
            : [value] "{x4}" (value),
        ),
        .x5, .t0 => asm volatile (""
            :
            : [value] "{x5}" (value),
        ),
        .x6, .t1 => asm volatile (""
            :
            : [value] "{x6}" (value),
        ),
        .x7, .t2 => asm volatile (""
            :
            : [value] "{x7}" (value),
        ),
        .x8, .s0, .fp => asm volatile (""
            :
            : [value] "{x8}" (value),
        ),
        .x9, .s1 => asm volatile (""
            :
            : [value] "{x9}" (value),
        ),
        .x10, .a0 => asm volatile (""
            :
            : [value] "{x10}" (value),
        ),
        .x11, .a1 => asm volatile (""
            :
            : [value] "{x11}" (value),
        ),
        .x12, .a2 => asm volatile (""
            :
            : [value] "{x12}" (value),
        ),
        .x13, .a3 => asm volatile (""
            :
            : [value] "{x13}" (value),
        ),
        .x14, .a4 => asm volatile (""
            :
            : [value] "{x14}" (value),
        ),
        .x15, .a5 => asm volatile (""
            :
            : [value] "{x15}" (value),
        ),
        .x16, .a6 => asm volatile (""
            :
            : [value] "{x16}" (value),
        ),
        .x17, .a7 => asm volatile (""
            :
            : [value] "{x17}" (value),
        ),
        .x18, .s2 => asm volatile (""
            :
            : [value] "{x18}" (value),
        ),
        .x19, .s3 => asm volatile (""
            :
            : [value] "{x19}" (value),
        ),
        .x20, .s4 => asm volatile (""
            :
            : [value] "{x20}" (value),
        ),
        .x21, .s5 => asm volatile (""
            :
            : [value] "{x21}" (value),
        ),
        .x22, .s6 => asm volatile (""
            :
            : [value] "{x22}" (value),
        ),
        .x23, .s7 => asm volatile (""
            :
            : [value] "{x23}" (value),
        ),
        .x24, .s8 => asm volatile (""
            :
            : [value] "{x24}" (value),
        ),
        .x25, .s9 => asm volatile (""
            :
            : [value] "{x25}" (value),
        ),
        .x26, .s10 => asm volatile (""
            :
            : [value] "{x26}" (value),
        ),
        .x27, .s11 => asm volatile (""
            :
            : [value] "{x27}" (value),
        ),
        .x28, .t3 => asm volatile (""
            :
            : [value] "{x28}" (value),
        ),
        .x29, .t4 => asm volatile (""
            :
            : [value] "{x29}" (value),
        ),
        .x30, .t5 => asm volatile (""
            :
            : [value] "{x30}" (value),
        ),
        .x31, .t6 => asm volatile (""
            :
            : [value] "{x31}" (value),
        ),
    }
}
