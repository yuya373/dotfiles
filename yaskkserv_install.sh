#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Downloading yaskkserv2 for macOS..."

    # Create temporary directory
    TEMP_DIR=$(mktemp -d /tmp/yaskkserv2.XXXXXX)
    cd "$TEMP_DIR"

    # Download the macOS release using gh
    gh release download --repo wachikun/yaskkserv2 --pattern '*apple-darwin*.tar.gz' --clobber

    if [ $? -ne 0 ]; then
        echo "Error: Failed to download macOS release"
        cd - > /dev/null
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Extract and install
    tar -xzf *apple-darwin*.tar.gz

    # Find the actual binary name after extraction
    # The tar.gz extracts to a directory like yaskkserv2-0.1.7-x86_64-apple-darwin
    EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "yaskkserv2-*-apple-darwin" | head -1)

    if [ -n "$EXTRACTED_DIR" ] && [ -f "$EXTRACTED_DIR/yaskkserv2" ]; then
        sudo mv "$EXTRACTED_DIR/yaskkserv2" /usr/local/bin/
        # Also move yaskkserv2_make_dictionary if it exists
        if [ -f "$EXTRACTED_DIR/yaskkserv2_make_dictionary" ]; then
            sudo mv "$EXTRACTED_DIR/yaskkserv2_make_dictionary" /usr/local/bin/
        fi
    else
        echo "Error: Could not find yaskkserv2 binary after extraction"
        echo "Contents of current directory:"
        ls -la
        cd - > /dev/null
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    echo "yaskkserv2 installed to /usr/local/bin/"
else
    echo "yay -S yaskkserv2"
fi
