#!/bin/bash

# Define source and target directories
SOURCE_DIR=$RECORDING_DIRECTORY
TARGET_DIR=$UPLOAD_DIRECTORY

# Check if target directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Created target directory: $TARGET_DIR"
fi

echo "Finding files in the source directory that have not been modified in the last minute..."
# Find files in the source directory that have not been modified in the last minute
# and move them to the target directory
find "$SOURCE_DIR" -type f -mmin +1 -exec mv {} "$TARGET_DIR" \;
echo "Files moved successfully!"

echo "Checking if files have unix timestamp and converting it into yyyyMMddHHmmss format in the Mauritian time zone..."
# Check if files have unix timestamp and convert it into yyyyMMddHHmmss format in the Mauritian time zone
for file in "$TARGET_DIR"/*; do
    if [[ -f "$file" ]]; then
        timestamp=$(stat -c %Y "$file")
        formatted_date=$(TZ=Indian/Mauritius date -d "@$timestamp" +"%Y%m%d%H%M%S")
        new_filename="${file%.*}_$formatted_date.${file##*.}"
        mv "$file" "$new_filename"
        echo "Renamed file: $file to $new_filename"
    fi
done
echo "Conversion completed!"
