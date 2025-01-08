# Highest eks-infra 
Prepare the infrastructure for a Kubernetes (AWS EKS service) cluster using Terraform. For the new infrastructure (dev environment), we need to be created:
VPC, subnets, and related components.
An ECR repository.
An EKS cluster with two t3.micro nodes.
The state file must be stored in S3, and it should be locked when the Terraform code is being executed. All Terraform code must be stored in your repository. 
If a push occurs in your repository, a job should automatically be triggered (using any CI tool) to execute the Terraform code.
