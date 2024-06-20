const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = std.Target.Cpu.Arch.riscv64,
        .os_tag = std.Target.Os.Tag.freestanding,
        .abi = std.Target.Abi.none,
    });

    const main_build_output = b.addExecutable(.{
        .name = "test",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .Debug,
        .error_tracing = true,
        .code_model = .medium,
    });

    const test_output = b.addTest(.{
        .name = "tester",
        .root_source_file = b.path("src/serial.zig"),
        .target = target,
        .optimize = .Debug,
        .error_tracing = true,
        .pic = true,
        .test_runner = b.path("src/test_runner.zig"),
    });

    main_build_output.setLinkerScript(b.path("linker.ld"));
    main_build_output.addAssemblyFile(b.path("boot.s"));

    test_output.setLinkerScript(b.path("linker.ld"));
    test_output.addAssemblyFile(b.path("boot.s"));

    b.installArtifact(test_output);
    b.installArtifact(main_build_output);

    const run_with_qemu = b.addSystemCommand(&.{ try b.findProgram(&.{"qemu-system-riscv64"}, &.{}), "-machine", "virt", "-cpu", "rv64", "-m", "128M", "-nographic", "-serial", "mon:stdio", "-bios", "none", "-kernel" });
    run_with_qemu.addArtifactArg(main_build_output);
    if (b.option(bool, "gdb", "Wait for a gdb connection") orelse false) run_with_qemu.addArgs(&.{ "-S", "-s" });

    const run_tests = b.addSystemCommand(&.{ try b.findProgram(&.{"qemu-system-riscv64"}, &.{}), "-machine", "virt", "-cpu", "rv64", "-m", "128M", "-nographic", "-serial", "mon:stdio", "-bios", "none", "-kernel" });
    run_tests.addArtifactArg(test_output);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&main_build_output.step);
    run_step.dependOn(&run_with_qemu.step);

    const test_step = b.step("test", "Run tests using QEMU");
    test_step.dependOn(&test_output.step);
    test_step.dependOn(&run_tests.step);
}
