
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <_start>:
80000000:	10001197          	auipc	gp,0x10001
80000004:	80018193          	addi	gp,gp,-2048 # 90000800 <__global_pointer$>
80000008:	00000717          	auipc	a4,0x0
8000000c:	24870713          	addi	a4,a4,584 # 80000250 <_sdata_load$>
80000010:	10000797          	auipc	a5,0x10000
80000014:	ff078793          	addi	a5,a5,-16 # 90000000 <RAM_START_ADDRESS>
80000018:	10000817          	auipc	a6,0x10000
8000001c:	fe880813          	addi	a6,a6,-24 # 90000000 <RAM_START_ADDRESS>

80000020 <_data_copy_loop>:
80000020:	00072883          	lw	a7,0(a4)
80000024:	0117a023          	sw	a7,0(a5)
80000028:	00478793          	addi	a5,a5,4
8000002c:	00470713          	addi	a4,a4,4
80000030:	ff07c8e3          	blt	a5,a6,80000020 <_data_copy_loop>
80000034:	10000717          	auipc	a4,0x10000
80000038:	fcc70713          	addi	a4,a4,-52 # 90000000 <RAM_START_ADDRESS>
8000003c:	10000797          	auipc	a5,0x10000
80000040:	fc478793          	addi	a5,a5,-60 # 90000000 <RAM_START_ADDRESS>

80000044 <_bss_zero_loop>:
80000044:	00072023          	sw	zero,0(a4)
80000048:	00470713          	addi	a4,a4,4
8000004c:	fef74ce3          	blt	a4,a5,80000044 <_bss_zero_loop>
80000050:	10000717          	auipc	a4,0x10000
80000054:	fb070713          	addi	a4,a4,-80 # 90000000 <RAM_START_ADDRESS>
80000058:	10000797          	auipc	a5,0x10000
8000005c:	3a878793          	addi	a5,a5,936 # 90000400 <__heap_end$>

80000060 <_heap_zero_loop>:
80000060:	00072023          	sw	zero,0(a4)
80000064:	00470713          	addi	a4,a4,4
80000068:	fef74ce3          	blt	a4,a5,80000060 <_heap_zero_loop>
8000006c:	00000713          	li	a4,0
80000070:	00000793          	li	a5,0
80000074:	00000813          	li	a6,0
80000078:	10004117          	auipc	sp,0x10004
8000007c:	b8810113          	addi	sp,sp,-1144 # 90003c00 <__stack_top$>
80000080:	00000297          	auipc	t0,0x0
80000084:	01428293          	addi	t0,t0,20 # 80000094 <_MSYSIE>
80000088:	305292f3          	csrrw	t0,mtvec,t0
8000008c:	19c000ef          	jal	80000228 <main>

80000090 <_halt>:
80000090:	0000006f          	j	80000090 <_halt>

80000094 <_MSYSIE>:
80000094:	f8010113          	addi	sp,sp,-128
80000098:	06112e23          	sw	ra,124(sp)
8000009c:	06512c23          	sw	t0,120(sp)
800000a0:	06612a23          	sw	t1,116(sp)
800000a4:	06712823          	sw	t2,112(sp)
800000a8:	07c12623          	sw	t3,108(sp)
800000ac:	07d12423          	sw	t4,104(sp)
800000b0:	07e12223          	sw	t5,100(sp)
800000b4:	07f12023          	sw	t6,96(sp)
800000b8:	04a12e23          	sw	a0,92(sp)
800000bc:	04b12c23          	sw	a1,88(sp)
800000c0:	04c12a23          	sw	a2,84(sp)
800000c4:	04d12823          	sw	a3,80(sp)
800000c8:	04e12623          	sw	a4,76(sp)
800000cc:	04f12423          	sw	a5,72(sp)
800000d0:	05012223          	sw	a6,68(sp)
800000d4:	05112023          	sw	a7,64(sp)
800000d8:	02812e23          	sw	s0,60(sp)
800000dc:	02912c23          	sw	s1,56(sp)
800000e0:	03212a23          	sw	s2,52(sp)
800000e4:	03312823          	sw	s3,48(sp)
800000e8:	03412623          	sw	s4,44(sp)
800000ec:	03512423          	sw	s5,40(sp)
800000f0:	03612223          	sw	s6,36(sp)
800000f4:	03712023          	sw	s7,32(sp)
800000f8:	01812e23          	sw	s8,28(sp)
800000fc:	01912c23          	sw	s9,24(sp)
80000100:	01a12a23          	sw	s10,20(sp)
80000104:	01b12823          	sw	s11,16(sp)
80000108:	0d0000ef          	jal	800001d8 <BASE_IRQ_HANDLER>
8000010c:	07c12083          	lw	ra,124(sp)
80000110:	07812283          	lw	t0,120(sp)
80000114:	07412303          	lw	t1,116(sp)
80000118:	07012383          	lw	t2,112(sp)
8000011c:	06c12e03          	lw	t3,108(sp)
80000120:	06812e83          	lw	t4,104(sp)
80000124:	06412f03          	lw	t5,100(sp)
80000128:	06012f83          	lw	t6,96(sp)
8000012c:	05c12503          	lw	a0,92(sp)
80000130:	05812583          	lw	a1,88(sp)
80000134:	05412603          	lw	a2,84(sp)
80000138:	05012683          	lw	a3,80(sp)
8000013c:	04c12703          	lw	a4,76(sp)
80000140:	04812783          	lw	a5,72(sp)
80000144:	04412803          	lw	a6,68(sp)
80000148:	04012883          	lw	a7,64(sp)
8000014c:	03c12403          	lw	s0,60(sp)
80000150:	03812483          	lw	s1,56(sp)
80000154:	03412903          	lw	s2,52(sp)
80000158:	03012983          	lw	s3,48(sp)
8000015c:	02c12a03          	lw	s4,44(sp)
80000160:	02812a83          	lw	s5,40(sp)
80000164:	02412b03          	lw	s6,36(sp)
80000168:	02012b83          	lw	s7,32(sp)
8000016c:	01c12c03          	lw	s8,28(sp)
80000170:	01812c83          	lw	s9,24(sp)
80000174:	01412d03          	lw	s10,20(sp)
80000178:	01012d83          	lw	s11,16(sp)
8000017c:	08010113          	addi	sp,sp,128
80000180:	30200073          	mret

80000184 <hal_write_32bit>:
80000184:	00b52023          	sw	a1,0(a0)
80000188:	00008067          	ret

8000018c <hal_write_16bit>:
8000018c:	00b51023          	sh	a1,0(a0)
80000190:	00008067          	ret

80000194 <hal_write_8bit>:
80000194:	00b50023          	sb	a1,0(a0)
80000198:	00008067          	ret

8000019c <hal_read_32bit>:
8000019c:	00052503          	lw	a0,0(a0)
800001a0:	00008067          	ret

800001a4 <hal_read_16bit>:
800001a4:	00051503          	lh	a0,0(a0)
800001a8:	01051513          	slli	a0,a0,0x10
800001ac:	01055513          	srli	a0,a0,0x10
800001b0:	00008067          	ret

800001b4 <hal_read_8bit>:
800001b4:	00050503          	lb	a0,0(a0)
800001b8:	0ff57513          	zext.b	a0,a0
800001bc:	00008067          	ret

800001c0 <EXT_IRQ_0_HANDLER>:
800001c0:	00008067          	ret

800001c4 <EXT_IRQ_1_HANDLER>:
800001c4:	00008067          	ret

800001c8 <EXT_IRQ_2_HANDLER>:
800001c8:	00008067          	ret

800001cc <EXT_IRQ_3_HANDLER>:
800001cc:	00008067          	ret

800001d0 <EXT_IRQ_4_HANDLER>:
800001d0:	00008067          	ret

800001d4 <EXT_IRQ_5_HANDLER>:
800001d4:	00008067          	ret

800001d8 <BASE_IRQ_HANDLER>:
800001d8:	342027f3          	csrr	a5,mcause
800001dc:	0017f713          	andi	a4,a5,1
800001e0:	00070463          	beqz	a4,800001e8 <BASE_IRQ_HANDLER+0x10>
800001e4:	fddff06f          	j	800001c0 <EXT_IRQ_0_HANDLER>
800001e8:	0027f713          	andi	a4,a5,2
800001ec:	00070463          	beqz	a4,800001f4 <BASE_IRQ_HANDLER+0x1c>
800001f0:	fd5ff06f          	j	800001c4 <EXT_IRQ_1_HANDLER>
800001f4:	0047f713          	andi	a4,a5,4
800001f8:	00070463          	beqz	a4,80000200 <BASE_IRQ_HANDLER+0x28>
800001fc:	fcdff06f          	j	800001c8 <EXT_IRQ_2_HANDLER>
80000200:	0087f713          	andi	a4,a5,8
80000204:	00070463          	beqz	a4,8000020c <BASE_IRQ_HANDLER+0x34>
80000208:	fc5ff06f          	j	800001cc <EXT_IRQ_3_HANDLER>
8000020c:	0107f713          	andi	a4,a5,16
80000210:	00070463          	beqz	a4,80000218 <BASE_IRQ_HANDLER+0x40>
80000214:	fbdff06f          	j	800001d0 <EXT_IRQ_4_HANDLER>
80000218:	0207f793          	andi	a5,a5,32
8000021c:	00078463          	beqz	a5,80000224 <BASE_IRQ_HANDLER+0x4c>
80000220:	fb5ff06f          	j	800001d4 <EXT_IRQ_5_HANDLER>
80000224:	00008067          	ret

80000228 <main>:
80000228:	02000793          	li	a5,32
8000022c:	30479073          	csrw	mie,a5
80000230:	000037b7          	lui	a5,0x3
80000234:	b0000737          	lui	a4,0xb0000
80000238:	ee078793          	addi	a5,a5,-288 # 2ee0 <ROM_SIZE+0xee0>
8000023c:	00f72023          	sw	a5,0(a4) # b0000000 <__stack_top$+0x1fffc400>
80000240:	10500073          	wfi
80000244:	00000513          	li	a0,0
80000248:	00008067          	ret
8000024c:	0000                	.insn	2, 0x
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	3441                	.insn	2, 0x3441
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <HEAP_SIZE-0x3ec>
   c:	002a                	.insn	2, 0x002a
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	697a                	.insn	2, 0x697a
  1e:	32727363          	bgeu	tp,t2,344 <HEAP_SIZE-0xbc>
  22:	3070                	.insn	2, 0x3070
  24:	7a5f 6669 6e65      	.insn	6, 0x6e6566697a5f
  2a:	32696563          	bltu	s2,t1,354 <HEAP_SIZE-0xac>
  2e:	3070                	.insn	2, 0x3070
  30:	0800                	.insn	2, 0x0800
  32:	0a01                	.insn	2, 0x0a01
  34:	Address 0x34 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	36343067          	.insn	4, 0x36343067
   a:	3639                	.insn	2, 0x3639
   c:	6664                	.insn	2, 0x6664
   e:	3930                	.insn	2, 0x3930
  10:	3336                	.insn	2, 0x3336
  12:	2029                	.insn	2, 0x2029
  14:	3431                	.insn	2, 0x3431
  16:	322e                	.insn	2, 0x322e
  18:	302e                	.insn	2, 0x302e
	...
