output "node-ips" {
  value = aws_eip.re-eip[*].public_ip
}

output "re-security-group" {
  value = aws_security_group.re.id
}

output "node-internal-ips" {
  value = aws_instance.re[*].private_ip
}
