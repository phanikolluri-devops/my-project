module "eks" {
  source = "./modules/eks"
  env = var.env
  subnets = var.subnets
}


module "databases" {
  source = "./modules/rds"
  for_each = var.databases
  allocated_storage = each.key["allocated_storage"]
  env = var.env
  subnets = var.subnets
}





