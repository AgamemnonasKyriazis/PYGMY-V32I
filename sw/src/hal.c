#include <hal.h>
#include <system.h>

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
    __asm__ volatile ("lb %0, 0(%1)" : "=r"(val) : "rK"(addr));
    return val;
}

void BASE_IRQ_HANDLER(void)
{
  uint32_t cause = hal_read_csr(mcause);

  if (cause & EXT_SYS_I0_IE)
  {
    EXT_IRQ_0_HANDLER();
  }
  else if (cause & EXT_SYS_I1_IE)
  {
    EXT_IRQ_1_HANDLER();
  }
  else if (cause & EXT_SYS_I2_IE)
  {
    EXT_IRQ_2_HANDLER();
  }
  else if (cause & EXT_SYS_I3_IE)
  {
    EXT_IRQ_3_HANDLER();
  }
  else if (cause & EXT_SYS_I4_IE)
  {
    EXT_IRQ_4_HANDLER();
  }
  else if (cause & EXT_SYS_I5_IE)
  {
    EXT_IRQ_5_HANDLER();
  }
  
  return;
}

__attribute__((weak)) void EXT_IRQ_0_HANDLER(void) { return; }
__attribute__((weak)) void EXT_IRQ_1_HANDLER(void) { return; }
__attribute__((weak)) void EXT_IRQ_2_HANDLER(void) { return; }
__attribute__((weak)) void EXT_IRQ_3_HANDLER(void) { return; }
__attribute__((weak)) void EXT_IRQ_4_HANDLER(void) { return; }
__attribute__((weak)) void EXT_IRQ_5_HANDLER(void) { return; }
