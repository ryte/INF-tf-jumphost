output "cosg" {
  description = "Security group to be added to all instances the jumphost should have access to"
  value       = aws_security_group.cosg.id
}

output "ip" {
  description = "Elastic IP of the jumphost"
  value       = aws_instance.instance.public_ip
}

output "fqdn" {
  description = "FQDN of the jumphost"
  value       = aws_route53_record.record.fqdn
}
