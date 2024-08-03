resource "aws_instance" "private_ec2" {
  count                  = var.private_ec2.instance_count ##length(var.vpc_private_subnets) * var.private_ec2.root_block_device.instance_count
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.private_ec2.instance_type
  key_name               = var.private_ec2.instance_keypair
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private_subnet[count.index % length(var.vpc_private_subnets)].id
  #user_data = file(var.user_data_file[count.index])
  user_data = file("${path.module}/server-1.sh")
  tags = {
    Name = "${local.environment}-${var.private_ec2.name}-${count.index + 1}"
  }
  root_block_device {
    volume_size = var.private_ec2.root_block_device.volume_size
    volume_type = var.private_ec2.root_block_device.volume_type
    iops        = var.private_ec2.root_block_device.iops
    throughput  = var.private_ec2.root_block_device.throughput
  }
  tags_all = local.common_tags
}

