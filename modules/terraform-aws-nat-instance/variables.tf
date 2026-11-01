variable "name" {
  description = "Name for the NAT instance and its resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC the NAT instance serves"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet to place the NAT instance in"
  type        = string
}

variable "private_route_table_ids" {
  description = "Private route tables whose 0.0.0.0/0 route should point at the NAT instance"
  type        = map(string)
}

variable "instance_type" {
  description = "Graviton instance type for the NAT instance"
  type        = string
  default     = "t4g.micro"
}

variable "use_spot_instances" {
  description = "Run the NAT instance on Spot; the ASG relaunches it if reclaimed"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the NAT instance and its resources"
  type        = map(string)
  default     = {}
}
