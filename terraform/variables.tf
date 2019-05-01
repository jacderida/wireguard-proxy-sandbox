variable "region" {
  default = "eu-west-2"
  description = "The AWS region to use"
}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  description = "The availability zones to use"
}

variable "jenkins_key_pair" {
  default = "jenkins-prod"
  description = "The key pair for the Jenkins master instance"
}

variable "jenkins_master_ami" {
  default = {
    eu-west-2 = "ami-0883141bc92a74917"
  }
  description = "AMI for Jenkins Master (Ubuntu 18.04)"
}

variable "jenkins_master_instance_type" {
  default = "t2.micro"
  description = "Instance type for Jenkins Master"
}

variable "haproxy_ami" {
  default = {
    eu-west-2 = "ami-0883141bc92a74917"
  }
  description = "AMI for HAProxy (Ubuntu 18.04)"
}

variable "haproxy_instance_type" {
  default = "t2.micro"
  description = "Instance type for HAProxy machine"
}
