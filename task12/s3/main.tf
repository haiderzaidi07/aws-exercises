resource "aws_s3_bucket" "haider-tf-beanstalk-codepipeline-bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_public_access_block" "beanstalk_codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.haider-tf-beanstalk-codepipeline-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "haider-tf-beanstalk-object" {
  bucket = aws_s3_bucket.haider-tf-beanstalk-codepipeline-bucket.id
  key    = "haider-eb-nodejs.zip"
  source = "./app/haider-eb-nodejs.zip"

  depends_on = [null_resource.create_nodejs_app_zip]
}

resource "null_resource" "create_nodejs_app_zip" {

  provisioner "local-exec" {
    command = file("${path.root}/create_app_zip.sh")
  }

  triggers = {
    "run_at" = timestamp()
  }
}