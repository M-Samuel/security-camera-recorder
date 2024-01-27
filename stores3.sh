#!/bin/bash
while true
do
aws s3 sync /recordings s3://$S3_BUCKET/$S3_DIRECTORY && find /recordings -name '*.mp4' -type f -mmin +$DELETE_FILE_OLDER_MIN -delete -print
sleep $SYNC_S3_AFTER_SECONDS
echo "S3 Bucket Upload Respawning.."
done