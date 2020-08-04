output "gpnet_address" {
  value = aws_instance.web_gpnet.*.public_ip
}
