#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <system.h>

#include <hal.h>

const uint8_t const msg[] = "Hello World!\r\n\0";

volatile uart_instance_t* const UART = (uart_instance_t*)(UART_BASE);

volatile timer_instance_t* const TIMER = (timer_instance_t*)(TIMER_BASE);

volatile gpio_instance_t* const GPIO = (gpio_instance_t*)(GPIO_BASE);

static inline void
__wfi(void)
{
  asm volatile("wfi");
}

int main1()
{
  uint8_t msg_local [64] = {0};
  for (int i = 0; msg[i] > 0; i++) {
    msg_local[i] = msg[i];
    UART->DATA = msg[i];
  }
  return 0;
}

int main()
{
  hal_write_csr(mie, (EXT_SYS_I5_IE | EXT_SYS_I0_IE));
  __wfi();
  UART->DATA = 'b' + (uint8_t)hal_read_csr(mhartid);
  return 0;
}

void EXT_IRQ_0_HANDLER(void) {
  UART->DATA = UART->DATA;
  return;
}

void EXT_IRQ_5_HANDLER(void) {
  return;
}