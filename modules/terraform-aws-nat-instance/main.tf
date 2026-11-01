# Low-cost egress for private subnets: a fck-nat instance in place of a managed
# NAT gateway (~$6/mo vs ~$33/mo plus per-GB processing).
#
# Runs as a single-instance ASG (fck-nat "ha_mode"): if the instance fails or
# is reclaimed, the ASG launches a replacement that reattaches the same static
# ENI (so the route table never changes) and the same EIP (so the external
# egress address never changes). Expect a few minutes of lost egress during a
# replacement.
#
# Don't stop this instance by hand: the ASG treats a stopped instance as
# unhealthy and replaces it. Scale the ASG to 0 instead.

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.name}-eip" })
}

module "fck_nat" {
  source  = "RaJiska/fck-nat/aws"
  version = "1.6.1"

  name      = var.name
  vpc_id    = var.vpc_id
  subnet_id = var.public_subnet_id

  ha_mode            = true
  instance_type      = var.instance_type
  use_spot_instances = var.use_spot_instances
  eip_allocation_ids = [aws_eip.this.allocation_id]

  update_route_tables = true
  route_tables_ids    = var.private_route_table_ids

  # Lets the instance be reached with SSM for troubleshooting / packet capture.
  attach_ssm_policy = true

  tags = var.tags
}
