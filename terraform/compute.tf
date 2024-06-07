data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240411"]
  }
}

resource "random_id" "node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_key_pair" "terran_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "terran_main" {
  count                       = var.main_instance_count
  instance_type               = var.main_instance_type
  ami                         = data.aws_ami.server_ami.id
  key_name                    = aws_key_pair.terran_auth.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  subnet_id                   = aws_subnet.public[count.index].id
  user_data                   = templatefile("./main-userdata.tpl", { new_hostname = "terran-main-${random_id.node_id[count.index].dec}" })
  user_data_replace_on_change = true
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "terran-main-${random_id.node_id[count.index].dec}"
  }
}
