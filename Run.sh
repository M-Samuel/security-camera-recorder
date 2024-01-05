#!/bin/bash

# record rtsp stream to file 
ffmpeg -rtsp_transport tcp -i $RTSP  -c:v copy -c:a aac -reset_timestamps 1 -f segment -segment_time $SEG_TIME -strftime 1  /recordings/stream_piece_%s.mp4 &
P1=$!

# upload file to amazon s3 and delete old files
while true; do aws s3 sync /recordings s3://$S3_BUCKET/$S3_DIRECTORY && find /recordings -name '*.mp4' -type f -mmin +5 -delete -print; sleep $SYNC_S3_AFTER_SECONDS; done &
P2=$!

wait $P1 $P2