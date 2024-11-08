
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:

_start:
    # Load gp
    .option push
	.option norelax
    la gp, __global_pointer$
       0:	20001197          	auipc	gp,0x20001
       4:	80018193          	add	gp,gp,-2048 # 20000800 <__global_pointer$>

    la a4, _sdata_load$
       8:	00001717          	auipc	a4,0x1
       c:	69870713          	add	a4,a4,1688 # 16a0 <_sdata_load$>
    la a5, _sdata$
      10:	20000797          	auipc	a5,0x20000
      14:	ff078793          	add	a5,a5,-16 # 20000000 <GPIO>
    la a6, _edata$
      18:	20000817          	auipc	a6,0x20000
      1c:	0f880813          	add	a6,a6,248 # 20000110 <__malloc_sbrk_start>

00000020 <_data_copy_loop>:
_data_copy_loop:
    lw a7, 0(a4)
      20:	00072883          	lw	a7,0(a4)
    sw a7, 0(a5)
      24:	0117a023          	sw	a7,0(a5)
    addi a5, a5, 0x04
      28:	00478793          	add	a5,a5,4
    addi a4, a4, 0x04
      2c:	00470713          	add	a4,a4,4
    blt a5, a6, _data_copy_loop
      30:	ff07c8e3          	blt	a5,a6,20 <_data_copy_loop>

    la a4, _sbss$
      34:	20000717          	auipc	a4,0x20000
      38:	0dc70713          	add	a4,a4,220 # 20000110 <__malloc_sbrk_start>
    la a5, _ebss$
      3c:	20000797          	auipc	a5,0x20000
      40:	12478793          	add	a5,a5,292 # 20000160 <__end$>

00000044 <_bss_zero_loop>:
_bss_zero_loop:
    sw zero, 0(a4)
      44:	00072023          	sw	zero,0(a4)
    addi a4, a4, 0x04
      48:	00470713          	add	a4,a4,4
    blt a4, a5, _bss_zero_loop
      4c:	fef74ce3          	blt	a4,a5,44 <_bss_zero_loop>

    la a4, __heap_start$
      50:	20000717          	auipc	a4,0x20000
      54:	11070713          	add	a4,a4,272 # 20000160 <__end$>
    la a5, __heap_end$
      58:	20000797          	auipc	a5,0x20000
      5c:	50878793          	add	a5,a5,1288 # 20000560 <__heap_end$>

00000060 <_heap_zero_loop>:
_heap_zero_loop:
    sw zero, 0(a4)
      60:	00072023          	sw	zero,0(a4)
    addi a4, a4, 0x04
      64:	00470713          	add	a4,a4,4
    blt a4, a5, _heap_zero_loop
      68:	fef74ce3          	blt	a4,a5,60 <_heap_zero_loop>

    li a4, 0
      6c:	00000713          	li	a4,0
    li a5, 0
      70:	00000793          	li	a5,0
    li a6, 0
      74:	00000813          	li	a6,0

    .option pop

    # Load sp
    la sp, __stack_top$
      78:	20004117          	auipc	sp,0x20004
      7c:	ce810113          	add	sp,sp,-792 # 20003d60 <__stack_top$>

    # Load trap handler base
    la t0, _MSYSIE
      80:	00000297          	auipc	t0,0x0
      84:	01428293          	add	t0,t0,20 # 94 <_MSYSIE>
    csrrw t0, mtvec, t0
      88:	305292f3          	csrrw	t0,mtvec,t0

    call main
      8c:	16c000ef          	jal	1f8 <main>

00000090 <_halt>:

_halt:
    j _halt
      90:	0000006f          	j	90 <_halt>

00000094 <_MSYSIE>:
#    lw s8, 28(sp)
#    lw s9, 24(sp)
#    lw s10, 20(sp)
#    lw s11, 16(sp)
#    addi sp, sp, 128        # Deallocate stack space
    mret
      94:	30200073          	mret

00000098 <hal_write_32bit>:
#include <hal.h>
#include <system.h>

void hal_write_32bit(uint32_t addr, uint32_t val) {
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
      98:	00b52023          	sw	a1,0(a0)
}
      9c:	00008067          	ret

000000a0 <hal_write_16bit>:

void hal_write_16bit(uint32_t addr, uint16_t val) {
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
      a0:	00b51023          	sh	a1,0(a0)
}
      a4:	00008067          	ret

000000a8 <hal_write_8bit>:

void hal_write_8bit(uint32_t addr, uint8_t val) {
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
      a8:	00b50023          	sb	a1,0(a0)
}
      ac:	00008067          	ret

000000b0 <hal_read_32bit>:

uint32_t hal_read_32bit(uint32_t addr) {
    uint32_t val;
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
      b0:	00052503          	lw	a0,0(a0)
    return val;
}
      b4:	00008067          	ret

000000b8 <hal_read_16bit>:

uint16_t hal_read_16bit(uint32_t addr) {
    uint16_t val;
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
      b8:	00051503          	lh	a0,0(a0)
    return val;
}
      bc:	01051513          	sll	a0,a0,0x10
      c0:	01055513          	srl	a0,a0,0x10
      c4:	00008067          	ret

000000c8 <hal_read_8bit>:

uint8_t hal_read_8bit(uint32_t addr) {
    uint8_t val;
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
      c8:	00050503          	lb	a0,0(a0)
    return val;
}
      cc:	0ff57513          	zext.b	a0,a0
      d0:	00008067          	ret

000000d4 <EXT_IRQ_0_HANDLER>:
  }
  
  return;
}

__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
      d4:	00008067          	ret

000000d8 <EXT_IRQ_1_HANDLER>:
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
      d8:	00008067          	ret

000000dc <EXT_IRQ_2_HANDLER>:
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
      dc:	00008067          	ret

000000e0 <EXT_IRQ_3_HANDLER>:
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
      e0:	00008067          	ret

000000e4 <EXT_IRQ_4_HANDLER>:
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
      e4:	00008067          	ret

000000e8 <EXT_IRQ_5_HANDLER>:
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
      e8:	00008067          	ret

000000ec <BASE_IRQ_HANDLER>:
  uint32_t cause = hal_read_csr(mcause);
      ec:	342027f3          	csrr	a5,mcause
  if (cause & EXT_SYS_I0_IE)
      f0:	0017f713          	and	a4,a5,1
      f4:	00070463          	beqz	a4,fc <BASE_IRQ_HANDLER+0x10>
    EXT_IRQ_0_HANDLER();
      f8:	fddff06f          	j	d4 <EXT_IRQ_0_HANDLER>
  else if (cause & EXT_SYS_I1_IE)
      fc:	0027f713          	and	a4,a5,2
     100:	00070463          	beqz	a4,108 <BASE_IRQ_HANDLER+0x1c>
    EXT_IRQ_1_HANDLER();
     104:	fd5ff06f          	j	d8 <EXT_IRQ_1_HANDLER>
  else if (cause & EXT_SYS_I2_IE)
     108:	0047f713          	and	a4,a5,4
     10c:	00070463          	beqz	a4,114 <BASE_IRQ_HANDLER+0x28>
    EXT_IRQ_2_HANDLER();
     110:	fcdff06f          	j	dc <EXT_IRQ_2_HANDLER>
  else if (cause & EXT_SYS_I3_IE)
     114:	0087f713          	and	a4,a5,8
     118:	00070463          	beqz	a4,120 <BASE_IRQ_HANDLER+0x34>
    EXT_IRQ_3_HANDLER();
     11c:	fc5ff06f          	j	e0 <EXT_IRQ_3_HANDLER>
  else if (cause & EXT_SYS_I4_IE)
     120:	0107f713          	and	a4,a5,16
     124:	00070463          	beqz	a4,12c <BASE_IRQ_HANDLER+0x40>
    EXT_IRQ_4_HANDLER();
     128:	fbdff06f          	j	e4 <EXT_IRQ_4_HANDLER>
  else if (cause & EXT_SYS_I5_IE)
     12c:	0207f793          	and	a5,a5,32
     130:	00078463          	beqz	a5,138 <BASE_IRQ_HANDLER+0x4c>
    EXT_IRQ_5_HANDLER();
     134:	fb5ff06f          	j	e8 <EXT_IRQ_5_HANDLER>
}
     138:	00008067          	ret

0000013c <hex_print>:
  ((uart_instance_t *)(UART_BASE))->DATA = size;
  size >>= 8;
  ((uart_instance_t *)(UART_BASE))->DATA = size;
  size >>= 8;
  ((uart_instance_t *)(UART_BASE))->DATA = size;
  size >>= 8;
     13c:	01855513          	srl	a0,a0,0x18
  ((uart_instance_t *)(UART_BASE))->DATA = size;
     140:	400007b7          	lui	a5,0x40000
     144:	00a78023          	sb	a0,0(a5) # 40000000 <__stack_top$+0x1fffc2a0>
}
     148:	00008067          	ret

0000014c <echo>:

int echo(int fd, const char* ptr, size_t size) {
  while (*ptr)
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
     14c:	40000737          	lui	a4,0x40000
  while (*ptr)
     150:	0005c783          	lbu	a5,0(a1)
     154:	00079463          	bnez	a5,15c <echo+0x10>
}
     158:	00008067          	ret
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
     15c:	00158593          	add	a1,a1,1
     160:	00f70023          	sb	a5,0(a4) # 40000000 <__stack_top$+0x1fffc2a0>
     164:	fedff06f          	j	150 <echo+0x4>

00000168 <_open>:

int _open(int fd) {
  return -1;
}
     168:	fff00513          	li	a0,-1
     16c:	00008067          	ret

00000170 <_close>:

int _close(int fd) {
     170:	fff00513          	li	a0,-1
     174:	00008067          	ret

00000178 <_fstat>:
  return -1;
}

int _fstat(int fd, struct stat *st) {
  st->st_mode = S_IFCHR;
     178:	000027b7          	lui	a5,0x2
     17c:	00f5a223          	sw	a5,4(a1)
  return 0;
}
     180:	00000513          	li	a0,0
     184:	00008067          	ret

00000188 <_isatty>:

int _isatty(int fd) {
  return 1;
}
     188:	00100513          	li	a0,1
     18c:	00008067          	ret

00000190 <_lseek>:

int _lseek(int fd, int ptr, int dir) {
  return 0;
}
     190:	00000513          	li	a0,0
     194:	00008067          	ret

00000198 <_exit>:

void _exit(int status) {
  while (1);
     198:	0000006f          	j	198 <_exit>

0000019c <_kill>:
}

void _kill(int pid, int sig) {
  return;
}
     19c:	00008067          	ret

000001a0 <_getpid>:

int _getpid(void) {
  return -1;
}
     1a0:	fff00513          	li	a0,-1
     1a4:	00008067          	ret

000001a8 <_sbrk>:

void *_sbrk(ptrdiff_t incr) {
     1a8:	00050793          	mv	a5,a0
  extern char __heap_start$;
  extern char __heap_end$;
  static char * curbrk = &__end$;
  char * ret = NULL;

  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
     1ac:	8b41a503          	lw	a0,-1868(gp) # 200000b4 <curbrk.0>
     1b0:	96018713          	add	a4,gp,-1696 # 20000160 <__end$>
     1b4:	00f507b3          	add	a5,a0,a5
     1b8:	00e7ea63          	bltu	a5,a4,1cc <_sbrk+0x24>
     1bc:	d6018713          	add	a4,gp,-672 # 20000560 <__heap_end$>
     1c0:	00f76663          	bltu	a4,a5,1cc <_sbrk+0x24>
    return (void *)-1;
  }

  ret = curbrk;
  curbrk += incr;
     1c4:	8af1aa23          	sw	a5,-1868(gp) # 200000b4 <curbrk.0>
  return ret;
     1c8:	00008067          	ret
    return (void *)-1;
     1cc:	fff00513          	li	a0,-1
}
     1d0:	00008067          	ret

000001d4 <_read>:

int _read (int fd, char *buf, int count) {
  int read = 0;
  return read;
}
     1d4:	00000513          	li	a0,0
     1d8:	00008067          	ret

000001dc <_write>:
  size >>= 8;
     1dc:	0185d593          	srl	a1,a1,0x18
  ((uart_instance_t *)(UART_BASE))->DATA = size;
     1e0:	400007b7          	lui	a5,0x40000
     1e4:	00b78023          	sb	a1,0(a5) # 40000000 <__stack_top$+0x1fffc2a0>

int _write(int fd, const void* ptr, ssize_t len) {
  hex_print(len);
  hex_print((size_t)(char*)ptr);
  return len;
     1e8:	00060513          	mv	a0,a2
     1ec:	00008067          	ret

000001f0 <loop>:

uint8_t loop(uint8_t x) {
  if (x < 255)
    return loop(x+1);
  return x;
}
     1f0:	0ff00513          	li	a0,255
     1f4:	00008067          	ret

000001f8 <main>:

int main()
{
  //UART->DATA = loop(1);

  snprintf(buf, 10, "%s", msg);
     1f8:	20000637          	lui	a2,0x20000
{
     1fc:	ff010113          	add	sp,sp,-16
  snprintf(buf, 10, "%s", msg);
     200:	84c18693          	add	a3,gp,-1972 # 2000004c <msg>
     204:	00c60613          	add	a2,a2,12 # 2000000c <UART+0x4>
     208:	00a00593          	li	a1,10
     20c:	91c18513          	add	a0,gp,-1764 # 2000011c <buf>
{
     210:	00112623          	sw	ra,12(sp)
  snprintf(buf, 10, "%s", msg);
     214:	0bc000ef          	jal	2d0 <sniprintf>

  while (1);
     218:	0000006f          	j	218 <main+0x20>

0000021c <_sniprintf_r>:
     21c:	f7010113          	add	sp,sp,-144
     220:	06812c23          	sw	s0,120(sp)
     224:	06912a23          	sw	s1,116(sp)
     228:	06112e23          	sw	ra,124(sp)
     22c:	07212823          	sw	s2,112(sp)
     230:	08e12023          	sw	a4,128(sp)
     234:	08f12223          	sw	a5,132(sp)
     238:	09012423          	sw	a6,136(sp)
     23c:	09112623          	sw	a7,140(sp)
     240:	00050493          	mv	s1,a0
     244:	00060413          	mv	s0,a2
     248:	02065463          	bgez	a2,270 <_sniprintf_r+0x54>
     24c:	08b00793          	li	a5,139
     250:	00f52023          	sw	a5,0(a0)
     254:	fff00513          	li	a0,-1
     258:	07c12083          	lw	ra,124(sp)
     25c:	07812403          	lw	s0,120(sp)
     260:	07412483          	lw	s1,116(sp)
     264:	07012903          	lw	s2,112(sp)
     268:	09010113          	add	sp,sp,144
     26c:	00008067          	ret
     270:	20800793          	li	a5,520
     274:	00f11a23          	sh	a5,20(sp)
     278:	00b12423          	sw	a1,8(sp)
     27c:	00b12c23          	sw	a1,24(sp)
     280:	00068613          	mv	a2,a3
     284:	00000793          	li	a5,0
     288:	00040463          	beqz	s0,290 <_sniprintf_r+0x74>
     28c:	fff40793          	add	a5,s0,-1
     290:	fff00913          	li	s2,-1
     294:	08010693          	add	a3,sp,128
     298:	00810593          	add	a1,sp,8
     29c:	00048513          	mv	a0,s1
     2a0:	00f12823          	sw	a5,16(sp)
     2a4:	00f12e23          	sw	a5,28(sp)
     2a8:	01211b23          	sh	s2,22(sp)
     2ac:	00d12223          	sw	a3,4(sp)
     2b0:	3f8000ef          	jal	6a8 <_svfiprintf_r>
     2b4:	01255663          	bge	a0,s2,2c0 <_sniprintf_r+0xa4>
     2b8:	08b00793          	li	a5,139
     2bc:	00f4a023          	sw	a5,0(s1)
     2c0:	f8040ce3          	beqz	s0,258 <_sniprintf_r+0x3c>
     2c4:	00812783          	lw	a5,8(sp)
     2c8:	00078023          	sb	zero,0(a5)
     2cc:	f8dff06f          	j	258 <_sniprintf_r+0x3c>

000002d0 <sniprintf>:
     2d0:	f6010113          	add	sp,sp,-160
     2d4:	06912a23          	sw	s1,116(sp)
     2d8:	08f12a23          	sw	a5,148(sp)
     2dc:	06112e23          	sw	ra,124(sp)
     2e0:	06812c23          	sw	s0,120(sp)
     2e4:	07212823          	sw	s2,112(sp)
     2e8:	08d12623          	sw	a3,140(sp)
     2ec:	08e12823          	sw	a4,144(sp)
     2f0:	09012c23          	sw	a6,152(sp)
     2f4:	09112e23          	sw	a7,156(sp)
     2f8:	8b81a483          	lw	s1,-1864(gp) # 200000b8 <_impure_ptr>
     2fc:	0205d463          	bgez	a1,324 <sniprintf+0x54>
     300:	08b00793          	li	a5,139
     304:	00f4a023          	sw	a5,0(s1)
     308:	fff00513          	li	a0,-1
     30c:	07c12083          	lw	ra,124(sp)
     310:	07812403          	lw	s0,120(sp)
     314:	07412483          	lw	s1,116(sp)
     318:	07012903          	lw	s2,112(sp)
     31c:	0a010113          	add	sp,sp,160
     320:	00008067          	ret
     324:	20800793          	li	a5,520
     328:	00f11a23          	sh	a5,20(sp)
     32c:	00a12423          	sw	a0,8(sp)
     330:	00a12c23          	sw	a0,24(sp)
     334:	00058413          	mv	s0,a1
     338:	00000793          	li	a5,0
     33c:	00058463          	beqz	a1,344 <sniprintf+0x74>
     340:	fff58793          	add	a5,a1,-1
     344:	fff00913          	li	s2,-1
     348:	08c10693          	add	a3,sp,140
     34c:	00810593          	add	a1,sp,8
     350:	00048513          	mv	a0,s1
     354:	00f12823          	sw	a5,16(sp)
     358:	00f12e23          	sw	a5,28(sp)
     35c:	01211b23          	sh	s2,22(sp)
     360:	00d12223          	sw	a3,4(sp)
     364:	344000ef          	jal	6a8 <_svfiprintf_r>
     368:	01255663          	bge	a0,s2,374 <sniprintf+0xa4>
     36c:	08b00793          	li	a5,139
     370:	00f4a023          	sw	a5,0(s1)
     374:	f8040ce3          	beqz	s0,30c <sniprintf+0x3c>
     378:	00812783          	lw	a5,8(sp)
     37c:	00078023          	sb	zero,0(a5)
     380:	f8dff06f          	j	30c <sniprintf+0x3c>

00000384 <__ssputs_r>:
     384:	fe010113          	add	sp,sp,-32
     388:	01212823          	sw	s2,16(sp)
     38c:	0085a903          	lw	s2,8(a1)
     390:	00812c23          	sw	s0,24(sp)
     394:	01312623          	sw	s3,12(sp)
     398:	01512223          	sw	s5,4(sp)
     39c:	01612023          	sw	s6,0(sp)
     3a0:	00112e23          	sw	ra,28(sp)
     3a4:	00912a23          	sw	s1,20(sp)
     3a8:	01412423          	sw	s4,8(sp)
     3ac:	0005aa83          	lw	s5,0(a1)
     3b0:	00058413          	mv	s0,a1
     3b4:	00060b13          	mv	s6,a2
     3b8:	00068993          	mv	s3,a3
     3bc:	0926ee63          	bltu	a3,s2,458 <HEAP_SIZE+0x58>
     3c0:	00c59783          	lh	a5,12(a1)
     3c4:	4807f713          	and	a4,a5,1152
     3c8:	08070663          	beqz	a4,454 <HEAP_SIZE+0x54>
     3cc:	01442683          	lw	a3,20(s0)
     3d0:	0105a583          	lw	a1,16(a1)
     3d4:	00050a13          	mv	s4,a0
     3d8:	00169713          	sll	a4,a3,0x1
     3dc:	00d70733          	add	a4,a4,a3
     3e0:	01f75493          	srl	s1,a4,0x1f
     3e4:	00e484b3          	add	s1,s1,a4
     3e8:	40ba8ab3          	sub	s5,s5,a1
     3ec:	00198713          	add	a4,s3,1
     3f0:	4014d493          	sra	s1,s1,0x1
     3f4:	01570733          	add	a4,a4,s5
     3f8:	00e4f463          	bgeu	s1,a4,400 <HEAP_SIZE>
     3fc:	00070493          	mv	s1,a4
     400:	4007f793          	and	a5,a5,1024
     404:	0a078663          	beqz	a5,4b0 <HEAP_SIZE+0xb0>
     408:	00048593          	mv	a1,s1
     40c:	000a0513          	mv	a0,s4
     410:	57d000ef          	jal	118c <_malloc_r>
     414:	00050913          	mv	s2,a0
     418:	0a050c63          	beqz	a0,4d0 <HEAP_SIZE+0xd0>
     41c:	01042583          	lw	a1,16(s0)
     420:	000a8613          	mv	a2,s5
     424:	3c9000ef          	jal	fec <memcpy>
     428:	00c45783          	lhu	a5,12(s0)
     42c:	b7f7f793          	and	a5,a5,-1153
     430:	0807e793          	or	a5,a5,128
     434:	00f41623          	sh	a5,12(s0)
     438:	01242823          	sw	s2,16(s0)
     43c:	00942a23          	sw	s1,20(s0)
     440:	01590933          	add	s2,s2,s5
     444:	415484b3          	sub	s1,s1,s5
     448:	01242023          	sw	s2,0(s0)
     44c:	00942423          	sw	s1,8(s0)
     450:	00098913          	mv	s2,s3
     454:	0129f463          	bgeu	s3,s2,45c <HEAP_SIZE+0x5c>
     458:	00098913          	mv	s2,s3
     45c:	00042503          	lw	a0,0(s0)
     460:	00090613          	mv	a2,s2
     464:	000b0593          	mv	a1,s6
     468:	349000ef          	jal	fb0 <memmove>
     46c:	00842783          	lw	a5,8(s0)
     470:	00000513          	li	a0,0
     474:	412787b3          	sub	a5,a5,s2
     478:	00f42423          	sw	a5,8(s0)
     47c:	00042783          	lw	a5,0(s0)
     480:	012787b3          	add	a5,a5,s2
     484:	00f42023          	sw	a5,0(s0)
     488:	01c12083          	lw	ra,28(sp)
     48c:	01812403          	lw	s0,24(sp)
     490:	01412483          	lw	s1,20(sp)
     494:	01012903          	lw	s2,16(sp)
     498:	00c12983          	lw	s3,12(sp)
     49c:	00812a03          	lw	s4,8(sp)
     4a0:	00412a83          	lw	s5,4(sp)
     4a4:	00012b03          	lw	s6,0(sp)
     4a8:	02010113          	add	sp,sp,32
     4ac:	00008067          	ret
     4b0:	00048613          	mv	a2,s1
     4b4:	000a0513          	mv	a0,s4
     4b8:	69d000ef          	jal	1354 <_realloc_r>
     4bc:	00050913          	mv	s2,a0
     4c0:	f6051ce3          	bnez	a0,438 <HEAP_SIZE+0x38>
     4c4:	01042583          	lw	a1,16(s0)
     4c8:	000a0513          	mv	a0,s4
     4cc:	345000ef          	jal	1010 <_free_r>
     4d0:	00c00793          	li	a5,12
     4d4:	00fa2023          	sw	a5,0(s4)
     4d8:	00c45783          	lhu	a5,12(s0)
     4dc:	fff00513          	li	a0,-1
     4e0:	0407e793          	or	a5,a5,64
     4e4:	00f41623          	sh	a5,12(s0)
     4e8:	fa1ff06f          	j	488 <HEAP_SIZE+0x88>

000004ec <__ssprint_r>:
     4ec:	00862783          	lw	a5,8(a2)
     4f0:	fd010113          	add	sp,sp,-48
     4f4:	01412c23          	sw	s4,24(sp)
     4f8:	01712623          	sw	s7,12(sp)
     4fc:	02112623          	sw	ra,44(sp)
     500:	02812423          	sw	s0,40(sp)
     504:	02912223          	sw	s1,36(sp)
     508:	03212023          	sw	s2,32(sp)
     50c:	01312e23          	sw	s3,28(sp)
     510:	01512a23          	sw	s5,20(sp)
     514:	01612823          	sw	s6,16(sp)
     518:	01812423          	sw	s8,8(sp)
     51c:	00062b83          	lw	s7,0(a2)
     520:	00060a13          	mv	s4,a2
     524:	12079863          	bnez	a5,654 <__ssprint_r+0x168>
     528:	00000513          	li	a0,0
     52c:	02c12083          	lw	ra,44(sp)
     530:	02812403          	lw	s0,40(sp)
     534:	000a2223          	sw	zero,4(s4)
     538:	02412483          	lw	s1,36(sp)
     53c:	02012903          	lw	s2,32(sp)
     540:	01c12983          	lw	s3,28(sp)
     544:	01812a03          	lw	s4,24(sp)
     548:	01412a83          	lw	s5,20(sp)
     54c:	01012b03          	lw	s6,16(sp)
     550:	00c12b83          	lw	s7,12(sp)
     554:	00812c03          	lw	s8,8(sp)
     558:	03010113          	add	sp,sp,48
     55c:	00008067          	ret
     560:	000bab03          	lw	s6,0(s7)
     564:	004ba983          	lw	s3,4(s7)
     568:	008b8b93          	add	s7,s7,8
     56c:	00842903          	lw	s2,8(s0)
     570:	00042c03          	lw	s8,0(s0)
     574:	fe0986e3          	beqz	s3,560 <__ssprint_r+0x74>
     578:	0929ea63          	bltu	s3,s2,60c <__ssprint_r+0x120>
     57c:	00c41783          	lh	a5,12(s0)
     580:	4807f713          	and	a4,a5,1152
     584:	08070863          	beqz	a4,614 <__ssprint_r+0x128>
     588:	01442683          	lw	a3,20(s0)
     58c:	01042583          	lw	a1,16(s0)
     590:	00169713          	sll	a4,a3,0x1
     594:	00d70733          	add	a4,a4,a3
     598:	01f75493          	srl	s1,a4,0x1f
     59c:	40bc0c33          	sub	s8,s8,a1
     5a0:	00e484b3          	add	s1,s1,a4
     5a4:	001c0713          	add	a4,s8,1
     5a8:	4014d493          	sra	s1,s1,0x1
     5ac:	01370733          	add	a4,a4,s3
     5b0:	00e4f463          	bgeu	s1,a4,5b8 <__ssprint_r+0xcc>
     5b4:	00070493          	mv	s1,a4
     5b8:	4007f793          	and	a5,a5,1024
     5bc:	0a078663          	beqz	a5,668 <__ssprint_r+0x17c>
     5c0:	00048593          	mv	a1,s1
     5c4:	000a8513          	mv	a0,s5
     5c8:	3c5000ef          	jal	118c <_malloc_r>
     5cc:	00050913          	mv	s2,a0
     5d0:	0a050c63          	beqz	a0,688 <__ssprint_r+0x19c>
     5d4:	01042583          	lw	a1,16(s0)
     5d8:	000c0613          	mv	a2,s8
     5dc:	211000ef          	jal	fec <memcpy>
     5e0:	00c45783          	lhu	a5,12(s0)
     5e4:	b7f7f793          	and	a5,a5,-1153
     5e8:	0807e793          	or	a5,a5,128
     5ec:	00f41623          	sh	a5,12(s0)
     5f0:	01242823          	sw	s2,16(s0)
     5f4:	00942a23          	sw	s1,20(s0)
     5f8:	01890933          	add	s2,s2,s8
     5fc:	418484b3          	sub	s1,s1,s8
     600:	01242023          	sw	s2,0(s0)
     604:	00942423          	sw	s1,8(s0)
     608:	00098913          	mv	s2,s3
     60c:	0129f463          	bgeu	s3,s2,614 <__ssprint_r+0x128>
     610:	00098913          	mv	s2,s3
     614:	00042503          	lw	a0,0(s0)
     618:	000b0593          	mv	a1,s6
     61c:	00090613          	mv	a2,s2
     620:	191000ef          	jal	fb0 <memmove>
     624:	00842783          	lw	a5,8(s0)
     628:	013b0b33          	add	s6,s6,s3
     62c:	412787b3          	sub	a5,a5,s2
     630:	00f42423          	sw	a5,8(s0)
     634:	00042783          	lw	a5,0(s0)
     638:	012787b3          	add	a5,a5,s2
     63c:	00f42023          	sw	a5,0(s0)
     640:	008a2783          	lw	a5,8(s4)
     644:	413787b3          	sub	a5,a5,s3
     648:	00fa2423          	sw	a5,8(s4)
     64c:	00079a63          	bnez	a5,660 <__ssprint_r+0x174>
     650:	ed9ff06f          	j	528 <__ssprint_r+0x3c>
     654:	00050a93          	mv	s5,a0
     658:	00058413          	mv	s0,a1
     65c:	00000b13          	li	s6,0
     660:	00000993          	li	s3,0
     664:	f09ff06f          	j	56c <__ssprint_r+0x80>
     668:	00048613          	mv	a2,s1
     66c:	000a8513          	mv	a0,s5
     670:	4e5000ef          	jal	1354 <_realloc_r>
     674:	00050913          	mv	s2,a0
     678:	f6051ce3          	bnez	a0,5f0 <__ssprint_r+0x104>
     67c:	01042583          	lw	a1,16(s0)
     680:	000a8513          	mv	a0,s5
     684:	18d000ef          	jal	1010 <_free_r>
     688:	00c00793          	li	a5,12
     68c:	00faa023          	sw	a5,0(s5)
     690:	00c45783          	lhu	a5,12(s0)
     694:	fff00513          	li	a0,-1
     698:	0407e793          	or	a5,a5,64
     69c:	00f41623          	sh	a5,12(s0)
     6a0:	000a2423          	sw	zero,8(s4)
     6a4:	e89ff06f          	j	52c <__ssprint_r+0x40>

000006a8 <_svfiprintf_r>:
     6a8:	00c5d783          	lhu	a5,12(a1)
     6ac:	f5010113          	add	sp,sp,-176
     6b0:	0a812423          	sw	s0,168(sp)
     6b4:	0a912223          	sw	s1,164(sp)
     6b8:	0b212023          	sw	s2,160(sp)
     6bc:	09412c23          	sw	s4,152(sp)
     6c0:	0a112623          	sw	ra,172(sp)
     6c4:	09312e23          	sw	s3,156(sp)
     6c8:	09512a23          	sw	s5,148(sp)
     6cc:	09612823          	sw	s6,144(sp)
     6d0:	09712623          	sw	s7,140(sp)
     6d4:	09812423          	sw	s8,136(sp)
     6d8:	09912223          	sw	s9,132(sp)
     6dc:	09a12023          	sw	s10,128(sp)
     6e0:	07b12e23          	sw	s11,124(sp)
     6e4:	0807f793          	and	a5,a5,128
     6e8:	00050a13          	mv	s4,a0
     6ec:	00058913          	mv	s2,a1
     6f0:	00060493          	mv	s1,a2
     6f4:	00068413          	mv	s0,a3
     6f8:	06078863          	beqz	a5,768 <_svfiprintf_r+0xc0>
     6fc:	0105a783          	lw	a5,16(a1)
     700:	06079463          	bnez	a5,768 <_svfiprintf_r+0xc0>
     704:	04000593          	li	a1,64
     708:	285000ef          	jal	118c <_malloc_r>
     70c:	00a92023          	sw	a0,0(s2)
     710:	00a92823          	sw	a0,16(s2)
     714:	04051663          	bnez	a0,760 <_svfiprintf_r+0xb8>
     718:	00c00793          	li	a5,12
     71c:	00fa2023          	sw	a5,0(s4)
     720:	fff00513          	li	a0,-1
     724:	0ac12083          	lw	ra,172(sp)
     728:	0a812403          	lw	s0,168(sp)
     72c:	0a412483          	lw	s1,164(sp)
     730:	0a012903          	lw	s2,160(sp)
     734:	09c12983          	lw	s3,156(sp)
     738:	09812a03          	lw	s4,152(sp)
     73c:	09412a83          	lw	s5,148(sp)
     740:	09012b03          	lw	s6,144(sp)
     744:	08c12b83          	lw	s7,140(sp)
     748:	08812c03          	lw	s8,136(sp)
     74c:	08412c83          	lw	s9,132(sp)
     750:	08012d03          	lw	s10,128(sp)
     754:	07c12d83          	lw	s11,124(sp)
     758:	0b010113          	add	sp,sp,176
     75c:	00008067          	ret
     760:	04000793          	li	a5,64
     764:	00f92a23          	sw	a5,20(s2)
     768:	02000793          	li	a5,32
     76c:	02f104a3          	sb	a5,41(sp)
     770:	03000793          	li	a5,48
     774:	02012223          	sw	zero,36(sp)
     778:	02f10523          	sb	a5,42(sp)
     77c:	00812623          	sw	s0,12(sp)
     780:	02500c93          	li	s9,37
     784:	00000a93          	li	s5,0
     788:	00048413          	mv	s0,s1
     78c:	00044783          	lbu	a5,0(s0)
     790:	00078463          	beqz	a5,798 <_svfiprintf_r+0xf0>
     794:	0d979863          	bne	a5,s9,864 <_svfiprintf_r+0x1bc>
     798:	40940db3          	sub	s11,s0,s1
     79c:	02940663          	beq	s0,s1,7c8 <_svfiprintf_r+0x120>
     7a0:	000d8693          	mv	a3,s11
     7a4:	00048613          	mv	a2,s1
     7a8:	00090593          	mv	a1,s2
     7ac:	000a0513          	mv	a0,s4
     7b0:	bd5ff0ef          	jal	384 <__ssputs_r>
     7b4:	fff00793          	li	a5,-1
     7b8:	24f50863          	beq	a0,a5,a08 <_svfiprintf_r+0x360>
     7bc:	02412783          	lw	a5,36(sp)
     7c0:	01b787b3          	add	a5,a5,s11
     7c4:	02f12223          	sw	a5,36(sp)
     7c8:	00044783          	lbu	a5,0(s0)
     7cc:	22078e63          	beqz	a5,a08 <_svfiprintf_r+0x360>
     7d0:	fff00793          	li	a5,-1
     7d4:	00140493          	add	s1,s0,1
     7d8:	00012823          	sw	zero,16(sp)
     7dc:	00012e23          	sw	zero,28(sp)
     7e0:	00f12a23          	sw	a5,20(sp)
     7e4:	00012c23          	sw	zero,24(sp)
     7e8:	040109a3          	sb	zero,83(sp)
     7ec:	06012423          	sw	zero,104(sp)
     7f0:	00100d93          	li	s11,1
     7f4:	0004c583          	lbu	a1,0(s1)
     7f8:	00500613          	li	a2,5
     7fc:	81018513          	add	a0,gp,-2032 # 20000010 <UART+0x8>
     800:	78c000ef          	jal	f8c <memchr>
     804:	01012783          	lw	a5,16(sp)
     808:	00148413          	add	s0,s1,1
     80c:	06051063          	bnez	a0,86c <_svfiprintf_r+0x1c4>
     810:	0107f713          	and	a4,a5,16
     814:	00070663          	beqz	a4,820 <_svfiprintf_r+0x178>
     818:	02000713          	li	a4,32
     81c:	04e109a3          	sb	a4,83(sp)
     820:	0087f713          	and	a4,a5,8
     824:	00070663          	beqz	a4,830 <_svfiprintf_r+0x188>
     828:	02b00713          	li	a4,43
     82c:	04e109a3          	sb	a4,83(sp)
     830:	0004c683          	lbu	a3,0(s1)
     834:	02a00713          	li	a4,42
     838:	04e68863          	beq	a3,a4,888 <_svfiprintf_r+0x1e0>
     83c:	01c12703          	lw	a4,28(sp)
     840:	00048413          	mv	s0,s1
     844:	00000793          	li	a5,0
     848:	00900613          	li	a2,9
     84c:	00044683          	lbu	a3,0(s0)
     850:	00140593          	add	a1,s0,1
     854:	fd068693          	add	a3,a3,-48
     858:	10d67863          	bgeu	a2,a3,968 <_svfiprintf_r+0x2c0>
     85c:	04079063          	bnez	a5,89c <_svfiprintf_r+0x1f4>
     860:	0540006f          	j	8b4 <_svfiprintf_r+0x20c>
     864:	00140413          	add	s0,s0,1
     868:	f25ff06f          	j	78c <_svfiprintf_r+0xe4>
     86c:	81018713          	add	a4,gp,-2032 # 20000010 <UART+0x8>
     870:	40e50533          	sub	a0,a0,a4
     874:	00ad9533          	sll	a0,s11,a0
     878:	00a7e7b3          	or	a5,a5,a0
     87c:	00f12823          	sw	a5,16(sp)
     880:	00040493          	mv	s1,s0
     884:	f71ff06f          	j	7f4 <_svfiprintf_r+0x14c>
     888:	00c12703          	lw	a4,12(sp)
     88c:	00470693          	add	a3,a4,4
     890:	00072703          	lw	a4,0(a4)
     894:	00d12623          	sw	a3,12(sp)
     898:	00074663          	bltz	a4,8a4 <_svfiprintf_r+0x1fc>
     89c:	00e12e23          	sw	a4,28(sp)
     8a0:	0140006f          	j	8b4 <_svfiprintf_r+0x20c>
     8a4:	40e00733          	neg	a4,a4
     8a8:	0027e793          	or	a5,a5,2
     8ac:	00e12e23          	sw	a4,28(sp)
     8b0:	00f12823          	sw	a5,16(sp)
     8b4:	00044703          	lbu	a4,0(s0)
     8b8:	02e00793          	li	a5,46
     8bc:	02f71863          	bne	a4,a5,8ec <_svfiprintf_r+0x244>
     8c0:	00144703          	lbu	a4,1(s0)
     8c4:	02a00793          	li	a5,42
     8c8:	0af71e63          	bne	a4,a5,984 <_svfiprintf_r+0x2dc>
     8cc:	00c12783          	lw	a5,12(sp)
     8d0:	00240413          	add	s0,s0,2
     8d4:	00478713          	add	a4,a5,4
     8d8:	0007a783          	lw	a5,0(a5)
     8dc:	00e12623          	sw	a4,12(sp)
     8e0:	0007d463          	bgez	a5,8e8 <_svfiprintf_r+0x240>
     8e4:	fff00793          	li	a5,-1
     8e8:	00f12a23          	sw	a5,20(sp)
     8ec:	00044583          	lbu	a1,0(s0)
     8f0:	00300613          	li	a2,3
     8f4:	81818513          	add	a0,gp,-2024 # 20000018 <UART+0x10>
     8f8:	694000ef          	jal	f8c <memchr>
     8fc:	02050263          	beqz	a0,920 <_svfiprintf_r+0x278>
     900:	81818793          	add	a5,gp,-2024 # 20000018 <UART+0x10>
     904:	40f50533          	sub	a0,a0,a5
     908:	01012783          	lw	a5,16(sp)
     90c:	04000713          	li	a4,64
     910:	00a71733          	sll	a4,a4,a0
     914:	00e7e7b3          	or	a5,a5,a4
     918:	00140413          	add	s0,s0,1
     91c:	00f12823          	sw	a5,16(sp)
     920:	00044583          	lbu	a1,0(s0)
     924:	00600613          	li	a2,6
     928:	81c18513          	add	a0,gp,-2020 # 2000001c <UART+0x14>
     92c:	00140493          	add	s1,s0,1
     930:	02b10423          	sb	a1,40(sp)
     934:	658000ef          	jal	f8c <memchr>
     938:	0e050263          	beqz	a0,a1c <_svfiprintf_r+0x374>
     93c:	0a0a9263          	bnez	s5,9e0 <_svfiprintf_r+0x338>
     940:	01012703          	lw	a4,16(sp)
     944:	00c12783          	lw	a5,12(sp)
     948:	10077713          	and	a4,a4,256
     94c:	08070263          	beqz	a4,9d0 <_svfiprintf_r+0x328>
     950:	00478793          	add	a5,a5,4
     954:	00f12623          	sw	a5,12(sp)
     958:	02412783          	lw	a5,36(sp)
     95c:	013787b3          	add	a5,a5,s3
     960:	02f12223          	sw	a5,36(sp)
     964:	e25ff06f          	j	788 <_svfiprintf_r+0xe0>
     968:	00271793          	sll	a5,a4,0x2
     96c:	00e787b3          	add	a5,a5,a4
     970:	00179793          	sll	a5,a5,0x1
     974:	00d78733          	add	a4,a5,a3
     978:	00058413          	mv	s0,a1
     97c:	00100793          	li	a5,1
     980:	ecdff06f          	j	84c <_svfiprintf_r+0x1a4>
     984:	00140413          	add	s0,s0,1
     988:	00012a23          	sw	zero,20(sp)
     98c:	00000793          	li	a5,0
     990:	00000713          	li	a4,0
     994:	00900613          	li	a2,9
     998:	00044683          	lbu	a3,0(s0)
     99c:	00140593          	add	a1,s0,1
     9a0:	fd068693          	add	a3,a3,-48
     9a4:	00d67863          	bgeu	a2,a3,9b4 <_svfiprintf_r+0x30c>
     9a8:	f40782e3          	beqz	a5,8ec <_svfiprintf_r+0x244>
     9ac:	00e12a23          	sw	a4,20(sp)
     9b0:	f3dff06f          	j	8ec <_svfiprintf_r+0x244>
     9b4:	00271793          	sll	a5,a4,0x2
     9b8:	00e787b3          	add	a5,a5,a4
     9bc:	00179793          	sll	a5,a5,0x1
     9c0:	00d78733          	add	a4,a5,a3
     9c4:	00058413          	mv	s0,a1
     9c8:	00100793          	li	a5,1
     9cc:	fcdff06f          	j	998 <_svfiprintf_r+0x2f0>
     9d0:	00778793          	add	a5,a5,7
     9d4:	ff87f793          	and	a5,a5,-8
     9d8:	00878793          	add	a5,a5,8
     9dc:	f79ff06f          	j	954 <_svfiprintf_r+0x2ac>
     9e0:	00c10713          	add	a4,sp,12
     9e4:	38400693          	li	a3,900
     9e8:	00090613          	mv	a2,s2
     9ec:	01010593          	add	a1,sp,16
     9f0:	000a0513          	mv	a0,s4
     9f4:	00000097          	auipc	ra,0x0
     9f8:	000000e7          	jalr	zero # 0 <_start>
     9fc:	fff00793          	li	a5,-1
     a00:	00050993          	mv	s3,a0
     a04:	f4f51ae3          	bne	a0,a5,958 <_svfiprintf_r+0x2b0>
     a08:	00c95783          	lhu	a5,12(s2)
     a0c:	0407f793          	and	a5,a5,64
     a10:	d00798e3          	bnez	a5,720 <_svfiprintf_r+0x78>
     a14:	02412503          	lw	a0,36(sp)
     a18:	d0dff06f          	j	724 <_svfiprintf_r+0x7c>
     a1c:	00c10713          	add	a4,sp,12
     a20:	38400693          	li	a3,900
     a24:	00090613          	mv	a2,s2
     a28:	01010593          	add	a1,sp,16
     a2c:	000a0513          	mv	a0,s4
     a30:	1b8000ef          	jal	be8 <_printf_i>
     a34:	fc9ff06f          	j	9fc <_svfiprintf_r+0x354>

00000a38 <_printf_common>:
     a38:	fd010113          	add	sp,sp,-48
     a3c:	01512a23          	sw	s5,20(sp)
     a40:	0105a783          	lw	a5,16(a1)
     a44:	00070a93          	mv	s5,a4
     a48:	0085a703          	lw	a4,8(a1)
     a4c:	02812423          	sw	s0,40(sp)
     a50:	03212023          	sw	s2,32(sp)
     a54:	01312e23          	sw	s3,28(sp)
     a58:	01412c23          	sw	s4,24(sp)
     a5c:	02112623          	sw	ra,44(sp)
     a60:	02912223          	sw	s1,36(sp)
     a64:	01612823          	sw	s6,16(sp)
     a68:	01712623          	sw	s7,12(sp)
     a6c:	00050993          	mv	s3,a0
     a70:	00058413          	mv	s0,a1
     a74:	00060913          	mv	s2,a2
     a78:	00068a13          	mv	s4,a3
     a7c:	00e7d463          	bge	a5,a4,a84 <_printf_common+0x4c>
     a80:	00070793          	mv	a5,a4
     a84:	00f92023          	sw	a5,0(s2)
     a88:	04344703          	lbu	a4,67(s0)
     a8c:	00070663          	beqz	a4,a98 <_printf_common+0x60>
     a90:	00178793          	add	a5,a5,1
     a94:	00f92023          	sw	a5,0(s2)
     a98:	00042783          	lw	a5,0(s0)
     a9c:	0207f793          	and	a5,a5,32
     aa0:	00078863          	beqz	a5,ab0 <_printf_common+0x78>
     aa4:	00092783          	lw	a5,0(s2)
     aa8:	00278793          	add	a5,a5,2
     aac:	00f92023          	sw	a5,0(s2)
     ab0:	00042483          	lw	s1,0(s0)
     ab4:	0064f493          	and	s1,s1,6
     ab8:	00049e63          	bnez	s1,ad4 <_printf_common+0x9c>
     abc:	01940b13          	add	s6,s0,25
     ac0:	fff00b93          	li	s7,-1
     ac4:	00c42783          	lw	a5,12(s0)
     ac8:	00092703          	lw	a4,0(s2)
     acc:	40e787b3          	sub	a5,a5,a4
     ad0:	08f4c263          	blt	s1,a5,b54 <_printf_common+0x11c>
     ad4:	04344783          	lbu	a5,67(s0)
     ad8:	00f036b3          	snez	a3,a5
     adc:	00042783          	lw	a5,0(s0)
     ae0:	0207f793          	and	a5,a5,32
     ae4:	0c079063          	bnez	a5,ba4 <_printf_common+0x16c>
     ae8:	04340613          	add	a2,s0,67
     aec:	000a0593          	mv	a1,s4
     af0:	00098513          	mv	a0,s3
     af4:	000a80e7          	jalr	s5
     af8:	fff00793          	li	a5,-1
     afc:	06f50863          	beq	a0,a5,b6c <_printf_common+0x134>
     b00:	00042783          	lw	a5,0(s0)
     b04:	00400713          	li	a4,4
     b08:	00000493          	li	s1,0
     b0c:	0067f793          	and	a5,a5,6
     b10:	00e79c63          	bne	a5,a4,b28 <_printf_common+0xf0>
     b14:	00c42483          	lw	s1,12(s0)
     b18:	00092783          	lw	a5,0(s2)
     b1c:	40f484b3          	sub	s1,s1,a5
     b20:	0004d463          	bgez	s1,b28 <_printf_common+0xf0>
     b24:	00000493          	li	s1,0
     b28:	00842783          	lw	a5,8(s0)
     b2c:	01042703          	lw	a4,16(s0)
     b30:	00f75663          	bge	a4,a5,b3c <_printf_common+0x104>
     b34:	40e787b3          	sub	a5,a5,a4
     b38:	00f484b3          	add	s1,s1,a5
     b3c:	00000913          	li	s2,0
     b40:	01a40413          	add	s0,s0,26
     b44:	fff00b13          	li	s6,-1
     b48:	09249063          	bne	s1,s2,bc8 <_printf_common+0x190>
     b4c:	00000513          	li	a0,0
     b50:	0200006f          	j	b70 <_printf_common+0x138>
     b54:	00100693          	li	a3,1
     b58:	000b0613          	mv	a2,s6
     b5c:	000a0593          	mv	a1,s4
     b60:	00098513          	mv	a0,s3
     b64:	000a80e7          	jalr	s5
     b68:	03751a63          	bne	a0,s7,b9c <_printf_common+0x164>
     b6c:	fff00513          	li	a0,-1
     b70:	02c12083          	lw	ra,44(sp)
     b74:	02812403          	lw	s0,40(sp)
     b78:	02412483          	lw	s1,36(sp)
     b7c:	02012903          	lw	s2,32(sp)
     b80:	01c12983          	lw	s3,28(sp)
     b84:	01812a03          	lw	s4,24(sp)
     b88:	01412a83          	lw	s5,20(sp)
     b8c:	01012b03          	lw	s6,16(sp)
     b90:	00c12b83          	lw	s7,12(sp)
     b94:	03010113          	add	sp,sp,48
     b98:	00008067          	ret
     b9c:	00148493          	add	s1,s1,1
     ba0:	f25ff06f          	j	ac4 <_printf_common+0x8c>
     ba4:	00d40733          	add	a4,s0,a3
     ba8:	03000613          	li	a2,48
     bac:	04c701a3          	sb	a2,67(a4)
     bb0:	04544703          	lbu	a4,69(s0)
     bb4:	00168793          	add	a5,a3,1
     bb8:	00f407b3          	add	a5,s0,a5
     bbc:	00268693          	add	a3,a3,2
     bc0:	04e781a3          	sb	a4,67(a5)
     bc4:	f25ff06f          	j	ae8 <_printf_common+0xb0>
     bc8:	00100693          	li	a3,1
     bcc:	00040613          	mv	a2,s0
     bd0:	000a0593          	mv	a1,s4
     bd4:	00098513          	mv	a0,s3
     bd8:	000a80e7          	jalr	s5
     bdc:	f96508e3          	beq	a0,s6,b6c <_printf_common+0x134>
     be0:	00190913          	add	s2,s2,1
     be4:	f65ff06f          	j	b48 <_printf_common+0x110>

00000be8 <_printf_i>:
     be8:	fc010113          	add	sp,sp,-64
     bec:	02812c23          	sw	s0,56(sp)
     bf0:	03412423          	sw	s4,40(sp)
     bf4:	03512223          	sw	s5,36(sp)
     bf8:	03612023          	sw	s6,32(sp)
     bfc:	02112e23          	sw	ra,60(sp)
     c00:	02912a23          	sw	s1,52(sp)
     c04:	03212823          	sw	s2,48(sp)
     c08:	03312623          	sw	s3,44(sp)
     c0c:	01712e23          	sw	s7,28(sp)
     c10:	01812c23          	sw	s8,24(sp)
     c14:	01912a23          	sw	s9,20(sp)
     c18:	0185c783          	lbu	a5,24(a1)
     c1c:	00068b13          	mv	s6,a3
     c20:	07800693          	li	a3,120
     c24:	00050a13          	mv	s4,a0
     c28:	00058413          	mv	s0,a1
     c2c:	00060a93          	mv	s5,a2
     c30:	00f6ee63          	bltu	a3,a5,c4c <_printf_i+0x64>
     c34:	06200693          	li	a3,98
     c38:	04358b93          	add	s7,a1,67
     c3c:	00f6ec63          	bltu	a3,a5,c54 <_printf_i+0x6c>
     c40:	28078663          	beqz	a5,ecc <_printf_i+0x2e4>
     c44:	05800693          	li	a3,88
     c48:	22d78863          	beq	a5,a3,e78 <_printf_i+0x290>
     c4c:	04240c93          	add	s9,s0,66
     c50:	03c0006f          	j	c8c <_printf_i+0xa4>
     c54:	f9d78813          	add	a6,a5,-99
     c58:	0ff87813          	zext.b	a6,a6
     c5c:	01500693          	li	a3,21
     c60:	ff06e6e3          	bltu	a3,a6,c4c <_printf_i+0x64>
     c64:	85c18693          	add	a3,gp,-1956 # 2000005c <msg+0x10>
     c68:	00281813          	sll	a6,a6,0x2
     c6c:	00d80833          	add	a6,a6,a3
     c70:	00082683          	lw	a3,0(a6)
     c74:	00068067          	jr	a3
     c78:	00072783          	lw	a5,0(a4)
     c7c:	04258c93          	add	s9,a1,66
     c80:	00478693          	add	a3,a5,4
     c84:	0007a783          	lw	a5,0(a5)
     c88:	00d72023          	sw	a3,0(a4)
     c8c:	04f40123          	sb	a5,66(s0)
     c90:	00100793          	li	a5,1
     c94:	2740006f          	j	f08 <_printf_i+0x320>
     c98:	0005a783          	lw	a5,0(a1)
     c9c:	00072603          	lw	a2,0(a4)
     ca0:	0807f593          	and	a1,a5,128
     ca4:	00460693          	add	a3,a2,4
     ca8:	02058463          	beqz	a1,cd0 <_printf_i+0xe8>
     cac:	00062483          	lw	s1,0(a2)
     cb0:	00d72023          	sw	a3,0(a4)
     cb4:	0004d863          	bgez	s1,cc4 <_printf_i+0xdc>
     cb8:	02d00793          	li	a5,45
     cbc:	409004b3          	neg	s1,s1
     cc0:	04f401a3          	sb	a5,67(s0)
     cc4:	82418913          	add	s2,gp,-2012 # 20000024 <UART+0x1c>
     cc8:	00a00993          	li	s3,10
     ccc:	0c40006f          	j	d90 <_printf_i+0x1a8>
     cd0:	00062483          	lw	s1,0(a2)
     cd4:	0407f793          	and	a5,a5,64
     cd8:	00d72023          	sw	a3,0(a4)
     cdc:	fc078ce3          	beqz	a5,cb4 <_printf_i+0xcc>
     ce0:	01049493          	sll	s1,s1,0x10
     ce4:	4104d493          	sra	s1,s1,0x10
     ce8:	fcdff06f          	j	cb4 <_printf_i+0xcc>
     cec:	0005a603          	lw	a2,0(a1)
     cf0:	00072683          	lw	a3,0(a4)
     cf4:	08067593          	and	a1,a2,128
     cf8:	0006a483          	lw	s1,0(a3)
     cfc:	00468693          	add	a3,a3,4
     d00:	00059a63          	bnez	a1,d14 <_printf_i+0x12c>
     d04:	04067613          	and	a2,a2,64
     d08:	00060663          	beqz	a2,d14 <_printf_i+0x12c>
     d0c:	01049493          	sll	s1,s1,0x10
     d10:	0104d493          	srl	s1,s1,0x10
     d14:	00d72023          	sw	a3,0(a4)
     d18:	06f00713          	li	a4,111
     d1c:	82418913          	add	s2,gp,-2012 # 20000024 <UART+0x1c>
     d20:	00800993          	li	s3,8
     d24:	06e78463          	beq	a5,a4,d8c <_printf_i+0x1a4>
     d28:	00a00993          	li	s3,10
     d2c:	0600006f          	j	d8c <_printf_i+0x1a4>
     d30:	0005a783          	lw	a5,0(a1)
     d34:	0207e793          	or	a5,a5,32
     d38:	00f5a023          	sw	a5,0(a1)
     d3c:	07800793          	li	a5,120
     d40:	83818913          	add	s2,gp,-1992 # 20000038 <UART+0x30>
     d44:	04f402a3          	sb	a5,69(s0)
     d48:	00042783          	lw	a5,0(s0)
     d4c:	00072683          	lw	a3,0(a4)
     d50:	0807f613          	and	a2,a5,128
     d54:	0006a483          	lw	s1,0(a3)
     d58:	00468693          	add	a3,a3,4
     d5c:	00061a63          	bnez	a2,d70 <_printf_i+0x188>
     d60:	0407f613          	and	a2,a5,64
     d64:	00060663          	beqz	a2,d70 <_printf_i+0x188>
     d68:	01049493          	sll	s1,s1,0x10
     d6c:	0104d493          	srl	s1,s1,0x10
     d70:	00d72023          	sw	a3,0(a4)
     d74:	0017f713          	and	a4,a5,1
     d78:	00070663          	beqz	a4,d84 <_printf_i+0x19c>
     d7c:	0207e793          	or	a5,a5,32
     d80:	00f42023          	sw	a5,0(s0)
     d84:	0e048e63          	beqz	s1,e80 <_printf_i+0x298>
     d88:	01000993          	li	s3,16
     d8c:	040401a3          	sb	zero,67(s0)
     d90:	00442783          	lw	a5,4(s0)
     d94:	00f42423          	sw	a5,8(s0)
     d98:	0007ce63          	bltz	a5,db4 <_printf_i+0x1cc>
     d9c:	00042703          	lw	a4,0(s0)
     da0:	00f4e7b3          	or	a5,s1,a5
     da4:	000b8c93          	mv	s9,s7
     da8:	ffb77713          	and	a4,a4,-5
     dac:	00e42023          	sw	a4,0(s0)
     db0:	02078e63          	beqz	a5,dec <_printf_i+0x204>
     db4:	000b8c93          	mv	s9,s7
     db8:	00098593          	mv	a1,s3
     dbc:	00048513          	mv	a0,s1
     dc0:	079000ef          	jal	1638 <__umodsi3>
     dc4:	00a90533          	add	a0,s2,a0
     dc8:	00054783          	lbu	a5,0(a0)
     dcc:	00098593          	mv	a1,s3
     dd0:	00048513          	mv	a0,s1
     dd4:	fefc8fa3          	sb	a5,-1(s9)
     dd8:	00048c13          	mv	s8,s1
     ddc:	015000ef          	jal	15f0 <__hidden___udivsi3>
     de0:	fffc8c93          	add	s9,s9,-1
     de4:	00050493          	mv	s1,a0
     de8:	fd3c78e3          	bgeu	s8,s3,db8 <_printf_i+0x1d0>
     dec:	00800793          	li	a5,8
     df0:	02f99463          	bne	s3,a5,e18 <_printf_i+0x230>
     df4:	00042783          	lw	a5,0(s0)
     df8:	0017f793          	and	a5,a5,1
     dfc:	00078e63          	beqz	a5,e18 <_printf_i+0x230>
     e00:	00442703          	lw	a4,4(s0)
     e04:	01042783          	lw	a5,16(s0)
     e08:	00e7c863          	blt	a5,a4,e18 <_printf_i+0x230>
     e0c:	03000793          	li	a5,48
     e10:	fefc8fa3          	sb	a5,-1(s9)
     e14:	fffc8c93          	add	s9,s9,-1
     e18:	419b8bb3          	sub	s7,s7,s9
     e1c:	01742823          	sw	s7,16(s0)
     e20:	000b0713          	mv	a4,s6
     e24:	000a8693          	mv	a3,s5
     e28:	00c10613          	add	a2,sp,12
     e2c:	00040593          	mv	a1,s0
     e30:	000a0513          	mv	a0,s4
     e34:	c05ff0ef          	jal	a38 <_printf_common>
     e38:	fff00493          	li	s1,-1
     e3c:	0c951c63          	bne	a0,s1,f14 <_printf_i+0x32c>
     e40:	fff00513          	li	a0,-1
     e44:	03c12083          	lw	ra,60(sp)
     e48:	03812403          	lw	s0,56(sp)
     e4c:	03412483          	lw	s1,52(sp)
     e50:	03012903          	lw	s2,48(sp)
     e54:	02c12983          	lw	s3,44(sp)
     e58:	02812a03          	lw	s4,40(sp)
     e5c:	02412a83          	lw	s5,36(sp)
     e60:	02012b03          	lw	s6,32(sp)
     e64:	01c12b83          	lw	s7,28(sp)
     e68:	01812c03          	lw	s8,24(sp)
     e6c:	01412c83          	lw	s9,20(sp)
     e70:	04010113          	add	sp,sp,64
     e74:	00008067          	ret
     e78:	82418913          	add	s2,gp,-2012 # 20000024 <UART+0x1c>
     e7c:	ec9ff06f          	j	d44 <_printf_i+0x15c>
     e80:	00042783          	lw	a5,0(s0)
     e84:	fdf7f793          	and	a5,a5,-33
     e88:	00f42023          	sw	a5,0(s0)
     e8c:	efdff06f          	j	d88 <_printf_i+0x1a0>
     e90:	0005a683          	lw	a3,0(a1)
     e94:	00072783          	lw	a5,0(a4)
     e98:	0145a603          	lw	a2,20(a1)
     e9c:	0806f513          	and	a0,a3,128
     ea0:	00478593          	add	a1,a5,4
     ea4:	00050a63          	beqz	a0,eb8 <_printf_i+0x2d0>
     ea8:	00b72023          	sw	a1,0(a4)
     eac:	0007a783          	lw	a5,0(a5)
     eb0:	00c7a023          	sw	a2,0(a5)
     eb4:	0180006f          	j	ecc <_printf_i+0x2e4>
     eb8:	00b72023          	sw	a1,0(a4)
     ebc:	0406f693          	and	a3,a3,64
     ec0:	0007a783          	lw	a5,0(a5)
     ec4:	fe0686e3          	beqz	a3,eb0 <_printf_i+0x2c8>
     ec8:	00c79023          	sh	a2,0(a5)
     ecc:	00042823          	sw	zero,16(s0)
     ed0:	000b8c93          	mv	s9,s7
     ed4:	f4dff06f          	j	e20 <_printf_i+0x238>
     ed8:	00072783          	lw	a5,0(a4)
     edc:	0045a603          	lw	a2,4(a1)
     ee0:	00000593          	li	a1,0
     ee4:	00478693          	add	a3,a5,4
     ee8:	00d72023          	sw	a3,0(a4)
     eec:	0007ac83          	lw	s9,0(a5)
     ef0:	000c8513          	mv	a0,s9
     ef4:	098000ef          	jal	f8c <memchr>
     ef8:	00050663          	beqz	a0,f04 <_printf_i+0x31c>
     efc:	41950533          	sub	a0,a0,s9
     f00:	00a42223          	sw	a0,4(s0)
     f04:	00442783          	lw	a5,4(s0)
     f08:	00f42823          	sw	a5,16(s0)
     f0c:	040401a3          	sb	zero,67(s0)
     f10:	f11ff06f          	j	e20 <_printf_i+0x238>
     f14:	01042683          	lw	a3,16(s0)
     f18:	000c8613          	mv	a2,s9
     f1c:	000a8593          	mv	a1,s5
     f20:	000a0513          	mv	a0,s4
     f24:	000b00e7          	jalr	s6
     f28:	f0950ce3          	beq	a0,s1,e40 <_printf_i+0x258>
     f2c:	00042783          	lw	a5,0(s0)
     f30:	0027f793          	and	a5,a5,2
     f34:	04079463          	bnez	a5,f7c <_printf_i+0x394>
     f38:	00c12783          	lw	a5,12(sp)
     f3c:	00c42503          	lw	a0,12(s0)
     f40:	f0f552e3          	bge	a0,a5,e44 <_printf_i+0x25c>
     f44:	00078513          	mv	a0,a5
     f48:	efdff06f          	j	e44 <_printf_i+0x25c>
     f4c:	00100693          	li	a3,1
     f50:	00090613          	mv	a2,s2
     f54:	000a8593          	mv	a1,s5
     f58:	000a0513          	mv	a0,s4
     f5c:	000b00e7          	jalr	s6
     f60:	ef3500e3          	beq	a0,s3,e40 <_printf_i+0x258>
     f64:	00148493          	add	s1,s1,1
     f68:	00c42783          	lw	a5,12(s0)
     f6c:	00c12703          	lw	a4,12(sp)
     f70:	40e787b3          	sub	a5,a5,a4
     f74:	fcf4cce3          	blt	s1,a5,f4c <_printf_i+0x364>
     f78:	fc1ff06f          	j	f38 <_printf_i+0x350>
     f7c:	00000493          	li	s1,0
     f80:	01940913          	add	s2,s0,25
     f84:	fff00993          	li	s3,-1
     f88:	fe1ff06f          	j	f68 <_printf_i+0x380>

00000f8c <memchr>:
     f8c:	0ff5f593          	zext.b	a1,a1
     f90:	00c50633          	add	a2,a0,a2
     f94:	00c51663          	bne	a0,a2,fa0 <memchr+0x14>
     f98:	00000513          	li	a0,0
     f9c:	00008067          	ret
     fa0:	00054783          	lbu	a5,0(a0)
     fa4:	feb78ce3          	beq	a5,a1,f9c <memchr+0x10>
     fa8:	00150513          	add	a0,a0,1
     fac:	fe9ff06f          	j	f94 <memchr+0x8>

00000fb0 <memmove>:
     fb0:	02060c63          	beqz	a2,fe8 <memmove+0x38>
     fb4:	00050313          	mv	t1,a0
     fb8:	00100693          	li	a3,1
     fbc:	00b56a63          	bltu	a0,a1,fd0 <memmove+0x20>
     fc0:	fff00693          	li	a3,-1
     fc4:	fff60713          	add	a4,a2,-1
     fc8:	00e30333          	add	t1,t1,a4
     fcc:	00e585b3          	add	a1,a1,a4
     fd0:	00058383          	lb	t2,0(a1)
     fd4:	00730023          	sb	t2,0(t1)
     fd8:	fff60613          	add	a2,a2,-1
     fdc:	00d30333          	add	t1,t1,a3
     fe0:	00d585b3          	add	a1,a1,a3
     fe4:	fe0616e3          	bnez	a2,fd0 <memmove+0x20>
     fe8:	00008067          	ret

00000fec <memcpy>:
     fec:	00050313          	mv	t1,a0
     ff0:	00060e63          	beqz	a2,100c <memcpy+0x20>
     ff4:	00058383          	lb	t2,0(a1)
     ff8:	00730023          	sb	t2,0(t1)
     ffc:	fff60613          	add	a2,a2,-1
    1000:	00130313          	add	t1,t1,1
    1004:	00158593          	add	a1,a1,1
    1008:	fe0616e3          	bnez	a2,ff4 <memcpy+0x8>
    100c:	00008067          	ret

00001010 <_free_r>:
    1010:	0e058a63          	beqz	a1,1104 <_free_r+0xf4>
    1014:	ffc5a783          	lw	a5,-4(a1)
    1018:	fe010113          	add	sp,sp,-32
    101c:	00812c23          	sw	s0,24(sp)
    1020:	00112e23          	sw	ra,28(sp)
    1024:	ffc58413          	add	s0,a1,-4
    1028:	0007d463          	bgez	a5,1030 <_free_r+0x20>
    102c:	00f40433          	add	s0,s0,a5
    1030:	00a12623          	sw	a0,12(sp)
    1034:	318000ef          	jal	134c <__malloc_lock>
    1038:	9141a783          	lw	a5,-1772(gp) # 20000114 <__malloc_free_list>
    103c:	00c12503          	lw	a0,12(sp)
    1040:	00079e63          	bnez	a5,105c <_free_r+0x4c>
    1044:	00042223          	sw	zero,4(s0)
    1048:	9081aa23          	sw	s0,-1772(gp) # 20000114 <__malloc_free_list>
    104c:	01812403          	lw	s0,24(sp)
    1050:	01c12083          	lw	ra,28(sp)
    1054:	02010113          	add	sp,sp,32
    1058:	2f80006f          	j	1350 <__malloc_unlock>
    105c:	02f47463          	bgeu	s0,a5,1084 <_free_r+0x74>
    1060:	00042603          	lw	a2,0(s0)
    1064:	00c406b3          	add	a3,s0,a2
    1068:	00d79a63          	bne	a5,a3,107c <_free_r+0x6c>
    106c:	0007a683          	lw	a3,0(a5)
    1070:	0047a783          	lw	a5,4(a5)
    1074:	00c686b3          	add	a3,a3,a2
    1078:	00d42023          	sw	a3,0(s0)
    107c:	00f42223          	sw	a5,4(s0)
    1080:	fc9ff06f          	j	1048 <_free_r+0x38>
    1084:	00078713          	mv	a4,a5
    1088:	0047a783          	lw	a5,4(a5)
    108c:	00078463          	beqz	a5,1094 <_free_r+0x84>
    1090:	fef47ae3          	bgeu	s0,a5,1084 <_free_r+0x74>
    1094:	00072683          	lw	a3,0(a4)
    1098:	00d70633          	add	a2,a4,a3
    109c:	02861863          	bne	a2,s0,10cc <_free_r+0xbc>
    10a0:	00042603          	lw	a2,0(s0)
    10a4:	00c686b3          	add	a3,a3,a2
    10a8:	00d72023          	sw	a3,0(a4)
    10ac:	00d70633          	add	a2,a4,a3
    10b0:	f8c79ee3          	bne	a5,a2,104c <_free_r+0x3c>
    10b4:	0007a603          	lw	a2,0(a5)
    10b8:	0047a783          	lw	a5,4(a5)
    10bc:	00d606b3          	add	a3,a2,a3
    10c0:	00d72023          	sw	a3,0(a4)
    10c4:	00f72223          	sw	a5,4(a4)
    10c8:	f85ff06f          	j	104c <_free_r+0x3c>
    10cc:	00c47863          	bgeu	s0,a2,10dc <_free_r+0xcc>
    10d0:	00c00793          	li	a5,12
    10d4:	00f52023          	sw	a5,0(a0)
    10d8:	f75ff06f          	j	104c <_free_r+0x3c>
    10dc:	00042603          	lw	a2,0(s0)
    10e0:	00c406b3          	add	a3,s0,a2
    10e4:	00d79a63          	bne	a5,a3,10f8 <_free_r+0xe8>
    10e8:	0007a683          	lw	a3,0(a5)
    10ec:	0047a783          	lw	a5,4(a5)
    10f0:	00c686b3          	add	a3,a3,a2
    10f4:	00d42023          	sw	a3,0(s0)
    10f8:	00f42223          	sw	a5,4(s0)
    10fc:	00872223          	sw	s0,4(a4)
    1100:	f4dff06f          	j	104c <_free_r+0x3c>
    1104:	00008067          	ret

00001108 <sbrk_aligned>:
    1108:	ff010113          	add	sp,sp,-16
    110c:	01212023          	sw	s2,0(sp)
    1110:	9101a783          	lw	a5,-1776(gp) # 20000110 <__malloc_sbrk_start>
    1114:	00812423          	sw	s0,8(sp)
    1118:	00912223          	sw	s1,4(sp)
    111c:	00112623          	sw	ra,12(sp)
    1120:	00050493          	mv	s1,a0
    1124:	00058413          	mv	s0,a1
    1128:	00079863          	bnez	a5,1138 <sbrk_aligned+0x30>
    112c:	00000593          	li	a1,0
    1130:	2fc000ef          	jal	142c <_sbrk_r>
    1134:	90a1a823          	sw	a0,-1776(gp) # 20000110 <__malloc_sbrk_start>
    1138:	00040593          	mv	a1,s0
    113c:	00048513          	mv	a0,s1
    1140:	2ec000ef          	jal	142c <_sbrk_r>
    1144:	fff00913          	li	s2,-1
    1148:	03251263          	bne	a0,s2,116c <sbrk_aligned+0x64>
    114c:	fff00413          	li	s0,-1
    1150:	00c12083          	lw	ra,12(sp)
    1154:	00040513          	mv	a0,s0
    1158:	00812403          	lw	s0,8(sp)
    115c:	00412483          	lw	s1,4(sp)
    1160:	00012903          	lw	s2,0(sp)
    1164:	01010113          	add	sp,sp,16
    1168:	00008067          	ret
    116c:	00350413          	add	s0,a0,3
    1170:	ffc47413          	and	s0,s0,-4
    1174:	fc850ee3          	beq	a0,s0,1150 <sbrk_aligned+0x48>
    1178:	40a405b3          	sub	a1,s0,a0
    117c:	00048513          	mv	a0,s1
    1180:	2ac000ef          	jal	142c <_sbrk_r>
    1184:	fd2516e3          	bne	a0,s2,1150 <sbrk_aligned+0x48>
    1188:	fc5ff06f          	j	114c <sbrk_aligned+0x44>

0000118c <_malloc_r>:
    118c:	fe010113          	add	sp,sp,-32
    1190:	00912a23          	sw	s1,20(sp)
    1194:	00358493          	add	s1,a1,3
    1198:	ffc4f493          	and	s1,s1,-4
    119c:	01212823          	sw	s2,16(sp)
    11a0:	00112e23          	sw	ra,28(sp)
    11a4:	00812c23          	sw	s0,24(sp)
    11a8:	01312623          	sw	s3,12(sp)
    11ac:	01412423          	sw	s4,8(sp)
    11b0:	00848493          	add	s1,s1,8
    11b4:	00c00793          	li	a5,12
    11b8:	00050913          	mv	s2,a0
    11bc:	0af4f063          	bgeu	s1,a5,125c <_malloc_r+0xd0>
    11c0:	00c00493          	li	s1,12
    11c4:	08b4ee63          	bltu	s1,a1,1260 <_malloc_r+0xd4>
    11c8:	00090513          	mv	a0,s2
    11cc:	180000ef          	jal	134c <__malloc_lock>
    11d0:	9141a783          	lw	a5,-1772(gp) # 20000114 <__malloc_free_list>
    11d4:	00078413          	mv	s0,a5
    11d8:	0a041a63          	bnez	s0,128c <_malloc_r+0x100>
    11dc:	00048593          	mv	a1,s1
    11e0:	00090513          	mv	a0,s2
    11e4:	f25ff0ef          	jal	1108 <sbrk_aligned>
    11e8:	fff00793          	li	a5,-1
    11ec:	00050413          	mv	s0,a0
    11f0:	14f51663          	bne	a0,a5,133c <_malloc_r+0x1b0>
    11f4:	9141a403          	lw	s0,-1772(gp) # 20000114 <__malloc_free_list>
    11f8:	00040793          	mv	a5,s0
    11fc:	10079c63          	bnez	a5,1314 <_malloc_r+0x188>
    1200:	12040463          	beqz	s0,1328 <_malloc_r+0x19c>
    1204:	00042a03          	lw	s4,0(s0)
    1208:	00000593          	li	a1,0
    120c:	00090513          	mv	a0,s2
    1210:	01440a33          	add	s4,s0,s4
    1214:	218000ef          	jal	142c <_sbrk_r>
    1218:	10aa1863          	bne	s4,a0,1328 <_malloc_r+0x19c>
    121c:	00042783          	lw	a5,0(s0)
    1220:	00090513          	mv	a0,s2
    1224:	40f484b3          	sub	s1,s1,a5
    1228:	00048593          	mv	a1,s1
    122c:	eddff0ef          	jal	1108 <sbrk_aligned>
    1230:	fff00793          	li	a5,-1
    1234:	0ef50a63          	beq	a0,a5,1328 <_malloc_r+0x19c>
    1238:	00042783          	lw	a5,0(s0)
    123c:	009787b3          	add	a5,a5,s1
    1240:	00f42023          	sw	a5,0(s0)
    1244:	9141a783          	lw	a5,-1772(gp) # 20000114 <__malloc_free_list>
    1248:	0e078e63          	beqz	a5,1344 <_malloc_r+0x1b8>
    124c:	0047a703          	lw	a4,4(a5)
    1250:	0c871863          	bne	a4,s0,1320 <_malloc_r+0x194>
    1254:	0007a223          	sw	zero,4(a5)
    1258:	0640006f          	j	12bc <_malloc_r+0x130>
    125c:	f604d4e3          	bgez	s1,11c4 <_malloc_r+0x38>
    1260:	00c00793          	li	a5,12
    1264:	00f92023          	sw	a5,0(s2)
    1268:	00000513          	li	a0,0
    126c:	01c12083          	lw	ra,28(sp)
    1270:	01812403          	lw	s0,24(sp)
    1274:	01412483          	lw	s1,20(sp)
    1278:	01012903          	lw	s2,16(sp)
    127c:	00c12983          	lw	s3,12(sp)
    1280:	00812a03          	lw	s4,8(sp)
    1284:	02010113          	add	sp,sp,32
    1288:	00008067          	ret
    128c:	00042683          	lw	a3,0(s0)
    1290:	409686b3          	sub	a3,a3,s1
    1294:	0606ca63          	bltz	a3,1308 <_malloc_r+0x17c>
    1298:	00b00713          	li	a4,11
    129c:	04d77a63          	bgeu	a4,a3,12f0 <_malloc_r+0x164>
    12a0:	00942023          	sw	s1,0(s0)
    12a4:	00940733          	add	a4,s0,s1
    12a8:	04879063          	bne	a5,s0,12e8 <_malloc_r+0x15c>
    12ac:	90e1aa23          	sw	a4,-1772(gp) # 20000114 <__malloc_free_list>
    12b0:	00442783          	lw	a5,4(s0)
    12b4:	00d72023          	sw	a3,0(a4)
    12b8:	00f72223          	sw	a5,4(a4)
    12bc:	00090513          	mv	a0,s2
    12c0:	090000ef          	jal	1350 <__malloc_unlock>
    12c4:	00b40513          	add	a0,s0,11
    12c8:	00440793          	add	a5,s0,4
    12cc:	ff857513          	and	a0,a0,-8
    12d0:	40f50733          	sub	a4,a0,a5
    12d4:	f8f50ce3          	beq	a0,a5,126c <_malloc_r+0xe0>
    12d8:	00e40433          	add	s0,s0,a4
    12dc:	40a787b3          	sub	a5,a5,a0
    12e0:	00f42023          	sw	a5,0(s0)
    12e4:	f89ff06f          	j	126c <_malloc_r+0xe0>
    12e8:	00e7a223          	sw	a4,4(a5)
    12ec:	fc5ff06f          	j	12b0 <_malloc_r+0x124>
    12f0:	00442703          	lw	a4,4(s0)
    12f4:	00879663          	bne	a5,s0,1300 <_malloc_r+0x174>
    12f8:	90e1aa23          	sw	a4,-1772(gp) # 20000114 <__malloc_free_list>
    12fc:	fc1ff06f          	j	12bc <_malloc_r+0x130>
    1300:	00e7a223          	sw	a4,4(a5)
    1304:	fb9ff06f          	j	12bc <_malloc_r+0x130>
    1308:	00040793          	mv	a5,s0
    130c:	00442403          	lw	s0,4(s0)
    1310:	ec9ff06f          	j	11d8 <_malloc_r+0x4c>
    1314:	00078413          	mv	s0,a5
    1318:	0047a783          	lw	a5,4(a5)
    131c:	ee1ff06f          	j	11fc <_malloc_r+0x70>
    1320:	00070793          	mv	a5,a4
    1324:	f25ff06f          	j	1248 <_malloc_r+0xbc>
    1328:	00c00793          	li	a5,12
    132c:	00f92023          	sw	a5,0(s2)
    1330:	00090513          	mv	a0,s2
    1334:	01c000ef          	jal	1350 <__malloc_unlock>
    1338:	f31ff06f          	j	1268 <_malloc_r+0xdc>
    133c:	00952023          	sw	s1,0(a0)
    1340:	f7dff06f          	j	12bc <_malloc_r+0x130>
    1344:	00002223          	sw	zero,4(zero) # 4 <_start+0x4>
    1348:	00100073          	ebreak

0000134c <__malloc_lock>:
    134c:	00008067          	ret

00001350 <__malloc_unlock>:
    1350:	00008067          	ret

00001354 <_realloc_r>:
    1354:	fe010113          	add	sp,sp,-32
    1358:	00812c23          	sw	s0,24(sp)
    135c:	00112e23          	sw	ra,28(sp)
    1360:	00912a23          	sw	s1,20(sp)
    1364:	01212823          	sw	s2,16(sp)
    1368:	01312623          	sw	s3,12(sp)
    136c:	01412423          	sw	s4,8(sp)
    1370:	00060413          	mv	s0,a2
    1374:	02059463          	bnez	a1,139c <_realloc_r+0x48>
    1378:	01812403          	lw	s0,24(sp)
    137c:	01c12083          	lw	ra,28(sp)
    1380:	01412483          	lw	s1,20(sp)
    1384:	01012903          	lw	s2,16(sp)
    1388:	00c12983          	lw	s3,12(sp)
    138c:	00812a03          	lw	s4,8(sp)
    1390:	00060593          	mv	a1,a2
    1394:	02010113          	add	sp,sp,32
    1398:	df5ff06f          	j	118c <_malloc_r>
    139c:	02061863          	bnez	a2,13cc <_realloc_r+0x78>
    13a0:	c71ff0ef          	jal	1010 <_free_r>
    13a4:	00000493          	li	s1,0
    13a8:	01c12083          	lw	ra,28(sp)
    13ac:	01812403          	lw	s0,24(sp)
    13b0:	01012903          	lw	s2,16(sp)
    13b4:	00c12983          	lw	s3,12(sp)
    13b8:	00812a03          	lw	s4,8(sp)
    13bc:	00048513          	mv	a0,s1
    13c0:	01412483          	lw	s1,20(sp)
    13c4:	02010113          	add	sp,sp,32
    13c8:	00008067          	ret
    13cc:	00050a13          	mv	s4,a0
    13d0:	00058493          	mv	s1,a1
    13d4:	0a0000ef          	jal	1474 <_malloc_usable_size_r>
    13d8:	00050913          	mv	s2,a0
    13dc:	00856663          	bltu	a0,s0,13e8 <_realloc_r+0x94>
    13e0:	00155793          	srl	a5,a0,0x1
    13e4:	fc87e2e3          	bltu	a5,s0,13a8 <_realloc_r+0x54>
    13e8:	00040593          	mv	a1,s0
    13ec:	000a0513          	mv	a0,s4
    13f0:	d9dff0ef          	jal	118c <_malloc_r>
    13f4:	00050993          	mv	s3,a0
    13f8:	00051663          	bnez	a0,1404 <_realloc_r+0xb0>
    13fc:	00098493          	mv	s1,s3
    1400:	fa9ff06f          	j	13a8 <_realloc_r+0x54>
    1404:	00040613          	mv	a2,s0
    1408:	00897463          	bgeu	s2,s0,1410 <_realloc_r+0xbc>
    140c:	00090613          	mv	a2,s2
    1410:	00048593          	mv	a1,s1
    1414:	00098513          	mv	a0,s3
    1418:	bd5ff0ef          	jal	fec <memcpy>
    141c:	00048593          	mv	a1,s1
    1420:	000a0513          	mv	a0,s4
    1424:	bedff0ef          	jal	1010 <_free_r>
    1428:	fd5ff06f          	j	13fc <_realloc_r+0xa8>

0000142c <_sbrk_r>:
    142c:	ff010113          	add	sp,sp,-16
    1430:	00812423          	sw	s0,8(sp)
    1434:	00912223          	sw	s1,4(sp)
    1438:	00050413          	mv	s0,a0
    143c:	00058513          	mv	a0,a1
    1440:	00112623          	sw	ra,12(sp)
    1444:	9001ac23          	sw	zero,-1768(gp) # 20000118 <errno>
    1448:	d61fe0ef          	jal	1a8 <_sbrk>
    144c:	fff00793          	li	a5,-1
    1450:	00f51863          	bne	a0,a5,1460 <_sbrk_r+0x34>
    1454:	9181a783          	lw	a5,-1768(gp) # 20000118 <errno>
    1458:	00078463          	beqz	a5,1460 <_sbrk_r+0x34>
    145c:	00f42023          	sw	a5,0(s0)
    1460:	00c12083          	lw	ra,12(sp)
    1464:	00812403          	lw	s0,8(sp)
    1468:	00412483          	lw	s1,4(sp)
    146c:	01010113          	add	sp,sp,16
    1470:	00008067          	ret

00001474 <_malloc_usable_size_r>:
    1474:	ffc5a783          	lw	a5,-4(a1)
    1478:	ffc78513          	add	a0,a5,-4
    147c:	0007d863          	bgez	a5,148c <_malloc_usable_size_r+0x18>
    1480:	00a585b3          	add	a1,a1,a0
    1484:	0005a783          	lw	a5,0(a1)
    1488:	00f50533          	add	a0,a0,a5
    148c:	00008067          	ret

00001490 <_reclaim_reent>:
    1490:	8b81a783          	lw	a5,-1864(gp) # 200000b8 <_impure_ptr>
    1494:	14a78863          	beq	a5,a0,15e4 <_reclaim_reent+0x154>
    1498:	01c52783          	lw	a5,28(a0)
    149c:	fe010113          	add	sp,sp,-32
    14a0:	00812c23          	sw	s0,24(sp)
    14a4:	00112e23          	sw	ra,28(sp)
    14a8:	00912a23          	sw	s1,20(sp)
    14ac:	01212823          	sw	s2,16(sp)
    14b0:	01312623          	sw	s3,12(sp)
    14b4:	00050413          	mv	s0,a0
    14b8:	04078a63          	beqz	a5,150c <_reclaim_reent+0x7c>
    14bc:	00c7a783          	lw	a5,12(a5)
    14c0:	02078c63          	beqz	a5,14f8 <_reclaim_reent+0x68>
    14c4:	00000493          	li	s1,0
    14c8:	08000913          	li	s2,128
    14cc:	01c42783          	lw	a5,28(s0)
    14d0:	00c7a783          	lw	a5,12(a5)
    14d4:	009787b3          	add	a5,a5,s1
    14d8:	0007a583          	lw	a1,0(a5)
    14dc:	0c059c63          	bnez	a1,15b4 <_reclaim_reent+0x124>
    14e0:	00448493          	add	s1,s1,4
    14e4:	ff2494e3          	bne	s1,s2,14cc <_reclaim_reent+0x3c>
    14e8:	01c42783          	lw	a5,28(s0)
    14ec:	00040513          	mv	a0,s0
    14f0:	00c7a583          	lw	a1,12(a5)
    14f4:	b1dff0ef          	jal	1010 <_free_r>
    14f8:	01c42783          	lw	a5,28(s0)
    14fc:	0007a583          	lw	a1,0(a5)
    1500:	00058663          	beqz	a1,150c <_reclaim_reent+0x7c>
    1504:	00040513          	mv	a0,s0
    1508:	b09ff0ef          	jal	1010 <_free_r>
    150c:	01442583          	lw	a1,20(s0)
    1510:	00058663          	beqz	a1,151c <_reclaim_reent+0x8c>
    1514:	00040513          	mv	a0,s0
    1518:	af9ff0ef          	jal	1010 <_free_r>
    151c:	01c42583          	lw	a1,28(s0)
    1520:	00058663          	beqz	a1,152c <_reclaim_reent+0x9c>
    1524:	00040513          	mv	a0,s0
    1528:	ae9ff0ef          	jal	1010 <_free_r>
    152c:	03042583          	lw	a1,48(s0)
    1530:	00058663          	beqz	a1,153c <_reclaim_reent+0xac>
    1534:	00040513          	mv	a0,s0
    1538:	ad9ff0ef          	jal	1010 <_free_r>
    153c:	03442583          	lw	a1,52(s0)
    1540:	00058663          	beqz	a1,154c <_reclaim_reent+0xbc>
    1544:	00040513          	mv	a0,s0
    1548:	ac9ff0ef          	jal	1010 <_free_r>
    154c:	03842583          	lw	a1,56(s0)
    1550:	00058663          	beqz	a1,155c <_reclaim_reent+0xcc>
    1554:	00040513          	mv	a0,s0
    1558:	ab9ff0ef          	jal	1010 <_free_r>
    155c:	04842583          	lw	a1,72(s0)
    1560:	00058663          	beqz	a1,156c <_reclaim_reent+0xdc>
    1564:	00040513          	mv	a0,s0
    1568:	aa9ff0ef          	jal	1010 <_free_r>
    156c:	04442583          	lw	a1,68(s0)
    1570:	00058663          	beqz	a1,157c <_reclaim_reent+0xec>
    1574:	00040513          	mv	a0,s0
    1578:	a99ff0ef          	jal	1010 <_free_r>
    157c:	02c42583          	lw	a1,44(s0)
    1580:	00058663          	beqz	a1,158c <_reclaim_reent+0xfc>
    1584:	00040513          	mv	a0,s0
    1588:	a89ff0ef          	jal	1010 <_free_r>
    158c:	02042783          	lw	a5,32(s0)
    1590:	02078c63          	beqz	a5,15c8 <_reclaim_reent+0x138>
    1594:	00040513          	mv	a0,s0
    1598:	01812403          	lw	s0,24(sp)
    159c:	01c12083          	lw	ra,28(sp)
    15a0:	01412483          	lw	s1,20(sp)
    15a4:	01012903          	lw	s2,16(sp)
    15a8:	00c12983          	lw	s3,12(sp)
    15ac:	02010113          	add	sp,sp,32
    15b0:	00078067          	jr	a5
    15b4:	0005a983          	lw	s3,0(a1)
    15b8:	00040513          	mv	a0,s0
    15bc:	a55ff0ef          	jal	1010 <_free_r>
    15c0:	00098593          	mv	a1,s3
    15c4:	f19ff06f          	j	14dc <_reclaim_reent+0x4c>
    15c8:	01c12083          	lw	ra,28(sp)
    15cc:	01812403          	lw	s0,24(sp)
    15d0:	01412483          	lw	s1,20(sp)
    15d4:	01012903          	lw	s2,16(sp)
    15d8:	00c12983          	lw	s3,12(sp)
    15dc:	02010113          	add	sp,sp,32
    15e0:	00008067          	ret
    15e4:	00008067          	ret

000015e8 <__divsi3>:
    15e8:	06054063          	bltz	a0,1648 <__umodsi3+0x10>
    15ec:	0605c663          	bltz	a1,1658 <__umodsi3+0x20>

000015f0 <__hidden___udivsi3>:
    15f0:	00058613          	mv	a2,a1
    15f4:	00050593          	mv	a1,a0
    15f8:	fff00513          	li	a0,-1
    15fc:	02060c63          	beqz	a2,1634 <__hidden___udivsi3+0x44>
    1600:	00100693          	li	a3,1
    1604:	00b67a63          	bgeu	a2,a1,1618 <__hidden___udivsi3+0x28>
    1608:	00c05863          	blez	a2,1618 <__hidden___udivsi3+0x28>
    160c:	00161613          	sll	a2,a2,0x1
    1610:	00169693          	sll	a3,a3,0x1
    1614:	feb66ae3          	bltu	a2,a1,1608 <__hidden___udivsi3+0x18>
    1618:	00000513          	li	a0,0
    161c:	00c5e663          	bltu	a1,a2,1628 <__hidden___udivsi3+0x38>
    1620:	40c585b3          	sub	a1,a1,a2
    1624:	00d56533          	or	a0,a0,a3
    1628:	0016d693          	srl	a3,a3,0x1
    162c:	00165613          	srl	a2,a2,0x1
    1630:	fe0696e3          	bnez	a3,161c <__hidden___udivsi3+0x2c>
    1634:	00008067          	ret

00001638 <__umodsi3>:
    1638:	00008293          	mv	t0,ra
    163c:	fb5ff0ef          	jal	15f0 <__hidden___udivsi3>
    1640:	00058513          	mv	a0,a1
    1644:	00028067          	jr	t0
    1648:	40a00533          	neg	a0,a0
    164c:	00b04863          	bgtz	a1,165c <__umodsi3+0x24>
    1650:	40b005b3          	neg	a1,a1
    1654:	f9dff06f          	j	15f0 <__hidden___udivsi3>
    1658:	40b005b3          	neg	a1,a1
    165c:	00008293          	mv	t0,ra
    1660:	f91ff0ef          	jal	15f0 <__hidden___udivsi3>
    1664:	40a00533          	neg	a0,a0
    1668:	00028067          	jr	t0

0000166c <__modsi3>:
    166c:	00008293          	mv	t0,ra
    1670:	0005ca63          	bltz	a1,1684 <__modsi3+0x18>
    1674:	00054c63          	bltz	a0,168c <__modsi3+0x20>
    1678:	f79ff0ef          	jal	15f0 <__hidden___udivsi3>
    167c:	00058513          	mv	a0,a1
    1680:	00028067          	jr	t0
    1684:	40b005b3          	neg	a1,a1
    1688:	fe0558e3          	bgez	a0,1678 <__modsi3+0xc>
    168c:	40a00533          	neg	a0,a0
    1690:	f61ff0ef          	jal	15f0 <__hidden___udivsi3>
    1694:	40b00533          	neg	a0,a1
    1698:	00028067          	jr	t0
    169c:	0000                	.insn	2, 0x
	...

Disassembly of section .data:

20000000 <GPIO>:
20000000:	0000                	.insn	2, 0x
20000002:	8000                	.insn	2, 0x8000

20000004 <TIMER>:
volatile timer_instance_t* const TIMER = (timer_instance_t*)(TIMER_BASE);
20000004:	0000                	.insn	2, 0x
20000006:	6000                	.insn	2, 0x6000

20000008 <UART>:
volatile uart_instance_t* const UART = (uart_instance_t*)(UART_BASE);
20000008:	0000                	.insn	2, 0x
2000000a:	4000                	.insn	2, 0x4000
2000000c:	7325                	.insn	2, 0x7325
2000000e:	0000                	.insn	2, 0x
20000010:	2b302d23          	sw	s3,698(zero) # 2ba <_sniprintf_r+0x9e>
20000014:	0020                	.insn	2, 0x0020
20000016:	0000                	.insn	2, 0x
20000018:	6c68                	.insn	2, 0x6c68
2000001a:	004c                	.insn	2, 0x004c
2000001c:	6665                	.insn	2, 0x6665
2000001e:	47464567          	.insn	4, 0x47464567
20000022:	0000                	.insn	2, 0x
20000024:	3130                	.insn	2, 0x3130
20000026:	3332                	.insn	2, 0x3332
20000028:	3534                	.insn	2, 0x3534
2000002a:	3736                	.insn	2, 0x3736
2000002c:	3938                	.insn	2, 0x3938
2000002e:	4241                	.insn	2, 0x4241
20000030:	46454443          	.insn	4, 0x46454443
20000034:	0000                	.insn	2, 0x
20000036:	0000                	.insn	2, 0x
20000038:	3130                	.insn	2, 0x3130
2000003a:	3332                	.insn	2, 0x3332
2000003c:	3534                	.insn	2, 0x3534
2000003e:	3736                	.insn	2, 0x3736
20000040:	3938                	.insn	2, 0x3938
20000042:	6261                	.insn	2, 0x6261
20000044:	66656463          	bltu	a0,t1,200006ac <__heap_end$+0x14c>
20000048:	0000                	.insn	2, 0x
	...

2000004c <msg>:
const uint8_t const msg[] = "Hello World!";
2000004c:	6548                	.insn	2, 0x6548
2000004e:	6c6c                	.insn	2, 0x6c6c
20000050:	6f57206f          	j	20072f44 <__stack_top$+0x6f1e4>
20000054:	6c72                	.insn	2, 0x6c72
20000056:	2164                	.insn	2, 0x2164
20000058:	0000                	.insn	2, 0x
2000005a:	0000                	.insn	2, 0x
2000005c:	0c78                	.insn	2, 0x0c78
2000005e:	0000                	.insn	2, 0x
20000060:	0c98                	.insn	2, 0x0c98
20000062:	0000                	.insn	2, 0x
20000064:	0c4c                	.insn	2, 0x0c4c
20000066:	0000                	.insn	2, 0x
20000068:	0c4c                	.insn	2, 0x0c4c
2000006a:	0000                	.insn	2, 0x
2000006c:	0c4c                	.insn	2, 0x0c4c
2000006e:	0000                	.insn	2, 0x
20000070:	0c4c                	.insn	2, 0x0c4c
20000072:	0000                	.insn	2, 0x
20000074:	0c98                	.insn	2, 0x0c98
20000076:	0000                	.insn	2, 0x
20000078:	0c4c                	.insn	2, 0x0c4c
2000007a:	0000                	.insn	2, 0x
2000007c:	0c4c                	.insn	2, 0x0c4c
2000007e:	0000                	.insn	2, 0x
20000080:	0c4c                	.insn	2, 0x0c4c
20000082:	0000                	.insn	2, 0x
20000084:	0c4c                	.insn	2, 0x0c4c
20000086:	0000                	.insn	2, 0x
20000088:	0e90                	.insn	2, 0x0e90
2000008a:	0000                	.insn	2, 0x
2000008c:	0cec                	.insn	2, 0x0cec
2000008e:	0000                	.insn	2, 0x
20000090:	0d30                	.insn	2, 0x0d30
20000092:	0000                	.insn	2, 0x
20000094:	0c4c                	.insn	2, 0x0c4c
20000096:	0000                	.insn	2, 0x
20000098:	0c4c                	.insn	2, 0x0c4c
2000009a:	0000                	.insn	2, 0x
2000009c:	0ed8                	.insn	2, 0x0ed8
2000009e:	0000                	.insn	2, 0x
200000a0:	0c4c                	.insn	2, 0x0c4c
200000a2:	0000                	.insn	2, 0x
200000a4:	0cec                	.insn	2, 0x0cec
200000a6:	0000                	.insn	2, 0x
200000a8:	0c4c                	.insn	2, 0x0c4c
200000aa:	0000                	.insn	2, 0x
200000ac:	0c4c                	.insn	2, 0x0c4c
200000ae:	0000                	.insn	2, 0x
200000b0:	0d3c                	.insn	2, 0x0d3c
	...

200000b4 <curbrk.0>:
  static char * curbrk = &__end$;
200000b4:	0160                	.insn	2, 0x0160
200000b6:	2000                	.insn	2, 0x2000

200000b8 <_impure_ptr>:
200000b8:	00bc                	.insn	2, 0x00bc
200000ba:	2000                	.insn	2, 0x2000

200000bc <_impure_data>:
	...
200000c4:	0068                	.insn	2, 0x0068
200000c6:	0000                	.insn	2, 0x
200000c8:	00d0                	.insn	2, 0x00d0
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
    la gp, __global_pointer$
   0:	2841                	.insn	2, 0x2841
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
    la a4, _sdata_load$
   8:	01007663          	bgeu	zero,a6,14 <ROM_START_ADDRESS+0x14>
   c:	001e                	.insn	2, 0x001e
   e:	0000                	.insn	2, 0x
    la a5, _sdata$
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
    la a6, _edata$
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	697a                	.insn	2, 0x697a
  1e:	32727363          	bgeu	tp,t2,344 <sniprintf+0x74>
    lw a7, 0(a4)
  22:	3070                	.insn	2, 0x3070
    sw a7, 0(a5)
  24:	0800                	.insn	2, 0x0800
  26:	0a01                	.insn	2, 0x0a01
    addi a5, a5, 0x04
  28:	Address 0x28 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
    la gp, __global_pointer$
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	2029                	.insn	2, 0x2029
    la a4, _sdata_load$
   8:	3331                	.insn	2, 0x3331
   a:	322e                	.insn	2, 0x322e
   c:	302e                	.insn	2, 0x302e
   e:	4700                	.insn	2, 0x4700
    la a5, _sdata$
  10:	203a4343          	.insn	4, 0x203a4343
  14:	4728                	.insn	2, 0x4728
  16:	554e                	.insn	2, 0x554e
    la a6, _edata$
  18:	2029                	.insn	2, 0x2029
  1a:	3331                	.insn	2, 0x3331
  1c:	322e                	.insn	2, 0x322e
  1e:	302e                	.insn	2, 0x302e
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
    la gp, __global_pointer$
   0:	000000e7          	jalr	zero # 0 <ROM_START_ADDRESS>
   4:	0005                	.insn	2, 0x0005
   6:	0004                	.insn	2, 0x0004
    la a4, _sdata_load$
   8:	002e                	.insn	2, 0x002e
   a:	0000                	.insn	2, 0x
   c:	0101                	.insn	2, 0x0101
   e:	fb01                	.insn	2, 0xfb01
    la a5, _sdata$
  10:	0d0e                	.insn	2, 0x0d0e
  12:	0100                	.insn	2, 0x0100
  14:	0101                	.insn	2, 0x0101
  16:	0001                	.insn	2, 0x0001
    la a6, _edata$
  18:	0000                	.insn	2, 0x
  1a:	0001                	.insn	2, 0x0001
  1c:	0100                	.insn	2, 0x0100
  1e:	0101                	.insn	2, 0x0101
    lw a7, 0(a4)
  20:	021f 0000 0000      	.insn	6, 0x021f
    sw a7, 0(a5)
  26:	00f1                	.insn	2, 0x00f1
    addi a5, a5, 0x04
  28:	0000                	.insn	2, 0x
  2a:	0102                	.insn	2, 0x0102
    addi a4, a4, 0x04
  2c:	021f 020f 0023      	.insn	6, 0x0023020f021f
    blt a5, a6, _data_copy_loop
  32:	0000                	.insn	2, 0x
    la a4, _sbss$
  34:	2301                	.insn	2, 0x2301
  36:	0000                	.insn	2, 0x
  38:	0100                	.insn	2, 0x0100
  3a:	0500                	.insn	2, 0x0500
    la a5, _ebss$
  3c:	0002                	.insn	2, 0x0002
  3e:	0000                	.insn	2, 0x
  40:	1a00                	.insn	2, 0x1a00
  42:	08090203          	lb	tp,128(s2)
    sw zero, 0(a4)
  46:	0100                	.insn	2, 0x0100
    addi a4, a4, 0x04
  48:	08090103          	lb	sp,128(s2)
    blt a4, a5, _bss_zero_loop
  4c:	0100                	.insn	2, 0x0100
  4e:	08090103          	lb	sp,128(s2)
    la a4, __heap_start$
  52:	0100                	.insn	2, 0x0100
  54:	08090203          	lb	tp,128(s2)
    la a5, __heap_end$
  58:	0100                	.insn	2, 0x0100
  5a:	04090103          	lb	sp,64(s2)
  5e:	0100                	.insn	2, 0x0100
    sw zero, 0(a4)
  60:	04090103          	lb	sp,64(s2)
    addi a4, a4, 0x04
  64:	0100                	.insn	2, 0x0100
  66:	04090103          	lb	sp,64(s2)
    blt a4, a5, _heap_zero_loop
  6a:	0100                	.insn	2, 0x0100
    li a4, 0
  6c:	04090103          	lb	sp,64(s2)
    li a5, 0
  70:	0100                	.insn	2, 0x0100
  72:	04090203          	lb	tp,64(s2)
    li a6, 0
  76:	0100                	.insn	2, 0x0100
    la sp, __stack_top$
  78:	08090103          	lb	sp,128(s2)
  7c:	0100                	.insn	2, 0x0100
  7e:	08090203          	lb	tp,128(s2)
    la t0, _MSYSIE
  82:	0100                	.insn	2, 0x0100
  84:	04090103          	lb	sp,64(s2)
    csrrw t0, mtvec, t0
  88:	0100                	.insn	2, 0x0100
  8a:	04090103          	lb	sp,64(s2)
    call main
  8e:	0100                	.insn	2, 0x0100
    j _halt
  90:	04090203          	lb	tp,64(s2)
    mret
  94:	0100                	.insn	2, 0x0100
  96:	08090103          	lb	sp,128(s2)
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  9a:	0100                	.insn	2, 0x0100
}
  9c:	08090203          	lb	tp,128(s2)
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a0:	0100                	.insn	2, 0x0100
  a2:	04090103          	lb	sp,64(s2)
}
  a6:	0100                	.insn	2, 0x0100
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a8:	04090103          	lb	sp,64(s2)
}
  ac:	0100                	.insn	2, 0x0100
  ae:	04090203          	lb	tp,64(s2)
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b2:	0100                	.insn	2, 0x0100
}
  b4:	04090103          	lb	sp,64(s2)
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	0100                	.insn	2, 0x0100
  ba:	04090103          	lb	sp,64(s2)
}
  be:	0100                	.insn	2, 0x0100
  c0:	04090503          	lb	a0,64(s2)
  c4:	0100                	.insn	2, 0x0100
  c6:	08090303          	lb	t1,128(s2)
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  ca:	0100                	.insn	2, 0x0100
}
  cc:	08090103          	lb	sp,128(s2)
  d0:	0100                	.insn	2, 0x0100
  d2:	04090203          	lb	tp,64(s2)
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d6:	0100                	.insn	2, 0x0100
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  d8:	04090303          	lb	t1,64(s2)
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	0100                	.insn	2, 0x0100
  de:	0900c203          	lbu	tp,144(ra) # a84 <_printf_common+0x4c>
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e2:	0004                	.insn	2, 0x0004
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	0901                	.insn	2, 0x0901
  e6:	0004                	.insn	2, 0x0004
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	0100                	.insn	2, 0x0100
  ea:	4301                	.insn	2, 0x4301
  uint32_t cause = hal_read_csr(mcause);
  ec:	0002                	.insn	2, 0x0002
  ee:	0500                	.insn	2, 0x0500
  if (cause & EXT_SYS_I0_IE)
  f0:	0400                	.insn	2, 0x0400
  f2:	4000                	.insn	2, 0x4000
  f4:	0000                	.insn	2, 0x
  f6:	0100                	.insn	2, 0x0100
    EXT_IRQ_0_HANDLER();
  f8:	0101                	.insn	2, 0x0101
  fa:	000d0efb          	.insn	4, 0x000d0efb
  else if (cause & EXT_SYS_I1_IE)
  fe:	0101                	.insn	2, 0x0101
 100:	0101                	.insn	2, 0x0101
 102:	0000                	.insn	2, 0x
    EXT_IRQ_1_HANDLER();
 104:	0100                	.insn	2, 0x0100
 106:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I2_IE)
 108:	0101                	.insn	2, 0x0101
 10a:	1f01                	.insn	2, 0x1f01
 10c:	0004                	.insn	2, 0x0004
 10e:	0000                	.insn	2, 0x
    EXT_IRQ_2_HANDLER();
 110:	f100                	.insn	2, 0xf100
 112:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I3_IE)
 114:	3500                	.insn	2, 0x3500
 116:	0000                	.insn	2, 0x
 118:	6400                	.insn	2, 0x6400
 11a:	0000                	.insn	2, 0x
    EXT_IRQ_3_HANDLER();
 11c:	0200                	.insn	2, 0x0200
 11e:	1f01                	.insn	2, 0x1f01
  else if (cause & EXT_SYS_I4_IE)
 120:	0f02                	.insn	2, 0x0f02
 122:	2f04                	.insn	2, 0x2f04
 124:	0000                	.insn	2, 0x
 126:	0100                	.insn	2, 0x0100
    EXT_IRQ_4_HANDLER();
 128:	0000002f          	.insn	4, 0x002f
  else if (cause & EXT_SYS_I5_IE)
 12c:	8f01                	.insn	2, 0x8f01
 12e:	0000                	.insn	2, 0x
 130:	0200                	.insn	2, 0x0200
 132:	00a0                	.insn	2, 0x00a0
    EXT_IRQ_5_HANDLER();
 134:	0000                	.insn	2, 0x
 136:	00330503          	lb	a0,3(t1)
}
 13a:	0205                	.insn	2, 0x0205
  size >>= 8;
 13c:	0098                	.insn	2, 0x0098
 13e:	0000                	.insn	2, 0x
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	0515                	.insn	2, 0x0515
 142:	0305                	.insn	2, 0x0305
 144:	0901                	.insn	2, 0x0901
 146:	0000                	.insn	2, 0x
}
 148:	0501                	.insn	2, 0x0501
 14a:	0601                	.insn	2, 0x0601
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	04090103          	lb	sp,64(s2)
  while (*ptr)
 150:	0100                	.insn	2, 0x0100
 152:	3305                	.insn	2, 0x3305
 154:	0306                	.insn	2, 0x0306
 156:	0902                	.insn	2, 0x0902
}
 158:	0004                	.insn	2, 0x0004
 15a:	0501                	.insn	2, 0x0501
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	0305                	.insn	2, 0x0305
 15e:	0901                	.insn	2, 0x0901
 160:	0000                	.insn	2, 0x
 162:	0501                	.insn	2, 0x0501
 164:	0601                	.insn	2, 0x0601
 166:	04090103          	lb	sp,64(s2)
}
 16a:	0100                	.insn	2, 0x0100
 16c:	3105                	.insn	2, 0x3105
 16e:	0306                	.insn	2, 0x0306
int _close(int fd) {
 170:	0902                	.insn	2, 0x0902
 172:	0004                	.insn	2, 0x0004
 174:	0501                	.insn	2, 0x0501
 176:	0305                	.insn	2, 0x0305
  st->st_mode = S_IFCHR;
 178:	0901                	.insn	2, 0x0901
 17a:	0000                	.insn	2, 0x
 17c:	0501                	.insn	2, 0x0501
 17e:	0601                	.insn	2, 0x0601
}
 180:	04090103          	lb	sp,64(s2)
 184:	0100                	.insn	2, 0x0100
 186:	2805                	.insn	2, 0x2805
}
 188:	0306                	.insn	2, 0x0306
 18a:	0902                	.insn	2, 0x0902
 18c:	0004                	.insn	2, 0x0004
 18e:	0501                	.insn	2, 0x0501
}
 190:	0305                	.insn	2, 0x0305
 192:	0901                	.insn	2, 0x0901
 194:	0000                	.insn	2, 0x
 196:	0301                	.insn	2, 0x0301
  while (1);
 198:	0901                	.insn	2, 0x0901
 19a:	0000                	.insn	2, 0x
}
 19c:	0301                	.insn	2, 0x0301
 19e:	0901                	.insn	2, 0x0901
}
 1a0:	0004                	.insn	2, 0x0004
 1a2:	0501                	.insn	2, 0x0501
 1a4:	0601                	.insn	2, 0x0601
 1a6:	00090103          	lb	sp,0(s2)
void *_sbrk(ptrdiff_t incr) {
 1aa:	0100                	.insn	2, 0x0100
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	2805                	.insn	2, 0x2805
 1ae:	0306                	.insn	2, 0x0306
 1b0:	0902                	.insn	2, 0x0902
 1b2:	0004                	.insn	2, 0x0004
 1b4:	0501                	.insn	2, 0x0501
 1b6:	0305                	.insn	2, 0x0305
 1b8:	0901                	.insn	2, 0x0901
 1ba:	0000                	.insn	2, 0x
 1bc:	0301                	.insn	2, 0x0301
 1be:	0901                	.insn	2, 0x0901
 1c0:	0000                	.insn	2, 0x
 1c2:	0301                	.insn	2, 0x0301
  curbrk += incr;
 1c4:	0901                	.insn	2, 0x0901
 1c6:	0004                	.insn	2, 0x0004
  return ret;
 1c8:	0501                	.insn	2, 0x0501
 1ca:	0601                	.insn	2, 0x0601
    return (void *)-1;
 1cc:	00090103          	lb	sp,0(s2)
}
 1d0:	0100                	.insn	2, 0x0100
 1d2:	2605                	.insn	2, 0x2605
}
 1d4:	0306                	.insn	2, 0x0306
 1d6:	0902                	.insn	2, 0x0902
 1d8:	000c                	.insn	2, 0x000c
 1da:	0501                	.insn	2, 0x0501
  size >>= 8;
 1dc:	0305                	.insn	2, 0x0305
 1de:	0901                	.insn	2, 0x0901
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e0:	0000                	.insn	2, 0x
 1e2:	0301                	.insn	2, 0x0301
 1e4:	0901                	.insn	2, 0x0901
 1e6:	0000                	.insn	2, 0x
 1e8:	0301                	.insn	2, 0x0301
 1ea:	0901                	.insn	2, 0x0901
 1ec:	0004                	.insn	2, 0x0004
 1ee:	0501                	.insn	2, 0x0501
}
 1f0:	0601                	.insn	2, 0x0601
 1f2:	00090103          	lb	sp,0(s2)
 1f6:	0100                	.insn	2, 0x0100
  snprintf(buf, 10, "%s", msg);
 1f8:	3405                	.insn	2, 0x3405
 1fa:	0306                	.insn	2, 0x0306
{
 1fc:	0922                	.insn	2, 0x0922
 1fe:	0008                	.insn	2, 0x0008
  snprintf(buf, 10, "%s", msg);
 200:	0501                	.insn	2, 0x0501
 202:	0336                	.insn	2, 0x0336
 204:	0900                	.insn	2, 0x0900
 206:	0000                	.insn	2, 0x
 208:	0501                	.insn	2, 0x0501
 20a:	063e                	.insn	2, 0x063e
 20c:	00090003          	lb	zero,0(s2)
{
 210:	0100                	.insn	2, 0x0100
 212:	1c05                	.insn	2, 0x1c05
  snprintf(buf, 10, "%s", msg);
 214:	0306                	.insn	2, 0x0306
 216:	0901                	.insn	2, 0x0901
  while (1);
 218:	0004                	.insn	2, 0x0004
 21a:	0301                	.insn	2, 0x0301
 21c:	0901                	.insn	2, 0x0901
 21e:	0004                	.insn	2, 0x0004
 220:	0301                	.insn	2, 0x0301
 222:	0901                	.insn	2, 0x0901
 224:	0004                	.insn	2, 0x0004
 226:	0301                	.insn	2, 0x0301
 228:	0901                	.insn	2, 0x0901
 22a:	0004                	.insn	2, 0x0004
 22c:	0301                	.insn	2, 0x0301
 22e:	0901                	.insn	2, 0x0901
 230:	0004                	.insn	2, 0x0004
 232:	0501                	.insn	2, 0x0501
 234:	0301                	.insn	2, 0x0301
 236:	095c                	.insn	2, 0x095c
 238:	0004                	.insn	2, 0x0004
 23a:	0501                	.insn	2, 0x0501
 23c:	09010303          	lb	t1,144(sp)
 240:	0000                	.insn	2, 0x
 242:	0501                	.insn	2, 0x0501
 244:	0314                	.insn	2, 0x0314
 246:	0900                	.insn	2, 0x0900
 248:	0000                	.insn	2, 0x
 24a:	0301                	.insn	2, 0x0301
 24c:	0900                	.insn	2, 0x0900
 24e:	0000                	.insn	2, 0x
 250:	0301                	.insn	2, 0x0301
 252:	0900                	.insn	2, 0x0900
 254:	0004                	.insn	2, 0x0004
 256:	0501                	.insn	2, 0x0501
 258:	09020303          	lb	t1,144(tp) # 90 <_halt>
 25c:	0000                	.insn	2, 0x
 25e:	0501                	.insn	2, 0x0501
 260:	060d                	.insn	2, 0x060d
 262:	00090003          	lb	zero,0(s2)
 266:	0100                	.insn	2, 0x0100
 268:	0605                	.insn	2, 0x0605
 26a:	04090003          	lb	zero,64(s2)
 26e:	0100                	.insn	2, 0x0100
 270:	0505                	.insn	2, 0x0505
 272:	0306                	.insn	2, 0x0306
 274:	0902                	.insn	2, 0x0902
 276:	0004                	.insn	2, 0x0004
 278:	0501                	.insn	2, 0x0501
 27a:	0308                	.insn	2, 0x0308
 27c:	0902                	.insn	2, 0x0902
 27e:	0004                	.insn	2, 0x0004
 280:	0501                	.insn	2, 0x0501
 282:	0612                	.insn	2, 0x0612
 284:	00090003          	lb	zero,0(s2)
 288:	0100                	.insn	2, 0x0100
 28a:	0b05                	.insn	2, 0x0b05
 28c:	04090003          	lb	zero,64(s2)
 290:	0100                	.insn	2, 0x0100
 292:	0505                	.insn	2, 0x0505
 294:	0306                	.insn	2, 0x0306
 296:	0902                	.insn	2, 0x0902
 298:	0004                	.insn	2, 0x0004
 29a:	0501                	.insn	2, 0x0501
 29c:	0308                	.insn	2, 0x0308
 29e:	0902                	.insn	2, 0x0902
 2a0:	0004                	.insn	2, 0x0004
 2a2:	0501                	.insn	2, 0x0501
 2a4:	0612                	.insn	2, 0x0612
 2a6:	00090003          	lb	zero,0(s2)
 2aa:	0100                	.insn	2, 0x0100
 2ac:	0b05                	.insn	2, 0x0b05
 2ae:	04090003          	lb	zero,64(s2)
 2b2:	0100                	.insn	2, 0x0100
 2b4:	0505                	.insn	2, 0x0505
 2b6:	0306                	.insn	2, 0x0306
 2b8:	0902                	.insn	2, 0x0902
 2ba:	0004                	.insn	2, 0x0004
 2bc:	0501                	.insn	2, 0x0501
 2be:	0308                	.insn	2, 0x0308
 2c0:	0902                	.insn	2, 0x0902
 2c2:	0004                	.insn	2, 0x0004
 2c4:	0501                	.insn	2, 0x0501
 2c6:	0612                	.insn	2, 0x0612
 2c8:	00090003          	lb	zero,0(s2)
 2cc:	0100                	.insn	2, 0x0100
 2ce:	0b05                	.insn	2, 0x0b05
 2d0:	04090003          	lb	zero,64(s2)
 2d4:	0100                	.insn	2, 0x0100
 2d6:	0505                	.insn	2, 0x0505
 2d8:	0306                	.insn	2, 0x0306
 2da:	0902                	.insn	2, 0x0902
 2dc:	0004                	.insn	2, 0x0004
 2de:	0501                	.insn	2, 0x0501
 2e0:	0308                	.insn	2, 0x0308
 2e2:	0902                	.insn	2, 0x0902
 2e4:	0004                	.insn	2, 0x0004
 2e6:	0501                	.insn	2, 0x0501
 2e8:	0612                	.insn	2, 0x0612
 2ea:	00090003          	lb	zero,0(s2)
 2ee:	0100                	.insn	2, 0x0100
 2f0:	0b05                	.insn	2, 0x0b05
 2f2:	04090003          	lb	zero,64(s2)
 2f6:	0100                	.insn	2, 0x0100
 2f8:	0505                	.insn	2, 0x0505
 2fa:	0306                	.insn	2, 0x0306
 2fc:	0902                	.insn	2, 0x0902
 2fe:	0004                	.insn	2, 0x0004
 300:	0501                	.insn	2, 0x0501
 302:	0308                	.insn	2, 0x0308
 304:	0902                	.insn	2, 0x0902
 306:	0004                	.insn	2, 0x0004
 308:	0501                	.insn	2, 0x0501
 30a:	0612                	.insn	2, 0x0612
 30c:	00090003          	lb	zero,0(s2)
 310:	0100                	.insn	2, 0x0100
 312:	0b05                	.insn	2, 0x0b05
 314:	04090003          	lb	zero,64(s2)
 318:	0100                	.insn	2, 0x0100
 31a:	0505                	.insn	2, 0x0505
 31c:	0306                	.insn	2, 0x0306
 31e:	0902                	.insn	2, 0x0902
 320:	0004                	.insn	2, 0x0004
 322:	0501                	.insn	2, 0x0501
 324:	0601                	.insn	2, 0x0601
 326:	04090403          	lb	s0,64(s2)
 32a:	0100                	.insn	2, 0x0100
 32c:	0409                	.insn	2, 0x0409
 32e:	0000                	.insn	2, 0x
 330:	0101                	.insn	2, 0x0101
 332:	0000031b          	.insn	4, 0x031b
 336:	0005                	.insn	2, 0x0005
 338:	0004                	.insn	2, 0x0004
 33a:	0070                	.insn	2, 0x0070
 33c:	0000                	.insn	2, 0x
 33e:	0101                	.insn	2, 0x0101
 340:	fb01                	.insn	2, 0xfb01
 342:	0d0e                	.insn	2, 0x0d0e
 344:	0100                	.insn	2, 0x0100
 346:	0101                	.insn	2, 0x0101
 348:	0001                	.insn	2, 0x0001
 34a:	0000                	.insn	2, 0x
 34c:	0001                	.insn	2, 0x0001
 34e:	0100                	.insn	2, 0x0100
 350:	0101                	.insn	2, 0x0101
 352:	061f 0000 0000      	.insn	6, 0x061f
 358:	00f1                	.insn	2, 0x00f1
 35a:	0000                	.insn	2, 0x
 35c:	0035                	.insn	2, 0x0035
 35e:	0000                	.insn	2, 0x
 360:	00b9                	.insn	2, 0x00b9
 362:	0000                	.insn	2, 0x
 364:	0064                	.insn	2, 0x0064
 366:	0000                	.insn	2, 0x
 368:	000000ef          	jal	368 <sniprintf+0x98>
 36c:	0102                	.insn	2, 0x0102
 36e:	021f 0c0f 00ae      	.insn	6, 0x00ae0c0f021f
 374:	0000                	.insn	2, 0x
 376:	ae01                	.insn	2, 0xae01
 378:	0000                	.insn	2, 0x
 37a:	0100                	.insn	2, 0x0100
 37c:	0000008f          	.insn	4, 0x008f
 380:	f502                	.insn	2, 0xf502
 382:	0000                	.insn	2, 0x
 384:	0300                	.insn	2, 0x0300
 386:	00000097          	auipc	ra,0x0
 38a:	a004                	.insn	2, 0xa004
 38c:	0000                	.insn	2, 0x
 38e:	0400                	.insn	2, 0x0400
 390:	00fe                	.insn	2, 0x00fe
 392:	0000                	.insn	2, 0x
 394:	0904                	.insn	2, 0x0904
 396:	0001                	.insn	2, 0x0001
 398:	0400                	.insn	2, 0x0400
 39a:	0098                	.insn	2, 0x0098
 39c:	0000                	.insn	2, 0x
 39e:	1504                	.insn	2, 0x1504
 3a0:	0001                	.insn	2, 0x0001
 3a2:	0400                	.insn	2, 0x0400
 3a4:	011c                	.insn	2, 0x011c
 3a6:	0000                	.insn	2, 0x
 3a8:	2505                	.insn	2, 0x2505
 3aa:	0001                	.insn	2, 0x0001
 3ac:	0400                	.insn	2, 0x0400
 3ae:	1c05                	.insn	2, 0x1c05
 3b0:	0500                	.insn	2, 0x0500
 3b2:	3c02                	.insn	2, 0x3c02
 3b4:	0001                	.insn	2, 0x0001
 3b6:	0300                	.insn	2, 0x0300
 3b8:	0109                	.insn	2, 0x0109
 3ba:	0305                	.insn	2, 0x0305
 3bc:	00090103          	lb	sp,0(s2)
 3c0:	0100                	.insn	2, 0x0100
 3c2:	00090103          	lb	sp,0(s2)
 3c6:	0100                	.insn	2, 0x0100
 3c8:	00090103          	lb	sp,0(s2)
 3cc:	0100                	.insn	2, 0x0100
 3ce:	00090103          	lb	sp,0(s2)
 3d2:	0100                	.insn	2, 0x0100
 3d4:	00090103          	lb	sp,0(s2)
 3d8:	0100                	.insn	2, 0x0100
 3da:	00090103          	lb	sp,0(s2)
 3de:	0100                	.insn	2, 0x0100
 3e0:	00090103          	lb	sp,0(s2)
 3e4:	0100                	.insn	2, 0x0100
 3e6:	00090103          	lb	sp,0(s2)
 3ea:	0100                	.insn	2, 0x0100
 3ec:	0805                	.insn	2, 0x0805
 3ee:	0306                	.insn	2, 0x0306
 3f0:	097f 0000 0501 032a 	.insn	10, 0x0901032a05010000097f
 3f8:	0901 
 3fa:	0004                	.insn	2, 0x0004
 3fc:	0501                	.insn	2, 0x0501
 3fe:	0301                	.insn	2, 0x0301
 400:	0901                	.insn	2, 0x0901
 402:	0008                	.insn	2, 0x0008
 404:	0501                	.insn	2, 0x0501
 406:	0630                	.insn	2, 0x0630
 408:	04090203          	lb	tp,64(s2)
 40c:	0100                	.insn	2, 0x0100
 40e:	0305                	.insn	2, 0x0305
 410:	00090103          	lb	sp,0(s2)
 414:	0100                	.insn	2, 0x0100
 416:	2c05                	.insn	2, 0x2c05
 418:	0306                	.insn	2, 0x0306
 41a:	0901                	.insn	2, 0x0901
 41c:	0000                	.insn	2, 0x
 41e:	0501                	.insn	2, 0x0501
 420:	060a                	.insn	2, 0x060a
 422:	04097f03          	.insn	4, 0x04097f03
 426:	0100                	.insn	2, 0x0100
 428:	0105                	.insn	2, 0x0105
 42a:	0306                	.insn	2, 0x0306
 42c:	0902                	.insn	2, 0x0902
 42e:	0008                	.insn	2, 0x0008
 430:	0501                	.insn	2, 0x0501
 432:	0605                	.insn	2, 0x0605
 434:	04097f03          	.insn	4, 0x04097f03
 438:	0100                	.insn	2, 0x0100
 43a:	3205                	.insn	2, 0x3205
 43c:	0306                	.insn	2, 0x0306
 43e:	0900                	.insn	2, 0x0900
 440:	0000                	.insn	2, 0x
 442:	0501                	.insn	2, 0x0501
 444:	032c                	.insn	2, 0x032c
 446:	0900                	.insn	2, 0x0900
 448:	0004                	.insn	2, 0x0004
 44a:	0501                	.insn	2, 0x0501
 44c:	03030613          	add	a2,t1,48
 450:	0809                	.insn	2, 0x0809
 452:	0100                	.insn	2, 0x0100
 454:	0305                	.insn	2, 0x0305
 456:	00090103          	lb	sp,0(s2)
 45a:	0100                	.insn	2, 0x0100
 45c:	0105                	.insn	2, 0x0105
 45e:	0306                	.insn	2, 0x0306
 460:	0901                	.insn	2, 0x0901
 462:	0000                	.insn	2, 0x
 464:	0501                	.insn	2, 0x0501
 466:	0605                	.insn	2, 0x0605
 468:	08090203          	lb	tp,128(s2)
 46c:	0100                	.insn	2, 0x0100
 46e:	2505                	.insn	2, 0x2505
 470:	08090403          	lb	s0,128(s2)
 474:	0100                	.insn	2, 0x0100
 476:	0305                	.insn	2, 0x0305
 478:	00090103          	lb	sp,0(s2)
 47c:	0100                	.insn	2, 0x0100
 47e:	0f05                	.insn	2, 0x0f05
 480:	0306                	.insn	2, 0x0306
 482:	0900                	.insn	2, 0x0900
 484:	0000                	.insn	2, 0x
 486:	0501                	.insn	2, 0x0501
 488:	01030603          	lb	a2,16(t1)
 48c:	0809                	.insn	2, 0x0809
 48e:	0100                	.insn	2, 0x0100
 490:	0105                	.insn	2, 0x0105
 492:	0306                	.insn	2, 0x0306
 494:	0901                	.insn	2, 0x0901
 496:	0000                	.insn	2, 0x
 498:	0501                	.insn	2, 0x0501
 49a:	0615                	.insn	2, 0x0615
 49c:	08090203          	lb	tp,128(s2)
 4a0:	0100                	.insn	2, 0x0100
 4a2:	0305                	.insn	2, 0x0305
 4a4:	00090103          	lb	sp,0(s2)
 4a8:	0100                	.insn	2, 0x0100
 4aa:	0105                	.insn	2, 0x0105
 4ac:	0306                	.insn	2, 0x0306
 4ae:	0901                	.insn	2, 0x0901
 4b0:	0000                	.insn	2, 0x
 4b2:	0501                	.insn	2, 0x0501
 4b4:	0626                	.insn	2, 0x0626
 4b6:	08090203          	lb	tp,128(s2)
 4ba:	0100                	.insn	2, 0x0100
 4bc:	0305                	.insn	2, 0x0305
 4be:	00090103          	lb	sp,0(s2)
 4c2:	0100                	.insn	2, 0x0100
 4c4:	0105                	.insn	2, 0x0105
 4c6:	0306                	.insn	2, 0x0306
 4c8:	0901                	.insn	2, 0x0901
 4ca:	0000                	.insn	2, 0x
 4cc:	0501                	.insn	2, 0x0501
 4ce:	0618                	.insn	2, 0x0618
 4d0:	08090203          	lb	tp,128(s2)
 4d4:	0100                	.insn	2, 0x0100
 4d6:	0305                	.insn	2, 0x0305
 4d8:	00090103          	lb	sp,0(s2)
 4dc:	0100                	.insn	2, 0x0100
 4de:	0905                	.insn	2, 0x0905
 4e0:	00090003          	lb	zero,0(s2)
 4e4:	0100                	.insn	2, 0x0100
 4e6:	1e05                	.insn	2, 0x1e05
 4e8:	04090303          	lb	t1,64(s2)
 4ec:	0100                	.insn	2, 0x0100
 4ee:	0305                	.insn	2, 0x0305
 4f0:	00090103          	lb	sp,0(s2)
 4f4:	0100                	.insn	2, 0x0100
 4f6:	0105                	.insn	2, 0x0105
 4f8:	0306                	.insn	2, 0x0306
 4fa:	0901                	.insn	2, 0x0901
 4fc:	0000                	.insn	2, 0x
 4fe:	0501                	.insn	2, 0x0501
 500:	02030613          	add	a2,t1,32
 504:	0409                	.insn	2, 0x0409
 506:	0100                	.insn	2, 0x0100
 508:	0305                	.insn	2, 0x0305
 50a:	00090103          	lb	sp,0(s2)
 50e:	0100                	.insn	2, 0x0100
 510:	0105                	.insn	2, 0x0105
 512:	0306                	.insn	2, 0x0306
 514:	0901                	.insn	2, 0x0901
 516:	0000                	.insn	2, 0x
 518:	0501                	.insn	2, 0x0501
 51a:	061d                	.insn	2, 0x061d
 51c:	08090203          	lb	tp,128(s2)
 520:	0100                	.insn	2, 0x0100
 522:	0305                	.insn	2, 0x0305
 524:	00090103          	lb	sp,0(s2)
 528:	0100                	.insn	2, 0x0100
 52a:	00090103          	lb	sp,0(s2)
 52e:	0100                	.insn	2, 0x0100
 530:	00090103          	lb	sp,0(s2)
 534:	0100                	.insn	2, 0x0100
 536:	00090103          	lb	sp,0(s2)
 53a:	0100                	.insn	2, 0x0100
 53c:	00090103          	lb	sp,0(s2)
 540:	0100                	.insn	2, 0x0100
 542:	00090203          	lb	tp,0(s2)
 546:	0100                	.insn	2, 0x0100
 548:	1005                	.insn	2, 0x1005
 54a:	0306                	.insn	2, 0x0306
 54c:	0900                	.insn	2, 0x0900
 54e:	0000                	.insn	2, 0x
 550:	0501                	.insn	2, 0x0501
 552:	031d                	.insn	2, 0x031d
 554:	0979                	.insn	2, 0x0979
 556:	0000                	.insn	2, 0x
 558:	0501                	.insn	2, 0x0501
 55a:	0310                	.insn	2, 0x0310
 55c:	00040907          	.insn	4, 0x00040907
 560:	0501                	.insn	2, 0x0501
 562:	0306                	.insn	2, 0x0306
 564:	0900                	.insn	2, 0x0900
 566:	0004                	.insn	2, 0x0004
 568:	0501                	.insn	2, 0x0501
 56a:	0310                	.insn	2, 0x0310
 56c:	0900                	.insn	2, 0x0900
 56e:	0004                	.insn	2, 0x0004
 570:	0501                	.insn	2, 0x0501
 572:	0306                	.insn	2, 0x0306
 574:	0900                	.insn	2, 0x0900
 576:	0004                	.insn	2, 0x0004
 578:	0501                	.insn	2, 0x0501
 57a:	04020023          	sb	zero,64(tp) # 40 <_data_copy_loop+0x20>
 57e:	0301                	.insn	2, 0x0301
 580:	0900                	.insn	2, 0x0900
 582:	0004                	.insn	2, 0x0004
 584:	0501                	.insn	2, 0x0501
 586:	04030603          	lb	a2,64(t1)
 58a:	0809                	.insn	2, 0x0809
 58c:	0100                	.insn	2, 0x0100
 58e:	00090103          	lb	sp,0(s2)
 592:	0100                	.insn	2, 0x0100
 594:	0a05                	.insn	2, 0x0a05
 596:	0306                	.insn	2, 0x0306
 598:	0900                	.insn	2, 0x0900
 59a:	0000                	.insn	2, 0x
 59c:	0501                	.insn	2, 0x0501
 59e:	01030603          	lb	a2,16(t1)
 5a2:	0409                	.insn	2, 0x0409
 5a4:	0100                	.insn	2, 0x0100
 5a6:	0a05                	.insn	2, 0x0a05
 5a8:	0306                	.insn	2, 0x0306
 5aa:	0900                	.insn	2, 0x0900
 5ac:	0000                	.insn	2, 0x
 5ae:	0501                	.insn	2, 0x0501
 5b0:	030c                	.insn	2, 0x030c
 5b2:	0004097b          	.insn	4, 0x0004097b
 5b6:	0501                	.insn	2, 0x0501
 5b8:	0301                	.insn	2, 0x0301
 5ba:	0906                	.insn	2, 0x0906
 5bc:	0004                	.insn	2, 0x0004
 5be:	0501                	.insn	2, 0x0501
 5c0:	062a                	.insn	2, 0x062a
 5c2:	04090203          	lb	tp,64(s2)
 5c6:	0100                	.insn	2, 0x0100
 5c8:	0305                	.insn	2, 0x0305
 5ca:	00090103          	lb	sp,0(s2)
 5ce:	0100                	.insn	2, 0x0100
 5d0:	00090103          	lb	sp,0(s2)
 5d4:	0100                	.insn	2, 0x0100
 5d6:	0105                	.insn	2, 0x0105
 5d8:	0306                	.insn	2, 0x0306
 5da:	0901                	.insn	2, 0x0901
 5dc:	0000                	.insn	2, 0x
 5de:	0501                	.insn	2, 0x0501
 5e0:	0632                	.insn	2, 0x0632
 5e2:	08090203          	lb	tp,128(s2)
 5e6:	0100                	.insn	2, 0x0100
 5e8:	0305                	.insn	2, 0x0305
 5ea:	00090103          	lb	sp,0(s2)
 5ee:	0100                	.insn	2, 0x0100
 5f0:	00090103          	lb	sp,0(s2)
 5f4:	0100                	.insn	2, 0x0100
 5f6:	097fb903          	.insn	4, 0x097fb903
 5fa:	0000                	.insn	2, 0x
 5fc:	0301                	.insn	2, 0x0301
 5fe:	0901                	.insn	2, 0x0901
 600:	0000                	.insn	2, 0x
 602:	0301                	.insn	2, 0x0301
 604:	0901                	.insn	2, 0x0901
 606:	0000                	.insn	2, 0x
 608:	0301                	.insn	2, 0x0301
 60a:	0901                	.insn	2, 0x0901
 60c:	0000                	.insn	2, 0x
 60e:	0301                	.insn	2, 0x0301
 610:	0901                	.insn	2, 0x0901
 612:	0000                	.insn	2, 0x
 614:	0301                	.insn	2, 0x0301
 616:	0901                	.insn	2, 0x0901
 618:	0000                	.insn	2, 0x
 61a:	0301                	.insn	2, 0x0301
 61c:	0901                	.insn	2, 0x0901
 61e:	0000                	.insn	2, 0x
 620:	0301                	.insn	2, 0x0301
 622:	0901                	.insn	2, 0x0901
 624:	0000                	.insn	2, 0x
 626:	0501                	.insn	2, 0x0501
 628:	0608                	.insn	2, 0x0608
 62a:	00097f03          	.insn	4, 0x00097f03
 62e:	0100                	.insn	2, 0x0100
 630:	2a05                	.insn	2, 0x2a05
 632:	04090103          	lb	sp,64(s2)
 636:	0100                	.insn	2, 0x0100
 638:	0305                	.insn	2, 0x0305
 63a:	0306                	.insn	2, 0x0306
 63c:	00c1                	.insn	2, 0x00c1
 63e:	0809                	.insn	2, 0x0809
 640:	0100                	.insn	2, 0x0100
 642:	0105                	.insn	2, 0x0105
 644:	0306                	.insn	2, 0x0306
 646:	0901                	.insn	2, 0x0901
 648:	0000                	.insn	2, 0x
 64a:	0901                	.insn	2, 0x0901
 64c:	0008                	.insn	2, 0x0008
 64e:	0100                	.insn	2, 0x0100
 650:	d001                	.insn	2, 0xd001
 652:	0000                	.insn	2, 0x
 654:	0500                	.insn	2, 0x0500
 656:	0400                	.insn	2, 0x0400
 658:	5b00                	.insn	2, 0x5b00
 65a:	0000                	.insn	2, 0x
 65c:	0100                	.insn	2, 0x0100
 65e:	0101                	.insn	2, 0x0101
 660:	000d0efb          	.insn	4, 0x000d0efb
 664:	0101                	.insn	2, 0x0101
 666:	0101                	.insn	2, 0x0101
 668:	0000                	.insn	2, 0x
 66a:	0100                	.insn	2, 0x0100
 66c:	0000                	.insn	2, 0x
 66e:	0101                	.insn	2, 0x0101
 670:	1f01                	.insn	2, 0x1f01
 672:	00000007          	.insn	4, 0x0007
 676:	f100                	.insn	2, 0xf100
 678:	0000                	.insn	2, 0x
 67a:	3500                	.insn	2, 0x3500
 67c:	0000                	.insn	2, 0x
 67e:	6400                	.insn	2, 0x6400
 680:	0000                	.insn	2, 0x
 682:	b900                	.insn	2, 0xb900
 684:	0000                	.insn	2, 0x
 686:	ef00                	.insn	2, 0xef00
 688:	0000                	.insn	2, 0x
 68a:	3900                	.insn	2, 0x3900
 68c:	0001                	.insn	2, 0x0001
 68e:	0200                	.insn	2, 0x0200
 690:	1f01                	.insn	2, 0x1f01
 692:	0f02                	.insn	2, 0x0f02
 694:	00013207          	.insn	4, 0x00013207
 698:	0100                	.insn	2, 0x0100
 69a:	0132                	.insn	2, 0x0132
 69c:	0000                	.insn	2, 0x
 69e:	8f01                	.insn	2, 0x8f01
 6a0:	0000                	.insn	2, 0x
 6a2:	0200                	.insn	2, 0x0200
 6a4:	00a0                	.insn	2, 0x00a0
 6a6:	0000                	.insn	2, 0x
 6a8:	0000f503          	.insn	4, 0xf503
 6ac:	0400                	.insn	2, 0x0400
 6ae:	011c                	.insn	2, 0x011c
 6b0:	0000                	.insn	2, 0x
 6b2:	6005                	.insn	2, 0x6005
 6b4:	0001                	.insn	2, 0x0001
 6b6:	0600                	.insn	2, 0x0600
 6b8:	1905                	.insn	2, 0x1905
 6ba:	0500                	.insn	2, 0x0500
 6bc:	f002                	.insn	2, 0xf002
 6be:	0001                	.insn	2, 0x0001
 6c0:	0300                	.insn	2, 0x0300
 6c2:	0114                	.insn	2, 0x0114
 6c4:	0305                	.insn	2, 0x0305
 6c6:	00090103          	lb	sp,0(s2)
 6ca:	0100                	.insn	2, 0x0100
 6cc:	0105                	.insn	2, 0x0105
 6ce:	0306                	.insn	2, 0x0306
 6d0:	00000903          	lb	s2,0(zero) # 0 <ROM_START_ADDRESS>
 6d4:	0901                	.insn	2, 0x0901
 6d6:	0008                	.insn	2, 0x0008
 6d8:	0100                	.insn	2, 0x0100
 6da:	0501                	.insn	2, 0x0501
 6dc:	0001                	.insn	2, 0x0001
 6de:	0205                	.insn	2, 0x0205
 6e0:	01f8                	.insn	2, 0x01f8
 6e2:	0000                	.insn	2, 0x
 6e4:	05011b03          	lh	s6,80(sp)
 6e8:	09030303          	lb	t1,144(t1)
 6ec:	0000                	.insn	2, 0x
 6ee:	0501                	.insn	2, 0x0501
 6f0:	0601                	.insn	2, 0x0601
 6f2:	04097d03          	.insn	4, 0x04097d03
 6f6:	0100                	.insn	2, 0x0100
 6f8:	0305                	.insn	2, 0x0305
 6fa:	04090303          	lb	t1,64(s2)
 6fe:	0100                	.insn	2, 0x0100
 700:	0105                	.insn	2, 0x0105
 702:	10097d03          	.insn	4, 0x10097d03
 706:	0100                	.insn	2, 0x0100
 708:	0305                	.insn	2, 0x0305
 70a:	04090303          	lb	t1,64(s2)
 70e:	0100                	.insn	2, 0x0100
 710:	0306                	.insn	2, 0x0306
 712:	0902                	.insn	2, 0x0902
 714:	0004                	.insn	2, 0x0004
 716:	0501                	.insn	2, 0x0501
 718:	0309                	.insn	2, 0x0309
 71a:	0900                	.insn	2, 0x0900
 71c:	0000                	.insn	2, 0x
 71e:	0901                	.insn	2, 0x0901
 720:	0004                	.insn	2, 0x0004
 722:	0100                	.insn	2, 0x0100
 724:	4f01                	.insn	2, 0x4f01
 726:	0001                	.insn	2, 0x0001
 728:	0500                	.insn	2, 0x0500
 72a:	0400                	.insn	2, 0x0400
 72c:	2e00                	.insn	2, 0x2e00
 72e:	0000                	.insn	2, 0x
 730:	0100                	.insn	2, 0x0100
 732:	0101                	.insn	2, 0x0101
 734:	000d0efb          	.insn	4, 0x000d0efb
 738:	0101                	.insn	2, 0x0101
 73a:	0101                	.insn	2, 0x0101
 73c:	0000                	.insn	2, 0x
 73e:	0100                	.insn	2, 0x0100
 740:	0000                	.insn	2, 0x
 742:	0101                	.insn	2, 0x0101
 744:	1f01                	.insn	2, 0x1f01
 746:	6802                	.insn	2, 0x6802
 748:	0001                	.insn	2, 0x0001
 74a:	c900                	.insn	2, 0xc900
 74c:	0001                	.insn	2, 0x0001
 74e:	0200                	.insn	2, 0x0200
 750:	1f01                	.insn	2, 0x1f01
 752:	0f02                	.insn	2, 0x0f02
 754:	ec02                	.insn	2, 0xec02
 756:	0001                	.insn	2, 0x0001
 758:	0100                	.insn	2, 0x0100
 75a:	01ec                	.insn	2, 0x01ec
 75c:	0000                	.insn	2, 0x
 75e:	0001                	.insn	2, 0x0001
 760:	0205                	.insn	2, 0x0205
 762:	15e8                	.insn	2, 0x15e8
 764:	0000                	.insn	2, 0x
 766:	0100c403          	lbu	s0,16(ra) # 396 <__ssputs_r+0x12>
 76a:	04090103          	lb	sp,64(s2)
 76e:	0100                	.insn	2, 0x0100
 770:	04090403          	lb	s0,64(s2)
 774:	0100                	.insn	2, 0x0100
 776:	04090103          	lb	sp,64(s2)
 77a:	0100                	.insn	2, 0x0100
 77c:	04090103          	lb	sp,64(s2)
 780:	0100                	.insn	2, 0x0100
 782:	04090103          	lb	sp,64(s2)
 786:	0100                	.insn	2, 0x0100
 788:	04090103          	lb	sp,64(s2)
 78c:	0100                	.insn	2, 0x0100
 78e:	04090103          	lb	sp,64(s2)
 792:	0100                	.insn	2, 0x0100
 794:	04090203          	lb	tp,64(s2)
 798:	0100                	.insn	2, 0x0100
 79a:	04090103          	lb	sp,64(s2)
 79e:	0100                	.insn	2, 0x0100
 7a0:	04090103          	lb	sp,64(s2)
 7a4:	0100                	.insn	2, 0x0100
 7a6:	04090103          	lb	sp,64(s2)
 7aa:	0100                	.insn	2, 0x0100
 7ac:	04090203          	lb	tp,64(s2)
 7b0:	0100                	.insn	2, 0x0100
 7b2:	04090203          	lb	tp,64(s2)
 7b6:	0100                	.insn	2, 0x0100
 7b8:	04090103          	lb	sp,64(s2)
 7bc:	0100                	.insn	2, 0x0100
 7be:	04090103          	lb	sp,64(s2)
 7c2:	0100                	.insn	2, 0x0100
 7c4:	04090203          	lb	tp,64(s2)
 7c8:	0100                	.insn	2, 0x0100
 7ca:	04090103          	lb	sp,64(s2)
 7ce:	0100                	.insn	2, 0x0100
 7d0:	04090103          	lb	sp,64(s2)
 7d4:	0100                	.insn	2, 0x0100
 7d6:	04090203          	lb	tp,64(s2)
 7da:	0100                	.insn	2, 0x0100
 7dc:	04090603          	lb	a2,64(s2)
 7e0:	0100                	.insn	2, 0x0100
 7e2:	04090103          	lb	sp,64(s2)
 7e6:	0100                	.insn	2, 0x0100
 7e8:	04090103          	lb	sp,64(s2)
 7ec:	0100                	.insn	2, 0x0100
 7ee:	04090103          	lb	sp,64(s2)
 7f2:	0100                	.insn	2, 0x0100
 7f4:	04090503          	lb	a0,64(s2)
 7f8:	0100                	.insn	2, 0x0100
 7fa:	04090203          	lb	tp,64(s2)
 7fe:	0100                	.insn	2, 0x0100
 800:	04090203          	lb	tp,64(s2)
 804:	0100                	.insn	2, 0x0100
 806:	04090103          	lb	sp,64(s2)
 80a:	0100                	.insn	2, 0x0100
 80c:	04090203          	lb	tp,64(s2)
 810:	0100                	.insn	2, 0x0100
 812:	04090203          	lb	tp,64(s2)
 816:	0100                	.insn	2, 0x0100
 818:	04090103          	lb	sp,64(s2)
 81c:	0100                	.insn	2, 0x0100
 81e:	04090103          	lb	sp,64(s2)
 822:	0100                	.insn	2, 0x0100
 824:	04090103          	lb	sp,64(s2)
 828:	0100                	.insn	2, 0x0100
 82a:	04090403          	lb	s0,64(s2)
 82e:	0100                	.insn	2, 0x0100
 830:	04090103          	lb	sp,64(s2)
 834:	0100                	.insn	2, 0x0100
 836:	04090103          	lb	sp,64(s2)
 83a:	0100                	.insn	2, 0x0100
 83c:	04090203          	lb	tp,64(s2)
 840:	0100                	.insn	2, 0x0100
 842:	04090103          	lb	sp,64(s2)
 846:	0100                	.insn	2, 0x0100
 848:	04090103          	lb	sp,64(s2)
 84c:	0100                	.insn	2, 0x0100
 84e:	04090203          	lb	tp,64(s2)
 852:	0100                	.insn	2, 0x0100
 854:	04090103          	lb	sp,64(s2)
 858:	0100                	.insn	2, 0x0100
 85a:	04090203          	lb	tp,64(s2)
 85e:	0100                	.insn	2, 0x0100
 860:	04090103          	lb	sp,64(s2)
 864:	0100                	.insn	2, 0x0100
 866:	04090103          	lb	sp,64(s2)
 86a:	0100                	.insn	2, 0x0100
 86c:	04090103          	lb	sp,64(s2)
 870:	0100                	.insn	2, 0x0100
 872:	0409                	.insn	2, 0x0409
 874:	0000                	.insn	2, 0x
 876:	0101                	.insn	2, 0x0101

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
    la gp, __global_pointer$
   0:	6d6f682f          	.insn	4, 0x6d6f682f
   4:	2f65                	.insn	2, 0x2f65
   6:	6761                	.insn	2, 0x6761
    la a4, _sdata_load$
   8:	6d61                	.insn	2, 0x6d61
   a:	6d65                	.insn	2, 0x6d65
   c:	6f6e                	.insn	2, 0x6f6e
   e:	2f6e                	.insn	2, 0x2f6e
    la a5, _sdata$
  10:	6f44                	.insn	2, 0x6f44
  12:	656d7563          	bgeu	s10,s6,65c <__ssprint_r+0x170>
  16:	746e                	.insn	2, 0x746e
    la a6, _edata$
  18:	59502f73          	.insn	4, 0x59502f73
  1c:	2f594d47          	.insn	4, 0x2f594d47
    lw a7, 0(a4)
  20:	73007773          	.insn	4, 0x73007773
    sw a7, 0(a5)
  24:	6174                	.insn	2, 0x6174
  26:	7472                	.insn	2, 0x7472
    addi a5, a5, 0x04
  28:	732e                	.insn	2, 0x732e
  2a:	7300                	.insn	2, 0x7300
    addi a4, a4, 0x04
  2c:	6372                	.insn	2, 0x6372
  2e:	6c61682f          	.insn	4, 0x6c61682f
    blt a5, a6, _data_copy_loop
  32:	632e                	.insn	2, 0x632e
    la a4, _sbss$
  34:	2f00                	.insn	2, 0x2f00
  36:	2f74706f          	j	47b2c <RAM_SIZE+0x43b2c>
  3a:	6972                	.insn	2, 0x6972
    la a5, _ebss$
  3c:	2f766373          	.insn	4, 0x2f766373
  40:	6972                	.insn	2, 0x6972
  42:	33766373          	.insn	4, 0x33766373
    sw zero, 0(a4)
  46:	2d32                	.insn	2, 0x2d32
    addi a4, a4, 0x04
  48:	6e75                	.insn	2, 0x6e75
  4a:	776f6e6b          	.insn	4, 0x776f6e6b
    blt a4, a5, _bss_zero_loop
  4e:	2d6e                	.insn	2, 0x2d6e
    la a4, __heap_start$
  50:	6c65                	.insn	2, 0x6c65
  52:	2f66                	.insn	2, 0x2f66
  54:	6e69                	.insn	2, 0x6e69
  56:	64756c63          	bltu	a0,t2,6ae <_svfiprintf_r+0x6>
    la a5, __heap_end$
  5a:	2f65                	.insn	2, 0x2f65
  5c:	616d                	.insn	2, 0x616d
  5e:	6e696863          	bltu	s2,t1,74e <_svfiprintf_r+0xa6>
    sw zero, 0(a4)
  62:	0065                	.insn	2, 0x0065
    addi a4, a4, 0x04
  64:	74706f2f          	.insn	4, 0x74706f2f
    blt a4, a5, _heap_zero_loop
  68:	7369722f          	.insn	4, 0x7369722f
    li a4, 0
  6c:	722f7663          	bgeu	t5,sp,798 <_svfiprintf_r+0xf0>
    li a5, 0
  70:	7369                	.insn	2, 0x7369
  72:	32337663          	bgeu	t1,gp,39e <__ssputs_r+0x1a>
    li a6, 0
  76:	752d                	.insn	2, 0x752d
    la sp, __stack_top$
  78:	6b6e                	.insn	2, 0x6b6e
  7a:	6f6e                	.insn	2, 0x6f6e
  7c:	652d6e77          	.insn	4, 0x652d6e77
    la t0, _MSYSIE
  80:	666c                	.insn	2, 0x666c
  82:	636e692f          	.insn	4, 0x636e692f
  86:	756c                	.insn	2, 0x756c
    csrrw t0, mtvec, t0
  88:	6564                	.insn	2, 0x6564
  8a:	7379732f          	.insn	4, 0x7379732f
    call main
  8e:	5f00                	.insn	2, 0x5f00
    j _halt
  90:	6564                	.insn	2, 0x6564
  92:	6166                	.insn	2, 0x6166
    mret
  94:	6c75                	.insn	2, 0x6c75
  96:	5f74                	.insn	2, 0x5f74
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  98:	7974                	.insn	2, 0x7974
  9a:	6570                	.insn	2, 0x6570
}
  9c:	00682e73          	.insn	4, 0x00682e73
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a0:	735f 6474 6e69      	.insn	6, 0x6e696474735f
}
  a6:	2e74                	.insn	2, 0x2e74
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a8:	0068                	.insn	2, 0x0068
  aa:	2f637273          	.insn	4, 0x2f637273
}
  ae:	63737973          	.insn	4, 0x63737973
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b2:	6c61                	.insn	2, 0x6c61
}
  b4:	736c                	.insn	2, 0x736c
  b6:	632e                	.insn	2, 0x632e
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	2f00                	.insn	2, 0x2f00
  ba:	2f74706f          	j	47bb0 <RAM_SIZE+0x43bb0>
}
  be:	6972                	.insn	2, 0x6972
  c0:	2f766373          	.insn	4, 0x2f766373
  c4:	696c                	.insn	2, 0x696c
  c6:	2f62                	.insn	2, 0x2f62
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  c8:	2f636367          	.insn	4, 0x2f636367
}
  cc:	6972                	.insn	2, 0x6972
  ce:	33766373          	.insn	4, 0x33766373
  d2:	2d32                	.insn	2, 0x2d32
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d4:	6e75                	.insn	2, 0x6e75
  d6:	776f6e6b          	.insn	4, 0x776f6e6b
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  da:	2d6e                	.insn	2, 0x2d6e
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	6c65                	.insn	2, 0x6c65
  de:	2f66                	.insn	2, 0x2f66
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e0:	3331                	.insn	2, 0x3331
  e2:	322e                	.insn	2, 0x322e
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	302e                	.insn	2, 0x302e
  e6:	636e692f          	.insn	4, 0x636e692f
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  ea:	756c                	.insn	2, 0x756c
  uint32_t cause = hal_read_csr(mcause);
  ec:	6564                	.insn	2, 0x6564
  ee:	2e00                	.insn	2, 0x2e00
  if (cause & EXT_SYS_I0_IE)
  f0:	6372732f          	.insn	4, 0x6372732f
  f4:	7300                	.insn	2, 0x7300
  f6:	6474                	.insn	2, 0x6474
    EXT_IRQ_0_HANDLER();
  f8:	6564                	.insn	2, 0x6564
  fa:	2e66                	.insn	2, 0x2e66
  else if (cause & EXT_SYS_I1_IE)
  fc:	0068                	.insn	2, 0x0068
  fe:	745f 6d69 7665      	.insn	6, 0x76656d69745f
    EXT_IRQ_1_HANDLER();
 104:	6c61                	.insn	2, 0x6c61
 106:	682e                	.insn	2, 0x682e
  else if (cause & EXT_SYS_I2_IE)
 108:	5f00                	.insn	2, 0x5f00
 10a:	6974                	.insn	2, 0x6974
 10c:	656d                	.insn	2, 0x656d
 10e:	63657073          	.insn	4, 0x63657073
    EXT_IRQ_2_HANDLER();
 112:	682e                	.insn	2, 0x682e
  else if (cause & EXT_SYS_I3_IE)
 114:	7300                	.insn	2, 0x7300
 116:	6174                	.insn	2, 0x6174
 118:	2e74                	.insn	2, 0x2e74
 11a:	0068                	.insn	2, 0x0068
    EXT_IRQ_3_HANDLER();
 11c:	74737973          	.insn	4, 0x74737973
  else if (cause & EXT_SYS_I4_IE)
 120:	6d65                	.insn	2, 0x6d65
 122:	682e                	.insn	2, 0x682e
 124:	7500                	.insn	2, 0x7500
 126:	696e                	.insn	2, 0x696e
    EXT_IRQ_4_HANDLER();
 128:	2e647473          	.insn	4, 0x2e647473
  else if (cause & EXT_SYS_I5_IE)
 12c:	0068                	.insn	2, 0x0068
 12e:	2f637273          	.insn	4, 0x2f637273
 132:	616d                	.insn	2, 0x616d
    EXT_IRQ_5_HANDLER();
 134:	6e69                	.insn	2, 0x6e69
 136:	632e                	.insn	2, 0x632e
}
 138:	2f00                	.insn	2, 0x2f00
 13a:	2f74706f          	j	47c30 <RAM_SIZE+0x43c30>
  size >>= 8;
 13e:	6972                	.insn	2, 0x6972
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	2f766373          	.insn	4, 0x2f766373
 144:	6972                	.insn	2, 0x6972
 146:	33766373          	.insn	4, 0x33766373
}
 14a:	2d32                	.insn	2, 0x2d32
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	6e75                	.insn	2, 0x6e75
 14e:	776f6e6b          	.insn	4, 0x776f6e6b
  while (*ptr)
 152:	2d6e                	.insn	2, 0x2d6e
 154:	6c65                	.insn	2, 0x6c65
 156:	2f66                	.insn	2, 0x2f66
}
 158:	6e69                	.insn	2, 0x6e69
 15a:	64756c63          	bltu	a0,t2,7b2 <_svfiprintf_r+0x10a>
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15e:	0065                	.insn	2, 0x0065
 160:	69647473          	.insn	4, 0x69647473
 164:	00682e6f          	jal	t3,8216a <RAM_SIZE+0x7e16a>
}
 168:	6d6f682f          	.insn	4, 0x6d6f682f
 16c:	2f65                	.insn	2, 0x2f65
 16e:	6f6e7473          	.insn	4, 0x6f6e7473
int _close(int fd) {
 172:	746c                	.insn	2, 0x746c
 174:	6e69                	.insn	2, 0x6e69
 176:	6d742f67          	.insn	4, 0x6d742f67
  st->st_mode = S_IFCHR;
 17a:	2f70                	.insn	2, 0x2f70
 17c:	7672                	.insn	2, 0x7672
 17e:	2f636367          	.insn	4, 0x2f636367
}
 182:	6972                	.insn	2, 0x6972
 184:	2d766373          	.insn	4, 0x2d766373
}
 188:	2d756e67          	.insn	4, 0x2d756e67
 18c:	6f74                	.insn	2, 0x6f74
 18e:	68636c6f          	jal	s8,36814 <RAM_SIZE+0x32814>
}
 192:	6961                	.insn	2, 0x6961
 194:	2f6e                	.insn	2, 0x2f6e
 196:	7562                	.insn	2, 0x7562
  while (1);
 198:	6c69                	.insn	2, 0x6c69
 19a:	2d64                	.insn	2, 0x2d64
}
 19c:	2d636367          	.insn	4, 0x2d636367
}
 1a0:	656e                	.insn	2, 0x656e
 1a2:	62696c77          	.insn	4, 0x62696c77
 1a6:	732d                	.insn	2, 0x732d
void *_sbrk(ptrdiff_t incr) {
 1a8:	6174                	.insn	2, 0x6174
 1aa:	2f326567          	.insn	4, 0x2f326567
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ae:	6972                	.insn	2, 0x6972
 1b0:	33766373          	.insn	4, 0x33766373
 1b4:	2d32                	.insn	2, 0x2d32
 1b6:	6e75                	.insn	2, 0x6e75
 1b8:	776f6e6b          	.insn	4, 0x776f6e6b
 1bc:	2d6e                	.insn	2, 0x2d6e
 1be:	6c65                	.insn	2, 0x6c65
 1c0:	2f66                	.insn	2, 0x2f66
 1c2:	696c                	.insn	2, 0x696c
  curbrk += incr;
 1c4:	6762                	.insn	2, 0x6762
 1c6:	2e006363          	bltu	zero,zero,4ac <HEAP_SIZE+0xac>
  return ret;
 1ca:	2f2e                	.insn	2, 0x2f2e
    return (void *)-1;
 1cc:	2e2e                	.insn	2, 0x2e2e
 1ce:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
}
 1d2:	2f2e                	.insn	2, 0x2f2e
}
 1d4:	2f636367          	.insn	4, 0x2f636367
 1d8:	696c                	.insn	2, 0x696c
 1da:	6762                	.insn	2, 0x6762
  size >>= 8;
 1dc:	632f6363          	bltu	t5,s2,802 <_svfiprintf_r+0x15a>
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e0:	69666e6f          	jal	t3,66876 <RAM_SIZE+0x62876>
 1e4:	69722f67          	.insn	4, 0x69722f67
 1e8:	00766373          	.insn	4, 0x00766373
 1ec:	6964                	.insn	2, 0x6964
 1ee:	2e76                	.insn	2, 0x2e76
}
 1f0:	Address 0x1f0 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
    la gp, __global_pointer$
   0:	0021                	.insn	2, 0x0021
   2:	0000                	.insn	2, 0x
   4:	0005                	.insn	2, 0x0005
   6:	0401                	.insn	2, 0x0401
    la a4, _sdata_load$
   8:	0000                	.insn	2, 0x
   a:	0000                	.insn	2, 0x
   c:	0001                	.insn	2, 0x0001
   e:	0000                	.insn	2, 0x
    la a5, _sdata$
  10:	0000                	.insn	2, 0x
  12:	0000                	.insn	2, 0x
  14:	9c00                	.insn	2, 0x9c00
  16:	0001                	.insn	2, 0x0001
    la a6, _edata$
  18:	0000                	.insn	2, 0x
  1a:	0c00                	.insn	2, 0x0c00
  1c:	0000                	.insn	2, 0x
  1e:	2f00                	.insn	2, 0x2f00
    lw a7, 0(a4)
  20:	0000                	.insn	2, 0x
  22:	0100                	.insn	2, 0x0100
    sw a7, 0(a5)
  24:	8e80                	.insn	2, 0x8e80
  26:	0002                	.insn	2, 0x0002
    addi a5, a5, 0x04
  28:	0500                	.insn	2, 0x0500
  2a:	0100                	.insn	2, 0x0100
    addi a4, a4, 0x04
  2c:	1404                	.insn	2, 0x1404
  2e:	0000                	.insn	2, 0x
    blt a5, a6, _data_copy_loop
  30:	0c00                	.insn	2, 0x0c00
  32:	010a                	.insn	2, 0x010a
    la a4, _sbss$
  34:	0000                	.insn	2, 0x
  36:	2b1d                	.insn	2, 0x2b1d
  38:	0000                	.insn	2, 0x
  3a:	0000                	.insn	2, 0x
    la a5, _ebss$
  3c:	0000                	.insn	2, 0x
  3e:	9800                	.insn	2, 0x9800
  40:	0000                	.insn	2, 0x
  42:	a400                	.insn	2, 0xa400
    sw zero, 0(a4)
  44:	0000                	.insn	2, 0x
  46:	eb00                	.insn	2, 0xeb00
    addi a4, a4, 0x04
  48:	0000                	.insn	2, 0x
  4a:	0100                	.insn	2, 0x0100
    blt a4, a5, _bss_zero_loop
  4c:	0708                	.insn	2, 0x0708
  4e:	00000173          	.insn	4, 0x0173
    la a4, __heap_start$
  52:	0401                	.insn	2, 0x0401
  54:	00017d07          	.insn	4, 0x00017d07
    la a5, __heap_end$
  58:	0100                	.insn	2, 0x0100
  5a:	0601                	.insn	2, 0x0601
  5c:	00ac                	.insn	2, 0x00ac
  5e:	0000                	.insn	2, 0x
    sw zero, 0(a4)
  60:	4b02                	.insn	2, 0x4b02
  62:	0000                	.insn	2, 0x
    addi a4, a4, 0x04
  64:	0200                	.insn	2, 0x0200
  66:	0047182b          	.insn	4, 0x0047182b
    blt a4, a5, _heap_zero_loop
  6a:	0000                	.insn	2, 0x
    li a4, 0
  6c:	0101                	.insn	2, 0x0101
  6e:	aa08                	.insn	2, 0xaa08
    li a5, 0
  70:	0000                	.insn	2, 0x
  72:	0100                	.insn	2, 0x0100
    li a6, 0
  74:	0502                	.insn	2, 0x0502
  76:	01ad                	.insn	2, 0x01ad
    la sp, __stack_top$
  78:	0000                	.insn	2, 0x
  7a:	dd02                	.insn	2, 0xdd02
  7c:	0000                	.insn	2, 0x
  7e:	0200                	.insn	2, 0x0200
    la t0, _MSYSIE
  80:	1939                	.insn	2, 0x1939
  82:	0061                	.insn	2, 0x0061
  84:	0000                	.insn	2, 0x
  86:	0201                	.insn	2, 0x0201
    csrrw t0, mtvec, t0
  88:	0000b807          	.insn	4, 0xb807
    call main
  8c:	0100                	.insn	2, 0x0100
  8e:	0504                	.insn	2, 0x0504
    j _halt
  90:	01a4                	.insn	2, 0x01a4
  92:	0000                	.insn	2, 0x
    mret
  94:	ff02                	.insn	2, 0xff02
  96:	0000                	.insn	2, 0x
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  98:	0200                	.insn	2, 0x0200
  9a:	007b194f          	.insn	4, 0x007b194f
}
  9e:	0000                	.insn	2, 0x
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a0:	0401                	.insn	2, 0x0401
  a2:	00017807          	.insn	4, 0x00017807
}
  a6:	0100                	.insn	2, 0x0100
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a8:	0508                	.insn	2, 0x0508
  aa:	019f 0000 040d      	.insn	6, 0x040d0000019f
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b0:	6905                	.insn	2, 0x6905
  b2:	746e                	.insn	2, 0x746e
}
  b4:	0200                	.insn	2, 0x0200
  b6:	004d                	.insn	2, 0x004d
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	0000                	.insn	2, 0x
  ba:	3b131803          	lh	a6,945(t1)
}
  be:	0000                	.insn	2, 0x
  c0:	0200                	.insn	2, 0x0200
  c2:	00df 0000 2403      	.insn	6, 0x2403000000df
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  c8:	5514                	.insn	2, 0x5514
  ca:	0000                	.insn	2, 0x
}
  cc:	0200                	.insn	2, 0x0200
  ce:	0101                	.insn	2, 0x0101
  d0:	0000                	.insn	2, 0x
  d2:	6f143003          	.insn	4, 0x6f143003
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d6:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  d8:	0400                	.insn	2, 0x0400
  da:	01d9                	.insn	2, 0x01d9
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	0000                	.insn	2, 0x
  de:	01610447          	.insn	4, 0x01610447
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e2:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	0446                	.insn	2, 0x0446
  e6:	0075                	.insn	2, 0x0075
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	0000                	.insn	2, 0x
  ea:	0445                	.insn	2, 0x0445
  uint32_t cause = hal_read_csr(mcause);
  ec:	000001b7          	lui	gp,0x0
  if (cause & EXT_SYS_I0_IE)
  f0:	0444                	.insn	2, 0x0444
  f2:	000000cb          	.insn	4, 0x00cb
  f6:	00550e43          	.insn	4, 0x00550e43
    EXT_IRQ_0_HANDLER();
  fa:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I1_IE)
  fc:	4201                	.insn	2, 0x4201
  fe:	011c                	.insn	2, 0x011c
 100:	e805                	.insn	2, 0xe805
 102:	0000                	.insn	2, 0x
    EXT_IRQ_1_HANDLER();
 104:	2200                	.insn	2, 0x2200
 106:	00ec                	.insn	2, 0x00ec
  else if (cause & EXT_SYS_I2_IE)
 108:	0000                	.insn	2, 0x
 10a:	0050                	.insn	2, 0x0050
 10c:	0000                	.insn	2, 0x
 10e:	9c01                	.insn	2, 0x9c01
    EXT_IRQ_2_HANDLER();
 110:	0150                	.insn	2, 0x0150
 112:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I3_IE)
 114:	990a                	.insn	2, 0x990a
 116:	0001                	.insn	2, 0x0001
 118:	0c00                	.insn	2, 0x0c00
 11a:	00a8                	.insn	2, 0x00a8
    EXT_IRQ_3_HANDLER();
 11c:	0000                	.insn	2, 0x
 11e:	000c                	.insn	2, 0x000c
  else if (cause & EXT_SYS_I4_IE)
 120:	0000                	.insn	2, 0x
 122:	0000ec0f          	.insn	4, 0xec0f
 126:	0400                	.insn	2, 0x0400
    EXT_IRQ_4_HANDLER();
 128:	0000                	.insn	2, 0x
 12a:	1900                	.insn	2, 0x1900
  else if (cause & EXT_SYS_I5_IE)
 12c:	0001                	.insn	2, 0x0001
 12e:	0a00                	.insn	2, 0x0a00
 130:	00f9                	.insn	2, 0x00f9
 132:	0000                	.insn	2, 0x
    EXT_IRQ_5_HANDLER();
 134:	a814                	.insn	2, 0xa814
 136:	0000                	.insn	2, 0x
}
 138:	0c00                	.insn	2, 0x0c00
 13a:	0000                	.insn	2, 0x
  size >>= 8;
 13c:	0000                	.insn	2, 0x
 13e:	0000fc03          	.insn	4, 0xfc03
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 142:	d200                	.insn	2, 0xd200
 144:	0000                	.insn	2, 0x
 146:	0300                	.insn	2, 0x0300
}
 148:	0108                	.insn	2, 0x0108
 14a:	0000                	.insn	2, 0x
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	00cc                	.insn	2, 0x00cc
 14e:	0000                	.insn	2, 0x
  while (*ptr)
 150:	00011403          	lh	s0,0(sp)
 154:	c600                	.insn	2, 0xc600
 156:	0000                	.insn	2, 0x
}
 158:	0300                	.insn	2, 0x0300
 15a:	0120                	.insn	2, 0x0120
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	0000                	.insn	2, 0x
 15e:	00c0                	.insn	2, 0x00c0
 160:	0000                	.insn	2, 0x
 162:	00012c03          	lw	s8,0(sp)
 166:	ba00                	.insn	2, 0xba00
}
 168:	0000                	.insn	2, 0x
 16a:	0300                	.insn	2, 0x0300
 16c:	0138                	.insn	2, 0x0138
 16e:	0000                	.insn	2, 0x
int _close(int fd) {
 170:	00b4                	.insn	2, 0x00b4
 172:	0000                	.insn	2, 0x
 174:	0600                	.insn	2, 0x0600
 176:	00000067          	jr	zero # 0 <ROM_START_ADDRESS>
  st->st_mode = S_IFCHR;
 17a:	091c                	.insn	2, 0x091c
 17c:	0090                	.insn	2, 0x0090
 17e:	0000                	.insn	2, 0x
}
 180:	00c8                	.insn	2, 0x00c8
 182:	0000                	.insn	2, 0x
 184:	000c                	.insn	2, 0x000c
 186:	0000                	.insn	2, 0x
}
 188:	9c01                	.insn	2, 0x9c01
 18a:	0186                	.insn	2, 0x0186
 18c:	0000                	.insn	2, 0x
 18e:	00008707          	.insn	4, 0x8707
}
 192:	1c00                	.insn	2, 0x1c00
 194:	a820                	.insn	2, 0xa820
 196:	0000                	.insn	2, 0x
  while (1);
 198:	3200                	.insn	2, 0x3200
 19a:	0000                	.insn	2, 0x
}
 19c:	0b00                	.insn	2, 0x0b00
 19e:	6176                	.insn	2, 0x6176
}
 1a0:	006c                	.insn	2, 0x006c
 1a2:	0d1d                	.insn	2, 0x0d1d
 1a4:	0090                	.insn	2, 0x0090
 1a6:	0000                	.insn	2, 0x
void *_sbrk(ptrdiff_t incr) {
 1a8:	5a01                	.insn	2, 0x5a01
 1aa:	0600                	.insn	2, 0x0600
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	018a                	.insn	2, 0x018a
 1ae:	0000                	.insn	2, 0x
 1b0:	0a16                	.insn	2, 0x0a16
 1b2:	009c                	.insn	2, 0x009c
 1b4:	0000                	.insn	2, 0x
 1b6:	00b8                	.insn	2, 0x00b8
 1b8:	0000                	.insn	2, 0x
 1ba:	0010                	.insn	2, 0x0010
 1bc:	0000                	.insn	2, 0x
 1be:	9c01                	.insn	2, 0x9c01
 1c0:	000001bf 00008707 	.insn	8, 0x8707000001bf
  return ret;
 1c8:	1600                	.insn	2, 0x1600
 1ca:	a822                	.insn	2, 0xa822
    return (void *)-1;
 1cc:	0000                	.insn	2, 0x
 1ce:	4600                	.insn	2, 0x4600
}
 1d0:	0000                	.insn	2, 0x
 1d2:	1000                	.insn	2, 0x1000
}
 1d4:	6176                	.insn	2, 0x6176
 1d6:	006c                	.insn	2, 0x006c
 1d8:	1701                	.insn	2, 0x1701
 1da:	9c0e                	.insn	2, 0x9c0e
  size >>= 8;
 1dc:	0000                	.insn	2, 0x
 1de:	5a00                	.insn	2, 0x5a00
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e0:	0000                	.insn	2, 0x
 1e2:	0000                	.insn	2, 0x
 1e4:	8c06                	.insn	2, 0x8c06
 1e6:	0000                	.insn	2, 0x
 1e8:	1000                	.insn	2, 0x1000
 1ea:	a80a                	.insn	2, 0xa80a
 1ec:	0000                	.insn	2, 0x
 1ee:	b000                	.insn	2, 0xb000
 1f0:	0000                	.insn	2, 0x
 1f2:	0800                	.insn	2, 0x0800
 1f4:	0000                	.insn	2, 0x
 1f6:	0100                	.insn	2, 0x0100
  snprintf(buf, 10, "%s", msg);
 1f8:	f59c                	.insn	2, 0xf59c
 1fa:	0001                	.insn	2, 0x0001
{
 1fc:	0700                	.insn	2, 0x0700
 1fe:	00000087          	.insn	4, 0x0087
  snprintf(buf, 10, "%s", msg);
 202:	2210                	.insn	2, 0x2210
 204:	00a8                	.insn	2, 0x00a8
 206:	0000                	.insn	2, 0x
 208:	0060                	.insn	2, 0x0060
 20a:	0000                	.insn	2, 0x
 20c:	6c61760b          	.insn	4, 0x6c61760b
{
 210:	1100                	.insn	2, 0x1100
 212:	a80e                	.insn	2, 0xa80e
  snprintf(buf, 10, "%s", msg);
 214:	0000                	.insn	2, 0x
 216:	0100                	.insn	2, 0x0100
  while (1);
 218:	005a                	.insn	2, 0x005a
 21a:	9b05                	.insn	2, 0x9b05
 21c:	0000                	.insn	2, 0x
 21e:	0c00                	.insn	2, 0x0c00
 220:	00a8                	.insn	2, 0x00a8
 222:	0000                	.insn	2, 0x
 224:	0008                	.insn	2, 0x0008
 226:	0000                	.insn	2, 0x
 228:	9c01                	.insn	2, 0x9c01
 22a:	0224                	.insn	2, 0x0224
 22c:	0000                	.insn	2, 0x
 22e:	8708                	.insn	2, 0x8708
 230:	0000                	.insn	2, 0x
 232:	0c00                	.insn	2, 0x0c00
 234:	a81e                	.insn	2, 0xa81e
 236:	0000                	.insn	2, 0x
 238:	0100                	.insn	2, 0x0100
 23a:	095a                	.insn	2, 0x095a
 23c:	6176                	.insn	2, 0x6176
 23e:	006c                	.insn	2, 0x006c
 240:	2c0c                	.insn	2, 0x2c0c
 242:	0090                	.insn	2, 0x0090
 244:	0000                	.insn	2, 0x
 246:	5b01                	.insn	2, 0x5b01
 248:	0500                	.insn	2, 0x0500
 24a:	0000003b          	.insn	4, 0x003b
 24e:	a008                	.insn	2, 0xa008
 250:	0000                	.insn	2, 0x
 252:	0800                	.insn	2, 0x0800
 254:	0000                	.insn	2, 0x
 256:	0100                	.insn	2, 0x0100
 258:	539c                	.insn	2, 0x539c
 25a:	0002                	.insn	2, 0x0002
 25c:	0800                	.insn	2, 0x0800
 25e:	00000087          	.insn	4, 0x0087
 262:	1f08                	.insn	2, 0x1f08
 264:	00a8                	.insn	2, 0x00a8
 266:	0000                	.insn	2, 0x
 268:	5a01                	.insn	2, 0x5a01
 26a:	7609                	.insn	2, 0x7609
 26c:	6c61                	.insn	2, 0x6c61
 26e:	0800                	.insn	2, 0x0800
 270:	9c2e                	.insn	2, 0x9c2e
 272:	0000                	.insn	2, 0x
 274:	0100                	.insn	2, 0x0100
 276:	c905005b          	.insn	4, 0xc905005b
 27a:	0001                	.insn	2, 0x0001
 27c:	0400                	.insn	2, 0x0400
 27e:	0098                	.insn	2, 0x0098
 280:	0000                	.insn	2, 0x
 282:	0008                	.insn	2, 0x0008
 284:	0000                	.insn	2, 0x
 286:	9c01                	.insn	2, 0x9c01
 288:	0282                	.insn	2, 0x0282
 28a:	0000                	.insn	2, 0x
 28c:	8708                	.insn	2, 0x8708
 28e:	0000                	.insn	2, 0x
 290:	0400                	.insn	2, 0x0400
 292:	a81f 0000 0100      	.insn	6, 0x01000000a81f
 298:	095a                	.insn	2, 0x095a
 29a:	6176                	.insn	2, 0x6176
 29c:	006c                	.insn	2, 0x006c
 29e:	2e04                	.insn	2, 0x2e04
 2a0:	00a8                	.insn	2, 0x00a8
 2a2:	0000                	.insn	2, 0x
 2a4:	5b01                	.insn	2, 0x5b01
 2a6:	1100                	.insn	2, 0x1100
 2a8:	00d2                	.insn	2, 0x00d2
 2aa:	0000                	.insn	2, 0x
 2ac:	00d4                	.insn	2, 0x00d4
 2ae:	0000                	.insn	2, 0x
 2b0:	0004                	.insn	2, 0x0004
 2b2:	0000                	.insn	2, 0x
 2b4:	9c01                	.insn	2, 0x9c01
 2b6:	0e00                	.insn	2, 0x0e00
 2b8:	0006                	.insn	2, 0x0006
 2ba:	0500                	.insn	2, 0x0500
 2bc:	0100                	.insn	2, 0x0100
 2be:	4004                	.insn	2, 0x4004
 2c0:	0001                	.insn	2, 0x0001
 2c2:	0e00                	.insn	2, 0x0e00
 2c4:	010a                	.insn	2, 0x010a
 2c6:	0000                	.insn	2, 0x
 2c8:	aa1d                	.insn	2, 0xaa1d
 2ca:	0000                	.insn	2, 0x
 2cc:	0000                	.insn	2, 0x
 2ce:	0000                	.insn	2, 0x
 2d0:	3c00                	.insn	2, 0x3c00
 2d2:	0001                	.insn	2, 0x0001
 2d4:	b400                	.insn	2, 0xb400
 2d6:	0000                	.insn	2, 0x
 2d8:	3200                	.insn	2, 0x3200
 2da:	03000003          	lb	zero,48(zero) # 30 <_data_copy_loop+0x10>
 2de:	0708                	.insn	2, 0x0708
 2e0:	00000173          	.insn	4, 0x0173
 2e4:	7d070403          	lb	s0,2000(a4)
 2e8:	0001                	.insn	2, 0x0001
 2ea:	0300                	.insn	2, 0x0300
 2ec:	0601                	.insn	2, 0x0601
 2ee:	00ac                	.insn	2, 0x00ac
 2f0:	0000                	.insn	2, 0x
 2f2:	4b01                	.insn	2, 0x4b01
 2f4:	0000                	.insn	2, 0x
 2f6:	0200                	.insn	2, 0x0200
 2f8:	0047182b          	.insn	4, 0x0047182b
 2fc:	0000                	.insn	2, 0x
 2fe:	aa080103          	lb	sp,-1376(a6)
 302:	0000                	.insn	2, 0x
 304:	0300                	.insn	2, 0x0300
 306:	0502                	.insn	2, 0x0502
 308:	01ad                	.insn	2, 0x01ad
 30a:	0000                	.insn	2, 0x
 30c:	b8070203          	lb	tp,-1152(a4)
 310:	0000                	.insn	2, 0x
 312:	0300                	.insn	2, 0x0300
 314:	0504                	.insn	2, 0x0504
 316:	01a4                	.insn	2, 0x01a4
 318:	0000                	.insn	2, 0x
 31a:	ff01                	.insn	2, 0xff01
 31c:	0000                	.insn	2, 0x
 31e:	0200                	.insn	2, 0x0200
 320:	006f194f          	.insn	4, 0x006f194f
 324:	0000                	.insn	2, 0x
 326:	78070403          	lb	s0,1920(a4)
 32a:	0001                	.insn	2, 0x0001
 32c:	0300                	.insn	2, 0x0300
 32e:	0508                	.insn	2, 0x0508
 330:	019f 0000 1401      	.insn	6, 0x14010000019f
 336:	0002                	.insn	2, 0x0002
 338:	0200                	.insn	2, 0x0200
 33a:	1ec8                	.insn	2, 0x1ec8
 33c:	0076                	.insn	2, 0x0076
 33e:	0000                	.insn	2, 0x
 340:	6905040f          	.insn	4, 0x6905040f
 344:	746e                	.insn	2, 0x746e
 346:	0100                	.insn	2, 0x0100
 348:	000002cf          	.insn	4, 0x02cf
 34c:	891a9103          	lh	sp,-1903(s5)
 350:	0000                	.insn	2, 0x
 352:	0100                	.insn	2, 0x0100
 354:	0308                	.insn	2, 0x0308
 356:	0000                	.insn	2, 0x
 358:	2d17d603          	lhu	a2,721(a5)
 35c:	0000                	.insn	2, 0x
 35e:	0100                	.insn	2, 0x0100
 360:	024a                	.insn	2, 0x024a
 362:	0000                	.insn	2, 0x
 364:	1e04                	.insn	2, 0x1e04
 366:	5c0e                	.insn	2, 0x5c0e
 368:	0000                	.insn	2, 0x
 36a:	0100                	.insn	2, 0x0100
 36c:	00000303          	lb	t1,0(zero) # 0 <ROM_START_ADDRESS>
 370:	2204                	.insn	2, 0x2204
 372:	5c0e                	.insn	2, 0x5c0e
 374:	0000                	.insn	2, 0x
 376:	0100                	.insn	2, 0x0100
 378:	01ec                	.insn	2, 0x01ec
 37a:	0000                	.insn	2, 0x
 37c:	2e04                	.insn	2, 0x2e04
 37e:	5c0e                	.insn	2, 0x5c0e
 380:	0000                	.insn	2, 0x
 382:	0100                	.insn	2, 0x0100
 384:	027f 0000 3804 4e0f 	.insn	10, 0x4e0f38040000027f
 38c:	0000 
 38e:	0100                	.insn	2, 0x0100
 390:	035e                	.insn	2, 0x035e
 392:	0000                	.insn	2, 0x
 394:	3c04                	.insn	2, 0x3c04
 396:	5518                	.insn	2, 0x5518
 398:	0000                	.insn	2, 0x
 39a:	0100                	.insn	2, 0x0100
 39c:	000001f3          	.insn	4, 0x01f3
 3a0:	3f04                	.insn	2, 0x3f04
 3a2:	5518                	.insn	2, 0x5518
 3a4:	0000                	.insn	2, 0x
 3a6:	0100                	.insn	2, 0x0100
 3a8:	0340                	.insn	2, 0x0340
 3aa:	0000                	.insn	2, 0x
 3ac:	4b04                	.insn	2, 0x4b04
 3ae:	5518                	.insn	2, 0x5518
 3b0:	0000                	.insn	2, 0x
 3b2:	0100                	.insn	2, 0x0100
 3b4:	0231                	.insn	2, 0x0231
 3b6:	0000                	.insn	2, 0x
 3b8:	5a04                	.insn	2, 0x5a04
 3ba:	6314                	.insn	2, 0x6314
 3bc:	0000                	.insn	2, 0x
 3be:	0100                	.insn	2, 0x0100
 3c0:	000001eb          	.insn	4, 0x01eb
 3c4:	6604                	.insn	2, 0x6604
 3c6:	c010                	.insn	2, 0xc010
 3c8:	0000                	.insn	2, 0x
 3ca:	0100                	.insn	2, 0x0100
 3cc:	0000038b          	.insn	4, 0x038b
 3d0:	9304                	.insn	2, 0x9304
 3d2:	00008917          	auipc	s2,0x8
 3d6:	1000                	.insn	2, 0x1000
 3d8:	0104                	.insn	2, 0x0104
 3da:	02b5                	.insn	2, 0x02b5
 3dc:	0000                	.insn	2, 0x
 3de:	d504                	.insn	2, 0xd504
 3e0:	5518                	.insn	2, 0x5518
 3e2:	0000                	.insn	2, 0x
 3e4:	0100                	.insn	2, 0x0100
 3e6:	004d                	.insn	2, 0x004d
 3e8:	0000                	.insn	2, 0x
 3ea:	1805                	.insn	2, 0x1805
 3ec:	00003b13          	sltiu	s6,zero,0
 3f0:	0100                	.insn	2, 0x0100
 3f2:	0000030f          	.insn	4, 0x030f
 3f6:	2a06                	.insn	2, 0x2a06
 3f8:	7d12                	.insn	2, 0x7d12
 3fa:	0000                	.insn	2, 0x
 3fc:	0800                	.insn	2, 0x0800
 3fe:	00000337          	lui	t1,0x0
 402:	0710                	.insn	2, 0x0710
 404:	016e082f          	.insn	4, 0x016e082f
 408:	0000                	.insn	2, 0x
 40a:	fc02                	.insn	2, 0xfc02
 40c:	0002                	.insn	2, 0x0002
 40e:	0700                	.insn	2, 0x0700
 410:	0930                	.insn	2, 0x0930
 412:	013a                	.insn	2, 0x013a
 414:	0000                	.insn	2, 0x
 416:	0200                	.insn	2, 0x0200
 418:	02e8                	.insn	2, 0x02e8
 41a:	0000                	.insn	2, 0x
 41c:	5c073107          	.insn	4, 0x5c073107
 420:	0000                	.insn	2, 0x
 422:	0800                	.insn	2, 0x0800
 424:	0100                	.insn	2, 0x0100
 426:	024c                	.insn	2, 0x024c
 428:	0000                	.insn	2, 0x
 42a:	6108                	.insn	2, 0x6108
 42c:	a814                	.insn	2, 0xa814
 42e:	0000                	.insn	2, 0x
 430:	0100                	.insn	2, 0x0100
 432:	0305                	.insn	2, 0x0305
 434:	0000                	.insn	2, 0x
 436:	6608                	.insn	2, 0x6608
 438:	b415                	.insn	2, 0xb415
 43a:	0000                	.insn	2, 0x
 43c:	0700                	.insn	2, 0x0700
 43e:	0000018b          	.insn	4, 0x018b
 442:	b3080103          	lb	sp,-1232(a6)
 446:	0000                	.insn	2, 0x
 448:	1100                	.insn	2, 0x1100
 44a:	0000018b          	.insn	4, 0x018b
 44e:	4201                	.insn	2, 0x4201
 450:	08000003          	lb	zero,128(zero) # 80 <_heap_zero_loop+0x20>
 454:	1289                	.insn	2, 0x1289
 456:	00f0                	.insn	2, 0x00f0
 458:	0000                	.insn	2, 0x
 45a:	ed01                	.insn	2, 0xed01
 45c:	0001                	.insn	2, 0x0001
 45e:	0800                	.insn	2, 0x0800
 460:	0108129b          	.insn	4, 0x0108129b
 464:	0000                	.insn	2, 0x
 466:	8101                	.insn	2, 0x8101
 468:	0002                	.insn	2, 0x0002
 46a:	0800                	.insn	2, 0x0800
 46c:	129f 00cc 0000      	.insn	6, 0x00cc129f
 472:	6001                	.insn	2, 0x6001
 474:	08000003          	lb	zero,128(zero) # 80 <_heap_zero_loop+0x20>
 478:	00d812a3          	sh	a3,5(a6)
 47c:	0000                	.insn	2, 0x
 47e:	f501                	.insn	2, 0xf501
 480:	0001                	.insn	2, 0x0001
 482:	0800                	.insn	2, 0x0800
 484:	00e412a7          	.insn	4, 0x00e412a7
 488:	0000                	.insn	2, 0x
 48a:	8c01                	.insn	2, 0x8c01
 48c:	08000003          	lb	zero,128(zero) # 80 <_heap_zero_loop+0x20>
 490:	12b6                	.insn	2, 0x12b6
 492:	0114                	.insn	2, 0x0114
 494:	0000                	.insn	2, 0x
 496:	3301                	.insn	2, 0x3301
 498:	0002                	.insn	2, 0x0002
 49a:	0800                	.insn	2, 0x0800
 49c:	00fc12bb          	.insn	4, 0x00fc12bb
 4a0:	0000                	.insn	2, 0x
 4a2:	b701                	.insn	2, 0xb701
 4a4:	0002                	.insn	2, 0x0002
 4a6:	0800                	.insn	2, 0x0800
 4a8:	13c0                	.insn	2, 0x13c0
 4aa:	0122                	.insn	2, 0x0122
 4ac:	0000                	.insn	2, 0x
 4ae:	f0041003          	lh	zero,-256(s0)
 4b2:	0002                	.insn	2, 0x0002
 4b4:	0700                	.insn	2, 0x0700
 4b6:	0192                	.insn	2, 0x0192
 4b8:	0000                	.insn	2, 0x
 4ba:	6408                	.insn	2, 0x6408
 4bc:	0002                	.insn	2, 0x0002
 4be:	5800                	.insn	2, 0x5800
 4c0:	1b09                	.insn	2, 0x1b09
 4c2:	c708                	.insn	2, 0xc708
 4c4:	0002                	.insn	2, 0x0002
 4c6:	0200                	.insn	2, 0x0200
 4c8:	037a                	.insn	2, 0x037a
 4ca:	0000                	.insn	2, 0x
 4cc:	1d09                	.insn	2, 0x1d09
 4ce:	af0a                	.insn	2, 0xaf0a
 4d0:	0001                	.insn	2, 0x0001
 4d2:	0000                	.insn	2, 0x
 4d4:	2a02                	.insn	2, 0x2a02
 4d6:	0002                	.insn	2, 0x0002
 4d8:	0900                	.insn	2, 0x0900
 4da:	0a1e                	.insn	2, 0x0a1e
 4dc:	00000197          	auipc	gp,0x0
 4e0:	0202                	.insn	2, 0x0202
 4e2:	02e0                	.insn	2, 0x02e0
 4e4:	0000                	.insn	2, 0x
 4e6:	1f09                	.insn	2, 0x1f09
 4e8:	df0a                	.insn	2, 0xdf0a
 4ea:	0001                	.insn	2, 0x0001
 4ec:	0400                	.insn	2, 0x0400
 4ee:	1c02                	.insn	2, 0x1c02
 4f0:	09000003          	lb	zero,144(zero) # 90 <_halt>
 4f4:	0b20                	.insn	2, 0x0b20
 4f6:	000001eb          	.insn	4, 0x01eb
 4fa:	0208                	.insn	2, 0x0208
 4fc:	00000287          	.insn	4, 0x0287
 500:	2109                	.insn	2, 0x2109
 502:	bb0a                	.insn	2, 0xbb0a
 504:	0001                	.insn	2, 0x0001
 506:	0a00                	.insn	2, 0x0a00
 508:	6c02                	.insn	2, 0x6c02
 50a:	09000003          	lb	zero,144(zero) # 90 <_halt>
 50e:	0a22                	.insn	2, 0x0a22
 510:	000001c7          	.insn	4, 0x01c7
 514:	020c                	.insn	2, 0x020c
 516:	0356                	.insn	2, 0x0356
 518:	0000                	.insn	2, 0x
 51a:	2309                	.insn	2, 0x2309
 51c:	af0a                	.insn	2, 0xaf0a
 51e:	0001                	.insn	2, 0x0001
 520:	0e00                	.insn	2, 0x0e00
 522:	c702                	.insn	2, 0xc702
 524:	0002                	.insn	2, 0x0002
 526:	0900                	.insn	2, 0x0900
 528:	0a24                	.insn	2, 0x0a24
 52a:	000001a3          	sb	zero,3(zero) # 3 <ROM_START_ADDRESS+0x3>
 52e:	0210                	.insn	2, 0x0210
 530:	0271                	.insn	2, 0x0271
 532:	0000                	.insn	2, 0x
 534:	2a09                	.insn	2, 0x2a09
 536:	00014613          	xor	a2,sp,0
 53a:	1800                	.insn	2, 0x1800
 53c:	9402                	.insn	2, 0x9402
 53e:	09000003          	lb	zero,144(zero) # 90 <_halt>
 542:	0146132b          	.insn	4, 0x0146132b
 546:	0000                	.insn	2, 0x
 548:	0228                	.insn	2, 0x0228
 54a:	000001fb          	.insn	4, 0x01fb
 54e:	2c09                	.insn	2, 0x2c09
 550:	00014613          	xor	a2,sp,0
 554:	3800                	.insn	2, 0x3800
 556:	2502                	.insn	2, 0x2502
 558:	09000003          	lb	zero,144(zero) # 90 <_halt>
 55c:	112d                	.insn	2, 0x112d
 55e:	017a                	.insn	2, 0x017a
 560:	0000                	.insn	2, 0x
 562:	0248                	.insn	2, 0x0248
 564:	020a                	.insn	2, 0x020a
 566:	0000                	.insn	2, 0x
 568:	2e09                	.insn	2, 0x2e09
 56a:	6e0c                	.insn	2, 0x6e0c
 56c:	0001                	.insn	2, 0x0001
 56e:	4c00                	.insn	2, 0x4c00
 570:	8e02                	.insn	2, 0x8e02
 572:	0002                	.insn	2, 0x0002
 574:	0900                	.insn	2, 0x0900
 576:	0930                	.insn	2, 0x0930
 578:	000002c7          	.insn	4, 0x02c7
 57c:	0050                	.insn	2, 0x0050
 57e:	5c12                	.insn	2, 0x5c12
 580:	0000                	.insn	2, 0x
 582:	d700                	.insn	2, 0xd700
 584:	0002                	.insn	2, 0x0002
 586:	1300                	.insn	2, 0x1300
 588:	002d                	.insn	2, 0x002d
 58a:	0000                	.insn	2, 0x
 58c:	0001                	.insn	2, 0x0001
 58e:	3a08                	.insn	2, 0x3a08
 590:	0002                	.insn	2, 0x0002
 592:	0100                	.insn	2, 0x0100
 594:	100a                	.insn	2, 0x100a
 596:	f210                	.insn	2, 0xf210
 598:	0002                	.insn	2, 0x0002
 59a:	0200                	.insn	2, 0x0200
 59c:	02b0                	.insn	2, 0x02b0
 59e:	0000                	.insn	2, 0x
 5a0:	110a                	.insn	2, 0x110a
 5a2:	00012e0b          	.insn	4, 0x00012e0b
 5a6:	0000                	.insn	2, 0x
 5a8:	0100                	.insn	2, 0x0100
 5aa:	023a                	.insn	2, 0x023a
 5ac:	0000                	.insn	2, 0x
 5ae:	120a                	.insn	2, 0x120a
 5b0:	0002d703          	lhu	a4,0(t0)
 5b4:	0500                	.insn	2, 0x0500
 5b6:	02d9                	.insn	2, 0x02d9
 5b8:	0000                	.insn	2, 0x
 5ba:	0550                	.insn	2, 0x0550
 5bc:	0089                	.insn	2, 0x0089
 5be:	0000                	.insn	2, 0x
 5c0:	01dc                	.insn	2, 0x01dc
 5c2:	0000                	.insn	2, 0x
 5c4:	0014                	.insn	2, 0x0014
 5c6:	0000                	.insn	2, 0x
 5c8:	9c01                	.insn	2, 0x9c01
 5ca:	0365                	.insn	2, 0x0365
 5cc:	0000                	.insn	2, 0x
 5ce:	6604                	.insn	2, 0x6604
 5d0:	0064                	.insn	2, 0x0064
 5d2:	1050                	.insn	2, 0x1050
 5d4:	0089                	.insn	2, 0x0089
 5d6:	0000                	.insn	2, 0x
 5d8:	0080                	.insn	2, 0x0080
 5da:	0000                	.insn	2, 0x
 5dc:	7004                	.insn	2, 0x7004
 5de:	7274                	.insn	2, 0x7274
 5e0:	5000                	.insn	2, 0x5000
 5e2:	6520                	.insn	2, 0x6520
 5e4:	98000003          	lb	zero,-1664(zero) # fffff980 <__stack_top$+0xdfffbc20>
 5e8:	0000                	.insn	2, 0x
 5ea:	0600                	.insn	2, 0x0600
 5ec:	656c                	.insn	2, 0x656c
 5ee:	006e                	.insn	2, 0x006e
 5f0:	2d50                	.insn	2, 0x2d50
 5f2:	000001d3          	.insn	4, 0x01d3
 5f6:	5c01                	.insn	2, 0x5c01
 5f8:	ad14                	.insn	2, 0xad14
 5fa:	0005                	.insn	2, 0x0005
 5fc:	dc00                	.insn	2, 0xdc00
 5fe:	0001                	.insn	2, 0x0001
 600:	0c00                	.insn	2, 0x0c00
 602:	0000                	.insn	2, 0x
 604:	0100                	.insn	2, 0x0100
 606:	0352                	.insn	2, 0x0352
 608:	ba09                	.insn	2, 0xba09
 60a:	0005                	.insn	2, 0x0005
 60c:	b000                	.insn	2, 0xb000
 60e:	0000                	.insn	2, 0x
 610:	0d00                	.insn	2, 0x0d00
 612:	05c5                	.insn	2, 0x05c5
 614:	0000                	.insn	2, 0x
 616:	00c8                	.insn	2, 0x00c8
 618:	0000                	.insn	2, 0x
 61a:	0000                	.insn	2, 0x
 61c:	00036a07          	.insn	4, 0x00036a07
 620:	1500                	.insn	2, 0x1500
 622:	1605                	.insn	2, 0x1605
 624:	4b000003          	lb	zero,1200(zero) # 4b0 <HEAP_SIZE+0xb0>
 628:	8905                	.insn	2, 0x8905
 62a:	0000                	.insn	2, 0x
 62c:	d400                	.insn	2, 0xd400
 62e:	0001                	.insn	2, 0x0001
 630:	0800                	.insn	2, 0x0800
 632:	0000                	.insn	2, 0x
 634:	0100                	.insn	2, 0x0100
 636:	ba9c                	.insn	2, 0xba9c
 638:	04000003          	lb	zero,64(zero) # 40 <_data_copy_loop+0x20>
 63c:	6466                	.insn	2, 0x6466
 63e:	4b00                	.insn	2, 0x4b00
 640:	8910                	.insn	2, 0x8910
 642:	0000                	.insn	2, 0x
 644:	db00                	.insn	2, 0xdb00
 646:	0000                	.insn	2, 0x
 648:	0600                	.insn	2, 0x0600
 64a:	7562                	.insn	2, 0x7562
 64c:	0066                	.insn	2, 0x0066
 64e:	01861a4b          	.insn	4, 0x01861a4b
 652:	0000                	.insn	2, 0x
 654:	5b01                	.insn	2, 0x5b01
 656:	790a                	.insn	2, 0x790a
 658:	0002                	.insn	2, 0x0002
 65a:	4b00                	.insn	2, 0x4b00
 65c:	00008923          	sb	zero,18(ra)
 660:	0100                	.insn	2, 0x0100
 662:	165c                	.insn	2, 0x165c
 664:	00000317          	auipc	t1,0x0
 668:	4c01                	.insn	2, 0x4c01
 66a:	00008907          	.insn	4, 0x8907
 66e:	0000                	.insn	2, 0x
 670:	0500                	.insn	2, 0x0500
 672:	03a1                	.insn	2, 0x03a1
 674:	0000                	.insn	2, 0x
 676:	0120073b          	.insn	4, 0x0120073b
 67a:	0000                	.insn	2, 0x
 67c:	01a8                	.insn	2, 0x01a8
 67e:	0000                	.insn	2, 0x
 680:	002c                	.insn	2, 0x002c
 682:	0000                	.insn	2, 0x
 684:	9c01                	.insn	2, 0x9c01
 686:	0424                	.insn	2, 0x0424
 688:	0000                	.insn	2, 0x
 68a:	00039c17          	auipc	s8,0x39
 68e:	0100                	.insn	2, 0x0100
 690:	0090173b          	.insn	4, 0x0090173b
 694:	0000                	.insn	2, 0x
 696:	000000f3          	.insn	4, 0x00f3
 69a:	0003300b          	.insn	4, 0x0003300b
 69e:	3c00                	.insn	2, 0x3c00
 6a0:	0000018b          	.insn	4, 0x018b
 6a4:	0003480b          	.insn	4, 0x0003480b
 6a8:	3d00                	.insn	2, 0x3d00
 6aa:	0000018b          	.insn	4, 0x018b
 6ae:	0002a40b          	.insn	4, 0x0002a40b
 6b2:	3e00                	.insn	2, 0x3e00
 6b4:	0000018b          	.insn	4, 0x018b
 6b8:	0318                	.insn	2, 0x0318
 6ba:	0002                	.insn	2, 0x0002
 6bc:	0100                	.insn	2, 0x0100
 6be:	0186113f 03050000 	.insn	8, 0x030500000186113f
 6c6:	00b4                	.insn	2, 0x00b4
 6c8:	2000                	.insn	2, 0x2000
 6ca:	7219                	.insn	2, 0x7219
 6cc:	7465                	.insn	2, 0x7465
 6ce:	0100                	.insn	2, 0x0100
 6d0:	0a40                	.insn	2, 0x0a40
 6d2:	0186                	.insn	2, 0x0186
 6d4:	0000                	.insn	2, 0x
 6d6:	0000010f          	.insn	4, 0x010f
 6da:	1a00                	.insn	2, 0x1a00
 6dc:	0269                	.insn	2, 0x0269
 6de:	0000                	.insn	2, 0x
 6e0:	3701                	.insn	2, 0x3701
 6e2:	8905                	.insn	2, 0x8905
 6e4:	0000                	.insn	2, 0x
 6e6:	a000                	.insn	2, 0xa000
 6e8:	0001                	.insn	2, 0x0001
 6ea:	0800                	.insn	2, 0x0800
 6ec:	0000                	.insn	2, 0x
 6ee:	0100                	.insn	2, 0x0100
 6f0:	1b9c                	.insn	2, 0x1b9c
 6f2:	0366                	.insn	2, 0x0366
 6f4:	0000                	.insn	2, 0x
 6f6:	3301                	.insn	2, 0x3301
 6f8:	9c06                	.insn	2, 0x9c06
 6fa:	0001                	.insn	2, 0x0001
 6fc:	0400                	.insn	2, 0x0400
 6fe:	0000                	.insn	2, 0x
 700:	0100                	.insn	2, 0x0100
 702:	6b9c                	.insn	2, 0x6b9c
 704:	0004                	.insn	2, 0x0004
 706:	0600                	.insn	2, 0x0600
 708:	6970                	.insn	2, 0x6970
 70a:	0064                	.insn	2, 0x0064
 70c:	00891033          	sll	zero,s2,s0
 710:	0000                	.insn	2, 0x
 712:	5a01                	.insn	2, 0x5a01
 714:	7306                	.insn	2, 0x7306
 716:	6769                	.insn	2, 0x6769
 718:	3300                	.insn	2, 0x3300
 71a:	8919                	.insn	2, 0x8919
 71c:	0000                	.insn	2, 0x
 71e:	0100                	.insn	2, 0x0100
 720:	241c005b          	.insn	4, 0x241c005b
 724:	0002                	.insn	2, 0x0002
 726:	0b00                	.insn	2, 0x0b00
 728:	0612                	.insn	2, 0x0612
 72a:	0198                	.insn	2, 0x0198
 72c:	0000                	.insn	2, 0x
 72e:	0004                	.insn	2, 0x0004
 730:	0000                	.insn	2, 0x
 732:	9c01                	.insn	2, 0x9c01
 734:	0000048f          	.insn	4, 0x048f
 738:	730a                	.insn	2, 0x730a
 73a:	2f000003          	lb	zero,752(zero) # 2f0 <sniprintf+0x20>
 73e:	8910                	.insn	2, 0x8910
 740:	0000                	.insn	2, 0x
 742:	0100                	.insn	2, 0x0100
 744:	005a                	.insn	2, 0x005a
 746:	5b05                	.insn	2, 0x5b05
 748:	0002                	.insn	2, 0x0002
 74a:	2b00                	.insn	2, 0x2b00
 74c:	8905                	.insn	2, 0x8905
 74e:	0000                	.insn	2, 0x
 750:	9000                	.insn	2, 0x9000
 752:	0001                	.insn	2, 0x0001
 754:	0800                	.insn	2, 0x0800
 756:	0000                	.insn	2, 0x
 758:	0100                	.insn	2, 0x0100
 75a:	d19c                	.insn	2, 0xd19c
 75c:	0004                	.insn	2, 0x0004
 75e:	0400                	.insn	2, 0x0400
 760:	6466                	.insn	2, 0x6466
 762:	2b00                	.insn	2, 0x2b00
 764:	8910                	.insn	2, 0x8910
 766:	0000                	.insn	2, 0x
 768:	2600                	.insn	2, 0x2600
 76a:	0001                	.insn	2, 0x0001
 76c:	0600                	.insn	2, 0x0600
 76e:	7470                	.insn	2, 0x7470
 770:	0072                	.insn	2, 0x0072
 772:	0089182b          	.insn	4, 0x0089182b
 776:	0000                	.insn	2, 0x
 778:	5b01                	.insn	2, 0x5b01
 77a:	6406                	.insn	2, 0x6406
 77c:	7269                	.insn	2, 0x7269
 77e:	2b00                	.insn	2, 0x2b00
 780:	8921                	.insn	2, 0x8921
 782:	0000                	.insn	2, 0x
 784:	0100                	.insn	2, 0x0100
 786:	005c                	.insn	2, 0x005c
 788:	bf05                	.insn	2, 0xbf05
 78a:	0002                	.insn	2, 0x0002
 78c:	2700                	.insn	2, 0x2700
 78e:	8905                	.insn	2, 0x8905
 790:	0000                	.insn	2, 0x
 792:	8800                	.insn	2, 0x8800
 794:	0001                	.insn	2, 0x0001
 796:	0800                	.insn	2, 0x0800
 798:	0000                	.insn	2, 0x
 79a:	0100                	.insn	2, 0x0100
 79c:	f99c                	.insn	2, 0xf99c
 79e:	0004                	.insn	2, 0x0004
 7a0:	0400                	.insn	2, 0x0400
 7a2:	6466                	.insn	2, 0x6466
 7a4:	2700                	.insn	2, 0x2700
 7a6:	8911                	.insn	2, 0x8911
 7a8:	0000                	.insn	2, 0x
 7aa:	3a00                	.insn	2, 0x3a00
 7ac:	0001                	.insn	2, 0x0001
 7ae:	0000                	.insn	2, 0x
 7b0:	6205                	.insn	2, 0x6205
 7b2:	0002                	.insn	2, 0x0002
 7b4:	2200                	.insn	2, 0x2200
 7b6:	8905                	.insn	2, 0x8905
 7b8:	0000                	.insn	2, 0x
 7ba:	7800                	.insn	2, 0x7800
 7bc:	0001                	.insn	2, 0x0001
 7be:	1000                	.insn	2, 0x1000
 7c0:	0000                	.insn	2, 0x
 7c2:	0100                	.insn	2, 0x0100
 7c4:	2d9c                	.insn	2, 0x2d9c
 7c6:	0005                	.insn	2, 0x0005
 7c8:	0400                	.insn	2, 0x0400
 7ca:	6466                	.insn	2, 0x6466
 7cc:	2200                	.insn	2, 0x2200
 7ce:	8910                	.insn	2, 0x8910
 7d0:	0000                	.insn	2, 0x
 7d2:	4e00                	.insn	2, 0x4e00
 7d4:	0001                	.insn	2, 0x0001
 7d6:	0600                	.insn	2, 0x0600
 7d8:	22007473          	.insn	4, 0x22007473
 7dc:	2d21                	.insn	2, 0x2d21
 7de:	0005                	.insn	2, 0x0005
 7e0:	0100                	.insn	2, 0x0100
 7e2:	0307005b          	.insn	4, 0x0307005b
 7e6:	0002                	.insn	2, 0x0002
 7e8:	1d00                	.insn	2, 0x1d00
 7ea:	0298                	.insn	2, 0x0298
 7ec:	0000                	.insn	2, 0x
 7ee:	1e01                	.insn	2, 0x1e01
 7f0:	8905                	.insn	2, 0x8905
 7f2:	0000                	.insn	2, 0x
 7f4:	4d00                	.insn	2, 0x4d00
 7f6:	0005                	.insn	2, 0x0005
 7f8:	0c00                	.insn	2, 0x0c00
 7fa:	6466                	.insn	2, 0x6466
 7fc:	1e00                	.insn	2, 0x1e00
 7fe:	8910                	.insn	2, 0x8910
 800:	0000                	.insn	2, 0x
 802:	0000                	.insn	2, 0x
 804:	551e                	.insn	2, 0x551e
 806:	0002                	.insn	2, 0x0002
 808:	0100                	.insn	2, 0x0100
 80a:	051a                	.insn	2, 0x051a
 80c:	0089                	.insn	2, 0x0089
 80e:	0000                	.insn	2, 0x
 810:	6901                	.insn	2, 0x6901
 812:	0005                	.insn	2, 0x0005
 814:	0c00                	.insn	2, 0x0c00
 816:	6466                	.insn	2, 0x6466
 818:	1a00                	.insn	2, 0x1a00
 81a:	0000890f          	.insn	4, 0x890f
 81e:	0000                	.insn	2, 0x
 820:	9f05                	.insn	2, 0x9f05
 822:	0002                	.insn	2, 0x0002
 824:	1500                	.insn	2, 0x1500
 826:	8905                	.insn	2, 0x8905
 828:	0000                	.insn	2, 0x
 82a:	4c00                	.insn	2, 0x4c00
 82c:	0001                	.insn	2, 0x0001
 82e:	1c00                	.insn	2, 0x1c00
 830:	0000                	.insn	2, 0x
 832:	0100                	.insn	2, 0x0100
 834:	ad9c                	.insn	2, 0xad9c
 836:	0005                	.insn	2, 0x0005
 838:	0400                	.insn	2, 0x0400
 83a:	6466                	.insn	2, 0x6466
 83c:	1500                	.insn	2, 0x1500
 83e:	890e                	.insn	2, 0x890e
 840:	0000                	.insn	2, 0x
 842:	6200                	.insn	2, 0x6200
 844:	0001                	.insn	2, 0x0001
 846:	0400                	.insn	2, 0x0400
 848:	7470                	.insn	2, 0x7470
 84a:	0072                	.insn	2, 0x0072
 84c:	1e15                	.insn	2, 0x1e15
 84e:	01fe                	.insn	2, 0x01fe
 850:	0000                	.insn	2, 0x
 852:	0000017b          	.insn	4, 0x017b
 856:	ca0a                	.insn	2, 0xca0a
 858:	0002                	.insn	2, 0x0002
 85a:	1500                	.insn	2, 0x1500
 85c:	9c2a                	.insn	2, 0x9c2a
 85e:	0000                	.insn	2, 0x
 860:	0100                	.insn	2, 0x0100
 862:	005c                	.insn	2, 0x005c
 864:	811f 0003 0100      	.insn	6, 0x01000003811f
 86a:	060a                	.insn	2, 0x060a
 86c:	d201                	.insn	2, 0xd201
 86e:	0005                	.insn	2, 0x0005
 870:	0c00                	.insn	2, 0x0c00
 872:	656c                	.insn	2, 0x656c
 874:	006e                	.insn	2, 0x006e
 876:	170a                	.insn	2, 0x170a
 878:	009c                	.insn	2, 0x009c
 87a:	0000                	.insn	2, 0x
 87c:	ca20                	.insn	2, 0xca20
 87e:	0002                	.insn	2, 0x0002
 880:	0100                	.insn	2, 0x0100
 882:	009c0a0b          	.insn	4, 0x009c0a0b
 886:	0000                	.insn	2, 0x
 888:	2100                	.insn	2, 0x2100
 88a:	05ad                	.insn	2, 0x05ad
 88c:	0000                	.insn	2, 0x
 88e:	013c                	.insn	2, 0x013c
 890:	0000                	.insn	2, 0x
 892:	0010                	.insn	2, 0x0010
 894:	0000                	.insn	2, 0x
 896:	9c01                	.insn	2, 0x9c01
 898:	05f8                	.insn	2, 0x05f8
 89a:	0000                	.insn	2, 0x
 89c:	ba09                	.insn	2, 0xba09
 89e:	0005                	.insn	2, 0x0005
 8a0:	8600                	.insn	2, 0x8600
 8a2:	0001                	.insn	2, 0x0001
 8a4:	0d00                	.insn	2, 0x0d00
 8a6:	05c5                	.insn	2, 0x05c5
 8a8:	0000                	.insn	2, 0x
 8aa:	019a                	.insn	2, 0x019a
 8ac:	0000                	.insn	2, 0x
 8ae:	2200                	.insn	2, 0x2200
 8b0:	054d                	.insn	2, 0x054d
 8b2:	0000                	.insn	2, 0x
 8b4:	0168                	.insn	2, 0x0168
 8b6:	0000                	.insn	2, 0x
 8b8:	0008                	.insn	2, 0x0008
 8ba:	0000                	.insn	2, 0x
 8bc:	9c01                	.insn	2, 0x9c01
 8be:	5e09                	.insn	2, 0x5e09
 8c0:	0005                	.insn	2, 0x0005
 8c2:	a900                	.insn	2, 0xa900
 8c4:	0001                	.insn	2, 0x0001
 8c6:	0000                	.insn	2, 0x
 8c8:	eb00                	.insn	2, 0xeb00
 8ca:	0002                	.insn	2, 0x0002
 8cc:	0500                	.insn	2, 0x0500
 8ce:	0100                	.insn	2, 0x0100
 8d0:	6e04                	.insn	2, 0x6e04
 8d2:	11000003          	lb	zero,272(zero) # 110 <BASE_IRQ_HANDLER+0x24>
 8d6:	010a                	.insn	2, 0x010a
 8d8:	0000                	.insn	2, 0x
 8da:	2e1d                	.insn	2, 0x2e1d
 8dc:	0001                	.insn	2, 0x0001
 8de:	0000                	.insn	2, 0x
 8e0:	0000                	.insn	2, 0x
 8e2:	0c00                	.insn	2, 0x0c00
 8e4:	0000                	.insn	2, 0x
 8e6:	0000                	.insn	2, 0x
 8e8:	0000                	.insn	2, 0x
 8ea:	5100                	.insn	2, 0x5100
 8ec:	0006                	.insn	2, 0x0006
 8ee:	0100                	.insn	2, 0x0100
 8f0:	0708                	.insn	2, 0x0708
 8f2:	00000173          	.insn	4, 0x0173
 8f6:	0101                	.insn	2, 0x0101
 8f8:	aa08                	.insn	2, 0xaa08
 8fa:	0000                	.insn	2, 0x
 8fc:	0100                	.insn	2, 0x0100
 8fe:	0601                	.insn	2, 0x0601
 900:	00ac                	.insn	2, 0x00ac
 902:	0000                	.insn	2, 0x
 904:	4b02                	.insn	2, 0x4b02
 906:	0000                	.insn	2, 0x
 908:	0200                	.insn	2, 0x0200
 90a:	002d182b          	.insn	4, 0x002d182b
 90e:	0000                	.insn	2, 0x
 910:	0201                	.insn	2, 0x0201
 912:	ad05                	.insn	2, 0xad05
 914:	0001                	.insn	2, 0x0001
 916:	0100                	.insn	2, 0x0100
 918:	0702                	.insn	2, 0x0702
 91a:	00b8                	.insn	2, 0x00b8
 91c:	0000                	.insn	2, 0x
 91e:	0401                	.insn	2, 0x0401
 920:	a405                	.insn	2, 0xa405
 922:	0001                	.insn	2, 0x0001
 924:	0200                	.insn	2, 0x0200
 926:	00ff 0000 4f02 6819 	.insn	10, 0x68194f02000000ff
 92e:	0000 
 930:	0100                	.insn	2, 0x0100
 932:	0704                	.insn	2, 0x0704
 934:	0178                	.insn	2, 0x0178
 936:	0000                	.insn	2, 0x
 938:	0801                	.insn	2, 0x0801
 93a:	9f05                	.insn	2, 0x9f05
 93c:	0001                	.insn	2, 0x0001
 93e:	1200                	.insn	2, 0x1200
 940:	0504                	.insn	2, 0x0504
 942:	6e69                	.insn	2, 0x6e69
 944:	0074                	.insn	2, 0x0074
 946:	0401                	.insn	2, 0x0401
 948:	00017d07          	.insn	4, 0x00017d07
 94c:	0200                	.insn	2, 0x0200
 94e:	004d                	.insn	2, 0x004d
 950:	0000                	.insn	2, 0x
 952:	3b131803          	lh	a6,945(t1) # a15 <_svfiprintf_r+0x36d>
 956:	0000                	.insn	2, 0x
 958:	0400                	.insn	2, 0x0400
 95a:	0084                	.insn	2, 0x0084
 95c:	0000                	.insn	2, 0x
 95e:	0102                	.insn	2, 0x0102
 960:	0001                	.insn	2, 0x0001
 962:	0300                	.insn	2, 0x0300
 964:	1430                	.insn	2, 0x1430
 966:	005c                	.insn	2, 0x005c
 968:	0000                	.insn	2, 0x
 96a:	0802                	.insn	2, 0x0802
 96c:	04000003          	lb	zero,64(zero) # 40 <_data_copy_loop+0x20>
 970:	17d6                	.insn	2, 0x17d6
 972:	007d                	.insn	2, 0x007d
 974:	0000                	.insn	2, 0x
 976:	1001                	.insn	2, 0x1001
 978:	f004                	.insn	2, 0xf004
 97a:	0002                	.insn	2, 0x0002
 97c:	0500                	.insn	2, 0x0500
 97e:	00b9                	.insn	2, 0x00b9
 980:	0000                	.insn	2, 0x
 982:	0101                	.insn	2, 0x0101
 984:	b308                	.insn	2, 0xb308
 986:	0000                	.insn	2, 0x
 988:	0400                	.insn	2, 0x0400
 98a:	00b9                	.insn	2, 0x00b9
 98c:	0000                	.insn	2, 0x
 98e:	c005                	.insn	2, 0xc005
 990:	0000                	.insn	2, 0x
 992:	0b00                	.insn	2, 0x0b00
 994:	023a                	.insn	2, 0x023a
 996:	0000                	.insn	2, 0x
 998:	1001                	.insn	2, 0x1001
 99a:	00e1                	.insn	2, 0x00e1
 99c:	0000                	.insn	2, 0x
 99e:	b00c                	.insn	2, 0xb00c
 9a0:	0002                	.insn	2, 0x0002
 9a2:	1100                	.insn	2, 0x1100
 9a4:	0000840b          	.insn	4, 0x840b
 9a8:	0000                	.insn	2, 0x
 9aa:	3a02                	.insn	2, 0x3a02
 9ac:	0002                	.insn	2, 0x0002
 9ae:	0500                	.insn	2, 0x0500
 9b0:	0312                	.insn	2, 0x0312
 9b2:	00ca                	.insn	2, 0x00ca
 9b4:	0000                	.insn	2, 0x
 9b6:	0000e107          	.insn	4, 0xe107
 9ba:	0b00                	.insn	2, 0x0b00
 9bc:	03c4                	.insn	2, 0x03c4
 9be:	0000                	.insn	2, 0x
 9c0:	1404                	.insn	2, 0x1404
 9c2:	0109                	.insn	2, 0x0109
 9c4:	0000                	.insn	2, 0x
 9c6:	da0c                	.insn	2, 0xda0c
 9c8:	15000003          	lb	zero,336(zero) # 150 <echo+0x4>
 9cc:	950c                	.insn	2, 0x950c
 9ce:	0000                	.insn	2, 0x
 9d0:	0000                	.insn	2, 0x
 9d2:	c402                	.insn	2, 0xc402
 9d4:	05000003          	lb	zero,80(zero) # 50 <_bss_zero_loop+0xc>
 9d8:	0316                	.insn	2, 0x0316
 9da:	00f2                	.insn	2, 0x00f2
 9dc:	0000                	.insn	2, 0x
 9de:	00010907          	.insn	4, 0x00010907
 9e2:	1300                	.insn	2, 0x1300
 9e4:	0501                	.insn	2, 0x0501
 9e6:	0918                	.insn	2, 0x0918
 9e8:	0174                	.insn	2, 0x0174
 9ea:	0000                	.insn	2, 0x
 9ec:	00305f03          	lhu	t5,3(zero) # 3 <ROM_START_ADDRESS+0x3>
 9f0:	841a                	.insn	2, 0x841a
 9f2:	0000                	.insn	2, 0x
 9f4:	0000                	.insn	2, 0x
 9f6:	00315f03          	lhu	t5,3(sp)
 9fa:	0000841b          	.insn	4, 0x841b
 9fe:	0100                	.insn	2, 0x0100
 a00:	00325f03          	lhu	t5,3(tp) # 3 <ROM_START_ADDRESS+0x3>
 a04:	841c                	.insn	2, 0x841c
 a06:	0000                	.insn	2, 0x
 a08:	0200                	.insn	2, 0x0200
 a0a:	00335f03          	lhu	t5,3(t1)
 a0e:	841d                	.insn	2, 0x841d
 a10:	0000                	.insn	2, 0x
 a12:	0300                	.insn	2, 0x0300
 a14:	00345f03          	lhu	t5,3(s0)
 a18:	841e                	.insn	2, 0x841e
 a1a:	0000                	.insn	2, 0x
 a1c:	0400                	.insn	2, 0x0400
 a1e:	00355f03          	lhu	t5,3(a0)
 a22:	841f 0000 0500      	.insn	6, 0x05000000841f
 a28:	00365f03          	lhu	t5,3(a2)
 a2c:	8420                	.insn	2, 0x8420
 a2e:	0000                	.insn	2, 0x
 a30:	0600                	.insn	2, 0x0600
 a32:	00375f03          	lhu	t5,3(a4)
 a36:	8421                	.insn	2, 0x8421
 a38:	0000                	.insn	2, 0x
 a3a:	0700                	.insn	2, 0x0700
 a3c:	0200                	.insn	2, 0x0200
 a3e:	03ad                	.insn	2, 0x03ad
 a40:	0000                	.insn	2, 0x
 a42:	2205                	.insn	2, 0x2205
 a44:	00011a03          	lh	s4,0(sp)
 a48:	1400                	.insn	2, 0x1400
 a4a:	03b4                	.insn	2, 0x03b4
 a4c:	0000                	.insn	2, 0x
 a4e:	0501                	.insn	2, 0x0501
 a50:	0f24                	.insn	2, 0x0f24
 a52:	01a4                	.insn	2, 0x01a4
 a54:	0000                	.insn	2, 0x
 a56:	a70d                	.insn	2, 0xa70d
 a58:	25000003          	lb	zero,592(zero) # 250 <_sniprintf_r+0x34>
 a5c:	0000840b          	.insn	4, 0x840b
 a60:	0d00                	.insn	2, 0x0d00
 a62:	03ed                	.insn	2, 0x03ed
 a64:	0000                	.insn	2, 0x
 a66:	0a26                	.insn	2, 0x0a26
 a68:	0174                	.insn	2, 0x0174
 a6a:	0000                	.insn	2, 0x
 a6c:	0200                	.insn	2, 0x0200
 a6e:	03b4                	.insn	2, 0x03b4
 a70:	0000                	.insn	2, 0x
 a72:	2705                	.insn	2, 0x2705
 a74:	00018003          	lb	zero,0(gp) # 4dc <HEAP_SIZE+0xdc>
 a78:	0700                	.insn	2, 0x0700
 a7a:	01a4                	.insn	2, 0x01a4
 a7c:	0000                	.insn	2, 0x
 a7e:	fd08                	.insn	2, 0xfd08
 a80:	29000003          	lb	zero,656(zero) # 290 <_sniprintf_r+0x74>
 a84:	c528                	.insn	2, 0xc528
 a86:	0001                	.insn	2, 0x0001
 a88:	0500                	.insn	2, 0x0500
 a8a:	00ed                	.insn	2, 0x00ed
 a8c:	0000                	.insn	2, 0x
 a8e:	c004                	.insn	2, 0xc004
 a90:	0001                	.insn	2, 0x0001
 a92:	0800                	.insn	2, 0x0800
 a94:	03f2                	.insn	2, 0x03f2
 a96:	0000                	.insn	2, 0x
 a98:	292a                	.insn	2, 0x292a
 a9a:	01da                	.insn	2, 0x01da
 a9c:	0000                	.insn	2, 0x
 a9e:	1505                	.insn	2, 0x1505
 aa0:	0001                	.insn	2, 0x0001
 aa2:	0400                	.insn	2, 0x0400
 aa4:	01d5                	.insn	2, 0x01d5
 aa6:	0000                	.insn	2, 0x
 aa8:	a808                	.insn	2, 0xa808
 aaa:	2b000003          	lb	zero,688(zero) # 2b0 <_sniprintf_r+0x94>
 aae:	ef28                	.insn	2, 0xef28
 ab0:	0001                	.insn	2, 0x0001
 ab2:	0500                	.insn	2, 0x0500
 ab4:	01b0                	.insn	2, 0x01b0
 ab6:	0000                	.insn	2, 0x
 ab8:	ea04                	.insn	2, 0xea04
 aba:	0001                	.insn	2, 0x0001
 abc:	0e00                	.insn	2, 0x0e00
 abe:	0090                	.insn	2, 0x0090
 ac0:	0000                	.insn	2, 0x
 ac2:	0204                	.insn	2, 0x0204
 ac4:	0000                	.insn	2, 0x
 ac6:	00007d0f          	.insn	4, 0x7d0f
 aca:	0c00                	.insn	2, 0x0c00
 acc:	0400                	.insn	2, 0x0400
 ace:	01f4                	.insn	2, 0x01f4
 ad0:	0000                	.insn	2, 0x
 ad2:	6d10                	.insn	2, 0x6d10
 ad4:	0b006773          	.insn	4, 0x0b006773
 ad8:	0415                	.insn	2, 0x0415
 ada:	0002                	.insn	2, 0x0002
 adc:	0500                	.insn	2, 0x0500
 ade:	00004c03          	lbu	s8,0(zero) # 0 <ROM_START_ADDRESS>
 ae2:	0920                	.insn	2, 0x0920
 ae4:	01b5                	.insn	2, 0x01b5
 ae6:	0000                	.insn	2, 0x
 ae8:	210d                	.insn	2, 0x210d
 aea:	0305                	.insn	2, 0x0305
 aec:	0008                	.insn	2, 0x0008
 aee:	2000                	.insn	2, 0x2000
 af0:	ca09                	.insn	2, 0xca09
 af2:	0001                	.insn	2, 0x0001
 af4:	0f00                	.insn	2, 0x0f00
 af6:	0522                	.insn	2, 0x0522
 af8:	00000403          	lb	s0,0(zero) # 0 <ROM_START_ADDRESS>
 afc:	0920                	.insn	2, 0x0920
 afe:	01df 0000 2111      	.insn	6, 0x2111000001df
 b04:	0305                	.insn	2, 0x0305
 b06:	0000                	.insn	2, 0x
 b08:	2000                	.insn	2, 0x2000
 b0a:	b90e                	.insn	2, 0xb90e
 b0c:	0000                	.insn	2, 0x
 b0e:	5100                	.insn	2, 0x5100
 b10:	0002                	.insn	2, 0x0002
 b12:	0f00                	.insn	2, 0x0f00
 b14:	007d                	.insn	2, 0x007d
 b16:	0000                	.insn	2, 0x
 b18:	6210003f 13006675 	.insn	8, 0x130066756210003f
 b20:	4106                	.insn	2, 0x4106
 b22:	0002                	.insn	2, 0x0002
 b24:	0500                	.insn	2, 0x0500
 b26:	00011c03          	lh	s8,0(sp)
 b2a:	1520                	.insn	2, 0x1520
 b2c:	03e4                	.insn	2, 0x03e4
 b2e:	0000                	.insn	2, 0x
 b30:	1006                	.insn	2, 0x1006
 b32:	0501                	.insn	2, 0x0501
 b34:	0076                	.insn	2, 0x0076
 b36:	0000                	.insn	2, 0x
 b38:	0284                	.insn	2, 0x0284
 b3a:	0000                	.insn	2, 0x
 b3c:	b40a                	.insn	2, 0xb40a
 b3e:	0000                	.insn	2, 0x
 b40:	0a00                	.insn	2, 0x0a00
 b42:	00a1                	.insn	2, 0x00a1
 b44:	0000                	.insn	2, 0x
 b46:	c50a                	.insn	2, 0xc50a
 b48:	0000                	.insn	2, 0x
 b4a:	1600                	.insn	2, 0x1600
 b4c:	1700                	.insn	2, 0x1700
 b4e:	03f8                	.insn	2, 0x03f8
 b50:	0000                	.insn	2, 0x
 b52:	1b01                	.insn	2, 0x1b01
 b54:	7605                	.insn	2, 0x7605
 b56:	0000                	.insn	2, 0x
 b58:	f800                	.insn	2, 0xf800
 b5a:	0001                	.insn	2, 0x0001
 b5c:	2400                	.insn	2, 0x2400
 b5e:	0000                	.insn	2, 0x
 b60:	0100                	.insn	2, 0x0100
 b62:	c99c                	.insn	2, 0xc99c
 b64:	0002                	.insn	2, 0x0002
 b66:	1800                	.insn	2, 0x1800
 b68:	0218                	.insn	2, 0x0218
 b6a:	0000                	.insn	2, 0x
 b6c:	0262                	.insn	2, 0x0262
 b6e:	0000                	.insn	2, 0x
 b70:	0106                	.insn	2, 0x0106
 b72:	055a                	.insn	2, 0x055a
 b74:	00011c03          	lh	s8,0(sp)
 b78:	0620                	.insn	2, 0x0620
 b7a:	5b01                	.insn	2, 0x5b01
 b7c:	3a01                	.insn	2, 0x3a01
 b7e:	0106                	.insn	2, 0x0106
 b80:	055c                	.insn	2, 0x055c
 b82:	00000c03          	lb	s8,0(zero) # 0 <ROM_START_ADDRESS>
 b86:	0620                	.insn	2, 0x0620
 b88:	5d01                	.insn	2, 0x5d01
 b8a:	0305                	.insn	2, 0x0305
 b8c:	004c                	.insn	2, 0x004c
 b8e:	2000                	.insn	2, 0x2000
 b90:	0000                	.insn	2, 0x
 b92:	d519                	.insn	2, 0xd519
 b94:	01000003          	lb	zero,16(zero) # 10 <ROM_START_ADDRESS+0x10>
 b98:	0915                	.insn	2, 0x0915
 b9a:	0084                	.insn	2, 0x0084
 b9c:	0000                	.insn	2, 0x
 b9e:	01f0                	.insn	2, 0x01f0
 ba0:	0000                	.insn	2, 0x
 ba2:	0008                	.insn	2, 0x0008
 ba4:	0000                	.insn	2, 0x
 ba6:	9c01                	.insn	2, 0x9c01
 ba8:	781a                	.insn	2, 0x781a
 baa:	0100                	.insn	2, 0x0100
 bac:	1615                	.insn	2, 0x1615
 bae:	0084                	.insn	2, 0x0084
 bb0:	0000                	.insn	2, 0x
 bb2:	01c9                	.insn	2, 0x01c9
 bb4:	0000                	.insn	2, 0x
 bb6:	0000                	.insn	2, 0x
 bb8:	0000005b          	.insn	4, 0x005b
 bbc:	0005                	.insn	2, 0x0005
 bbe:	0401                	.insn	2, 0x0401
 bc0:	04f1                	.insn	2, 0x04f1
 bc2:	0000                	.insn	2, 0x
 bc4:	2501                	.insn	2, 0x2501
 bc6:	e8000007          	.insn	4, 0xe8000007
 bca:	0015                	.insn	2, 0x0015
 bcc:	b400                	.insn	2, 0xb400
 bce:	0201                	.insn	2, 0x0201
 bd0:	0004                	.insn	2, 0x0004
 bd2:	2b00                	.insn	2, 0x2b00
 bd4:	0004                	.insn	2, 0x0004
 bd6:	2f00                	.insn	2, 0x2f00
 bd8:	0000                	.insn	2, 0x
 bda:	0100                	.insn	2, 0x0100
 bdc:	0280                	.insn	2, 0x0280
 bde:	048c                	.insn	2, 0x048c
 be0:	0000                	.insn	2, 0x
 be2:	e85d                	.insn	2, 0xe85d
 be4:	0015                	.insn	2, 0x0015
 be6:	8400                	.insn	2, 0x8400
 be8:	0201                	.insn	2, 0x0201
 bea:	049e                	.insn	2, 0x049e
 bec:	0000                	.insn	2, 0x
 bee:	f05d                	.insn	2, 0xf05d
 bf0:	0015                	.insn	2, 0x0015
 bf2:	4800                	.insn	2, 0x4800
 bf4:	9502                	.insn	2, 0x9502
 bf6:	0004                	.insn	2, 0x0004
 bf8:	5d00                	.insn	2, 0x5d00
 bfa:	15f0                	.insn	2, 0x15f0
 bfc:	0000                	.insn	2, 0x
 bfe:	0248                	.insn	2, 0x0248
 c00:	04a8                	.insn	2, 0x04a8
 c02:	0000                	.insn	2, 0x
 c04:	385d                	.insn	2, 0x385d
 c06:	0016                	.insn	2, 0x0016
 c08:	1000                	.insn	2, 0x1000
 c0a:	b202                	.insn	2, 0xb202
 c0c:	0004                	.insn	2, 0x0004
 c0e:	5d00                	.insn	2, 0x5d00
 c10:	166c                	.insn	2, 0x166c
 c12:	0000                	.insn	2, 0x
 c14:	0330                	.insn	2, 0x0330
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
    la gp, __global_pointer$
   0:	1101                	.insn	2, 0x1101
   2:	1000                	.insn	2, 0x1000
   4:	12011117          	auipc	sp,0x12011
    la a4, _sdata_load$
   8:	1b0e030f          	.insn	4, 0x1b0e030f
   c:	250e                	.insn	2, 0x250e
   e:	130e                	.insn	2, 0x130e
    la a5, _sdata$
  10:	0005                	.insn	2, 0x0005
  12:	0000                	.insn	2, 0x
  14:	2401                	.insn	2, 0x2401
  16:	0b00                	.insn	2, 0x0b00
    la a6, _edata$
  18:	030b3e0b          	.insn	4, 0x030b3e0b
  1c:	000e                	.insn	2, 0x000e
  1e:	0200                	.insn	2, 0x0200
    lw a7, 0(a4)
  20:	0016                	.insn	2, 0x0016
  22:	0b3a0e03          	lb	t3,179(s4)
    sw a7, 0(a5)
  26:	0b390b3b          	.insn	4, 0x0b390b3b
    addi a5, a5, 0x04
  2a:	1349                	.insn	2, 0x1349
    addi a4, a4, 0x04
  2c:	0000                	.insn	2, 0x
  2e:	7d004803          	lbu	a6,2000(zero) # 7d0 <_svfiprintf_r+0x128>
    blt a5, a6, _data_copy_loop
  32:	8201                	.insn	2, 0x8201
    la a4, _sbss$
  34:	1901                	.insn	2, 0x1901
  36:	0000137f 3f002e04 	.insn	12, 0x3a0e03193f002e040000137f
  3e:	3a0e0319 
    la a5, _ebss$
  42:	0121                	.insn	2, 0x0121
    sw zero, 0(a4)
  44:	21390b3b          	.insn	4, 0x21390b3b
    addi a4, a4, 0x04
  48:	271c                	.insn	2, 0x271c
  4a:	0019                	.insn	2, 0x0019
    blt a4, a5, _bss_zero_loop
  4c:	0500                	.insn	2, 0x0500
  4e:	012e                	.insn	2, 0x012e
    la a4, __heap_start$
  50:	0e03193f 3b01213a 	.insn	8, 0x3b01213a0e03193f
    la a5, __heap_end$
  58:	0621390b          	.insn	4, 0x0621390b
  5c:	01111927          	.insn	4, 0x01111927
    sw zero, 0(a4)
  60:	0612                	.insn	2, 0x0612
  62:	1840                	.insn	2, 0x1840
    addi a4, a4, 0x04
  64:	197a                	.insn	2, 0x197a
  66:	1301                	.insn	2, 0x1301
    blt a4, a5, _heap_zero_loop
  68:	0000                	.insn	2, 0x
  6a:	2e06                	.insn	2, 0x2e06
    li a4, 0
  6c:	3f01                	.insn	2, 0x3f01
  6e:	0319                	.insn	2, 0x0319
    li a5, 0
  70:	3a0e                	.insn	2, 0x3a0e
  72:	0121                	.insn	2, 0x0121
    li a6, 0
  74:	0b390b3b          	.insn	4, 0x0b390b3b
    la sp, __stack_top$
  78:	13491927          	.insn	4, 0x13491927
  7c:	0111                	.insn	2, 0x0111
  7e:	0612                	.insn	2, 0x0612
    la t0, _MSYSIE
  80:	1840                	.insn	2, 0x1840
  82:	197a                	.insn	2, 0x197a
  84:	1301                	.insn	2, 0x1301
  86:	0000                	.insn	2, 0x
    csrrw t0, mtvec, t0
  88:	03000507          	.insn	4, 0x03000507
    call main
  8c:	3a0e                	.insn	2, 0x3a0e
  8e:	0121                	.insn	2, 0x0121
    j _halt
  90:	0b390b3b          	.insn	4, 0x0b390b3b
    mret
  94:	1349                	.insn	2, 0x1349
  96:	1702                	.insn	2, 0x1702
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  98:	0000                	.insn	2, 0x
  9a:	0508                	.insn	2, 0x0508
}
  9c:	0300                	.insn	2, 0x0300
  9e:	3a0e                	.insn	2, 0x3a0e
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a0:	0121                	.insn	2, 0x0121
  a2:	0b390b3b          	.insn	4, 0x0b390b3b
}
  a6:	1349                	.insn	2, 0x1349
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a8:	1802                	.insn	2, 0x1802
  aa:	0000                	.insn	2, 0x
}
  ac:	0509                	.insn	2, 0x0509
  ae:	0300                	.insn	2, 0x0300
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b0:	3a08                	.insn	2, 0x3a08
  b2:	0121                	.insn	2, 0x0121
}
  b4:	0b390b3b          	.insn	4, 0x0b390b3b
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	1349                	.insn	2, 0x1349
  ba:	1802                	.insn	2, 0x1802
}
  bc:	0000                	.insn	2, 0x
  be:	340a                	.insn	2, 0x340a
  c0:	0300                	.insn	2, 0x0300
  c2:	3a0e                	.insn	2, 0x3a0e
  c4:	0121                	.insn	2, 0x0121
  c6:	3924213b          	.insn	4, 0x3924213b
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  ca:	0213490b          	.insn	4, 0x0213490b
}
  ce:	0b000017          	auipc	zero,0xb000
  d2:	0034                	.insn	2, 0x0034
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d4:	213a0803          	lb	a6,531(s4)
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  d8:	3b01                	.insn	2, 0x3b01
  da:	490b390b          	.insn	4, 0x490b390b
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  de:	00180213          	add	tp,a6,1
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e2:	0c00                	.insn	2, 0x0c00
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	0111                	.insn	2, 0x0111
  e6:	0e25                	.insn	2, 0x0e25
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	1f030b13          	add	s6,t1,496
  uint32_t cause = hal_read_csr(mcause);
  ec:	01111f1b          	.insn	4, 0x01111f1b
  if (cause & EXT_SYS_I0_IE)
  f0:	0612                	.insn	2, 0x0612
  f2:	1710                	.insn	2, 0x1710
  f4:	0000                	.insn	2, 0x
  f6:	240d                	.insn	2, 0x240d
    EXT_IRQ_0_HANDLER();
  f8:	0b00                	.insn	2, 0x0b00
  fa:	030b3e0b          	.insn	4, 0x030b3e0b
  else if (cause & EXT_SYS_I1_IE)
  fe:	0008                	.insn	2, 0x0008
 100:	0e00                	.insn	2, 0x0e00
 102:	002e                	.insn	2, 0x002e
    EXT_IRQ_1_HANDLER();
 104:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
  else if (cause & EXT_SYS_I2_IE)
 10c:	0b39                	.insn	2, 0x0b39
 10e:	0b201927          	.insn	4, 0x0b201927
    EXT_IRQ_2_HANDLER();
 112:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I3_IE)
 114:	11010b0f          	.insn	4, 0x11010b0f
 118:	1201                	.insn	2, 0x1201
 11a:	0106                	.insn	2, 0x0106
    EXT_IRQ_3_HANDLER();
 11c:	10000013          	li	zero,256
  else if (cause & EXT_SYS_I4_IE)
 120:	0034                	.insn	2, 0x0034
 122:	0b3a0803          	lb	a6,179(s4)
 126:	0b390b3b          	.insn	4, 0x0b390b3b
    EXT_IRQ_4_HANDLER();
 12a:	1349                	.insn	2, 0x1349
  else if (cause & EXT_SYS_I5_IE)
 12c:	1702                	.insn	2, 0x1702
 12e:	0000                	.insn	2, 0x
 130:	2e11                	.insn	2, 0x2e11
 132:	3100                	.insn	2, 0x3100
    EXT_IRQ_5_HANDLER();
 134:	12011113          	.insn	4, 0x12011113
}
 138:	4006                	.insn	2, 0x4006
 13a:	7a18                	.insn	2, 0x7a18
  size >>= 8;
 13c:	0019                	.insn	2, 0x0019
 13e:	0000                	.insn	2, 0x
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	1601                	.insn	2, 0x1601
 142:	0300                	.insn	2, 0x0300
 144:	3a0e                	.insn	2, 0x3a0e
 146:	390b3b0b          	.insn	4, 0x390b3b0b
}
 14a:	0013490b          	.insn	4, 0x0013490b
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14e:	0200                	.insn	2, 0x0200
  while (*ptr)
 150:	000d                	.insn	2, 0x000d
 152:	0b3a0e03          	lb	t3,179(s4)
 156:	0b390b3b          	.insn	4, 0x0b390b3b
}
 15a:	1349                	.insn	2, 0x1349
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	0b38                	.insn	2, 0x0b38
 15e:	0000                	.insn	2, 0x
 160:	0b002403          	lw	s0,176(zero) # b0 <hal_read_32bit>
 164:	030b3e0b          	.insn	4, 0x030b3e0b
}
 168:	000e                	.insn	2, 0x000e
 16a:	0400                	.insn	2, 0x0400
 16c:	0005                	.insn	2, 0x0005
 16e:	213a0803          	lb	a6,531(s4)
int _close(int fd) {
 172:	3b01                	.insn	2, 0x3b01
 174:	490b390b          	.insn	4, 0x490b390b
  st->st_mode = S_IFCHR;
 178:	00170213          	add	tp,a4,1
 17c:	0500                	.insn	2, 0x0500
 17e:	012e                	.insn	2, 0x012e
}
 180:	0e03193f 3b01213a 	.insn	8, 0x3b01213a0e03193f
}
 188:	270b390b          	.insn	4, 0x270b390b
 18c:	4919                	.insn	2, 0x4919
 18e:	12011113          	.insn	4, 0x12011113
}
 192:	4006                	.insn	2, 0x4006
 194:	7a18                	.insn	2, 0x7a18
 196:	0119                	.insn	2, 0x0119
  while (1);
 198:	06000013          	li	zero,96
}
 19c:	0005                	.insn	2, 0x0005
 19e:	213a0803          	lb	a6,531(s4)
}
 1a2:	3b01                	.insn	2, 0x3b01
 1a4:	490b390b          	.insn	4, 0x490b390b
void *_sbrk(ptrdiff_t incr) {
 1a8:	00180213          	add	tp,a6,1
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	0700                	.insn	2, 0x0700
 1ae:	210b000f          	.insn	4, 0x210b000f
 1b2:	4904                	.insn	2, 0x4904
 1b4:	08000013          	li	zero,128
 1b8:	0e030113          	add	sp,t1,224
 1bc:	0b3a0b0b          	.insn	4, 0x0b3a0b0b
 1c0:	0b390b3b          	.insn	4, 0x0b390b3b
  curbrk += incr;
 1c4:	1301                	.insn	2, 0x1301
 1c6:	0000                	.insn	2, 0x
  return ret;
 1c8:	0509                	.insn	2, 0x0509
 1ca:	3100                	.insn	2, 0x3100
    return (void *)-1;
 1cc:	00170213          	add	tp,a4,1
}
 1d0:	0a00                	.insn	2, 0x0a00
 1d2:	0005                	.insn	2, 0x0005
}
 1d4:	213a0e03          	lb	t3,531(s4)
 1d8:	3b01                	.insn	2, 0x3b01
 1da:	490b390b          	.insn	4, 0x490b390b
  size >>= 8;
 1de:	00180213          	add	tp,a6,1
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e2:	0b00                	.insn	2, 0x0b00
 1e4:	0034                	.insn	2, 0x0034
 1e6:	213a0e03          	lb	t3,531(s4)
 1ea:	3b01                	.insn	2, 0x3b01
 1ec:	0f21390b          	.insn	4, 0x0f21390b
}
 1f0:	1349                	.insn	2, 0x1349
 1f2:	193c193f 050c0000 	.insn	8, 0x050c0000193c193f
  snprintf(buf, 10, "%s", msg);
 1fa:	0300                	.insn	2, 0x0300
{
 1fc:	3a08                	.insn	2, 0x3a08
 1fe:	0121                	.insn	2, 0x0121
  snprintf(buf, 10, "%s", msg);
 200:	0b390b3b          	.insn	4, 0x0b390b3b
 204:	1349                	.insn	2, 0x1349
 206:	0000                	.insn	2, 0x
 208:	340d                	.insn	2, 0x340d
 20a:	3100                	.insn	2, 0x3100
 20c:	00170213          	add	tp,a4,1
{
 210:	0e00                	.insn	2, 0x0e00
 212:	0111                	.insn	2, 0x0111
  snprintf(buf, 10, "%s", msg);
 214:	0e25                	.insn	2, 0x0e25
 216:	1f030b13          	add	s6,t1,496
  while (1);
 21a:	01111f1b          	.insn	4, 0x01111f1b
 21e:	0612                	.insn	2, 0x0612
 220:	1710                	.insn	2, 0x1710
 222:	0000                	.insn	2, 0x
 224:	0b00240f          	.insn	4, 0x0b00240f
 228:	030b3e0b          	.insn	4, 0x030b3e0b
 22c:	0008                	.insn	2, 0x0008
 22e:	1000                	.insn	2, 0x1000
 230:	0b0b000f          	.insn	4, 0x0b0b000f
 234:	0000                	.insn	2, 0x
 236:	2611                	.insn	2, 0x2611
 238:	4900                	.insn	2, 0x4900
 23a:	12000013          	li	zero,288
 23e:	0101                	.insn	2, 0x0101
 240:	1349                	.insn	2, 0x1349
 242:	1301                	.insn	2, 0x1301
 244:	0000                	.insn	2, 0x
 246:	49002113          	slti	sp,zero,1168
 24a:	000b2f13          	slti	t5,s6,0
 24e:	1400                	.insn	2, 0x1400
 250:	011d                	.insn	2, 0x011d
 252:	1331                	.insn	2, 0x1331
 254:	0111                	.insn	2, 0x0111
 256:	0612                	.insn	2, 0x0612
 258:	0b58                	.insn	2, 0x0b58
 25a:	0b59                	.insn	2, 0x0b59
 25c:	00000b57          	.insn	4, 0x0b57
 260:	2615                	.insn	2, 0x2615
 262:	0000                	.insn	2, 0x
 264:	1600                	.insn	2, 0x1600
 266:	0034                	.insn	2, 0x0034
 268:	0b3a0e03          	lb	t3,179(s4)
 26c:	0b390b3b          	.insn	4, 0x0b390b3b
 270:	1349                	.insn	2, 0x1349
 272:	0b1c                	.insn	2, 0x0b1c
 274:	0000                	.insn	2, 0x
 276:	03000517          	auipc	a0,0x3000
 27a:	3a0e                	.insn	2, 0x3a0e
 27c:	390b3b0b          	.insn	4, 0x390b3b0b
 280:	0213490b          	.insn	4, 0x0213490b
 284:	18000017          	auipc	zero,0x18000
 288:	0034                	.insn	2, 0x0034
 28a:	0b3a0e03          	lb	t3,179(s4)
 28e:	0b390b3b          	.insn	4, 0x0b390b3b
 292:	1349                	.insn	2, 0x1349
 294:	1802                	.insn	2, 0x1802
 296:	0000                	.insn	2, 0x
 298:	3419                	.insn	2, 0x3419
 29a:	0300                	.insn	2, 0x0300
 29c:	3a08                	.insn	2, 0x3a08
 29e:	390b3b0b          	.insn	4, 0x390b3b0b
 2a2:	0213490b          	.insn	4, 0x0213490b
 2a6:	1a000017          	auipc	zero,0x1a000
 2aa:	002e                	.insn	2, 0x002e
 2ac:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 2b4:	0b39                	.insn	2, 0x0b39
 2b6:	13491927          	.insn	4, 0x13491927
 2ba:	0111                	.insn	2, 0x0111
 2bc:	0612                	.insn	2, 0x0612
 2be:	1840                	.insn	2, 0x1840
 2c0:	197a                	.insn	2, 0x197a
 2c2:	0000                	.insn	2, 0x
 2c4:	3f012e1b          	.insn	4, 0x3f012e1b
 2c8:	0319                	.insn	2, 0x0319
 2ca:	3a0e                	.insn	2, 0x3a0e
 2cc:	390b3b0b          	.insn	4, 0x390b3b0b
 2d0:	1119270b          	.insn	4, 0x1119270b
 2d4:	1201                	.insn	2, 0x1201
 2d6:	4006                	.insn	2, 0x4006
 2d8:	7a18                	.insn	2, 0x7a18
 2da:	0119                	.insn	2, 0x0119
 2dc:	1c000013          	li	zero,448
 2e0:	012e                	.insn	2, 0x012e
 2e2:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 2ea:	0b39                	.insn	2, 0x0b39
 2ec:	01871927          	.insn	4, 0x01871927
 2f0:	1119                	.insn	2, 0x1119
 2f2:	1201                	.insn	2, 0x1201
 2f4:	4006                	.insn	2, 0x4006
 2f6:	7a18                	.insn	2, 0x7a18
 2f8:	0119                	.insn	2, 0x0119
 2fa:	1d000013          	li	zero,464
 2fe:	012e                	.insn	2, 0x012e
 300:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 308:	0b39                	.insn	2, 0x0b39
 30a:	13491927          	.insn	4, 0x13491927
 30e:	1301                	.insn	2, 0x1301
 310:	0000                	.insn	2, 0x
 312:	2e1e                	.insn	2, 0x2e1e
 314:	3f01                	.insn	2, 0x3f01
 316:	0319                	.insn	2, 0x0319
 318:	3a0e                	.insn	2, 0x3a0e
 31a:	390b3b0b          	.insn	4, 0x390b3b0b
 31e:	4919270b          	.insn	4, 0x4919270b
 322:	010b2013          	slti	zero,s6,16
 326:	1f000013          	li	zero,496
 32a:	012e                	.insn	2, 0x012e
 32c:	0e03193f 0b3b0b3a 	.insn	8, 0x0b3b0b3a0e03193f
 334:	0b39                	.insn	2, 0x0b39
 336:	0b201927          	.insn	4, 0x0b201927
 33a:	1301                	.insn	2, 0x1301
 33c:	0000                	.insn	2, 0x
 33e:	3420                	.insn	2, 0x3420
 340:	0300                	.insn	2, 0x0300
 342:	3a0e                	.insn	2, 0x3a0e
 344:	390b3b0b          	.insn	4, 0x390b3b0b
 348:	0013490b          	.insn	4, 0x0013490b
 34c:	2100                	.insn	2, 0x2100
 34e:	012e                	.insn	2, 0x012e
 350:	1331                	.insn	2, 0x1331
 352:	0111                	.insn	2, 0x0111
 354:	0612                	.insn	2, 0x0612
 356:	1840                	.insn	2, 0x1840
 358:	197a                	.insn	2, 0x197a
 35a:	1301                	.insn	2, 0x1301
 35c:	0000                	.insn	2, 0x
 35e:	2e22                	.insn	2, 0x2e22
 360:	3101                	.insn	2, 0x3101
 362:	12011113          	.insn	4, 0x12011113
 366:	4006                	.insn	2, 0x4006
 368:	7a18                	.insn	2, 0x7a18
 36a:	0019                	.insn	2, 0x0019
 36c:	0000                	.insn	2, 0x
 36e:	2401                	.insn	2, 0x2401
 370:	0b00                	.insn	2, 0x0b00
 372:	030b3e0b          	.insn	4, 0x030b3e0b
 376:	000e                	.insn	2, 0x000e
 378:	0200                	.insn	2, 0x0200
 37a:	0016                	.insn	2, 0x0016
 37c:	0b3a0e03          	lb	t3,179(s4)
 380:	0b390b3b          	.insn	4, 0x0b390b3b
 384:	1349                	.insn	2, 0x1349
 386:	0000                	.insn	2, 0x
 388:	03000d03          	lb	s10,48(zero) # 30 <_data_copy_loop+0x10>
 38c:	3a08                	.insn	2, 0x3a08
 38e:	0521                	.insn	2, 0x0521
 390:	21390b3b          	.insn	4, 0x21390b3b
 394:	0d13490b          	.insn	4, 0x0d13490b
 398:	0121                	.insn	2, 0x0121
 39a:	00000b6b          	.insn	4, 0x0b6b
 39e:	2604                	.insn	2, 0x2604
 3a0:	4900                	.insn	2, 0x4900
 3a2:	05000013          	li	zero,80
 3a6:	210b000f          	.insn	4, 0x210b000f
 3aa:	4904                	.insn	2, 0x4904
 3ac:	06000013          	li	zero,96
 3b0:	0049                	.insn	2, 0x0049
 3b2:	1802                	.insn	2, 0x1802
 3b4:	187e                	.insn	2, 0x187e
 3b6:	0000                	.insn	2, 0x
 3b8:	49003507          	.insn	4, 0x49003507
 3bc:	08000013          	li	zero,128
 3c0:	0034                	.insn	2, 0x0034
 3c2:	213a0e03          	lb	t3,531(s4)
 3c6:	3b05                	.insn	2, 0x3b05
 3c8:	490b390b          	.insn	4, 0x490b390b
 3cc:	3c193f13          	sltiu	t5,s2,961
 3d0:	0019                	.insn	2, 0x0019
 3d2:	0900                	.insn	2, 0x0900
 3d4:	0034                	.insn	2, 0x0034
 3d6:	213a1347          	.insn	4, 0x213a1347
 3da:	3b01                	.insn	2, 0x3b01
 3dc:	020b390b          	.insn	4, 0x020b390b
 3e0:	0018                	.insn	2, 0x0018
 3e2:	0a00                	.insn	2, 0x0a00
 3e4:	0005                	.insn	2, 0x0005
 3e6:	1349                	.insn	2, 0x1349
 3e8:	0000                	.insn	2, 0x
 3ea:	0301130b          	.insn	4, 0x0301130b
 3ee:	0b0e                	.insn	2, 0x0b0e
 3f0:	05213a0b          	.insn	4, 0x05213a0b
 3f4:	21390b3b          	.insn	4, 0x21390b3b
 3f8:	0110                	.insn	2, 0x0110
 3fa:	0c000013          	li	zero,192
 3fe:	000d                	.insn	2, 0x000d
 400:	213a0e03          	lb	t3,531(s4)
 404:	3b05                	.insn	2, 0x3b05
 406:	490b390b          	.insn	4, 0x490b390b
 40a:	00213813          	sltiu	a6,sp,2
 40e:	0000                	.insn	2, 0x
 410:	0d0d                	.insn	2, 0x0d0d
 412:	0300                	.insn	2, 0x0300
 414:	3a0e                	.insn	2, 0x3a0e
 416:	0521                	.insn	2, 0x0521
 418:	0b390b3b          	.insn	4, 0x0b390b3b
 41c:	1349                	.insn	2, 0x1349
 41e:	0000                	.insn	2, 0x
 420:	010e                	.insn	2, 0x010e
 422:	4901                	.insn	2, 0x4901
 424:	00130113          	add	sp,t1,1
 428:	0f00                	.insn	2, 0x0f00
 42a:	0021                	.insn	2, 0x0021
 42c:	1349                	.insn	2, 0x1349
 42e:	00000b2f          	.insn	4, 0x0b2f
 432:	3410                	.insn	2, 0x3410
 434:	0300                	.insn	2, 0x0300
 436:	3a08                	.insn	2, 0x3a08
 438:	0121                	.insn	2, 0x0121
 43a:	0b390b3b          	.insn	4, 0x0b390b3b
 43e:	1349                	.insn	2, 0x1349
 440:	1802193f 11110000 	.insn	8, 0x111100001802193f
 448:	2501                	.insn	2, 0x2501
 44a:	130e                	.insn	2, 0x130e
 44c:	1b1f030b          	.insn	4, 0x1b1f030b
 450:	551f 1117 1001      	.insn	6, 0x10011117551f
 456:	12000017          	auipc	zero,0x12000
 45a:	0024                	.insn	2, 0x0024
 45c:	0b3e0b0b          	.insn	4, 0x0b3e0b0b
 460:	00000803          	lb	a6,0(zero) # 0 <ROM_START_ADDRESS>
 464:	0b011313          	.insn	4, 0x0b011313
 468:	3b0b3a0b          	.insn	4, 0x3b0b3a0b
 46c:	010b390b          	.insn	4, 0x010b390b
 470:	14000013          	li	zero,320
 474:	0e030117          	auipc	sp,0xe030
 478:	0b3a0b0b          	.insn	4, 0x0b3a0b0b
 47c:	0b390b3b          	.insn	4, 0x0b390b3b
 480:	1301                	.insn	2, 0x1301
 482:	0000                	.insn	2, 0x
 484:	2e15                	.insn	2, 0x2e15
 486:	3f01                	.insn	2, 0x3f01
 488:	0319                	.insn	2, 0x0319
 48a:	3a0e                	.insn	2, 0x3a0e
 48c:	39053b0b          	.insn	4, 0x39053b0b
 490:	4919270b          	.insn	4, 0x4919270b
 494:	01193c13          	sltiu	s8,s2,17
 498:	16000013          	li	zero,352
 49c:	0018                	.insn	2, 0x0018
 49e:	0000                	.insn	2, 0x
 4a0:	3f012e17          	auipc	t3,0x3f012
 4a4:	0319                	.insn	2, 0x0319
 4a6:	3a0e                	.insn	2, 0x3a0e
 4a8:	390b3b0b          	.insn	4, 0x390b3b0b
 4ac:	1113490b          	.insn	4, 0x1113490b
 4b0:	1201                	.insn	2, 0x1201
 4b2:	4006                	.insn	2, 0x4006
 4b4:	7a18                	.insn	2, 0x7a18
 4b6:	0119                	.insn	2, 0x0119
 4b8:	18000013          	li	zero,384
 4bc:	0148                	.insn	2, 0x0148
 4be:	017d                	.insn	2, 0x017d
 4c0:	0000137f 3f012e19 	.insn	12, 0x3a0e03193f012e190000137f
 4c8:	3a0e0319 
 4cc:	390b3b0b          	.insn	4, 0x390b3b0b
 4d0:	4919270b          	.insn	4, 0x4919270b
 4d4:	12011113          	.insn	4, 0x12011113
 4d8:	4006                	.insn	2, 0x4006
 4da:	7a18                	.insn	2, 0x7a18
 4dc:	0019                	.insn	2, 0x0019
 4de:	1a00                	.insn	2, 0x1a00
 4e0:	0005                	.insn	2, 0x0005
 4e2:	0b3a0803          	lb	a6,179(s4)
 4e6:	0b390b3b          	.insn	4, 0x0b390b3b
 4ea:	1349                	.insn	2, 0x1349
 4ec:	1702                	.insn	2, 0x1702
 4ee:	0000                	.insn	2, 0x
 4f0:	0100                	.insn	2, 0x0100
 4f2:	0111                	.insn	2, 0x0111
 4f4:	1710                	.insn	2, 0x1710
 4f6:	0111                	.insn	2, 0x0111
 4f8:	0f12                	.insn	2, 0x0f12
 4fa:	0e1b0e03          	lb	t3,225(s6)
 4fe:	0e25                	.insn	2, 0x0e25
 500:	00000513          	li	a0,0
 504:	2e02                	.insn	2, 0x2e02
 506:	0300                	.insn	2, 0x0300
 508:	3f0e                	.insn	2, 0x3f0e
 50a:	4919                	.insn	2, 0x4919
 50c:	1115                	.insn	2, 0x1115
 50e:	1201                	.insn	2, 0x1201
 510:	0300000f          	fence	rw,unknown
 514:	0000003b          	.insn	4, 0x003b
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
    la gp, __global_pointer$
   0:	001c                	.insn	2, 0x001c
   2:	0000                	.insn	2, 0x
   4:	0002                	.insn	2, 0x0002
   6:	0000                	.insn	2, 0x
    la a4, _sdata_load$
   8:	0000                	.insn	2, 0x
   a:	0004                	.insn	2, 0x0004
	...
    la a5, _sdata$
  14:	0098                	.insn	2, 0x0098
	...
    la a6, _edata$
  1e:	0000                	.insn	2, 0x
    lw a7, 0(a4)
  20:	001c                	.insn	2, 0x001c
  22:	0000                	.insn	2, 0x
    sw a7, 0(a5)
  24:	0002                	.insn	2, 0x0002
  26:	0025                	.insn	2, 0x0025
    addi a5, a5, 0x04
  28:	0000                	.insn	2, 0x
  2a:	0004                	.insn	2, 0x0004
    addi a4, a4, 0x04
  2c:	0000                	.insn	2, 0x
  2e:	0000                	.insn	2, 0x
    blt a5, a6, _data_copy_loop
  30:	0098                	.insn	2, 0x0098
  32:	0000                	.insn	2, 0x
    la a4, _sbss$
  34:	00a4                	.insn	2, 0x00a4
	...
    la a5, _ebss$
  3e:	0000                	.insn	2, 0x
  40:	001c                	.insn	2, 0x001c
  42:	0000                	.insn	2, 0x
    sw zero, 0(a4)
  44:	0002                	.insn	2, 0x0002
  46:	000002b7          	lui	t0,0x0
    addi a4, a4, 0x04
  4a:	0004                	.insn	2, 0x0004
    blt a4, a5, _bss_zero_loop
  4c:	0000                	.insn	2, 0x
  4e:	0000                	.insn	2, 0x
    la a4, __heap_start$
  50:	013c                	.insn	2, 0x013c
  52:	0000                	.insn	2, 0x
  54:	00b4                	.insn	2, 0x00b4
	...
    la a5, __heap_end$
  5e:	0000                	.insn	2, 0x
    sw zero, 0(a4)
  60:	0024                	.insn	2, 0x0024
  62:	0000                	.insn	2, 0x
    addi a4, a4, 0x04
  64:	0002                	.insn	2, 0x0002
  66:	08c9                	.insn	2, 0x08c9
    blt a4, a5, _heap_zero_loop
  68:	0000                	.insn	2, 0x
  6a:	0004                	.insn	2, 0x0004
    li a4, 0
  6c:	0000                	.insn	2, 0x
  6e:	0000                	.insn	2, 0x
    li a5, 0
  70:	01f0                	.insn	2, 0x01f0
  72:	0000                	.insn	2, 0x
    li a6, 0
  74:	0008                	.insn	2, 0x0008
  76:	0000                	.insn	2, 0x
    la sp, __stack_top$
  78:	01f8                	.insn	2, 0x01f8
  7a:	0000                	.insn	2, 0x
  7c:	0024                	.insn	2, 0x0024
	...
    la t0, _MSYSIE
  86:	0000                	.insn	2, 0x
    csrrw t0, mtvec, t0
  88:	001c                	.insn	2, 0x001c
  8a:	0000                	.insn	2, 0x
    call main
  8c:	0002                	.insn	2, 0x0002
  8e:	0bb8                	.insn	2, 0x0bb8
    j _halt
  90:	0000                	.insn	2, 0x
  92:	0004                	.insn	2, 0x0004
    mret
  94:	0000                	.insn	2, 0x
  96:	0000                	.insn	2, 0x
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  98:	15e8                	.insn	2, 0x15e8
  9a:	0000                	.insn	2, 0x
}
  9c:	00b4                	.insn	2, 0x00b4
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
    la gp, __global_pointer$
   0:	2f637273          	.insn	4, 0x2f637273
   4:	72617473          	.insn	4, 0x72617473
    la a4, _sdata_load$
   8:	2e74                	.insn	2, 0x2e74
   a:	682f0073          	.insn	4, 0x682f0073
   e:	2f656d6f          	jal	s10,56304 <RAM_SIZE+0x52304>
    la a5, _sdata$
  12:	6761                	.insn	2, 0x6761
  14:	6d61                	.insn	2, 0x6d61
  16:	6d65                	.insn	2, 0x6d65
    la a6, _edata$
  18:	6f6e                	.insn	2, 0x6f6e
  1a:	2f6e                	.insn	2, 0x2f6e
  1c:	6f44                	.insn	2, 0x6f44
  1e:	656d7563          	bgeu	s10,s6,668 <__ssprint_r+0x17c>
    lw a7, 0(a4)
  22:	746e                	.insn	2, 0x746e
    sw a7, 0(a5)
  24:	59502f73          	.insn	4, 0x59502f73
    addi a5, a5, 0x04
  28:	2f594d47          	.insn	4, 0x2f594d47
    addi a4, a4, 0x04
  2c:	47007773          	.insn	4, 0x47007773
    blt a5, a6, _data_copy_loop
  30:	554e                	.insn	2, 0x554e
  32:	4120                	.insn	2, 0x4120
    la a4, _sbss$
  34:	2e322053          	.insn	4, 0x2e322053
  38:	3134                	.insn	2, 0x3134
  3a:	6800                	.insn	2, 0x6800
    la a5, _ebss$
  3c:	6c61                	.insn	2, 0x6c61
  3e:	775f 6972 6574      	.insn	6, 0x65746972775f
    sw zero, 0(a4)
  44:	315f 6236 7469      	.insn	6, 0x74696236315f
    addi a4, a4, 0x04
  4a:	5f00                	.insn	2, 0x5f00
    blt a4, a5, _bss_zero_loop
  4c:	755f 6e69 3874      	.insn	6, 0x38746e69755f
    la a4, __heap_start$
  52:	745f 4500 5458      	.insn	6, 0x54584500745f
    la a5, __heap_end$
  58:	495f 5152 305f      	.insn	6, 0x305f5152495f
  5e:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
    addi a4, a4, 0x04
  64:	5245                	.insn	2, 0x5245
  66:	6800                	.insn	2, 0x6800
    blt a4, a5, _heap_zero_loop
  68:	6c61                	.insn	2, 0x6c61
  6a:	725f 6165 5f64      	.insn	6, 0x5f646165725f
    li a5, 0
  70:	6238                	.insn	2, 0x6238
  72:	7469                	.insn	2, 0x7469
    li a6, 0
  74:	4500                	.insn	2, 0x4500
  76:	5458                	.insn	2, 0x5458
    la sp, __stack_top$
  78:	495f 5152 335f      	.insn	6, 0x335f5152495f
  7e:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
    la t0, _MSYSIE
  84:	5245                	.insn	2, 0x5245
  86:	6100                	.insn	2, 0x6100
    csrrw t0, mtvec, t0
  88:	6464                	.insn	2, 0x6464
  8a:	0072                	.insn	2, 0x0072
    call main
  8c:	6168                	.insn	2, 0x6168
  8e:	5f6c                	.insn	2, 0x5f6c
    j _halt
  90:	6572                	.insn	2, 0x6572
  92:	6461                	.insn	2, 0x6461
    mret
  94:	335f 6232 7469      	.insn	6, 0x74696232335f
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  9a:	6800                	.insn	2, 0x6800
}
  9c:	6c61                	.insn	2, 0x6c61
  9e:	775f 6972 6574      	.insn	6, 0x65746972775f
}
  a4:	385f 6962 0074      	.insn	6, 0x00746962385f
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  aa:	6e75                	.insn	2, 0x6e75
}
  ac:	6e676973          	.insn	4, 0x6e676973
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b0:	6465                	.insn	2, 0x6465
  b2:	6320                	.insn	2, 0x6320
}
  b4:	6168                	.insn	2, 0x6168
  b6:	0072                	.insn	2, 0x0072
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	726f6873          	.insn	4, 0x726f6873
}
  bc:	2074                	.insn	2, 0x2074
  be:	6e75                	.insn	2, 0x6e75
  c0:	6e676973          	.insn	4, 0x6e676973
  c4:	6465                	.insn	2, 0x6465
  c6:	6920                	.insn	2, 0x6920
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  c8:	746e                	.insn	2, 0x746e
  ca:	4500                	.insn	2, 0x4500
}
  cc:	5458                	.insn	2, 0x5458
  ce:	495f 5152 315f      	.insn	6, 0x315f5152495f
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d4:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  da:	5245                	.insn	2, 0x5245
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	5f00                	.insn	2, 0x5f00
  de:	755f 6e69 3174      	.insn	6, 0x31746e69755f
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	5f36                	.insn	2, 0x5f36
  e6:	0074                	.insn	2, 0x0074
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	4142                	.insn	2, 0x4142
  ea:	495f4553          	.insn	4, 0x495f4553
  uint32_t cause = hal_read_csr(mcause);
  ee:	5152                	.insn	2, 0x5152
  if (cause & EXT_SYS_I0_IE)
  f0:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
  f6:	5245                	.insn	2, 0x5245
    EXT_IRQ_0_HANDLER();
  f8:	5f00                	.insn	2, 0x5f00
  fa:	745f 706d 5f00      	.insn	6, 0x5f00706d745f
  else if (cause & EXT_SYS_I1_IE)
 100:	755f 6e69 3374      	.insn	6, 0x33746e69755f
    EXT_IRQ_1_HANDLER();
 106:	5f32                	.insn	2, 0x5f32
  else if (cause & EXT_SYS_I2_IE)
 108:	0074                	.insn	2, 0x0074
 10a:	20554e47          	.insn	4, 0x20554e47
 10e:	20373143          	.insn	4, 0x20373143
    EXT_IRQ_2_HANDLER();
 112:	3331                	.insn	2, 0x3331
  else if (cause & EXT_SYS_I3_IE)
 114:	322e                	.insn	2, 0x322e
 116:	302e                	.insn	2, 0x302e
 118:	2d20                	.insn	2, 0x2d20
 11a:	616d                	.insn	2, 0x616d
    EXT_IRQ_3_HANDLER();
 11c:	6962                	.insn	2, 0x6962
 11e:	693d                	.insn	2, 0x693d
  else if (cause & EXT_SYS_I4_IE)
 120:	706c                	.insn	2, 0x706c
 122:	2d203233          	.insn	4, 0x2d203233
 126:	746d                	.insn	2, 0x746d
    EXT_IRQ_4_HANDLER();
 128:	6e75                	.insn	2, 0x6e75
 12a:	3d65                	.insn	2, 0x3d65
  else if (cause & EXT_SYS_I5_IE)
 12c:	6f72                	.insn	2, 0x6f72
 12e:	74656b63          	bltu	a0,t1,884 <_svfiprintf_r+0x1dc>
 132:	2d20                	.insn	2, 0x2d20
    EXT_IRQ_5_HANDLER();
 134:	696d                	.insn	2, 0x696d
 136:	732d6173          	.insn	4, 0x732d6173
}
 13a:	6570                	.insn	2, 0x6570
  size >>= 8;
 13c:	30323d63          	.insn	4, 0x30323d63
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	3931                	.insn	2, 0x3931
 142:	3231                	.insn	2, 0x3231
 144:	3331                	.insn	2, 0x3331
 146:	2d20                	.insn	2, 0x2d20
}
 148:	616d                	.insn	2, 0x616d
 14a:	6372                	.insn	2, 0x6372
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	3d68                	.insn	2, 0x3d68
 14e:	7672                	.insn	2, 0x7672
  while (*ptr)
 150:	5f693233          	.insn	4, 0x5f693233
 154:	697a                	.insn	2, 0x697a
 156:	20727363          	bgeu	tp,t2,35c <sniprintf+0x8c>
}
 15a:	672d                	.insn	2, 0x672d
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	2d20                	.insn	2, 0x2d20
 15e:	4500734f          	.insn	4, 0x4500734f
 162:	5458                	.insn	2, 0x5458
 164:	495f 5152 345f      	.insn	6, 0x345f5152495f
}
 16a:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
int _close(int fd) {
 170:	5245                	.insn	2, 0x5245
 172:	6c00                	.insn	2, 0x6c00
 174:	20676e6f          	jal	t3,7637a <RAM_SIZE+0x7237a>
  st->st_mode = S_IFCHR;
 178:	6f6c                	.insn	2, 0x6f6c
 17a:	676e                	.insn	2, 0x676e
 17c:	7520                	.insn	2, 0x7520
 17e:	736e                	.insn	2, 0x736e
}
 180:	6769                	.insn	2, 0x6769
 182:	656e                	.insn	2, 0x656e
 184:	2064                	.insn	2, 0x2064
 186:	6e69                	.insn	2, 0x6e69
}
 188:	0074                	.insn	2, 0x0074
 18a:	6168                	.insn	2, 0x6168
 18c:	5f6c                	.insn	2, 0x5f6c
 18e:	6572                	.insn	2, 0x6572
}
 190:	6461                	.insn	2, 0x6461
 192:	315f 6236 7469      	.insn	6, 0x74696236315f
  while (1);
 198:	6300                	.insn	2, 0x6300
 19a:	7561                	.insn	2, 0x7561
}
 19c:	6c006573          	.insn	4, 0x6c006573
}
 1a0:	20676e6f          	jal	t3,763a6 <RAM_SIZE+0x723a6>
 1a4:	6f6c                	.insn	2, 0x6f6c
 1a6:	676e                	.insn	2, 0x676e
void *_sbrk(ptrdiff_t incr) {
 1a8:	6920                	.insn	2, 0x6920
 1aa:	746e                	.insn	2, 0x746e
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	7300                	.insn	2, 0x7300
 1ae:	6f68                	.insn	2, 0x6f68
 1b0:	7472                	.insn	2, 0x7472
 1b2:	6920                	.insn	2, 0x6920
 1b4:	746e                	.insn	2, 0x746e
 1b6:	4500                	.insn	2, 0x4500
 1b8:	5458                	.insn	2, 0x5458
 1ba:	495f 5152 325f      	.insn	6, 0x325f5152495f
 1c0:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
  curbrk += incr;
 1c6:	5245                	.insn	2, 0x5245
  return ret;
 1c8:	6800                	.insn	2, 0x6800
 1ca:	6c61                	.insn	2, 0x6c61
    return (void *)-1;
 1cc:	775f 6972 6574      	.insn	6, 0x65746972775f
}
 1d2:	335f 6232 7469      	.insn	6, 0x74696232335f
}
 1d8:	4500                	.insn	2, 0x4500
 1da:	5458                	.insn	2, 0x5458
  size >>= 8;
 1dc:	495f 5152 355f      	.insn	6, 0x355f5152495f
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e2:	485f 4e41 4c44      	.insn	6, 0x4c444e41485f
 1e8:	5245                	.insn	2, 0x5245
 1ea:	5f00                	.insn	2, 0x5f00
 1ec:	6f5f 6666 745f      	.insn	6, 0x745f66666f5f
}
 1f2:	5f00                	.insn	2, 0x5f00
 1f4:	675f 6469 745f      	.insn	6, 0x745f6469675f
  snprintf(buf, 10, "%s", msg);
 1fa:	7300                	.insn	2, 0x7300
{
 1fc:	5f74                	.insn	2, 0x5f74
 1fe:	6d697463          	bgeu	s2,s6,8c6 <_svfiprintf_r+0x21e>
  snprintf(buf, 10, "%s", msg);
 202:	6300                	.insn	2, 0x6300
 204:	7275                	.insn	2, 0x7275
 206:	7262                	.insn	2, 0x7262
 208:	7473006b          	.insn	4, 0x7473006b
 20c:	625f 6f6c 6b63      	.insn	6, 0x6b636f6c625f
{
 212:	5f5f0073          	.insn	4, 0x5f5f0073
  snprintf(buf, 10, "%s", msg);
 216:	6e69                	.insn	2, 0x6e69
  while (1);
 218:	5f74                	.insn	2, 0x5f74
 21a:	656c                	.insn	2, 0x656c
 21c:	7361                	.insn	2, 0x7361
 21e:	3674                	.insn	2, 0x3674
 220:	5f34                	.insn	2, 0x5f34
 222:	0074                	.insn	2, 0x0074
 224:	655f 6978 0074      	.insn	6, 0x00746978655f
 22a:	695f7473          	.insn	4, 0x695f7473
 22e:	6f6e                	.insn	2, 0x6f6e
 230:	5f00                	.insn	2, 0x5f00
 232:	6d5f 646f 5f65      	.insn	6, 0x5f65646f6d5f
 238:	0074                	.insn	2, 0x0074
 23a:	6175                	.insn	2, 0x6175
 23c:	7472                	.insn	2, 0x7472
 23e:	695f 736e 6174      	.insn	6, 0x6174736e695f
 244:	636e                	.insn	2, 0x636e
 246:	5f65                	.insn	2, 0x5f65
 248:	0074                	.insn	2, 0x0074
 24a:	5f5f 6c62 636b      	.insn	6, 0x636b6c625f5f
 250:	746e                	.insn	2, 0x746e
 252:	745f 5f00 706f      	.insn	6, 0x706f5f00745f
 258:	6e65                	.insn	2, 0x6e65
 25a:	5f00                	.insn	2, 0x5f00
 25c:	736c                	.insn	2, 0x736c
 25e:	6565                	.insn	2, 0x6565
 260:	665f006b          	.insn	4, 0x665f006b
 264:	74617473          	.insn	4, 0x74617473
 268:	5f00                	.insn	2, 0x5f00
 26a:	70746567          	.insn	4, 0x70746567
 26e:	6469                	.insn	2, 0x6469
 270:	7300                	.insn	2, 0x7300
 272:	5f74                	.insn	2, 0x5f74
 274:	7461                	.insn	2, 0x7461
 276:	6d69                	.insn	2, 0x6d69
 278:	6300                	.insn	2, 0x6300
 27a:	746e756f          	jal	a0,e79c0 <RAM_SIZE+0xe39c0>
 27e:	5f00                	.insn	2, 0x5f00
 280:	645f 7665 745f      	.insn	6, 0x745f7665645f
 286:	7300                	.insn	2, 0x7300
 288:	5f74                	.insn	2, 0x5f74
 28a:	6975                	.insn	2, 0x6975
 28c:	0064                	.insn	2, 0x0064
 28e:	735f7473          	.insn	4, 0x735f7473
 292:	6170                	.insn	2, 0x6170
 294:	6572                	.insn	2, 0x6572
 296:	0034                	.insn	2, 0x0034
 298:	635f 6f6c 6573      	.insn	6, 0x65736f6c635f
 29e:	6500                	.insn	2, 0x6500
 2a0:	006f6863          	bltu	t5,t1,2b0 <_sniprintf_r+0x94>
 2a4:	5f5f 6568 7061      	.insn	6, 0x706165685f5f
 2aa:	655f 646e 0024      	.insn	6, 0x0024646e655f
 2b0:	4144                	.insn	2, 0x4144
 2b2:	4154                	.insn	2, 0x4154
 2b4:	5f00                	.insn	2, 0x5f00
 2b6:	6e5f 696c 6b6e      	.insn	6, 0x6b6e696c6e5f
 2bc:	745f 5f00 7369      	.insn	6, 0x73695f00745f
 2c2:	7461                	.insn	2, 0x7461
 2c4:	7974                	.insn	2, 0x7974
 2c6:	7300                	.insn	2, 0x7300
 2c8:	5f74                	.insn	2, 0x5f74
 2ca:	657a6973          	.insn	4, 0x657a6973
 2ce:	7000                	.insn	2, 0x7000
 2d0:	7274                	.insn	2, 0x7274
 2d2:	6964                	.insn	2, 0x6964
 2d4:	6666                	.insn	2, 0x6666
 2d6:	745f 5f00 7277      	.insn	6, 0x72775f00745f
 2dc:	7469                	.insn	2, 0x7469
 2de:	0065                	.insn	2, 0x0065
 2e0:	6d5f7473          	.insn	4, 0x6d5f7473
 2e4:	0065646f          	jal	s0,562ea <RAM_SIZE+0x522ea>
 2e8:	7674                	.insn	2, 0x7674
 2ea:	6e5f 6573 0063      	.insn	6, 0x006365736e5f
 2f0:	6f6c                	.insn	2, 0x6f6c
 2f2:	676e                	.insn	2, 0x676e
 2f4:	6420                	.insn	2, 0x6420
 2f6:	6c62756f          	jal	a0,279bc <RAM_SIZE+0x239bc>
 2fa:	0065                	.insn	2, 0x0065
 2fc:	7674                	.insn	2, 0x7674
 2fe:	735f 6365 5f00      	.insn	6, 0x5f006365735f
 304:	625f 6b6c 6973      	.insn	6, 0x69736b6c625f
 30a:	657a                	.insn	2, 0x657a
 30c:	745f 7400 6d69      	.insn	6, 0x6d697400745f
 312:	5f65                	.insn	2, 0x5f65
 314:	0074                	.insn	2, 0x0074
 316:	725f 6165 0064      	.insn	6, 0x00646165725f
 31c:	6e5f7473          	.insn	4, 0x6e5f7473
 320:	696c                	.insn	2, 0x696c
 322:	6b6e                	.insn	2, 0x6b6e
 324:	7300                	.insn	2, 0x7300
 326:	5f74                	.insn	2, 0x5f74
 328:	6c62                	.insn	2, 0x6c62
 32a:	7a69736b          	.insn	4, 0x7a69736b
 32e:	0065                	.insn	2, 0x0065
 330:	5f5f 6e65 2464      	.insn	6, 0x24646e655f5f
 336:	7400                	.insn	2, 0x7400
 338:	6d69                	.insn	2, 0x6d69
 33a:	7365                	.insn	2, 0x7365
 33c:	6570                	.insn	2, 0x6570
 33e:	5f5f0063          	beq	t5,s5,91e <_svfiprintf_r+0x276>
 342:	6e69                	.insn	2, 0x6e69
 344:	00745f6f          	jal	t5,45b4a <RAM_SIZE+0x41b4a>
 348:	5f5f 6568 7061      	.insn	6, 0x706165685f5f
 34e:	735f 6174 7472      	.insn	6, 0x74726174735f
 354:	0024                	.insn	2, 0x0024
 356:	725f7473          	.insn	4, 0x725f7473
 35a:	6564                	.insn	2, 0x6564
 35c:	0076                	.insn	2, 0x0076
 35e:	5f5f 6975 5f64      	.insn	6, 0x5f6469755f5f
 364:	0074                	.insn	2, 0x0074
 366:	6b5f 6c69 006c      	.insn	6, 0x006c6c696b5f
 36c:	675f7473          	.insn	4, 0x675f7473
 370:	6469                	.insn	2, 0x6469
 372:	7300                	.insn	2, 0x7300
 374:	6174                	.insn	2, 0x6174
 376:	7574                	.insn	2, 0x7574
 378:	74730073          	.insn	4, 0x74730073
 37c:	645f 7665 6800      	.insn	6, 0x68007665645f
 382:	7865                	.insn	2, 0x7865
 384:	705f 6972 746e      	.insn	6, 0x746e6972705f
 38a:	5f00                	.insn	2, 0x5f00
 38c:	7a697373          	.insn	4, 0x7a697373
 390:	5f65                	.insn	2, 0x5f65
 392:	0074                	.insn	2, 0x0074
 394:	6d5f7473          	.insn	4, 0x6d5f7473
 398:	6974                	.insn	2, 0x6974
 39a:	006d                	.insn	2, 0x006d
 39c:	6e69                	.insn	2, 0x6e69
 39e:	5f007263          	bgeu	zero,a6,982 <_svfiprintf_r+0x2da>
 3a2:	6b726273          	.insn	4, 0x6b726273
 3a6:	5f00                	.insn	2, 0x5f00
 3a8:	4f495047          	.insn	4, 0x4f495047
 3ac:	5f00                	.insn	2, 0x5f00
 3ae:	4942                	.insn	2, 0x4942
 3b0:	5354                	.insn	2, 0x5354
 3b2:	0038                	.insn	2, 0x0038
 3b4:	6f697067          	.insn	4, 0x6f697067
 3b8:	695f 736e 6174      	.insn	6, 0x6174736e695f
 3be:	636e                	.insn	2, 0x636e
 3c0:	5f65                	.insn	2, 0x5f65
 3c2:	0074                	.insn	2, 0x0074
 3c4:	6974                	.insn	2, 0x6974
 3c6:	656d                	.insn	2, 0x656d
 3c8:	5f72                	.insn	2, 0x5f72
 3ca:	6e69                	.insn	2, 0x6e69
 3cc:	6e617473          	.insn	4, 0x6e617473
 3d0:	745f6563          	bltu	t5,t0,b1a <_printf_common+0xe2>
 3d4:	6c00                	.insn	2, 0x6c00
 3d6:	00706f6f          	jal	t5,6bdc <RAM_SIZE+0x2bdc>
 3da:	4854                	.insn	2, 0x4854
 3dc:	4552                	.insn	2, 0x4552
 3de:	4c4f4853          	.insn	4, 0x4c4f4853
 3e2:	0044                	.insn	2, 0x0044
 3e4:	72706e73          	.insn	4, 0x72706e73
 3e8:	6e69                	.insn	2, 0x6e69
 3ea:	6674                	.insn	2, 0x6674
 3ec:	7000                	.insn	2, 0x7000
 3ee:	6e69                	.insn	2, 0x6e69
 3f0:	49540073          	.insn	4, 0x49540073
 3f4:	454d                	.insn	2, 0x454d
 3f6:	0052                	.insn	2, 0x0052
 3f8:	616d                	.insn	2, 0x616d
 3fa:	6e69                	.insn	2, 0x6e69
 3fc:	5500                	.insn	2, 0x5500
 3fe:	5241                	.insn	2, 0x5241
 400:	0054                	.insn	2, 0x0054
 402:	2e2e                	.insn	2, 0x2e2e
 404:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
 408:	2e2e                	.insn	2, 0x2e2e
 40a:	672f2e2f          	.insn	4, 0x672f2e2f
 40e:	6c2f6363          	bltu	t5,sp,ad4 <_printf_common+0x9c>
 412:	6269                	.insn	2, 0x6269
 414:	2f636367          	.insn	4, 0x2f636367
 418:	666e6f63          	bltu	t3,t1,a96 <_printf_common+0x5e>
 41c:	6769                	.insn	2, 0x6769
 41e:	7369722f          	.insn	4, 0x7369722f
 422:	642f7663          	bgeu	t5,sp,a6e <_printf_common+0x36>
 426:	7669                	.insn	2, 0x7669
 428:	532e                	.insn	2, 0x532e
 42a:	2f00                	.insn	2, 0x2f00
 42c:	6f68                	.insn	2, 0x6f68
 42e:	656d                	.insn	2, 0x656d
 430:	6e74732f          	.insn	4, 0x6e74732f
 434:	69746c6f          	jal	s8,472ca <RAM_SIZE+0x432ca>
 438:	676e                	.insn	2, 0x676e
 43a:	706d742f          	.insn	4, 0x706d742f
 43e:	6776722f          	.insn	4, 0x6776722f
 442:	722f6363          	bltu	t5,sp,b68 <_printf_common+0x130>
 446:	7369                	.insn	2, 0x7369
 448:	672d7663          	bgeu	s10,s2,ab4 <_printf_common+0x7c>
 44c:	756e                	.insn	2, 0x756e
 44e:	742d                	.insn	2, 0x742d
 450:	636c6f6f          	jal	t5,c6a86 <RAM_SIZE+0xc2a86>
 454:	6168                	.insn	2, 0x6168
 456:	6e69                	.insn	2, 0x6e69
 458:	6975622f          	.insn	4, 0x6975622f
 45c:	646c                	.insn	2, 0x646c
 45e:	672d                	.insn	2, 0x672d
 460:	6e2d6363          	bltu	s10,sp,b46 <_printf_common+0x10e>
 464:	7765                	.insn	2, 0x7765
 466:	696c                	.insn	2, 0x696c
 468:	2d62                	.insn	2, 0x2d62
 46a:	67617473          	.insn	4, 0x67617473
 46e:	3265                	.insn	2, 0x3265
 470:	7369722f          	.insn	4, 0x7369722f
 474:	32337663          	bgeu	t1,gp,7a0 <_svfiprintf_r+0xf8>
 478:	752d                	.insn	2, 0x752d
 47a:	6b6e                	.insn	2, 0x6b6e
 47c:	6f6e                	.insn	2, 0x6f6e
 47e:	652d6e77          	.insn	4, 0x652d6e77
 482:	666c                	.insn	2, 0x666c
 484:	62696c2f          	.insn	4, 0x62696c2f
 488:	00636367          	.insn	4, 0x00636367
 48c:	5f5f 6964 7376      	.insn	6, 0x737669645f5f
 492:	3369                	.insn	2, 0x3369
 494:	5f00                	.insn	2, 0x5f00
 496:	685f 6469 6564      	.insn	6, 0x65646469685f
 49c:	5f6e                	.insn	2, 0x5f6e
 49e:	5f5f 6475 7669      	.insn	6, 0x766964755f5f
 4a4:	00336973          	.insn	4, 0x00336973
 4a8:	5f5f 6d75 646f      	.insn	6, 0x646f6d755f5f
 4ae:	00336973          	.insn	4, 0x00336973
 4b2:	5f5f 6f6d 7364      	.insn	6, 0x73646f6d5f5f
 4b8:	3369                	.insn	2, 0x3369
	...

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
    la gp, __global_pointer$
   0:	0070                	.insn	2, 0x0070
   2:	0000                	.insn	2, 0x
   4:	0005                	.insn	2, 0x0005
   6:	0004                	.insn	2, 0x0004
    la a4, _sdata_load$
   8:	0000                	.insn	2, 0x
   a:	0000                	.insn	2, 0x
   c:	5804                	.insn	2, 0x5804
   e:	045f0163          	beq	t5,t0,50 <_bss_zero_loop+0xc>
    la a5, _sdata$
  12:	6f64                	.insn	2, 0x6f64
  14:	5f01                	.insn	2, 0x5f01
  16:	7004                	.insn	2, 0x7004
    la a6, _edata$
  18:	5f0100fb          	.insn	4, 0x5f0100fb
  1c:	fc04                	.insn	2, 0xfc04
  1e:	8700                	.insn	2, 0x8700
    lw a7, 0(a4)
  20:	0101                	.insn	2, 0x0101
  22:	045f 0188 0193      	.insn	6, 0x01930188045f
    addi a5, a5, 0x04
  28:	5f01                	.insn	2, 0x5f01
  2a:	9404                	.insn	2, 0x9404
    addi a4, a4, 0x04
  2c:	9801                	.insn	2, 0x9801
  2e:	0101                	.insn	2, 0x0101
    blt a5, a6, _data_copy_loop
  30:	005f 3004 0134      	.insn	6, 0x01343004005f
    la a4, _sbss$
  36:	045a                	.insn	2, 0x045a
  38:	3c34                	.insn	2, 0x3c34
  3a:	a30a                	.insn	2, 0xa30a
    la a5, _ebss$
  3c:	260aa503          	lw	a0,608(s5)
  40:	2da8                	.insn	2, 0x2da8
  42:	00a8                	.insn	2, 0x00a8
    sw zero, 0(a4)
  44:	009f 2004 0124      	.insn	6, 0x01242004009f
    addi a4, a4, 0x04
  4a:	045a                	.insn	2, 0x045a
    blt a4, a5, _bss_zero_loop
  4c:	3024                	.insn	2, 0x3024
  4e:	a30a                	.insn	2, 0xa30a
    la a4, __heap_start$
  50:	260aa503          	lw	a0,608(s5)
  54:	2da8                	.insn	2, 0x2da8
  56:	00a8                	.insn	2, 0x00a8
    la a5, __heap_end$
  58:	009f 2404 0128      	.insn	6, 0x01282404009f
  5e:	005a                	.insn	2, 0x005a
    sw zero, 0(a4)
  60:	1804                	.insn	2, 0x1804
  62:	011c                	.insn	2, 0x011c
    addi a4, a4, 0x04
  64:	045a                	.insn	2, 0x045a
  66:	201c                	.insn	2, 0x201c
    blt a4, a5, _heap_zero_loop
  68:	a30a                	.insn	2, 0xa30a
  6a:	260aa503          	lw	a0,608(s5)
    li a4, 0
  6e:	2da8                	.insn	2, 0x2da8
    li a5, 0
  70:	00a8                	.insn	2, 0x00a8
  72:	009f 0145 0000      	.insn	6, 0x0145009f
    la sp, __stack_top$
  78:	0005                	.insn	2, 0x0005
  7a:	0004                	.insn	2, 0x0004
  7c:	0000                	.insn	2, 0x
  7e:	0000                	.insn	2, 0x
    la t0, _MSYSIE
  80:	a004                	.insn	2, 0xa004
  82:	b001                	.insn	2, 0xb001
  84:	0101                	.insn	2, 0x0101
  86:	045a                	.insn	2, 0x045a
    csrrw t0, mtvec, t0
  88:	01b0                	.insn	2, 0x01b0
  8a:	01b4                	.insn	2, 0x01b4
    call main
  8c:	a30a                	.insn	2, 0xa30a
  8e:	260aa503          	lw	a0,608(s5)
    j _halt
  92:	2da8                	.insn	2, 0x2da8
    mret
  94:	00a8                	.insn	2, 0x00a8
  96:	009f a004 a401      	.insn	6, 0xa401a004009f
}
  9c:	0101                	.insn	2, 0x0101
  9e:	01a4045b          	.insn	4, 0x01a4045b
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a2:	01b4                	.insn	2, 0x01b4
}
  a4:	a30a                	.insn	2, 0xa30a
  a6:	260ba503          	lw	a0,608(s7)
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  aa:	2da8                	.insn	2, 0x2da8
}
  ac:	00a8                	.insn	2, 0x00a8
  ae:	009f a004 a401      	.insn	6, 0xa401a004009f
}
  b4:	0101                	.insn	2, 0x0101
  b6:	01a4045b          	.insn	4, 0x01a4045b
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  ba:	01ac                	.insn	2, 0x01ac
}
  bc:	a30a                	.insn	2, 0xa30a
  be:	260ba503          	lw	a0,608(s7)
  c2:	2da8                	.insn	2, 0x2da8
  c4:	00a8                	.insn	2, 0x00a8
  c6:	009f a004 a401      	.insn	6, 0xa401a004009f
}
  cc:	0501                	.insn	2, 0x0501
  ce:	2548007b          	.insn	4, 0x2548007b
  d2:	049f 01a4 01ac      	.insn	6, 0x01ac01a4049f
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  d8:	5b01                	.insn	2, 0x5b01
  da:	0400                	.insn	2, 0x0400
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	0198                	.insn	2, 0x0198
  de:	019c                	.insn	2, 0x019c
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e0:	5a01                	.insn	2, 0x5a01
  e2:	9c04                	.insn	2, 0x9c04
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	a001                	.insn	2, 0xa001
  e6:	0a01                	.insn	2, 0x0a01
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	0aa503a3          	sb	a0,167(a0) # 300031d <RAM_SIZE+0x2ffc31d>
  uint32_t cause = hal_read_csr(mcause);
  ec:	a826                	.insn	2, 0xa826
  ee:	a82d                	.insn	2, 0xa82d
  if (cause & EXT_SYS_I0_IE)
  f0:	9f00                	.insn	2, 0x9f00
  f2:	0400                	.insn	2, 0x0400
  f4:	746c                	.insn	2, 0x746c
  f6:	5a01                	.insn	2, 0x5a01
    EXT_IRQ_0_HANDLER();
  f8:	7404                	.insn	2, 0x7404
  fa:	00fc                	.insn	2, 0x00fc
  else if (cause & EXT_SYS_I1_IE)
  fc:	5f01                	.insn	2, 0x5f01
  fe:	fc04                	.insn	2, 0xfc04
 100:	9800                	.insn	2, 0x9800
 102:	0a01                	.insn	2, 0x0a01
    EXT_IRQ_1_HANDLER();
 104:	0aa503a3          	sb	a0,167(a0)
  else if (cause & EXT_SYS_I2_IE)
 108:	a826                	.insn	2, 0xa826
 10a:	a82d                	.insn	2, 0xa82d
 10c:	9f00                	.insn	2, 0x9f00
 10e:	0400                	.insn	2, 0x0400
    EXT_IRQ_2_HANDLER();
 110:	886c                	.insn	2, 0x886c
 112:	0201                	.insn	2, 0x0201
  else if (cause & EXT_SYS_I3_IE)
 114:	9f30                	.insn	2, 0x9f30
 116:	8804                	.insn	2, 0x8804
 118:	9001                	.insn	2, 0x9001
 11a:	0101                	.insn	2, 0x0101
    EXT_IRQ_3_HANDLER();
 11c:	045a                	.insn	2, 0x045a
 11e:	0190                	.insn	2, 0x0190
  else if (cause & EXT_SYS_I4_IE)
 120:	0198                	.insn	2, 0x0198
 122:	3002                	.insn	2, 0x3002
 124:	009f 5404 0158      	.insn	6, 0x01585404009f
    EXT_IRQ_4_HANDLER();
 12a:	045a                	.insn	2, 0x045a
  else if (cause & EXT_SYS_I5_IE)
 12c:	5c58                	.insn	2, 0x5c58
 12e:	a30a                	.insn	2, 0xa30a
 130:	260aa503          	lw	a0,608(s5)
    EXT_IRQ_5_HANDLER();
 134:	2da8                	.insn	2, 0x2da8
 136:	00a8                	.insn	2, 0x00a8
}
 138:	009f 4c04 0150      	.insn	6, 0x01504c04009f
  size >>= 8;
 13e:	045a                	.insn	2, 0x045a
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	5450                	.insn	2, 0x5450
 142:	a30a                	.insn	2, 0xa30a
 144:	260aa503          	lw	a0,608(s5)
}
 148:	2da8                	.insn	2, 0x2da8
 14a:	00a8                	.insn	2, 0x00a8
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	009f 3c04 0148      	.insn	6, 0x01483c04009f
  while (*ptr)
 152:	045a                	.insn	2, 0x045a
 154:	4c48                	.insn	2, 0x4c48
 156:	a30a                	.insn	2, 0xa30a
}
 158:	260aa503          	lw	a0,608(s5)
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	2da8                	.insn	2, 0x2da8
 15e:	00a8                	.insn	2, 0x00a8
 160:	009f 1004 011c      	.insn	6, 0x011c1004009f
 166:	045a                	.insn	2, 0x045a
}
 168:	201c                	.insn	2, 0x201c
 16a:	a30a                	.insn	2, 0xa30a
 16c:	260aa503          	lw	a0,608(s5)
int _close(int fd) {
 170:	2da8                	.insn	2, 0x2da8
 172:	00a8                	.insn	2, 0x00a8
 174:	049f 2c20 5a01      	.insn	6, 0x5a012c20049f
  st->st_mode = S_IFCHR;
 17a:	0400                	.insn	2, 0x0400
 17c:	2410                	.insn	2, 0x2410
 17e:	5b01                	.insn	2, 0x5b01
}
 180:	2404                	.insn	2, 0x2404
 182:	012c                	.insn	2, 0x012c
 184:	0004005b          	.insn	4, 0x0004005b
}
 188:	0104                	.insn	2, 0x0104
 18a:	045a                	.insn	2, 0x045a
 18c:	1004                	.insn	2, 0x1004
 18e:	a30a                	.insn	2, 0xa30a
}
 190:	260aa503          	lw	a0,608(s5)
 194:	2da8                	.insn	2, 0x2da8
 196:	00a8                	.insn	2, 0x00a8
  while (1);
 198:	009f 0004 0504      	.insn	6, 0x05040004009f
}
 19e:	007a                	.insn	2, 0x007a
}
 1a0:	2548                	.insn	2, 0x2548
 1a2:	049f 1004 5a01      	.insn	6, 0x5a011004049f
void *_sbrk(ptrdiff_t incr) {
 1a8:	0400                	.insn	2, 0x0400
 1aa:	302c                	.insn	2, 0x302c
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	5a01                	.insn	2, 0x5a01
 1ae:	3004                	.insn	2, 0x3004
 1b0:	0a34                	.insn	2, 0x0a34
 1b2:	0aa503a3          	sb	a0,167(a0)
 1b6:	a826                	.insn	2, 0xa826
 1b8:	a82d                	.insn	2, 0xa82d
 1ba:	9f00                	.insn	2, 0x9f00
 1bc:	2100                	.insn	2, 0x2100
 1be:	0000                	.insn	2, 0x
 1c0:	0500                	.insn	2, 0x0500
 1c2:	0400                	.insn	2, 0x0400
  curbrk += incr;
 1c4:	0000                	.insn	2, 0x
 1c6:	0000                	.insn	2, 0x
  return ret;
 1c8:	0600                	.insn	2, 0x0600
 1ca:	01f0                	.insn	2, 0x01f0
    return (void *)-1;
 1cc:	0000                	.insn	2, 0x
 1ce:	0004                	.insn	2, 0x0004
}
 1d0:	0104                	.insn	2, 0x0104
 1d2:	045a                	.insn	2, 0x045a
}
 1d4:	0804                	.insn	2, 0x0804
 1d6:	a30a                	.insn	2, 0xa30a
 1d8:	260aa503          	lw	a0,608(s5)
  size >>= 8;
 1dc:	2da8                	.insn	2, 0x2da8
 1de:	00a8                	.insn	2, 0x00a8
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e0:	Address 0x1e0 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
    la gp, __global_pointer$
   0:	000c                	.insn	2, 0x000c
   2:	0000                	.insn	2, 0x
   4:	ffff                	.insn	2, 0xffff
   6:	ffff                	.insn	2, 0xffff
    la a4, _sdata_load$
   8:	7c010003          	lb	zero,1984(sp) # e030c34 <RAM_SIZE+0xe02cc34>
   c:	0d01                	.insn	2, 0x0d01
   e:	0002                	.insn	2, 0x0002
    la a5, _sdata$
  10:	000c                	.insn	2, 0x000c
  12:	0000                	.insn	2, 0x
  14:	0000                	.insn	2, 0x
  16:	0000                	.insn	2, 0x
    la a6, _edata$
  18:	0098                	.insn	2, 0x0098
  1a:	0000                	.insn	2, 0x
  1c:	0008                	.insn	2, 0x0008
  1e:	0000                	.insn	2, 0x
    lw a7, 0(a4)
  20:	000c                	.insn	2, 0x000c
  22:	0000                	.insn	2, 0x
    sw a7, 0(a5)
  24:	0000                	.insn	2, 0x
  26:	0000                	.insn	2, 0x
    addi a5, a5, 0x04
  28:	00a0                	.insn	2, 0x00a0
  2a:	0000                	.insn	2, 0x
    addi a4, a4, 0x04
  2c:	0008                	.insn	2, 0x0008
  2e:	0000                	.insn	2, 0x
    blt a5, a6, _data_copy_loop
  30:	000c                	.insn	2, 0x000c
  32:	0000                	.insn	2, 0x
    la a4, _sbss$
  34:	0000                	.insn	2, 0x
  36:	0000                	.insn	2, 0x
  38:	00a8                	.insn	2, 0x00a8
  3a:	0000                	.insn	2, 0x
    la a5, _ebss$
  3c:	0008                	.insn	2, 0x0008
  3e:	0000                	.insn	2, 0x
  40:	000c                	.insn	2, 0x000c
  42:	0000                	.insn	2, 0x
    sw zero, 0(a4)
  44:	0000                	.insn	2, 0x
  46:	0000                	.insn	2, 0x
    addi a4, a4, 0x04
  48:	00b0                	.insn	2, 0x00b0
  4a:	0000                	.insn	2, 0x
    blt a4, a5, _bss_zero_loop
  4c:	0008                	.insn	2, 0x0008
  4e:	0000                	.insn	2, 0x
    la a4, __heap_start$
  50:	000c                	.insn	2, 0x000c
  52:	0000                	.insn	2, 0x
  54:	0000                	.insn	2, 0x
  56:	0000                	.insn	2, 0x
    la a5, __heap_end$
  58:	00b8                	.insn	2, 0x00b8
  5a:	0000                	.insn	2, 0x
  5c:	0010                	.insn	2, 0x0010
  5e:	0000                	.insn	2, 0x
    sw zero, 0(a4)
  60:	000c                	.insn	2, 0x000c
  62:	0000                	.insn	2, 0x
    addi a4, a4, 0x04
  64:	0000                	.insn	2, 0x
  66:	0000                	.insn	2, 0x
    blt a4, a5, _heap_zero_loop
  68:	00c8                	.insn	2, 0x00c8
  6a:	0000                	.insn	2, 0x
    li a4, 0
  6c:	000c                	.insn	2, 0x000c
  6e:	0000                	.insn	2, 0x
    li a5, 0
  70:	000c                	.insn	2, 0x000c
  72:	0000                	.insn	2, 0x
    li a6, 0
  74:	0000                	.insn	2, 0x
  76:	0000                	.insn	2, 0x
    la sp, __stack_top$
  78:	00d4                	.insn	2, 0x00d4
  7a:	0000                	.insn	2, 0x
  7c:	0004                	.insn	2, 0x0004
  7e:	0000                	.insn	2, 0x
    la t0, _MSYSIE
  80:	000c                	.insn	2, 0x000c
  82:	0000                	.insn	2, 0x
  84:	0000                	.insn	2, 0x
  86:	0000                	.insn	2, 0x
    csrrw t0, mtvec, t0
  88:	00d8                	.insn	2, 0x00d8
  8a:	0000                	.insn	2, 0x
    call main
  8c:	0004                	.insn	2, 0x0004
  8e:	0000                	.insn	2, 0x
    j _halt
  90:	000c                	.insn	2, 0x000c
  92:	0000                	.insn	2, 0x
    mret
  94:	0000                	.insn	2, 0x
  96:	0000                	.insn	2, 0x
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
  98:	00dc                	.insn	2, 0x00dc
  9a:	0000                	.insn	2, 0x
}
  9c:	0004                	.insn	2, 0x0004
  9e:	0000                	.insn	2, 0x
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a0:	000c                	.insn	2, 0x000c
  a2:	0000                	.insn	2, 0x
}
  a4:	0000                	.insn	2, 0x
  a6:	0000                	.insn	2, 0x
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
  a8:	00e0                	.insn	2, 0x00e0
  aa:	0000                	.insn	2, 0x
}
  ac:	0004                	.insn	2, 0x0004
  ae:	0000                	.insn	2, 0x
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b0:	000c                	.insn	2, 0x000c
  b2:	0000                	.insn	2, 0x
}
  b4:	0000                	.insn	2, 0x
  b6:	0000                	.insn	2, 0x
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
  b8:	00e4                	.insn	2, 0x00e4
  ba:	0000                	.insn	2, 0x
}
  bc:	0004                	.insn	2, 0x0004
  be:	0000                	.insn	2, 0x
  c0:	000c                	.insn	2, 0x000c
  c2:	0000                	.insn	2, 0x
  c4:	0000                	.insn	2, 0x
  c6:	0000                	.insn	2, 0x
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
  c8:	00e8                	.insn	2, 0x00e8
  ca:	0000                	.insn	2, 0x
}
  cc:	0004                	.insn	2, 0x0004
  ce:	0000                	.insn	2, 0x
  d0:	000c                	.insn	2, 0x000c
  d2:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
  d4:	0000                	.insn	2, 0x
  d6:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
  d8:	00ec                	.insn	2, 0x00ec
  da:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
  dc:	0050                	.insn	2, 0x0050
  de:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
  e0:	000c                	.insn	2, 0x000c
  e2:	0000                	.insn	2, 0x
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
  e4:	ffff                	.insn	2, 0xffff
  e6:	ffff                	.insn	2, 0xffff
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
  e8:	7c010003          	lb	zero,1984(sp)
  uint32_t cause = hal_read_csr(mcause);
  ec:	0d01                	.insn	2, 0x0d01
  ee:	0002                	.insn	2, 0x0002
  if (cause & EXT_SYS_I0_IE)
  f0:	000c                	.insn	2, 0x000c
  f2:	0000                	.insn	2, 0x
  f4:	00e0                	.insn	2, 0x00e0
  f6:	0000                	.insn	2, 0x
    EXT_IRQ_0_HANDLER();
  f8:	013c                	.insn	2, 0x013c
  fa:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I1_IE)
  fc:	0010                	.insn	2, 0x0010
  fe:	0000                	.insn	2, 0x
 100:	000c                	.insn	2, 0x000c
 102:	0000                	.insn	2, 0x
    EXT_IRQ_1_HANDLER();
 104:	00e0                	.insn	2, 0x00e0
 106:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I2_IE)
 108:	014c                	.insn	2, 0x014c
 10a:	0000                	.insn	2, 0x
 10c:	001c                	.insn	2, 0x001c
 10e:	0000                	.insn	2, 0x
    EXT_IRQ_2_HANDLER();
 110:	000c                	.insn	2, 0x000c
 112:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I3_IE)
 114:	00e0                	.insn	2, 0x00e0
 116:	0000                	.insn	2, 0x
 118:	0168                	.insn	2, 0x0168
 11a:	0000                	.insn	2, 0x
    EXT_IRQ_3_HANDLER();
 11c:	0008                	.insn	2, 0x0008
 11e:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I4_IE)
 120:	000c                	.insn	2, 0x000c
 122:	0000                	.insn	2, 0x
 124:	00e0                	.insn	2, 0x00e0
 126:	0000                	.insn	2, 0x
    EXT_IRQ_4_HANDLER();
 128:	0170                	.insn	2, 0x0170
 12a:	0000                	.insn	2, 0x
  else if (cause & EXT_SYS_I5_IE)
 12c:	0008                	.insn	2, 0x0008
 12e:	0000                	.insn	2, 0x
 130:	000c                	.insn	2, 0x000c
 132:	0000                	.insn	2, 0x
    EXT_IRQ_5_HANDLER();
 134:	00e0                	.insn	2, 0x00e0
 136:	0000                	.insn	2, 0x
}
 138:	0178                	.insn	2, 0x0178
 13a:	0000                	.insn	2, 0x
  size >>= 8;
 13c:	0010                	.insn	2, 0x0010
 13e:	0000                	.insn	2, 0x
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 140:	000c                	.insn	2, 0x000c
 142:	0000                	.insn	2, 0x
 144:	00e0                	.insn	2, 0x00e0
 146:	0000                	.insn	2, 0x
}
 148:	0188                	.insn	2, 0x0188
 14a:	0000                	.insn	2, 0x
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 14c:	0008                	.insn	2, 0x0008
 14e:	0000                	.insn	2, 0x
  while (*ptr)
 150:	000c                	.insn	2, 0x000c
 152:	0000                	.insn	2, 0x
 154:	00e0                	.insn	2, 0x00e0
 156:	0000                	.insn	2, 0x
}
 158:	0190                	.insn	2, 0x0190
 15a:	0000                	.insn	2, 0x
    ((uart_instance_t *)(UART_BASE))->DATA = *ptr++;
 15c:	0008                	.insn	2, 0x0008
 15e:	0000                	.insn	2, 0x
 160:	000c                	.insn	2, 0x000c
 162:	0000                	.insn	2, 0x
 164:	00e0                	.insn	2, 0x00e0
 166:	0000                	.insn	2, 0x
}
 168:	0198                	.insn	2, 0x0198
 16a:	0000                	.insn	2, 0x
 16c:	0004                	.insn	2, 0x0004
 16e:	0000                	.insn	2, 0x
int _close(int fd) {
 170:	000c                	.insn	2, 0x000c
 172:	0000                	.insn	2, 0x
 174:	00e0                	.insn	2, 0x00e0
 176:	0000                	.insn	2, 0x
  st->st_mode = S_IFCHR;
 178:	019c                	.insn	2, 0x019c
 17a:	0000                	.insn	2, 0x
 17c:	0004                	.insn	2, 0x0004
 17e:	0000                	.insn	2, 0x
}
 180:	000c                	.insn	2, 0x000c
 182:	0000                	.insn	2, 0x
 184:	00e0                	.insn	2, 0x00e0
 186:	0000                	.insn	2, 0x
}
 188:	01a0                	.insn	2, 0x01a0
 18a:	0000                	.insn	2, 0x
 18c:	0008                	.insn	2, 0x0008
 18e:	0000                	.insn	2, 0x
}
 190:	000c                	.insn	2, 0x000c
 192:	0000                	.insn	2, 0x
 194:	00e0                	.insn	2, 0x00e0
 196:	0000                	.insn	2, 0x
  while (1);
 198:	01a8                	.insn	2, 0x01a8
 19a:	0000                	.insn	2, 0x
}
 19c:	002c                	.insn	2, 0x002c
 19e:	0000                	.insn	2, 0x
}
 1a0:	000c                	.insn	2, 0x000c
 1a2:	0000                	.insn	2, 0x
 1a4:	00e0                	.insn	2, 0x00e0
 1a6:	0000                	.insn	2, 0x
void *_sbrk(ptrdiff_t incr) {
 1a8:	01d4                	.insn	2, 0x01d4
 1aa:	0000                	.insn	2, 0x
  if (((curbrk + incr) < &__end$) || ((curbrk + incr) > &__heap_end$)) {
 1ac:	0008                	.insn	2, 0x0008
 1ae:	0000                	.insn	2, 0x
 1b0:	000c                	.insn	2, 0x000c
 1b2:	0000                	.insn	2, 0x
 1b4:	00e0                	.insn	2, 0x00e0
 1b6:	0000                	.insn	2, 0x
 1b8:	01dc                	.insn	2, 0x01dc
 1ba:	0000                	.insn	2, 0x
 1bc:	0014                	.insn	2, 0x0014
 1be:	0000                	.insn	2, 0x
 1c0:	000c                	.insn	2, 0x000c
 1c2:	0000                	.insn	2, 0x
  curbrk += incr;
 1c4:	ffff                	.insn	2, 0xffff
 1c6:	ffff                	.insn	2, 0xffff
  return ret;
 1c8:	7c010003          	lb	zero,1984(sp)
    return (void *)-1;
 1cc:	0d01                	.insn	2, 0x0d01
 1ce:	0002                	.insn	2, 0x0002
}
 1d0:	000c                	.insn	2, 0x000c
 1d2:	0000                	.insn	2, 0x
}
 1d4:	01c0                	.insn	2, 0x01c0
 1d6:	0000                	.insn	2, 0x
 1d8:	01f0                	.insn	2, 0x01f0
 1da:	0000                	.insn	2, 0x
  size >>= 8;
 1dc:	0008                	.insn	2, 0x0008
 1de:	0000                	.insn	2, 0x
  ((uart_instance_t *)(UART_BASE))->DATA = size;
 1e0:	0014                	.insn	2, 0x0014
 1e2:	0000                	.insn	2, 0x
 1e4:	01c0                	.insn	2, 0x01c0
 1e6:	0000                	.insn	2, 0x
 1e8:	01f8                	.insn	2, 0x01f8
 1ea:	0000                	.insn	2, 0x
 1ec:	0024                	.insn	2, 0x0024
 1ee:	0000                	.insn	2, 0x
}
 1f0:	0e48                	.insn	2, 0x0e48
 1f2:	5410                	.insn	2, 0x5410
 1f4:	0181                	.insn	2, 0x0181
	...

Disassembly of section .debug_rnglists:

00000000 <.debug_rnglists>:
    la gp, __global_pointer$
   0:	0015                	.insn	2, 0x0015
   2:	0000                	.insn	2, 0x
   4:	0005                	.insn	2, 0x0005
   6:	0004                	.insn	2, 0x0004
    la a4, _sdata_load$
   8:	0000                	.insn	2, 0x
   a:	0000                	.insn	2, 0x
   c:	0001f007          	.insn	4, 0x0001f007
    la a5, _sdata$
  10:	0800                	.insn	2, 0x0800
  12:	0001f807          	.insn	4, 0x0001f807
  16:	2400                	.insn	2, 0x2400
	...
