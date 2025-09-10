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

volatile uint32_t hw_lock_0 = 0;

enum RMAP_COMMAND {
  RMAP_GET,
  RMAP_POST
};

static inline void
__wfi(void)
{
  asm volatile("wfi");
}

int main1()
{
  // while (hw_lock_0 == 0);
  // uint32_t mhartid = hal_read_csr(mhartid);
  // UART->DATA = '0' + mhartid;
  while (1);
  return 0;
}

int main()
{
  hal_write_csr(mie, (EXT_SYS_I5_IE | EXT_SYS_I0_IE));
  // __wfi();
  // uint32_t mhartid = hal_read_csr(mhartid);
  // UART->DATA = '0' + mhartid;
  // hw_lock_0 = 1;
  // while (1);
  return 0;
}

uint32_t uart_read() {
  volatile uint32_t r;
  while (UART->RX_SIZE == 0);
  r = UART->DATA;
  return r;
}
void uart_write(uint32_t w) {
  UART->DATA = w;
}

void EXT_IRQ_0_HANDLER(void) {
  volatile uint32_t command;
  volatile uint32_t address;
  volatile uint32_t data;

  volatile uint32_t * ptr;

  command = uart_read();
  uart_write(command);

  if (command != RMAP_GET && command != RMAP_POST) {
    uart_write('p');uart_write('e');uart_write('o');uart_write('s');
    return;
  }

  address = \
  (uart_read()) |
  (uart_read() << 8) |
  (uart_read() << 16)  |
  (uart_read() << 24);

  uart_write(address);
  uart_write(address >> 8);
  uart_write(address >> 16);
  uart_write(address >> 24);

  ptr = (uint32_t *)address;

  if (command == RMAP_GET) {
    data = *ptr;
  }
  else if (command == RMAP_POST) {
    data = \
    (uart_read()) |
    (uart_read() << 8) |
    (uart_read() << 16)  |
    (uart_read() << 24);
    *ptr = data;
  }

  uart_write(data);
  uart_write(data >> 8);
  uart_write(data >> 16);
  uart_write(data >> 24);

  return;
}

void EXT_IRQ_5_HANDLER(void) {
  return;
}