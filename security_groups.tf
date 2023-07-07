resource "aws_security_group" "default" {
  name_prefix = "${local.short_name}-jump-default-sg"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  dynamic "ingress" {
    for_each = var.access_cidr_blocks
    content {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [ ingress.value ]
    }
  }

  tags   = merge(local.tags, { Role = "default" })
  vpc_id = var.vpc_id
}

resource "aws_security_group" "cosg" {
  name_prefix = "${local.short_name}-jump-cosg-sg"
  tags        = merge(local.tags, { Role = "COSG" })
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }
}
