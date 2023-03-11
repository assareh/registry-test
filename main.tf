module "ec2-instance" {
  source  = "registry.assareh.com/hashidemos/ec2-instance/aws"
  version = "0.0.1"
}

terraform {
 cloud {
    organization = "hashidemos"

    workspaces {
      name = "testing-registry"
    }
  }
}
