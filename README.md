# one2n-assessment = Site Reliability Engineer

This task was to create an HTTP service that lists the contents of an AWS S3 bucket, and deploy it using Terraform on AWS infrastructure. 
The service is written in Python using Flask, and the infrastructure is provisioned using Terraform.

Problem Statement

Part 1: HTTP Service

-> Implement an HTTP service that exposes an endpoint GET http://<IP>:<PORT>/list-bucket-content/<path>.
-> The service lists the content of a specific S3 bucket directory (path). If no path is provided, it returns the top-level content of the S3 bucket.
-> For Example:
   a) http://<IP>:<PORT>/list-bucket-content 
           should return top-level directories/files in the bucket.
   b)http://<IP>:<PORT>/list-bucket-content/<dir1> 
           should return content under dir1.

Part 2: Infrastructure Provisioning

-> Use Terraform to provision the infrastructure on AWS to deploy the service:
-> EC2 instance to run the HTTP service.
-> IAM role for the EC2 instance to access S3.
-> Security group to allow traffic on port 5000 (HTTP) and port 22 (SSH).

Solution Summary

1. HTTP Service (Python/Flask)

The HTTP service is implemented in Python using the Flask web framework. 
The key functionality is:

-> List S3 Bucket Content: The service lists the content of an S3 bucket (or specific directory path) using the AWS SDK (Boto3). It returns a JSON response with the directory and file names.
-> Endpoints:
   a) /list-bucket-content: Returns the top-level content of the S3 bucket.
   b) /list-bucket-content/<path>: Returns the content of a specific directory in the S3 bucket.
-> Error Handling:
   a) If AWS credentials are missing or incomplete, a 500 error with a message is returned.
   b) If an invalid path is provided, a 404 error is returned.


2. Terraform Infrastructure

-> AWS EC2: Provisioned an EC2 instance to host the Flask application.
-> IAM Role and Instance Profile: Created an IAM role with AmazonS3FullAccess to allow the EC2 instance to access the S3 bucket.
-> Security Group: Configured a security group to allow inbound traffic on port 5000 (HTTP) and port 22 (SSH).

