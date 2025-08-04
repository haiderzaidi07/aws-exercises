output "bucket_arn" {
  value = aws_s3_bucket.haider-tf-beanstalk-codepipeline-bucket.arn
}

output "bucket_id" {
  value = aws_s3_bucket.haider-tf-beanstalk-codepipeline-bucket.id
}

output "object_key" {
  value = aws_s3_object.haider-tf-beanstalk-object.key
}

output "bucket_location" {
  value = aws_s3_bucket.haider-tf-beanstalk-codepipeline-bucket.bucket
}