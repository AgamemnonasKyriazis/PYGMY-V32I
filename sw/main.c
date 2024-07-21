#include <stdint.h>

#define UROM  0x00000000
#define SRAM  0x01000000
#define UART  0x02000000

volatile uint8_t* const uart = (volatile uint8_t*)(UART);

const uint8_t const msg[] = "Hello World\r\n";

void delay(int d);

int main()
{

  int i;

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