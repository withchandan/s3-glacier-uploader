#!/bin/bash

FOLDER_PATH="upload-29-11-2024"             # Change to your desired folder name in the bucket
LOCAL_FOLDER="../../Documents/Premiere Pro" # Change to your local data folder path

# ============================================================================
# DO NOT MODIFY ANYTHING BELOW THIS LINE
# ============================================================================

# Variables
BUCKET_NAME="la.video.production.backup"
VERIFY_LOG="verification_results.log"

# Step 1: Upload Files to Specific Folder in S3 Glacier
echo "Step 1: Uploading files to S3 Glacier Glacier in folder s3://$BUCKET_NAME/$FOLDER_PATH/..."
find "$LOCAL_FOLDER" -type f | while read -r FILE; do
    FILE_NAME=$(basename "$FILE")
    echo "Uploading file: $FILE_NAME to s3://$BUCKET_NAME/$FOLDER_PATH/"
    aws s3 cp "$FILE" s3://$BUCKET_NAME/$FOLDER_PATH/ --recursive --storage-class GLACIER
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upload file $FILE_NAME. Retrying..."
        aws s3 cp "$FILE" s3://$BUCKET_NAME/$FOLDER_PATH/ --recursive --storage-class GLACIER
        if [ $? -ne 0 ]; then
            echo "Error: Failed again. Moving to the next file."
        fi
    fi
done
echo "Upload completed successfully."

# Step 2: Verify Uploaded Files
echo "Step 2: Verifying uploaded files in folder s3://$BUCKET_NAME/$FOLDER_PATH/..."
touch $VERIFY_LOG
find "$LOCAL_FOLDER" -type f | while read -r FILE; do
    FILE_NAME=$(basename "$FILE")
    LOCAL_SIZE=$(stat -f %z "$FILE") # Local file size in bytes

    echo $LOCAL_SIZE $FILE

    # Fetch file metadata from S3
    S3_METADATA=$(aws s3api head-object --bucket $BUCKET_NAME --key "$FOLDER_PATH/$FILE_NAME" 2>/dev/null)

    if [ $? -eq 0 ]; then
        S3_SIZE=$(echo "$S3_METADATA" | jq -r '.ContentLength') # Extract file size from metadata
        if [ "$LOCAL_SIZE" -eq "$S3_SIZE" ]; then
            echo "MATCH: $FILE_NAME" >>$VERIFY_LOG
        else
            echo "SIZE MISMATCH: $FILE_NAME (Local: $LOCAL_SIZE, S3: $S3_SIZE)" >>$VERIFY_LOG
        fi
    else
        echo "MISSING IN S3: $FILE_NAME" >>$VERIFY_LOG
    fi
done
echo "Verification complete. Results saved to $VERIFY_LOG."

Step 3: Summary
echo "Step 3: Summary of the process:"
echo "Total files processed: $(find "$LOCAL_FOLDER" -type f | wc -l)"
echo "Verification results (matches, mismatches, missing):"
cat $VERIFY_LOG
