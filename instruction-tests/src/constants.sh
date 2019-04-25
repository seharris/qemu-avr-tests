# Lookup table for 16 bit indirection registers.
declare -A LO=([X]=26 [Y]=28 [Z]=30)
declare -A HI=([X]=27 [Y]=29 [Z]=31)

# Addresses of useful registers in the full address space.
GPIOR0_MEM=0x3e
GPIOR1_MEM=0x4a
GPIOR2_MEM=0x4b

# Addresses of useful registers in the IO address space.
GPIOR0_IO=0x1e
GPIOR1_IO=0x2a
GPIOR2_IO=0x2b
SPL_IO=0x3d
SPH_IO=0x3e
SREG_IO=0x3f
