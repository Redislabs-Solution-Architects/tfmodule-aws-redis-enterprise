output "node-ips" {
  value = aws_eip.re-eip[*].public_ip
}
