#!/bin/bash
while true
do
ffmpeg -rtsp_transport tcp -i $RTSP  -c:v copy -c:a aac -reset_timestamps 1 -f segment -segment_time $SEG_TIME -strftime 1  /recordings/stream_piece_%s.mp4
echo "ffmpeg crashed Respawning.."
sleep 1
done