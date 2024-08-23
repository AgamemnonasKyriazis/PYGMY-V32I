#include <stdint.h>

#define SYS_FREQ               12000000u
#define UROM_BASE_ADDRESS      0x00000000
#define SRAM_BASE_ADDRESS      0x20000000
#define UART_BASE_ADDRESS      0x40000000
#define TIMER_BASE_ADDRESS     0x60000000

#define hal_read_csr(reg) ({ uint32_t __tmp; \
  __asm__ volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define hal_write_csr(reg, val) ({ \
  __asm__ volatile ("csrw " #reg ", %0" :: "rK"(val)); })

#define EXT_SYS_I0_IE   (0x01u) 
#define EXT_SYS_I1_IE   (0x01u<<1u)
#define EXT_SYS_I2_IE   (0x01u<<2u)
#define EXT_SYS_I3_IE   (0x01u<<3u)
#define EXT_SYS_I4_IE   (0x01u<<4u)
#define EXT_SYS_I5_IE   (0x01u<<5u)

void EXT_IRQ_0_HANDLER(void);
void EXT_IRQ_1_HANDLER(void);
void EXT_IRQ_2_HANDLER(void);
void EXT_IRQ_3_HANDLER(void);
void EXT_IRQ_4_HANDLER(void);
void EXT_IRQ_5_HANDLER(void);

void BASE_IRQ_HANDLER(void);

void hal_write_32bit(uint32_t addr, uint32_t val);
void hal_write_16bit(uint32_t addr, uint16_t val);
void hal_write_8bit(uint32_t addr, uint8_t val);

uint32_t hal_read_32bit(uint32_t addr);
uint16_t hal_read_16bit(uint32_t addr);
uint8_t hal_read_8bit(uint32_t addr);

const uint8_t const msg[] = "Hello World\r\n";

int main()
{
  int i;
  i = 0;

  unsigned int interval = 120u;
  hal_write_32bit(TIMER_BASE_ADDRESS, interval);

  while (msg[i])
  {
    hal_write_8bit(UART_BASE_ADDRESS, msg[i]);
    i++;
  }

  while (1);

  return 0;
}

void BASE_IRQ_HANDLER(void)
{
  uint32_t cause = hal_read_csr(mcause);

  if (cause & EXT_SYS_I0_IE)
  {
    EXT_IRQ_0_HANDLER();
  }

  if (cause & EXT_SYS_I1_IE)
  {
    EXT_IRQ_1_HANDLER();
  }

  if (cause & EXT_SYS_I2_IE)
  {
    EXT_IRQ_2_HANDLER();
  }

  if (cause & EXT_SYS_I3_IE)
  {
    EXT_IRQ_3_HANDLER();
  }

  if (cause & EXT_SYS_I4_IE)
  {
    EXT_IRQ_4_HANDLER();
  }

  if (cause & EXT_SYS_I5_IE)
  {
    EXT_IRQ_5_HANDLER();
  }

  return;
}

void EXT_IRQ_0_HANDLER(void) {
  char byteIn;
  byteIn = hal_read_8bit(UART_BASE_ADDRESS);
  hal_write_8bit(UART_BASE_ADDRESS, byteIn);
  return;
}

void EXT_IRQ_1_HANDLER(void) {
  return;
}

void EXT_IRQ_2_HANDLER(void) {
  return;
}

void EXT_IRQ_3_HANDLER(void) {
  return;
}

void EXT_IRQ_4_HANDLER(void) {
  return;
}

void EXT_IRQ_5_HANDLER(void) {
  return;
}

void hal_write_32bit(uint32_t addr, uint32_t val) {
    __asm__ volatile ("sw %1, 0(%0)" :: "rK"(addr), "rK"(val));
}

void hal_write_16bit(uint32_t addr, uint16_t val) {
    __asm__ volatile ("sh %1, 0(%0)" :: "rK"(addr), "rK"(val));
}

void hal_write_8bit(uint32_t addr, uint8_t val) {
    __asm__ volatile ("sb %1, 0(%0)" :: "rK"(addr), "rK"(val));
}

uint32_t hal_read_32bit(uint32_t addr) {
    uint32_t val;
    __asm__ volatile ("lw %0, 0(%1)" : "=r"(val) : "rK"(addr));
    return val;
}

uint16_t hal_read_16bit(uint32_t addr) {
    uint16_t val;
    __asm__ volatile ("lh %0, 0(%1)" : "=r"(val) : "rK"(addr));
    return val;
}

uint8_t hal_read_8bit(uint32_t addr) {
    uint8_t val;
    __asm__ volatile ("lbu %0, 0(%1)" : "=r"(val) : "rK"(addr));
    return val;
}