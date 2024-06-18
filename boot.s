.option pic
.option norvc
.section .text.init
.global _start

.extern main

_start:
    csrr    t0, mhartid
    bnez    t0, _wait
    xor     fp, fp, fp
    la      sp, _stack_start # Initialize stack pointer
    .option push
    .option norelax
    la      gp, _global_pointer  # Initialize global pointer
    .option pop
    call    main
    
_wait:
    wfi
    j      _wait

