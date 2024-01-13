output "jenkins_public_ip" {
    value = aws_instance.jenkins.public_ip  
}
output "jenkins_shh" {
    value = "ssh -i <path of key> ubuntu@${aws_instance.jenkins.public_ip}"

}

output "jenkins_url" {
    value = "http://${aws_instance.jenkins.public_ip}:8080"
  
}