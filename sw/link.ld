OUTPUT_ARCH("riscv")

ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00000000, LENGTH = 8k
  RAM (rw) : ORIGIN = 0x20000000, LENGTH = 8k
}

ROM_START_ADDRESS   = 0x00000000;        /* Must be the same value MEMORY region rom ORIGIN above. */
ROM_SIZE            = 8k;                /* Must be the same value MEMORY region rom LENGTH above. */

RAM_START_ADDRESS   = 0x20000000;        /* Must be the same value MEMORY region ram ORIGIN above. */
RAM_SIZE            = 8k;                /* Must be the same value MEMORY region ram LENGTH above. */

STACK_SIZE          = 4k;               /* needs to be calculated for your application */     
HEAP_SIZE           = 4k;               /* needs to be calculated for your application */

SECTIONS
{
  .text : ALIGN(4) 
  { 
    *(.text*)
    PROVIDE(__global_pointer$ = .); 
  } > ROM

  .rodata : ALIGN(4)
  {
    *(.rodata*)
  } > ROM

  .data : ALIGN(4)
  {
    *(.data*)
  } > ROM

  .bss : ALIGN(4)
  { 
    *(.bss*)
    PROVIDE(__bss_end$ = .);
  } > RAM

  _end = .;

  .heap : ALIGN(4)
  {
    PROVIDE(__heap_start$ = .);
    . = __heap_start$ + HEAP_SIZE;
    PROVIDE(__heap_end$ = .);
  } > RAM

  .stack : ALIGN(4)
  {
    PROVIDE(__stack_end$ = .);
    . = ORIGIN(RAM) + LENGTH(RAM);
    PROVIDE(__stack_top$ = .);
  } > RAM

}