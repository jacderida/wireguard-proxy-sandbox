provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "haproxy" {
  key_name = "wg_proxy_sandbox_haproxy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTmUQbV4u0rdJZwSRqaGQYSntST+OIVYG+WfViS2QTkdoi0e1+4hczZ+bbhKrHkg7jMM8tQN2ajFOVz4yI1+1LXz13faeOKC84bhWRRrIUgu/odmjlrlpo3UzlDmHa6Srgj+lIZJ6tkoOuZ06nx8Tsozjwshta6MeH7QVuBEfJUT6W1BTs7eObKrLOKxcXy6Hzwdo5cBGxNgCdbnoQxc2S7WyTxF0mmQ1ZpC5/AeTpltRg6InIxARhThGSzv3pNtMiW/co8dEAUAfkNaZSK7/QqSTYY3lylPenS3l5F8oe71g29s4OEpdwSrUUwEsBJUFvqN9U0gjbVSJSvvISeMY/"
}

resource "aws_key_pair" "jenkins" {
  key_name = "wg_proxy_sandbox_jenkins"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChWV0Kw5SFhyhYZorLAT7Viej83BQEBMykigLOxtSNErRN8CtgR/NQnicxfrMETDkv5f15Ni0NV4TD38jSih+zObATwsJkWRv1iB8B2EycgS01ki3g39ilTFNohucVdVL/s1+uLWpymcUgifmprebEywLYxYJGMr4RjCw7Jvgr2GHgpPbz/SgaiVXb+KsQ8mGRf45g9D8IVDLKym/Vql2QAN2zp1QNFVFuwBIiwEAen22eYpRojmRs/FCI9DHj3Qg6ojMy4UVFgUxexzjSjT+n5jMrKhHaZtQRAAPjWOnqJW3hkF0o/RU8CVlH1Lznr1IUjrwU7+gud15+1jC52t/h"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.59.0"
  name = "wg_proxy_sandbox"
  cidr = "10.0.0.0/16"
  azs = "${var.availability_zones}"
  public_subnets = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_instance" "jenkins_master" {
  ami = "${lookup(var.jenkins_master_ami, var.region)}"
  instance_type = "${var.jenkins_master_instance_type}"
  key_name = "${var.jenkins_key_pair}"
  subnet_id = "${module.vpc.private_subnets[0]}"
  associate_public_ip_address = true
  user_data = "${file("../setup_ansible_user.sh")}"
  vpc_security_group_ids = [
    "${aws_security_group.jenkins_master.id}"
  ]
  tags {
    Name = "wg_sandbox_jenkins_master"
    full_name = "wg_sandbox_jenkins_master-ubuntu-bionic-x86_64"
    group = "masters"
    environment = "dev"
  }
}

resource "aws_instance" "haproxy" {
  ami = "${lookup(var.haproxy_ami, var.region)}"
  instance_type = "${var.haproxy_instance_type}"
  key_name = "${var.jenkins_key_pair}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address = true
  user_data = "${file("../setup_ansible_user.sh")}"
  vpc_security_group_ids = [
    "${aws_security_group.haproxy.id}"
  ]
  tags {
    Name = "wg_sandbox_haproxy"
    full_name = "wg_sandbox_haproxy-ubuntu-bionic-x86_64"
    group = "proxies"
    environment = "dev"
  }
}
