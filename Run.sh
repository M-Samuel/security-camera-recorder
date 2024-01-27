#!/bin/bash

# record rtsp stream to file 
/scripts/record.sh &
P1=$!

# upload file to amazon s3 and delete old files
/scripts/stores3.sh &
P2=$!

# upload file to amazon s3 and delete old files
/scripts/rename.sh &
P3=$!


wait $P1 $P2 $P3