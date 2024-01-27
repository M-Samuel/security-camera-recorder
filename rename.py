import subprocess
import time
from datetime import datetime
import re
import logging
import pytz
import os
import os
# Set up logging
logging.basicConfig(level=logging.INFO)

# Set the bucket
bucket = os.environ.get("S3_BUCKET")

# Get the list of all files in the bucket
logging.info("Getting the list of all files in the bucket.")
files = subprocess.check_output(f"aws s3 ls s3://{bucket} --recursive | awk '{{print $4}}'", shell=True).decode().splitlines()

# Loop through the files
for file in files:
    logging.info(f"Processing file: {file}")
    # Check if the file name matches the pattern 'stream_piece_*.mp4'
    if re.match(r'.*/stream_piece_\d+\.mp4', file):
        # Extract the Unix timestamp from the file name
        timestamp = re.search(r'\d+', file).group()

        # Get the last modified date of the file in Unix timestamp
        logging.info("Getting the last modified date of the file.")
        last_modified = subprocess.check_output(f"aws s3 ls s3://{bucket}/{file} --recursive | awk '{{print $1\" \"$2}}' | date -f - +%s", shell=True).decode().strip()

        # Get the current date in Unix timestamp
        current_date = int(time.time())

        # Calculate the difference in minutes
        difference = (current_date - int(last_modified)) / 60

        # Check if the difference is greater than 5 minutes
        if difference > 5:
            # Convert UTC timestamp to Mauritius time zone
            mauritius_tz = pytz.timezone('Indian/Mauritius')
            last_modified_dt = datetime.utcfromtimestamp(int(last_modified)).replace(tzinfo=pytz.utc).astimezone(mauritius_tz)

            # Get the date in 'yyyyMMddHHmmss' format
            date_format = last_modified_dt.strftime('%Y%m%d%H%M%S')

            # Get the directory of the source file
            directory = os.path.dirname(file)

            # Set the new file name
            new_file = f"{directory}/stream_piece_{date_format}.mp4"

            # Rename the file
            logging.info(f"Renaming file to: {new_file}")
            subprocess.run(f"aws s3 mv s3://{bucket}/{file} s3://{bucket}/{new_file}", shell=True)