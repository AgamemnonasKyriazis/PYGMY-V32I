#include <stdint.h>

#include "hal.h"

#define SYS_FREQ               12000000u
#define UROM_BASE_ADDRESS      0x00000000
#define SRAM_BASE_ADDRESS      0x20000000
#define UART_BASE_ADDRESS      0x40000000
#define TIMER_BASE_ADDRESS     0x60000000

const uint8_t const msg[] = "Hello World!\r\n";

int main()
{  
  hal_write_csr(mie, (EXT_SYS_I5_IE | EXT_SYS_I0_IE));

  hal_write_32bit(TIMER_BASE_ADDRESS, SYS_FREQ);
  
  while (1);

  return 0;
}

void EXT_IRQ_0_HANDLER(void) {
  char byteIn;
  byteIn = hal_read_8bit(UART_BASE_ADDRESS);
  hal_write_8bit(UART_BASE_ADDRESS, byteIn);
  return;
}

void EXT_IRQ_5_HANDLER(void) {
  int i;
  i = 0;
  while (msg[i])
  {
    hal_write_8bit(UART_BASE_ADDRESS, msg[i++]);
  }
}