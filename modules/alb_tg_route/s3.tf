# Configure S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "nar.babkenasoyan.com"
  force_destroy = true
  website {
    index_document = "index.html"
  }
}

# Upload an index.html file to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html" 
  source = "d:/index.html" 
  content_type = "text/html"
}

# Create an S3 website endpoint
data "aws_s3_bucket" "my_bucket_details" {
  bucket = aws_s3_bucket.my_bucket.id
}

resource "aws_iam_role" "role" {
  name               = "role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"  # Assuming EC2 will assume this role
      },
      Action    = "sts:AssumeRole"
    }]
  })
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:PutBucketPolicy"]
    resources = [aws_s3_bucket.my_bucket.arn]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name        = "S3BucketPolicyAccess"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "s3_policy_attachment"
  roles      = [aws_iam_role.role.name]  # Replace with the name of your IAM role
  policy_arn = aws_iam_policy.s3_policy.arn
}
