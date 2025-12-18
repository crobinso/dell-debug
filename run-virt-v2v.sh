#!/bin/bash

set -euo pipefail

# Variables
DATE=$(date -u +%Y-%m-%d-%H%M%S)
LOG_FILE="${DATE}-v2v.log"
LINK_PATH="/var/tmp/fedora-40-sda"
OVA_URL="http://oirase.annexia.org/tmp/fedora-40.ova.xz"
OVA_FILE="/var/tmp/fedora-40.ova.xz"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <block-device>" >&2
    exit 1
fi

BLOCK_DEVICE="$1"

if [ ! -b "$BLOCK_DEVICE" ]; then
    echo "Error: $BLOCK_DEVICE is not a block device" >&2
    exit 1
fi

if [ ! -w "$BLOCK_DEVICE" ]; then
    echo "Error: No write access to $BLOCK_DEVICE" >&2
    exit 1
fi

echo "Creating symlink: $LINK_PATH -> $BLOCK_DEVICE"
ln -sf "$BLOCK_DEVICE" "$LINK_PATH"

if [ -f "$OVA_FILE" ]; then
    echo "File $OVA_FILE already exists, skipping download"
else
    echo "Downloading $OVA_URL to $OVA_FILE..."
    curl "$OVA_URL" -o "$OVA_FILE"
    echo "Download complete"
fi

# Redirect all output to log file and terminal
exec > >(tee "$LOG_FILE") 2>&1

set -x
virt-v2v -i ova "$OVA_FILE" -o local -os /var/tmp -on fedora-40 -v -x
virt-v2v-inspector -if raw -i disk --root first "$LINK_PATH" -v -x
