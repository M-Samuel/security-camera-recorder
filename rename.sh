#!/bin/bash

# Define source and target directories
SOURCE_DIR=$RECORDING_DIRECTORY
TARGET_DIR=$UPLOAD_DIRECTORY

# Check if target directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Created target directory: $TARGET_DIR"
fi

# Find files in the source directory that haven't been modified in the last minute and move them to the target directory
find "$SOURCE_DIR" -type f -mmin +1 -exec mv {} "$TARGET_DIR" \;
echo "Moved files from $SOURCE_DIR to $TARGET_DIR"

# Rename files in the target directory with Unix timestamp to yyyyMMddHHmmss format and convert to Mauritian time zone
find "$TARGET_DIR" -type f -name "*[0-9]*" -exec sh -c '
    filename=$(basename "$1")
    timestamp="${filename##*_}"
    if [[ $timestamp =~ ^[0-9]+$ ]]; then
        new_timestamp=$(date -d "@$timestamp" "+%Y%m%d%H%M%S" -u)
        new_filename="$(TZ=Indian/Mauritius date -d "$new_timestamp" "+%Y%m%d%H%M%S").${filename##*.}"
        mv "$1" "$(dirname "$1")/$new_filename"
        echo "Renamed file: $1 to $new_filename"
    fi
bash {} \;
