#include <stdint.h>

#include <system.h>
#include <hal.h>

const uint8_t const msg[] = "Hello World!\r\n";

typedef struct uart_instance_t {
  uint8_t DATA;
} uart_instance_t;

typedef struct timer_instance_t
{
  uint32_t THRESHOLD;
} timer_instance_t;

volatile uart_instance_t* const UART = (uart_instance_t*)(UART_BASE);

volatile timer_instance_t* const TIMER = (timer_instance_t*)(TIMER_BASE);

int main()
{  
  uint32_t IE_MASK = EXT_SYS_I0_IE | EXT_SYS_I5_IE;
  hal_write_csr(mie, IE_MASK);

  TIMER->THRESHOLD = (SYS_FREQ>>1);

  int i;
  i = 0;
  while (msg[i])
    UART->DATA = msg[i++];

  while (1);

  return 0;
}

void EXT_IRQ_0_HANDLER(void) {
  char byteIn;
  byteIn = UART->DATA;
  UART->DATA = byteIn;
  return;
}

void EXT_IRQ_5_HANDLER(void) {
  int i;
  i = 0;
  while (msg[i])
    UART->DATA = msg[i++];
}