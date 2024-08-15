# MediaTek Firmware Dumpper
# Firmware Detection Identifies and extracts firmware files for any MediaTek chipset.
# Cross-Platform Compatibility Functions correctly in both Unix-like systems and Windows (MinGW).

```
██╗     ██╗███████╗ █████╗ ██████╗ ██████╗   
██║     ██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗  
██║     ██║  ███╔╝ ███████║██████╔╝██║  ██║  
██║     ██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║  
███████╗██║███████╗██║  ██║██║  ██║██████╔╝  
╚══════╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝   
                                             
███████╗ ██████╗ ██╗   ██╗ █████╗ ██████╗ ██╗
██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔══██╗██║
███████╗██║   ██║██║   ██║███████║██║  ██║██║
╚════██║██║▄▄ ██║██║   ██║██╔══██║██║  ██║╚═╝
███████║╚██████╔╝╚██████╔╝██║  ██║██████╔╝██╗
╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝
```
Overview

The MediaTek Firmware Dumper is a versatile script designed to extract firmware from MediaTek chipsets. It is compatible with Unix-like systems (Linux, macOS) and Windows (MinGW). This tool is essential for security researchers, developers, and system administrators who need to handle MediaTek firmware.

Features

Cross-Platform Compatibility: Functions on Linux, macOS, and Windows (MinGW).
MediaTek Chipset Support: Supports all MediaTek firmware and chipsets.
Customizable Output: Allows specifying output directories and chipset names.
Advanced Error Handling: Includes comprehensive error reporting and help instructions.
Usage

Basic Usage

To run the script and dump firmware for all MediaTek chipsets:

./main.sh

Options

-h, --help: Display the help message.
--all: Dump all available MediaTek firmware.
--chipset <chipset>: Specify the MediaTek chipset to dump (e.g., mt7612u).
--output-dir <dir>: Define a custom output directory.
Examples

Dump firmware for a specific MediaTek chipset and save it to a custom directory:

./main.sh --chipset mt7612u --output-dir /path/to/output

Dump all available MediaTek firmware:

./main.sh --all

Requirements

Unix-like Systems: Requires dmesg, grep, find, tee, and cp.
Windows (MinGW): Requires similar tools and utilities available in the MinGW environment.
Root Privileges: The script must be executed with root or administrative privileges.
Installation

Clone the Repository:

git clone https://github.com/SleepTheGod/MediaTek-Firmware-Dumpper/

Navigate to the Directory:

cd MediaTek-Firmware-Dumpper

Make the Script Executable (Unix-like systems):

chmod +x main.sh

Run the Script:

./main.sh

Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have suggestions or improvements.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Contact

For any questions or feedback, please contact Taylor Christian Newsome at frugaze@gmail.com.
