#!/bin/bash
while true
do
python /scripts/rename.py
sleep $RENAME_S3_AFTER_SECONDS
echo "S3 Bucket Renaming files..."
done