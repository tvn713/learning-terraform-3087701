data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  subnet_id            = module.blog_vpc.public_subnets[0]
  tags = {
    Name = "HelloWorld"
  }
}

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"
 
  name = "dev"
  cidr = "10.0.0.0/16"
 
  azs             = ["us-west-2a","us-west-2b","us-west-2c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
 
  tags = {
    Project     = "ercot"
    Owner       = "tuan"
    Environment = "Dev"
    Terraform   = "true"
  }
 
}
