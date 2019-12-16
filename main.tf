data "aws_region" "current" {
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_actions       = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  alarm_description   = "Auto recover the EC2 instance in case of status check failures"
  alarm_name          = "EC2AutoRecover-${local.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = aws_instance.instance.id
  }

  evaluation_periods = "3"
  metric_name        = "StatusCheckFailed_System"
  namespace          = "AWS/EC2"
  period             = "60"
  statistic          = "Minimum"
  threshold          = "1"
}

resource "aws_eip_association" "eip" {
  allocation_id = aws_eip.eip.id
  instance_id   = aws_instance.instance.id
}

resource "aws_instance" "instance" {
  ami                  = var.ami
  iam_instance_profile = aws_iam_instance_profile.profile.name
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  tags                 = merge(local.tags, var.instance_tags)

  user_data = var.user_data

  vpc_security_group_ids = concat([aws_security_group.default.id, aws_security_group.cosg.id], var.additional_sgs)
}

