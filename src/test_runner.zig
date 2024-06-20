const std = @import("std");
const logger = std.log.scoped(.tester);
const serial = @import("serial.zig");

pub fn log(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const scope_prefix = "(" ++ switch (scope) {
        .kernel, .tester => @tagName(scope),
        else => if (@intFromEnum(level) >= @intFromEnum(std.log.Level.err)) @tagName(level) else return,
    } ++ "): ";

    const level_prefix = "[" ++ comptime level.asText() ++ "]";

    std.fmt.format(serial.writer, "{s: <10}" ++ scope_prefix ++ format ++ "\n", .{level_prefix} ++ args) catch return;
}

pub const std_options = .{
    .logFn = log,
};

pub export fn main() void {
    for (@import("builtin").test_functions) |fxn| {
        fxn.func() catch {
            logger.err("{s}", .{fxn.name});
        };
    }
}
