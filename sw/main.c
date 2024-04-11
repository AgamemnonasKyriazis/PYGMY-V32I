#include <stdint.h>

#define ROM   0x00000000
#define SRAM  0x00000100
#define UART  0x00000200

volatile char* const uart = (volatile char*)(UART);

char const msg[] = "Hello World!\r\n";

int main()
{
  int i;

  for (i = 0; i < 14; i++)
  {
    *uart = (char)msg[i];
  }

  while(1);

  return 0;
}
