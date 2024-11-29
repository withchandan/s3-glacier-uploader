
# **s3-glacier-uploader**

### **Description**  

**s3-glacier-uploader** is a bash script designed to efficiently upload large datasets to AWS S3, specifically using the Glacier Deep Archive storage class. This script simplifies the process of:  

1. Uploading files in bulk to a specified bucket and folder.  
2. Verifying the uploaded files by checking their presence and size in S3.  
3. Logging upload and verification results for easy tracking.  

Ideal for archiving massive amounts of data with reliability and minimal manual intervention.  

---

### **Key Features**

- **Flexible Uploads:** Supports uploads to a specific folder within an S3 bucket.  
- **Retry Mechanism:** Ensures reliability by retrying failed uploads.  
- **Lightweight Verification:** Confirms file presence and size match in S3.  
- **Comprehensive Logging:** Logs results for matches, mismatches, and missing files.  

---

### **Use Case**  

This tool is perfect for businesses or individuals looking to securely and efficiently archive data to AWS Glacier Deep Archive.

---

### **Getting Started**  

#### **Prerequisites**  

- AWS CLI installed and configured with appropriate credentials.  
- Bash shell environment (Linux/MacOS/WSL).  

#### **Setup**

1. Clone the repository:  

   ```bash
   git clone https://github.com/withchandan/s3-glacier-uploader
   cd s3-glacier-uploader
   ```

2. Make the script executable:  

   ```bash
   chmod +x script.sh
   ```

3. Update the script variables:
   - `BUCKET_NAME`: Your S3 bucket name.  
   - `FOLDER_PATH`: The folder path in the bucket where files will be uploaded.  
   - `LOCAL_FOLDER`: Path to the local folder containing files to be uploaded.

4. Run the script:  

   ```bash
   ./script.sh
   ```
