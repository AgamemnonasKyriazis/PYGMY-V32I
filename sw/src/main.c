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
  printf("%s\r\n", msg);
  return 0;
}