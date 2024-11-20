#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <system.h>

#include <hal.h>

const uint8_t const msg[] = "Hello World!";

volatile uart_instance_t* const UART = (uart_instance_t*)(UART_BASE);

volatile timer_instance_t* const TIMER = (timer_instance_t*)(TIMER_BASE);

volatile gpio_instance_t* const GPIO = (gpio_instance_t*)(GPIO_BASE);

char buf[64] = {0};

static inline void
__wfi(void)
{
  asm volatile("wfi");
}

int main()
{
  hal_write_csr(mie, (EXT_SYS_I5_IE));
  
  TIMER->THRESHOLD = 12000UL;
  
  __wfi();
  
  return 0;
}