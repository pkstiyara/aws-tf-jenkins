
output "Jenkins-IP" {
  value = aws_instance.node-1-server.public_ip
}


output "ssh-1" {
    value = "ssh -i my_key_pair ec2-user@${aws_instance.node-1-server.public_ip}"
}

output "Jenkins_URL" {
    value = "http://${aws_instance.node-1-server.public_ip}:8080"
  
}