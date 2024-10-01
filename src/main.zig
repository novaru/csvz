const std = @import("std");

fn generateHeaderLine(allocator: std.mem.Allocator, field_count: usize, column_width: usize) ![]const u8 {
    const total_width = field_count * (column_width + 1) + 1;
    var hline = try allocator.alloc(u8, total_width);

    hline[0] = '+';
    var i: usize = 1;
    while (i < total_width - 1) : (i += column_width + 1) {
        @memset(hline[i .. i + column_width], '-');
        hline[i + column_width] = '+';
    }

    return hline;
}

fn readCSV(allocator: std.mem.Allocator, file_path: []const u8, line_limit: ?usize) !void {
    const cwd = std.fs.cwd();

    const file_contents = try cwd.readFileAlloc(allocator, file_path, 1024);
    defer allocator.free(file_contents);

    var lines = std.mem.tokenizeAny(u8, file_contents, "\n");
    var line_count: usize = 0;
    var field_count: usize = 0;
    const column_width: u8 = 17;

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var fields = std.mem.tokenizeAny(u8, line, ",");
        while (fields.next()) |_| {
            field_count += 1;
        }
        break;
    }

    const hline = try generateHeaderLine(allocator, field_count, column_width);
    std.debug.print("{s}\n", .{hline});

    lines = std.mem.tokenizeAny(u8, file_contents, "\n");
    if (lines.next()) |header_line| {
        var fields = std.mem.tokenizeAny(u8, header_line, ",");
        std.debug.print("| ", .{});
        while (fields.next()) |field| {
            std.debug.print("{s: ^16}| ", .{field});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("{s}\n", .{hline});

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var fields = std.mem.tokenizeAny(u8, line, ",");
        var first = true;
        std.debug.print("| ", .{});
        while (fields.next()) |field| {
            if (!first) {
                std.debug.print("| ", .{});
            }

            std.debug.print("{s: ^16}", .{field});
            first = false;
        }
        std.debug.print("|\n", .{});
        line_count += 1;

        if (line_limit) |limit| {
            if (line_count >= limit) break;
        }
    }
    std.debug.print("{s}\n", .{hline});
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: csv-zig <file> [-l <number_of_lines>]\n", .{});
        return;
    }

    const file_path: []const u8 = args[1];
    var line_limit: ?usize = null;

    var i: usize = 2;
    while (i < args.len) {
        if (std.mem.eql(u8, args[i], "-l")) {
            if ((i + 1) < args.len) {
                line_limit = std.fmt.parseInt(usize, args[i + 1], 10) catch {
                    std.debug.print("Invalid line limit value\n", .{});
                    return;
                };
                i += 2;
            } else {
                std.debug.print("Missing value for -l flag\n", .{});
                return;
            }
        } else {
            std.debug.print("Unknown argument: {s}\n", .{args[i]});
            return;
        }
    }

    try readCSV(allocator, file_path, line_limit);
}
