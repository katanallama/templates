/* Linker script for the STM32F103RBT6 */

/* Specify the memory areas */
MEMORY
{
  RAM (xrw)      : ORIGIN = 0x20000000, LENGTH = 20K
  FLASH (rx)      : ORIGIN = 0x8000000, LENGTH = 128K
}
