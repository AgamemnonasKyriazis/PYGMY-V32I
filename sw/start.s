.section .text

.globl _start

_start:
    la gp, __global_pointer$
    la sp, __stack_top
    call main
_halt:
    j _halt

