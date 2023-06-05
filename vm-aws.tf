resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  public_key = var.aws_pub_key
}

resource "aws_instance" "vm" {
  ami                         = "ami-0af6e9042ea5a4e3e" # Linux 22.04 LTS
  instance_type               = "t3.nano" # Na zona de disponibilidade sa-east-1b não suporta maquinas t2
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_id # Utilizando o data source do bucket s3 da VPC 
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_id]
  associate_public_ip_address = true

  tags = {
    "Name" = "vm-terraform"
  }
}