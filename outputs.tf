output "cosg" {
  value       = aws_security_group.cosg.id
  description = "Security group to be added to all instances the jumphost should have access to."
}

output "ip" {
  value       = aws_instance.instance.public_ip
  description = "Elastic IP of the jumphost."
}

output "fqdn" {
  value       = aws_route53_record.record.fqdn
  description = "FQDN of the jumphost."
}

