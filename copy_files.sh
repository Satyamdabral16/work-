#!/bin/bash

# Define variables
SOURCE_SERVER="15.207.29.230"
SOURCE_PATH="bitnami@15.207.29.230:/opt/bitnami/work/"
DESTINATION_SERVER="65.2.53.129"
DESTINATION_USER="ubuntu"
DESTINATION_PATH="/home/ubuntu/work/A/"
LOG_FILE="/opt/bitnami/work/copy_files.log"
SSH_KEY="/opt/bitnami/work/id-rsa"

# Function to log messages
log_message() {
    echo "$(date) $1" >> "$LOG_FILE"
}

# Ensure the private key file has the correct permissions
chmod 600 "$SSH_KEY"

# Start the SSH agent and add the private key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

# Enable agent forwarding
ssh -o ForwardAgent=yes "$DESTINATION_USER@$DESTINATION_SERVER" "echo Agent forwarding is working"

# Log the start of the file copy process
log_message "Copying files started."

# Use scp to copy files
scp -o ForwardAgent=yes -i "$SSH_KEY" -r "$SOURCE_PATH" "$DESTINATION_USER@$DESTINATION_SERVER:$DESTINATION_PATH/"

# Check the exit status of the scp command
if [ $? -eq 0 ]; then
    log_message "Files copied successfully."
else
    log_message "Error: Files could not be copied. Check the log for details."
fi

# Stop the SSH agent
eval "$(ssh-agent -k)"

