resource "aws_key_pair" "this" {
  count      = local.create_key_pair ? 1 : 0
  key_name   = "${local.deployment_name}-key-pair"
  public_key = var.ssh_public_key
  tags       = local.common_tags
}

resource "aws_eip" "this" {
  count    = var.create_eip && !local.create_asg ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.this[0].id
  tags     = merge(local.common_tags, { Name = "${var.instance_name}-eip" })
}
