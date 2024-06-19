const std = @import("std");
const serial = @import("serial.zig");

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    kernelLog.err("PANIC!!!\n", .{});
    kernelLog.err("{s}\n", .{msg});

    var index: usize = 0;
    var iter = std.debug.StackIterator.init(@returnAddress(), @frameAddress());
    while (iter.next()) |address| : (index += 1) {
        if (index == 0) {
            kernelLog.debug("stack trace:", .{});
        }
        kernelLog.debug("{d: >3}: 0x{X:0>8}", .{ index, address });
    }

    while (true) {}
}

pub noinline fn add(a: u8, b: u8) u8 {
    return a + b;
}

pub const std_options = .{
    .logFn = log,
};

pub fn log(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const scope_prefix = "(" ++ switch (scope) {
        .kernel => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err)) @tagName(level) else return,
    } ++ "): ";

    const level_prefix = "[" ++ comptime level.asText() ++ "]";

    std.fmt.format(serial.writer, "{s: <8}" ++ scope_prefix ++ format ++ "\n", .{level_prefix} ++ args) catch return;
}

const kernelLog = std.log.scoped(.kernel);

pub export fn main() void {
    serial.init();
    kernelLog.err("error, man", .{});
    kernelLog.info("BRUHinfo", .{});
    _ = add(255, 1);
}
