output "egress_public_ip" {
  description = "Public IP that all private-subnet egress leaves from"
  value       = aws_eip.this.public_ip
}

output "eni_id" {
  description = "Static ENI the private default route targets"
  value       = module.fck_nat.eni_id
}

output "autoscaling_group_arn" {
  description = "ASG keeping a single NAT instance alive"
  value       = module.fck_nat.autoscaling_group_arn
}

output "security_group_id" {
  description = "Security group on the NAT instance"
  value       = module.fck_nat.security_group_id
}
