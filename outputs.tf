output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = module.vpc.private_subnets
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}
