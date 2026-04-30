OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY {
  RAM (rwx) : ORIGIN = 0x0, LENGTH = 64K
}

STACK_SIZE = 1024;
CL_SIZE = 32;

SECTIONS {
  .text_first 0xF8 : {
    FILL(0);
    SIM_EXIT = .;
    LONG(0x13);
    SIM_STOP = .;
    LONG(0x6F);
    LONG(-1);
  } >RAM

  .text.init 0x200 : { 
    *(.text.init) 
  } >RAM

  .text : {
    . = 0x1000;
    *crt.o(.text .text.*)
    *(.text .text.*)
    *(sc_test_section)
    . = ALIGN(CL_SIZE);
    PROVIDE(__TEXT_END__ = .);
  } >RAM 

  .data : { *(.data .data.*) . = ALIGN(CL_SIZE); } >RAM
  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    . = ALIGN(CL_SIZE);
  } >RAM
  .tdata : {
    PROVIDE(_tls_data = .);
    PROVIDE(_tdata_begin = .);
    *(.tdata .tdata.*)
    PROVIDE(_tdata_end = .);
    . = ALIGN(CL_SIZE);
  } >RAM
  .tbss : {
    PROVIDE(__BSS_START__ = .);
    *(.tbss .tbss.*)
    . = ALIGN(CL_SIZE);
    PROVIDE(_tbss_end = .);
  } >RAM
  .sbss : { *(.sbss .sbss.* .gnu.linkonce.sb.*) *(.scommon) } >RAM
  .bss : {
    *(.bss .bss.*)
    . = ALIGN(CL_SIZE);
    PROVIDE(__BSS_END__ = .);
  } >RAM
  _end = .;
  PROVIDE(__end = .);
  .stack ORIGIN(RAM) + LENGTH(RAM) - STACK_SIZE : {
    FILL(0);
    PROVIDE(__STACK_START__ = .);
    . += STACK_SIZE;
    PROVIDE(__C_STACK_TOP__ = .);
    PROVIDE(__STACK_END__ = .);
  } >RAM
  /DISCARD/ : { *(.eh_frame .eh_frame.*) }
}
