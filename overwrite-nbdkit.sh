#!/bin/bash

set -euo pipefail

SOURCE_FILE="nbdkit-file-plugin.so"
DEST_FILE="/usr/lib64/nbdkit/plugins/nbdkit-file-plugin.so"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found in current directory" >&2
    exit 1
fi

# Check if destination exists and files match
if [ -f "$DEST_FILE" ]; then
    if cmp -s "$SOURCE_FILE" "$DEST_FILE"; then
        echo "Files match, no action needed"
        exit 0
    fi
    echo "Files differ, backing up original to ${DEST_FILE}.orig"
    cp "$DEST_FILE" "${DEST_FILE}.orig"
    echo "Installing $SOURCE_FILE to $DEST_FILE"
else
    echo "Installing $SOURCE_FILE to $DEST_FILE"
fi

# Install the plugin
cp "$SOURCE_FILE" "$DEST_FILE"
echo "Installation complete"
