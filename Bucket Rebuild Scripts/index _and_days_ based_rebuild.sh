#!/bin/bash

# Configuration options
splunk_home="/opt/splunk"
admin_user="admin"
admin_password="splunk1234"
log_folder="/opt/splunk/rebuild_logs"
log_file="$log_folder/logfile_$(date +"%Y%m%d_%H%M%S").txt"
email_cc="mosesdayanand@test.com"
from_email="test_rebuild@test.com"
archive_path="/opt/splunk/myfrozenarchive/"

# Global variables for input parameters
index_name="rtest-1"
start_day="01"
start_month="06"
start_year="2024"
end_day="22"
end_month="06"
end_year="2024"

# Set a flag to track the success of the entire process
script_success=true

# Function to log messages to a file
log() {
    local level=$1
    local message=$2
    echo "[$level] $(date +"%Y-%m-%d %H:%M:%S") - $message" >> "$log_file"
}

# Function to send email notification using /usr/sbin/sendmail
send_email_notification() {
    local subject="$1"
    local body="$2"
    local to_address="mosesdayanand@positka.com"
    local headers="Subject: $subject\nTo: $to_address\nCc: $email_cc\nFrom: $from_email\n"
    echo -e "$headers\n$body" | /usr/sbin/sendmail -t
}

# Function to copy frozen buckets with progress and capture errors
copy_buckets_with_progress() {
    local source_folder="$1"
    local destination_folder="$2"
    log INFO "Copying buckets from $source_folder to $destination_folder"
    if rsync -a --recursive --exclude='rb_*' --ignore-existing "$source_folder" "$destination_folder" >> "$log_file" 2>&1; then
        log SUCCESS "Successfully copied frozen buckets from $source_folder to $destination_folder."
    else
        log FAILURE "Failed to copy frozen buckets from $source_folder to $destination_folder. See log for details."
        script_success=false
        send_email_notification "Error: Failed to Copy Frozen Buckets" "Failed to copy frozen buckets from $source_folder to $destination_folder. Please check the Rebuild log $log_file for details."
    fi
}

# Function to rebuild a bucket and capture errors
rebuild_bucket() {
    local bucket_path="$1"
    log INFO "Rebuilding bucket: $bucket_path"
    local result
    if result="$("$splunk_home/bin/splunk" rebuild "$bucket_path" 2>&1)"; then
        log SUCCESS "Bucket $bucket_path rebuilt successfully."
    else
        log FAILURE "Failed to rebuild bucket: $bucket_path. Error: $result"
        script_success=false
        send_email_notification "Error: Failed to Rebuild Bucket" "Failed to rebuild bucket: $bucket_path. Error: $result"
    fi
}

# Function to get the timestamp range for a given start and end date
get_timestamp_range() {
    local start_year=$1
    local start_month=$2
    local start_day=$3
    local end_year=$4
    local end_month=$5
    local end_day=$6
    local start_timestamp=$(date -d "$start_year-$start_month-$start_day 00:00:00" +%s)
    local end_timestamp=$(date -d "$end_year-$end_month-$end_day 23:59:59" +%s)
    echo "$start_timestamp $end_timestamp"
}

# Create log folder if it doesn't exist
mkdir -p "$log_folder"

# Begin script execution
log INFO "Script execution started."

# Define the path to the processed buckets file
processed_buckets_file="$log_folder/processed_buckets.txt"
touch "$processed_buckets_file"

if [ -z "$index_name" ] || [ -z "$start_day" ] || [ -z "$start_month" ] || [ -z "$start_year" ] || [ -z "$end_day" ] || [ -z "$end_month" ] || [ -z "$end_year" ]; then
    log FAILURE "Index name, start date, and end date parameters are required."
    send_email_notification "Error: Missing Parameters" "Index name, start date, and end date parameters are required for the script to run."
    exit 1
fi

# Get timestamp range for the specified start and end dates
read start_timestamp end_timestamp <<< $(get_timestamp_range $start_year $start_month $start_day $end_year $end_month $end_day)
log INFO "Timestamp range: $start_timestamp to $end_timestamp ($(date -d @$start_timestamp) to $(date -d @$end_timestamp))"

# Check if the specified index already exists
if "$splunk_home/bin/splunk" list index -auth "$admin_user:$admin_password" | grep -q "$index_name"; then
    log SUCCESS "Index $index_name already exists. Proceeding with bucket operations."
else
    log INFO "Index $index_name does not exist. Creating index."
    if "$splunk_home/bin/splunk" add index "$index_name" -auth "$admin_user:$admin_password" >> "$log_file" 2>&1; then
        log SUCCESS "Index $index_name created successfully."
    else
        log FAILURE "Failed to create index $index_name."
        send_email_notification "Error: Failed to Create Index" "Failed to create index $index_name."
        exit 1
    fi
fi

# Loop through indexers and check for matching buckets
for indexer in "$archive_path"/*; do
    index_folder="$indexer/$index_name/frozendb"
    if [ ! -d "$index_folder" ]; then
        log INFO "Index folder $index_folder not found on $indexer. Skipping."
        continue
    fi

    for bucket in "$index_folder"/db_*; do
        if [ -d "$bucket" ]; then
            bucket_name=$(basename "$bucket")
            bucket_start_time=$(echo "$bucket_name" | cut -d_ -f2)
            bucket_end_time=$(echo "$bucket_name" | cut -d_ -f3)

            log INFO "Checking bucket $bucket_name with timestamps $bucket_start_time to $bucket_end_time"

            if [ "$bucket_start_time" -ge "$start_timestamp" ] && [ "$bucket_end_time" -le "$end_timestamp" ]; then
                thaweddb_path="$splunk_home/var/lib/splunk/$index_name/thaweddb"
                mkdir -p "$thaweddb_path"
                log INFO "Copying and rebuilding bucket $bucket_name"
                copy_buckets_with_progress "$bucket" "$thaweddb_path"
                if [ "$script_success" = true ]; then
                    rebuild_bucket "$thaweddb_path/$bucket_name"
                fi
            else
                log INFO "Bucket $bucket_name does not fall within the specified time range. Skipping."
            fi
        fi
    done
done

# Log script completion
if [ "$script_success" = true ]; then
    log SUCCESS "Script execution completed successfully."
else
    log FAILURE "Script execution completed with errors. Check the log for details."
    send_email_notification "Error: Script Execution Completed with Errors" "Script execution completed with errors. Check the log for details."
fi

