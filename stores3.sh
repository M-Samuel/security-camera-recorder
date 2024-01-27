#!/bin/bash
while true
do
/scripts/rename.sh
aws s3 sync $UPLOAD_DIRECTORY s3://$S3_BUCKET/$S3_DIRECTORY && rm -f $UPLOAD_DIRECTORY/*
sleep $SYNC_S3_AFTER_SECONDS
echo "S3 Bucket Upload Respawning.."
done