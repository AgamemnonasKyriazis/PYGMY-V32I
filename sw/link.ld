OUTPUT_ARCH("riscv")

ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x80000000, LENGTH = 8k
  RAM (rw) : ORIGIN = 0x90000000, LENGTH = 16k
}

ROM_START_ADDRESS   = 0x80000000;        /* Must be the same value MEMORY region rom ORIGIN above. */
ROM_SIZE            = 8k;                /* Must be the same value MEMORY region rom LENGTH above. */

RAM_START_ADDRESS   = 0x90000000;        /* Must be the same value MEMORY region ram ORIGIN above. */
RAM_SIZE            = 16k;               /* Must be the same value MEMORY region ram LENGTH above. */

STACK_SIZE          = 14k;               /* needs to be calculated for your application */     
HEAP_SIZE           = 1k;                /* needs to be calculated for your application */

SECTIONS
{
  .text : ALIGN(0x10) 
  { 
    *(.text*)
    . = ALIGN(0x10);
  } > ROM

  .data : ALIGN(0x10)
  {
    _sdata$ = .;
    PROVIDE(_sdata_load$ = LOADADDR(.data));
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.srodata*)
    *(.rodata*)
    *(.sdata*)
    *(.data*)
    *(.scommon*)
    . = ALIGN(0x10);
    _edata$ = .;
  } > RAM AT > ROM

  .bss : ALIGN(0x10)
  { 
    _sbss$ = .;
    *(.sbss*)
    *(.bss*)
    *(*COMMON)
    . = ALIGN(0x10);
    _ebss$ = .;
  } > RAM

  .heap : ALIGN(0x10)
  {
    PROVIDE(__end$ = .);
    PROVIDE(__heap_start$ = .);
    . = __heap_start$ + HEAP_SIZE;
    . = ALIGN(0x10);
    PROVIDE(__heap_end$ = .);
  } > RAM

  .stack : ALIGN(0x10)
  {
    PROVIDE(__stack_end$ = .);
    . = __stack_end$ + STACK_SIZE;
    . = ALIGN(0x10);
    PROVIDE(__stack_top$ = .);
  } > RAM
}