resource "tls_private_key" "pvt_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.pvt_key.public_key_openssh
}

data "aws_s3_bucket" "pvt_key" {
  bucket = "test-private-key-bucket"
}

resource "aws_s3_bucket_object" "instance_key" {
  bucket = data.aws_s3_bucket.pvt_key.bucket
  key = var.key_name
  server_side_encryption = "AES256"
  content_type           = "text/plain"
  content                = <<EOF
private_key_pem: ${tls_private_key.pvt_key.private_key_pem}
EOF
}

resource "aws_instance" "ec2_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  
  key_name = aws_key_pair.key_pair.key_name
  #vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id = var.subnet_ids

  tags = {
    Name = var.instance_name
  }
}
