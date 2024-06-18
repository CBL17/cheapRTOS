const std = @import("std");
const serial = @import("serial.zig");

var kernel_panic_allocator_bytes: [100 * 1024]u8 = undefined;
var kernel_panic_allocator_state = std.heap.FixedBufferAllocator.init(kernel_panic_allocator_bytes[0..]);
const kernel_panic_allocator = kernel_panic_allocator_state.allocator();

extern var __debug_info_start: u8;
extern var __debug_info_end: u8;
extern var __debug_abbrev_start: u8;
extern var __debug_abbrev_end: u8;
extern var __debug_str_start: u8;
extern var __debug_str_end: u8;
extern var __debug_line_start: u8;
extern var __debug_line_end: u8;
extern var __debug_ranges_start: u8;
extern var __debug_ranges_end: u8;

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    serial.log("PANIC!!!\n", .{});
    serial.log("{s}\n", .{msg});

    backtrace() catch |err| serial.log("Backtracing error: {s}\n", .{@errorName(err)});

    while (true) {}
}

fn getSelfDebugInfo() !*std.dwarf.DwarfInfo {
    const S = struct {
        var have_self_debug_info = false;
        var self_debug_info: std.dwarf.DwarfInfo = undefined;

        var in_stream_state = std.io.InStream(anyerror){ .readFn = readFn };
        var in_stream_pos: u64 = 0;
        const in_stream = &in_stream_state;

        fn readFn(buffer: []u8) anyerror!usize {
            const ptr: [*]const u8 = @ptrFromInt(in_stream_pos);
            @memcpy(buffer.ptr, ptr);
            in_stream_pos += buffer.len;
            return buffer.len;
        }

        const SeekableStream = std.io.SeekableStream(anyerror, anyerror);
        var seekable_stream_state = SeekableStream{
            .seekToFn = seekToFn,
            .seekByFn = seekByFn,

            .getPosFn = getPosFn,
            .getEndPosFn = getEndPosFn,
        };
        const seekable_stream = &seekable_stream_state;

        fn seekToFn(pos: u64) anyerror!void {
            in_stream_pos = pos;
        }
        fn seekByFn(pos: i64) anyerror!void {
            in_stream_pos = @bitCast(@as(isize, @bitCast(in_stream_pos)) +% pos);
        }
        fn getPosFn() anyerror!u64 {
            return in_stream_pos;
        }
        fn getEndPosFn() anyerror!u64 {
            return @as(u64, @intFromPtr(&__debug_ranges_end));
        }
    };
    if (S.have_self_debug_info) return &S.self_debug_info;

    var sections = std.dwarf.DwarfInfo.null_section_array;

    const debug_info_start: [*]u8 = &__debug_info_start;
    const debug_info_end: [*]u8 = &__debug_info_start;
    const debug_abbrev_start: [*]u8 = &__debug_abbrev_start;
    const debug_abbrev_end: [*]u8 = &__debug_abbrev_end;
    const debug_str_start: [*]u8 = &__debug_str_start;
    const debug_str_end: [*]u8 = &__debug_str_end;
    const debug_line_start: [*]u8 = &__debug_line_start;
    const debug_line_end: [*]u8 = &__debug_line_end;
    const debug_ranges_start: [*]u8 = &__debug_ranges_start;
    const debug_ranges_end: [*]u8 = &__debug_ranges_end;
    sections[@intFromEnum(std.dwarf.DwarfSection.debug_info)] = .{ .data = debug_info_start[0 .. @intFromPtr(debug_info_start) - @intFromPtr(debug_info_end)], .owned = false };
    sections[@intFromEnum(std.dwarf.DwarfSection.debug_abbrev)] = .{ .data = debug_abbrev_start[0 .. @intFromPtr(debug_abbrev_start) - @intFromPtr(debug_abbrev_end)], .owned = false };
    sections[@intFromEnum(std.dwarf.DwarfSection.debug_str)] = .{ .data = debug_str_start[0 .. @intFromPtr(debug_str_start) - @intFromPtr(debug_str_end)], .owned = false };
    sections[@intFromEnum(std.dwarf.DwarfSection.debug_line)] = .{ .data = debug_line_start[0 .. @intFromPtr(debug_line_start) - @intFromPtr(debug_line_end)], .owned = false };
    sections[@intFromEnum(std.dwarf.DwarfSection.debug_ranges)] = .{ .data = debug_ranges_start[0 .. @intFromPtr(debug_ranges_start) - @intFromPtr(debug_ranges_end)], .owned = false };

    S.self_debug_info = std.dwarf.DwarfInfo{
        .endian = .little,
        .is_macho = false,
        .sections = sections,
    };
    try std.debug.openDwarfDebugInfo(&S.self_debug_info, kernel_panic_allocator);
    return &S.self_debug_info;
}

pub fn backtrace() !void {
    try std.dwarf.openDwarfDebugInfo(try getSelfDebugInfo(), kernel_panic_allocator);
    var it = std.debug.StackIterator.init(@returnAddress(), @frameAddress());
    while (it.next()) |ret_addr| {
        _ = ret_addr;
    }
}

pub noinline fn add(a: u8, b: u8) u8 {
    return a + b;
}

pub export fn main() void {
    serial.init();
    serial.log("{}\n", .{add(255, 1)});
    // serial.log("{*},{*},{*},{*},{*}\n", .{ &__debug_info_start, &__debug_abbrev_start, &__debug_str_start, &__debug_line_start, &__debug_ranges_start });
    // serial.log("{*},{*},{*},{*},{*}\n", .{ &__debug_info_end, &__debug_abbrev_end, &__debug_str_end, &__debug_line_end, &__debug_ranges_end });
}
