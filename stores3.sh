#!/bin/bash
while true
do
/scripts/rename.sh
aws s3 sync $UPLOAD_DIRECTORY s3://$S3_BUCKET/$S3_DIRECTORY && find $UPLOAD_DIRECTORY -name '*.mp4' -type f -mmin +$DELETE_FILE_OLDER_MIN -delete -print
sleep $SYNC_S3_AFTER_SECONDS
echo "S3 Bucket Upload Respawning.."
done