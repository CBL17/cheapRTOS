OUTPUT_ARCH( "riscv" )

ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

PHDRS
{
    text  PT_LOAD;
    data  PT_LOAD;
    bss   PT_LOAD;
    stack PT_LOAD;
}

SECTIONS
{

    .text : ALIGN(4k) {
        PROVIDE(_text_start = .);
        *(.text.init) *(.text .text.*)
        PROVIDE(_text_end = .);
    } >RAM AT>RAM :text

    PROVIDE(_global_pointer = .);

    .rodata : ALIGN(4k) {
        *(.rodata .rodata.*)
        *(.rodata)
        __debug_info_start = .;
        KEEP(*(.debug_info))
        __debug_info_end = .;
        __debug_abbrev_start = .;
        KEEP(*(.debug_abbrev))
        __debug_abbrev_end = .;
        __debug_str_start = .;
        KEEP(*(.debug_str))
        __debug_str_end = .;
        __debug_line_start = .;
        KEEP(*(.debug_line))
        __debug_line_end = .;
        __debug_ranges_start = .;
        KEEP(*(.debug_ranges))
        __debug_ranges_end = .;
    } >RAM AT>RAM :text

    .data : ALIGN(4k) {
        . = ALIGN(4096);
        PROVIDE(_data_start = .);
        *(.sdata .sdata.*) *(.data .data.*)
        PROVIDE(.data_end = .);
    } >RAM AT>RAM :data

    .bss : ALIGN(4k) {
        PROVIDE(_bss_start = .);
        *(.sbss .sbss.*) *(.bss .bss.*)
        PROVIDE(_bss_end = .);
    } >RAM AT>RAM :bss

    .stack : ALIGN(16) {
        PROVIDE(_stack_end = .);
        . += 0x10000;
        PROVIDE(_stack_start = .);
    } >RAM AT>RAM :stack

    PROVIDE(_memory_start = ORIGIN(RAM));
}
