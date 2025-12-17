#!/bin/bash

set -euo pipefail

LOOP_FILE="loop0.raw"
LOOP_DEVICE="/dev/loop0"

if [ -f "$LOOP_FILE" ]; then
    # File exists, tear down
    echo "File $LOOP_FILE exists, tearing down..."

    echo "Detaching loop device: $LOOP_DEVICE"
    sudo losetup -d "$LOOP_DEVICE" || true

    echo "Deleting file: $LOOP_FILE"
    rm -f "$LOOP_FILE" || true

    echo "Teardown complete"
else
    # File doesn't exist, set up
    echo "Creating 20G sparse file: $LOOP_FILE"
    truncate -s 7G "$LOOP_FILE"

    echo "Setting up loop device: $LOOP_DEVICE -> $LOOP_FILE"
    sudo losetup "$LOOP_DEVICE" "$LOOP_FILE"

    echo "Loop device setup complete"
    sudo losetup -l "$LOOP_DEVICE"
fi
