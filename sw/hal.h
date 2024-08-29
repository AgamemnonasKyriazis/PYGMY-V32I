#ifndef _HAL_
#define _HAL_

#include <stdint.h>

#define hal_read_csr(reg) ({ uint32_t __tmp; \
  __asm__ volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define hal_write_csr(reg, val) ({ \
  __asm__ volatile ("csrw " #reg ", %0" :: "rK"(val)); })

void hal_write_32bit(uint32_t addr, uint32_t val);
void hal_write_16bit(uint32_t addr, uint16_t val);
void hal_write_8bit(uint32_t addr, uint8_t val);

uint32_t hal_read_32bit(uint32_t addr);
uint16_t hal_read_16bit(uint32_t addr);
uint8_t hal_read_8bit(uint32_t addr);

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

#endif