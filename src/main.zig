const std = @import("std");
const serial = @import("serial.zig");

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    serial.log("PANIC!!!\n", .{});
    serial.log("{s}\n", .{msg});

    var index: usize = 0;
    var iter = std.debug.StackIterator.init(@returnAddress(), @frameAddress());
    while (iter.next()) |address| : (index += 1) {
        if (index == 0) {
            serial.log("stack trace:", .{});
        }
        serial.log("{d: >3}: 0x{X:0>8}", .{ index, address });
    }

    while (true) {}
}

pub noinline fn add(a: u8, b: u8) u8 {
    return a + b;
}

pub export fn main() void {
    serial.init();
    serial.log("{}\n", .{add(255, 1)});
}
