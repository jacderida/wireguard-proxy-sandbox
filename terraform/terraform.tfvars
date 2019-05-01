region = "eu-west-2"
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
jenkins_key_pair = "wg_proxy_sandbox_jenkins"
jenkins_master_ami = { eu-west-2 = "ami-0883141bc92a74917" }
jenkins_master_instance_type = "t2.micro"
haproxy_key_pair = "wg_proxy_sandbox_haproxy"
haproxy_ami { eu-west-2 = "ami-0883141bc92a74917" }
haproxy_instance_type = "t2.micro"
