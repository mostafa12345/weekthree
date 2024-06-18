terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
     bucket         = "testasdawf4115154"
     key            = "terraform.tfstate"
     region         = "us-east-1"
    }
 }

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "s3_bucket_01" {

   bucket = "mostaf1215sda4415"
   force_destroy = true
   object_lock_enabled = false 
   tags = {
    Name        = "s3_bucket_01"
    Environment = "terraformChamps"
  }
}

resource "aws_s3_object" "s3_directory_logs" {
  bucket = aws_s3_bucket.s3_bucket_01.bucket
  key    = "logs/"
  content_type = "application/x-directory"

  tags = {
    Environment = "terraformChamps"
  }
}

resource "aws_iam_user" "mostafa" {
  name = "mostafa"

  tags = {
    Environment = "terraformChamps"
  }
}

resource "aws_iam_user" "taha" {
  name = "taha"

  tags = {
    Environment = "terraformChamps"
  }
}

resource "aws_iam_role" "taha_role" {
  name = "TahaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        "AWS": "${aws_iam_user.taha.arn}"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = "terraformChamps"
  
  }
}
resource "aws_iam_policy" "taha_policy" {
  name        = "TahaS3GetObjectPolicy"
  description = "Policy to allow s3:GetObject from logs directory"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "s3:GetObject",
      Resource = "arn:aws:s3:::${aws_s3_bucket.s3_bucket_01.bucket}/logs/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "taha_attach_policy" {
  role       = aws_iam_role.taha_role.name
  policy_arn = aws_iam_policy.taha_policy.arn
}

resource "aws_iam_policy" "policy_mostafa" {
  name        = "policy-mostafa"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = "s3:PutObject",
      Effect   = "Allow",
      Resource = "arn:aws:s3:::${aws_s3_bucket.s3_bucket_01.bucket}/*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "mostafa_policy_attachment" {
  user       = aws_iam_user.mostafa.name
  policy_arn = aws_iam_policy.policy_mostafa.arn
}
