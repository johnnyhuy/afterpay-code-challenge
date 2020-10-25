output "load_balancer_dns" {
  value = aws_lb.this.dns_name
  description = "Load balancer DNS name to access the public website"
}

output "host_a_dns" {
  value = aws_instance.a.public_dns
}

output "host_b_dns" {
  value = aws_instance.a.public_dns
}

output "host_c_dns" {
  value = aws_instance.a.public_dns
}