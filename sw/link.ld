OUTPUT_ARCH("riscv")

ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00000000, LENGTH = 4k
  RAM (rw) : ORIGIN = 0x20000000, LENGTH = 4k
}

ROM_START_ADDRESS   = 0x00000000;        /* Must be the same value MEMORY region rom ORIGIN above. */
ROM_SIZE            = 4k;                /* Must be the same value MEMORY region rom LENGTH above. */

RAM_START_ADDRESS   = 0x20000000;        /* Must be the same value MEMORY region ram ORIGIN above. */
RAM_SIZE            = 4k;                /* Must be the same value MEMORY region ram LENGTH above. */

STACK_SIZE          = 4k;               /* needs to be calculated for your application */     
HEAP_SIZE           = 0;                /* needs to be calculated for your application */

SECTIONS
{
  .text : ALIGN(0x10) 
  { 
    *(.text*)
    PROVIDE(__global_pointer$ = .); 
  } > ROM

  .rodata : ALIGN(0x10)
  {
    *(.rodata*)
  } > ROM

  .data : ALIGN(0x10)
  {
    *(.data*)
  } > ROM

  .bss : ALIGN(0x10)
  { 
    *(.bss*)
    PROVIDE(__stack_top$ = . + LENGTH(RAM));
  } > RAM

}