#ifndef _SYSTEM_
#define _SYSTEM_

#define SYS_FREQ        12000000UL

#define UROM_BASE       0x00000000UL

#define SRAM_BASE       0x20000000UL

#define UART_BASE       0x40000000UL

#define TIMER_BASE      0x60000000UL

#define GPIO_BASE       0x80000000UL

typedef struct uart_instance_t {
  uint8_t DATA;
} uart_instance_t;

typedef struct timer_instance_t {
  uint32_t THRESHOLD;
} timer_instance_t;

typedef struct
{
  uint8_t _0 : 1;
  uint8_t _1 : 1;
  uint8_t _2 : 1;
  uint8_t _3 : 1;
  uint8_t _4 : 1;
  uint8_t _5 : 1;
  uint8_t _6 : 1;
  uint8_t _7 : 1;
} _BITS8;

typedef union gpio_instance_t {
  uint8_t _GPIO;
  _BITS8 pins;
} gpio_instance_t;

extern volatile uart_instance_t* const UART;
extern volatile timer_instance_t* const TIMER;
extern volatile gpio_instance_t* const GPIO;

#endif /* _SYSTEM_ */