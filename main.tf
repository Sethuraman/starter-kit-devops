module "ecs" {
  source            = "./modules/ecs"
  awsResourcePrefix = "devops-starter"
  ecs_cluster_name = "sethu-test1"
  asg_desired_size = "1"
  asg_max_size = "1"
  ecs_subnets = "subnet-3221d244,subnet-93b04dca,subnet-e83de98c"
  key_name = "sethu-ecs"
}
