# Directory where build files and artifacts are generated
BUILD_DIR := "build"

# Default target: build the project and install system-wide
default: install

debian-dependencies:
    sudo apt-get install gettext git pkg-config libgd-dev libusb-dev libusb-1.0-0-dev

# Build the project in the build directory
build:
    #!/bin/bash
    set -e  # Exit immediately if a command fails
    mkdir -p {{BUILD_DIR}}
    cd {{BUILD_DIR}}
    # Configure the project with Release build type and generate build files
    cmake ../ -DCMAKE_BUILD_TYPE=Release
    # Compile the project using generated build files
    make

# Install the built files system-wide (requires sudo)
install: build
    sudo cmake --install {{BUILD_DIR}}

# Remove build artifacts to clean the workspace
clean:
    rm -rf {{BUILD_DIR}}

# Print printer info
printer-info:
    ptouch-print --info

# Test printing simple text on one line (Dry Run)
test-one-line:
    ptouch-print --text 'A' --writepng test.png
    xdg-open test.png

# Test printing simple text on two line (Dry Run)
test-two-line:
    ptouch-print --text 'A' 'B' --writepng test.png
    xdg-open test.png

# Test printing simple text on one line
test-print-one-line:
    ptouch-print --text 'A'

# Test printing simple text on two line
test-print-two-line:
    ptouch-print --text 'A' 'B'
