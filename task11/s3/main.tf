resource "aws_s3_bucket" "haider-tf-beanstalk-bucket" {
  bucket = "haider-tf-beanstalk-bucket"

  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}

resource "aws_s3_object" "haider-tf-beanstalk-object" {
  bucket = aws_s3_bucket.haider-tf-beanstalk-bucket.id
  key    = "haider-eb-nodejs.zip"
  source = "./app/haider-eb-nodejs.zip"
}