# csvz

A simple CSV reader utility built in Zig. This tool reads CSV files and prints out the formatted contents in a table format. It allows for an optional flag to limit the number of lines displayed.

## Features

- Reads a CSV file and prints its contents in a formatted table format.
- Optionally limits the number of lines displayed using the `-l` flag.
- Automatically formats columns based on the longest field in each column.

## Requirements

- [Zig Programming Language](https://ziglang.org/download/) (version 0.10.0 or later)

## Installation

To use this tool, clone the repository and compile the Zig source code.

```bash
git clone https://github.com/novaru/csvz.git
cd csvz
zig build-exe src/main.zig
```

## Usage

Run the compiled executable with the CSV file path as an argument. You can also provide an optional `-l` flag to limit the number of lines displayed.

### Example:

```bash
./csvz path/to/file.csv
```

This will read the CSV file and print all rows.

```bash
./csvz path/to/file.csv -l 5
```

This will limit the output to 5 rows from the CSV file.

### Command-line options

- `<file>`: The path to the CSV file.
- `-l <number_of_lines>`: (Optional) Limit the number of lines printed from the CSV file.

## Example Output

For a CSV file `sample.csv`:

```
Name, Age, City
John Doe, 29, New York
Jane Smith, 25, Los Angeles
Alice Johnson, 32, Chicago
```

Running the command:

```bash
./csvz sample.csv
```

Would produce the following output:

```
+-----------------+-----------------+-----------------+
|      Name       |       Age       |       City      |
+-----------------+-----------------+-----------------+
|    John Doe     |        29       |     New York    |
|   Jane Smith    |        25       |    Los Angeles  |
|  Alice Johnson  |        32       |     Chicago     |
+-----------------+-----------------+-----------------+
```

## Error Handling

- If the file cannot be read, the program will output an error message and terminate.
- If the `-l` flag is provided but a valid number is not, the program will print an error message indicating the invalid input.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more information.
