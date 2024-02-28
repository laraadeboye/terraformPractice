
output "ec2_public_ip" {
  value =module.app-Server.instance.public_ip
}