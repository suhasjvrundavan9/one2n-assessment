from flask import Flask, jsonify, abort
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

app = Flask(__name__)

# Configure your AWS credentials and S3 bucket name
S3_BUCKET = "one2n-s3-bucket-listing"
REGION = "us-east-1"

s3_client = boto3.client("s3", region_name=REGION)

def list_s3_bucket(path=""):
    try:
        # If path is not empty, list objects with the prefix as the path
        prefix = path + "/" if path else ""
        response = s3_client.list_objects_v2(Bucket=S3_BUCKET, Prefix=prefix, Delimiter='/')
        
        contents = []
        for prefix in response.get('CommonPrefixes', []):
            contents.append(prefix['Prefix'].split('/')[-2])
        for obj in response.get('Contents', []):
            contents.append(obj['Key'].split('/')[-1])
        
        return {"content": contents}
    except (NoCredentialsError, PartialCredentialsError):
        abort(500, description="AWS credentials are missing or incomplete.")
    except Exception as e:
        abort(500, description=str(e))

@app.route("/list-bucket-content", methods=["GET"])
@app.route("/list-bucket-content/<path:path>", methods=["GET"])
def list_bucket(path=""):
    return jsonify(list_s3_bucket(path))

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)



