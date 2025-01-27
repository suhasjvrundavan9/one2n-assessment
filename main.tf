#configure the cloud provider and region
provider "aws" {
  region = "us-east-1"  
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_only_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "s3_access_instance_profile" {
  name = "s3-access-instance-profile"
  role = aws_iam_role.s3_access_role.name
}

#configure ec2 instance configurations
resource "aws_instance" "s3-service-instance" {
  ami           = "ami-0ac4dfaf1c5c0cce9"  
  instance_type = "t2.micro"               

  key_name      = "one2n-key"       
  security_groups = [aws_security_group.one2n-security-group.name]        
  iam_instance_profile   = aws_iam_instance_profile.s3_access_instance_profile.name

  tags = {
    Name = "S3-Content-Service"
  }

  # User data to install and start the service
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 python3-pip git
              pip3 install Flask boto3
              cd /home/ec2-user
              git clone https://github.com/suhasjvrundavan9/one2n-assessment.git
              cd one2n-assessment
              nohup python3 s3-bucket-listing.py &
              EOF
}



