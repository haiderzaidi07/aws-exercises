resource "aws_efs_file_system" "haider-tf-efs" {
  creation_token                  = "haider-tf-efs"
  throughput_mode                 = "provisioned"
  provisioned_throughput_in_mibps = 1
  encrypted                       = true

  tags = {
    Name = "haider-tf-efs"
  }
}

resource "aws_efs_mount_target" "mt-az1" {
  file_system_id  = aws_efs_file_system.haider-tf-efs.id
  subnet_id       = var.subnet_ids[0]
  security_groups = [var.security_group_id]
}

resource "aws_efs_mount_target" "mt-az2" {
  file_system_id  = aws_efs_file_system.haider-tf-efs.id
  subnet_id       = var.subnet_ids[1]
  security_groups = [var.security_group_id]
}