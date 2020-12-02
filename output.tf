output "jenkins_public_dns" {
  description = "The public DNS name of Jenkins instance"
  value       = aws_instance.jenkins.public_dns
}

output "jenkins_public_ip" {
  description = "The public IP address of Jenkins instance"
  value       = aws_instance.jenkins.public_ip
}
