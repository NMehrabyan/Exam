
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

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "nar.babkenasoyan.com"
 policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    =["s3:GetObject"],
        Resource  =[ "arn:aws:s3:::nar.babkenasoyan.com/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}