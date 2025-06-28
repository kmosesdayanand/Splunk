#!/bin/bash

# Configuration options
splunk_home="/opt/splunk"
admin_user="admin"
admin_password="splunk1234"
log_folder="/opt/splunk/rebuild_logs"
log_file="$log_folder/logfile_$(date +"%Y%m%d_%H%M%S").txt"
email_cc="cc@test.com"
from_email="rebuild_test@test.com"
index_name="cisco_asa"
frozen_buckets_path="/opt/splunk/myfrozenarchive/indexer1/rtest-1/frozendb/"

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
    local to_address="dumbledore@horgwarts.com"
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
    if grep -q "$bucket_path" "$processed_buckets_file"; then
        log SUCCESS "Bucket $bucket_path already processed. Skipping rebuild."
        
    else
        log INFO "Rebuilding bucket: $bucket_path"
        local result
        if result="$("$splunk_home/bin/splunk" rebuild "$bucket_path" "$index_name" 2>&1)"; then
            log SUCCESS "Bucket $bucket_path rebuilt successfully."
            echo "$(date +"%Y-%m-%d %H:%M:%S") - [SUCCESS] $indexer_name $index_name $bucket_path" >> "$processed_buckets_file"
        else
            log FAILURE "Failed to rebuild bucket: $bucket_path. Error: $result"
            script_success=false
            send_email_notification "Error: Failed to Rebuild Bucket" "Failed to rebuild bucket: $bucket_path. Error: $result"
        fi
    fi
}

# Create log folder if it doesn't exist
mkdir -p "$log_folder"

# Begin script execution
log INFO "Script execution started."

# Define the path to the processed buckets file
processed_buckets_file="$log_folder/processed_buckets.txt"

# Check if the specified index already exists
if "$splunk_home/bin/splunk" list index -auth "$admin_user:$admin_password" | grep -q "$index_name"; then
    log SUCCESS "Index $index_name already exists. Copying frozendb and rebuilding."

    # Copy frozen buckets from frozendb with progress and capture errors
    copy_buckets_with_progress "$frozen_buckets_path" "$splunk_home/var/lib/splunk/$index_name/thaweddb/"
    if [ $? -ne 0 ]; then
        log FAILURE "Failed to copy frozen buckets. Aborting script."
        exit 1
    else
        # Loop through each bucket and rebuild
        for bucket_path in "$splunk_home/var/lib/splunk/$index_name/thaweddb/"*; do
            if [ -d "$bucket_path" ]; then
                rebuild_bucket "$bucket_path"
            fi
        done
    fi
else
    log SUCCESS "Index $index_name does not exist. Creating index and copying frozen buckets."

    # Create index
    if "$splunk_home/bin/splunk" add index "$index_name" -auth "$admin_user:$admin_password" >> "$log_file" 2>&1; then
        log SUCCESS "Index created successfully."

        # Copy frozen buckets to thaweddb with progress and capture errors
        copy_buckets_with_progress "$frozen_buckets_path" "$splunk_home/var/lib/splunk/$index_name/thaweddb/"
        if [ $? -ne 0 ]; then
            log FAILURE "Failed to copy frozen buckets. Aborting script."
            exit 1
        else
            # Loop through each bucket and rebuild
            for bucket_path in "$splunk_home/var/lib/splunk/$index_name/thaweddb/"*; do
                if [ -d "$bucket_path" ]; then
                    rebuild_bucket "$bucket_path"
                fi
            done
        fi
    else
        log FAILURE "Failed to create index $index_name."
        script_success=false
        send_email_notification "Error: Failed to Create Index" "Failed to create index $index_name."
    fi
fi

# Log script completion
if [ "$script_success" = true ]; then
    log SUCCESS "Script execution completed successfully."
    log INFO "Script execution triggered a restart."
    /opt/splunk/bin/splunk restart
else
    log FAILURE "Script execution encountered errors. Please check the log for details."
    send_email_notification "Error: Script Execution Failed" "Script execution encountered errors. Please check the Rebuild log $log_file for details."
fi
