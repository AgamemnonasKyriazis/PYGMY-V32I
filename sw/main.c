#include <stdint.h>

#define ROM   0x00000000
#define SRAM  0x01000000
#define UART  0x02000000

volatile uint8_t* const uart = (volatile uint8_t*)(UART);

uint8_t const msg[] = "Hello World!\r\n";

int main()
{
  int i;

  i = 0;

  while (msg[i])
  {
    *uart = (uint8_t)msg[i++];
  }

  while(1);

  return 0;
}
