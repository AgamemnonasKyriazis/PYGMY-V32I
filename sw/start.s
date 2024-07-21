.section .text

.globl _start

_start:
    # Load gp
    la gp, __global_pointer$
    # Load sp
    la sp, __stack_top$

    # Load trap handler base
    la t0, _MSYSIE
    csrrw t0, mtvec, t0

    call main

_halt:
    j _halt

_MSYSIE:
    # Save the context
    addi sp, sp, -128       # Allocate stack space
    sw ra, 124(sp)          # Save return address
    sw t0, 120(sp)          # Save temporary registers
    sw t1, 116(sp)
    sw t2, 112(sp)
    sw t3, 108(sp)
    sw t4, 104(sp)
    sw t5, 100(sp)
    sw t6, 96(sp)
    sw a0, 92(sp)           # Save argument registers
    sw a1, 88(sp)
    sw a2, 84(sp)
    sw a3, 80(sp)
    sw a4, 76(sp)
    sw a5, 72(sp)
    sw a6, 68(sp)
    sw a7, 64(sp)
    sw s0, 60(sp)           # Save saved registers
    sw s1, 56(sp)
    sw s2, 52(sp)
    sw s3, 48(sp)
    sw s4, 44(sp)
    sw s5, 40(sp)
    sw s6, 36(sp)
    sw s7, 32(sp)
    sw s8, 28(sp)
    sw s9, 24(sp)
    sw s10, 20(sp)
    sw s11, 16(sp)
    # Begin of actual trap excecution
    csrrw t3, mie, zero
    li s0, 0x02000000
    lw s1, 0(s0)
    sw s1, 0(s0)
    csrrw zero, mie, t3
    # End of actual trap excecution
    # Restore the context
    lw ra, 124(sp)          # Restore return address
    lw t0, 120(sp)          # Restore temporary registers
    lw t1, 116(sp)
    lw t2, 112(sp)
    lw t3, 108(sp)
    lw t4, 104(sp)
    lw t5, 100(sp)
    lw t6, 96(sp)
    lw a0, 92(sp)           # Restore argument registers
    lw a1, 88(sp)
    lw a2, 84(sp)
    lw a3, 80(sp)
    lw a4, 76(sp)
    lw a5, 72(sp)
    lw a6, 68(sp)
    lw a7, 64(sp)
    lw s0, 60(sp)           # Restore saved registers
    lw s1, 56(sp)
    lw s2, 52(sp)
    lw s3, 48(sp)
    lw s4, 44(sp)
    lw s5, 40(sp)
    lw s6, 36(sp)
    lw s7, 32(sp)
    lw s8, 28(sp)
    lw s9, 24(sp)
    lw s10, 20(sp)
    lw s11, 16(sp)
    addi sp, sp, 128        # Deallocate stack space
    
    mret