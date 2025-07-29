output "bucket_id" {
  value = aws_s3_bucket.haider-tf-beanstalk-bucket.id
}

output "object_key" {
  value = aws_s3_object.haider-tf-beanstalk-object.key
}