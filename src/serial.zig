const std = @import("std");

const UART_BASE: u32 = 0x10000000;
const UART_INTERRUPTS: u32 = 0x10000001;
const UART_LINE_CTRL: u32 = 0x10000003;

pub fn init() void {
    // Disables UART interrupts
    const uart_interrupts_reg: *volatile u8 = @ptrFromInt(UART_INTERRUPTS);
    uart_interrupts_reg.* = 0x0;

    // Set UART to 8 bits
    const uart_line_ctrl_reg: *volatile u8 = @ptrFromInt(UART_LINE_CTRL);
    uart_line_ctrl_reg.* = 0x3;
}

const Writer = std.io.GenericWriter(void, error{}, uart_write);
const writer = Writer{ .context = {} };

pub fn log(comptime fmt: []const u8, args: anytype) void {
    std.fmt.format(writer, fmt ++ "\n", args) catch return;
}

pub fn uart_write(_: void, bytes: []const u8) error{}!usize {
    const uart_base_reg: *volatile u8 = @ptrFromInt(UART_BASE);

    for (bytes) |char| {
        uart_base_reg.* = char;
    }
    return bytes.len;
}

test "uart_write test" {
    const bytes_written: usize = try uart_write(void{}, "I am working!\n");
    try std.testing.expectEqual(15, bytes_written);
}
