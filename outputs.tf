output "node-ips" {
  value = aws_eip.re-eip[*].public_ip
}

output "re-security-group" {
  value = aws_security_group.re.id
}
