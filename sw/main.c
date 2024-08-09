#include <stdint.h>

#define SYS_FREQ  12000000;

#define UROM      0x00000000
#define SRAM      0x01000000
#define UART      0x02000000
#define TIMER_EXT 0x03000000

volatile uint8_t* const uart = (volatile uint8_t*)(UART);
volatile uint32_t* const ext_timer = (volatile uint32_t*)(TIMER_EXT);

const uint8_t const msg[] = "Hello World\r\n";

void delay(int d);

int main()
{

  int i;

  *(ext_timer+0x02) = (12000000);
  *(ext_timer+0x04) = 1;

  i = 0;

  while (msg[i])
  {
    *uart = msg[i];
    i++;
  }

  while (1);

  return 0;
}

void delay(int d)
{
  while (d > 0)
    d--;
  return;
}