#!/bin/bash

print_header() {
  echo -e " \
 ███████████  ███                                                                        
░░███░░░░░░█ ░░░                                                                         
 ░███   █ ░  ████  ████████  █████████████   █████ ███ █████  ██████   ████████   ██████ 
 ░███████   ░░███ ░░███░░███░░███░░███░░███ ░░███ ░███░░███  ░░░░░███ ░░███░░███ ███░░███
 ░███░░░█    ░███  ░███ ░░░  ░███ ░███ ░███  ░███ ░███ ░███   ███████  ░███ ░░░ ░███████ 
 ░███  ░     ░███  ░███      ░███ ░███ ░███  ░░███████████   ███░░███  ░███     ░███░░░  
 █████       █████ █████     █████░███ █████  ░░████░████   ░░████████ █████    ░░██████ 
░░░░░       ░░░░░ ░░░░░     ░░░░░ ░░░ ░░░░░    ░░░░ ░░░░     ░░░░░░░░ ░░░░░      ░░░░░░  
                                                                                         
                                                                                         
                                                                                         
 ██████████                                                                     ███      
░░███░░░░███                                                                   ░███      
 ░███   ░░███ █████ ████ █████████████   ████████  ████████   ██████  ████████ ░███      
 ░███    ░███░░███ ░███ ░░███░░███░░███ ░░███░░███░░███░░███ ███░░███░░███░░███░███      
 ░███    ░███ ░███ ░███  ░███ ░███ ░███  ░███ ░███ ░███ ░███░███████  ░███ ░░░ ░███      
 ░███    ███  ░███ ░███  ░███ ░███ ░███  ░███ ░███ ░███ ░███░███░░░   ░███     ░░░       
 ██████████   ░░████████ █████░███ █████ ░███████  ░███████ ░░██████  █████     ███      
░░░░░░░░░░     ░░░░░░░░ ░░░░░ ░░░ ░░░░░  ░███░░░   ░███░░░   ░░░░░░  ░░░░░     ░░░       
                                         ░███      ░███                                  
                                         █████     █████                                 
                                        ░░░░░     ░░░░░                                  
"
  echo -e "Made By Taylor Christian Newsome"
}

print_help() {
  echo -e "Usage: firmware_dumpper.sh [options]"
  echo -e "\nOptions:"
  echo -e "  -h, --help          Display this help message."
  echo -e "  --all               Dump all available MediaTek firmware."
  echo -e "  --chipset <chipset> Specify the MediaTek chipset to dump (e.g., mt7612u)."
  echo -e "  --output-dir <dir>  Specify a custom output directory."
}

check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "$1 is required but not installed. Please install it first."
    exit 1
  fi
}

dump_firmware_unix() {
  local chip=$1
  local output_dir=$2

  echo "Running Unix/Linux firmware dump for $chip..."

  mkdir -p "$output_dir"

  echo "Dumping firmware information from kernel logs..."
  dmesg | grep -i "$chip" | tee "$output_dir/${chip}_dmesg.log"

  grep -i "firmware" "$output_dir/${chip}_dmesg.log" | awk -F'[' '{print $2}' | awk -F']' '{print $1}' | while read -r FIRMWARE_PATH; do
    if [ -f "$FIRMWARE_PATH" ]; then
      echo "Copying firmware file: $FIRMWARE_PATH"
      cp "$FIRMWARE_PATH" "$output_dir/"
    else
      echo "Firmware file not found: $FIRMWARE_PATH"
    fi
  done

  echo "Searching for hidden kernel firmware files..."
  for dir in /lib/firmware /usr/lib/firmware /lib/firmware/updates; do
    if [ -d "$dir" ]; then
      find "$dir" -type f -name "*$chip*" -exec cp {} "$output_dir/" \;
    fi
  done

  echo "Searching system directories for additional files..."
  find / -type f \( -name "*$chip*" -o -name "*mediatek*" \) 2>/dev/null | while read -r FILE; do
    echo "Copying file: $FILE"
    cp "$FILE" "$output_dir/"
  done

  echo "Firmware dump complete. Files are saved in: $output_dir"
}

dump_firmware_windows() {
  local chip=$1
  local output_dir=$2

  echo "Running Windows firmware dump for $chip..."

  mkdir -p "$output_dir"

  dmesg | grep -i "$chip" > "$output_dir/${chip}_dmesg.log"

  grep -i "firmware" "$output_dir/${chip}_dmesg.log" | awk -F'[' '{print $2}' | awk -F']' '{print $1}' | while read -r FIRMWARE_PATH; do
    if [ -f "$FIRMWARE_PATH" ]; then
      echo "Copying firmware file: $FIRMWARE_PATH"
      cp "$FIRMWARE_PATH" "$output_dir/"
    else
      echo "Firmware file not found: $FIRMWARE_PATH"
    fi
  done

  for dir in /lib/firmware /usr/lib/firmware /lib/firmware/updates; do
    if [ -d "$dir" ]; then
      find "$dir" -type f -name "*$chip*" -exec cp {} "$output_dir/" \;
    fi
  done

  echo "Searching system directories for additional files..."
  find / -type f \( -name "*$chip*" -o -name "*mediatek*" \) 2>/dev/null | while read -r FILE; do
    echo "Copying file: $FILE"
    cp "$FILE" "$output_dir/"
  done

  echo "Firmware dump complete. Files are saved in: $output_dir"
}

report_error() {
  echo "Error occurred: $1" >&2
  exit 1
}

validate_requirements() {
  if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root."
    exit 1
  fi

  for cmd in "dmesg" "grep" "find" "tee" "cp"; do
    check_command "$cmd"
  done
}

main() {
  print_header

  CHIP="mediatek"
  OUTPUT_DIR="/tmp/mediatek_firmware_dump"

  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -h|--help)
        print_help
        exit 0
        ;;
      --all)
        CHIP="mediatek"
        ;;
      --chipset)
        CHIP="$2"
        shift
        ;;
      --output-dir)
        OUTPUT_DIR="$2"
        shift
        ;;
      *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
    esac
    shift
  done

  if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
    validate_requirements
    dump_firmware_unix "$CHIP" "$OUTPUT_DIR"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* ]]; then
    dump_firmware_windows "$CHIP" "$OUTPUT_DIR"
  else
    report_error "Unsupported operating system."
  fi
}

main "$@"
