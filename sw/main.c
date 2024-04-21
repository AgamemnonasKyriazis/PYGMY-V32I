#include <stdint.h>

#define UROM  0x00000000
#define SRAM  0x01000000
#define UART  0x02000000
#define ERAM  0x03000000

volatile uint8_t* const uart = (volatile uint8_t*)(UART);

volatile uint8_t* const eram = (volatile uint8_t*)(ERAM);

uint8_t const msg[] = "ABC!\r\n";

int main()
{
  int i;

  for (i = 0; i < 10; ++i)
  {
    eram[i] = (uint8_t)('a'+i);
    *uart = (uint8_t)eram[i];
  }

  while (1)
  {
    i = 0;
    while (msg[i])
    {
      *uart = (uint8_t)msg[i++];
    }

    for (i = 0; i < 120000; ++i);
  }

  return 0;
}
