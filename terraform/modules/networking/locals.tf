locals {
  prefix = "${var.env}-${var.module_name}"
  common_tags = {
    Environment = var.env
    Project     = var.project
    ModuleName  = var.module_name
    Name        = "${local.prefix}"
    ManagedBy   = var.managed_by
  }

  # Automatically select the first N available AZs (limited by actual available AZs)
  available_azs = slice(
    data.aws_availability_zones.available.names, 
    0, 
    min(var.max_azs, length(data.aws_availability_zones.available.names))
  )

  # Dynamically calculate subnet CIDR
  # Assuming VPC CIDR is /16, we will split it into /24 subnets
  vpc_cidr_prefix = split("/", var.vpc_cidr)[0]
  vpc_cidr_mask   = tonumber(split("/", var.vpc_cidr)[1])

  # Public subnets: 10.x.1.0/24, 10.x.2.0/24, ...
  public_subnet_cidrs = [
    for i in range(length(local.available_azs)) :
    "${join(".", slice(split(".", local.vpc_cidr_prefix), 0, 2))}.${i + 1}.0/24"
  ]

  # Private subnets: 10.x.11.0/24, 10.x.12.0/24, ...
  private_subnet_cidrs = [
    for i in range(length(local.available_azs)) :
    "${join(".", slice(split(".", local.vpc_cidr_prefix), 0, 2))}.${i + 11}.0/24"
  ]
}
