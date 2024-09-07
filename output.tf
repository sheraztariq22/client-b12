output "client_public_ip" {
  description = "The public IP address of the client instance."
  value       = aws_instance.client.public_ip
}
