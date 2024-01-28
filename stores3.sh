#!/bin/bash
while true
do
    if ! pgrep -x "ffmpeg" > /dev/null; then
        echo "ffmpeg is not running, exiting.."
        break
    fi
    /scripts/rename.sh
    aws s3 sync --storage-class STANDARD_IA $UPLOAD_DIRECTORY s3://$S3_BUCKET/$S3_DIRECTORY && rm -f $UPLOAD_DIRECTORY/*
    sleep $SYNC_S3_AFTER_SECONDS
    echo "S3 Bucket Upload Respawning.."
done