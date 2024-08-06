resource "aws_instance" "public_ec2" {
  count                  = var.public_ec2.instance_count ##length(var.vpc_public_subnets) * var.public_ec2["public_instance"].instance_count
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.public_ec2.instance_type
  key_name               = var.public_ec2.instance_keypair
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  #subnet_id              = aws_subnet.public_subnet[count.index % length(var.vpc_public_subnets)].id
  tags = {
    Name = "${local.environment}-${var.public_ec2.name}-${count.index + 1}"
  }
  root_block_device {
    volume_size = var.public_ec2.root_block_device.volume_size
    volume_type = var.public_ec2.root_block_device.volume_type
    iops        = var.public_ec2.root_block_device.iops
    throughput  = var.public_ec2.root_block_device.throughput
  }
  tags_all = local.common_tags
}

resource "aws_eip" "ec2_eip" {
  # count = 2
  depends_on = [aws_vpc.main]
  domain     = "vpc"
  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.name_prefix}-ec2-eip"
    }
  )
}

resource "aws_eip_association" "ec2_eip_assoc" {
  # count = 2
  instance_id   = aws_instance.public_ec2[0].id
  allocation_id = aws_eip.ec2_eip.id
}



