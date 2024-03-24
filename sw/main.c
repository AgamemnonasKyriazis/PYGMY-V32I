#include <stdint.h>

#define ROM   0x00000000
#define SRAM  0x00000100
#define UART  0x00000200

volatile char* const uart = (volatile char*)(UART);

char const msg[] = "Hello World!\r\n";

int main()
{
  int i;

  while(1)
  {
    for (i = 0; i < 14; i++)
    {
      *uart = (char)msg[i];
    }
    for (i = 0; i < 120000; i++);
  }

  return 0;
}
