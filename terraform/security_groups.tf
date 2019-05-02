resource "aws_security_group" "haproxy" {
  name = "wg_sandbox_haproxy"
  description = "Connectivity for haproxy machine."
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "haproxy_ingress_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group_rule" "haproxy_ingress_51820" {
  type = "ingress"
  from_port = 51820
  to_port = 51820
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group_rule" "haproxy_egress_all_jenkins_master_traffic" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  source_security_group_id = "${aws_security_group.jenkins_master.id}"
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group_rule" "haproxy_ingress_all_jenkins_master_slave_traffic" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = -1
  source_security_group_id = "${aws_security_group.jenkins_master.id}"
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group_rule" "haproxy_egress_http" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group_rule" "haproxy_egress_https" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.haproxy.id}"
}

resource "aws_security_group" "jenkins_master" {
  name = "wg_sandbox_jenkins_master"
  description = "Connectivity for Jenkins master."
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "jenkins_master_ingress_ssh_from_haproxy" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.haproxy.id}"
  security_group_id = "${aws_security_group.jenkins_master.id}"
}

resource "aws_security_group_rule" "jenkins_master_ingress_51820_from_haproxy" {
  type = "ingress"
  from_port = 51820
  to_port = 51820
  protocol = "udp"
  source_security_group_id = "${aws_security_group.haproxy.id}"
  security_group_id = "${aws_security_group.jenkins_master.id}"
}

resource "aws_security_group_rule" "jenkins_master_egress_http" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_master.id}"
}

resource "aws_security_group_rule" "jenkins_master_egress_https" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_master.id}"
}

resource "aws_security_group_rule" "jenkins_master_egress_ssh" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_master.id}"
}

resource "aws_security_group_rule" "jenkins_master_egress_51820" {
  type = "egress"
  from_port = 51820
  to_port = 51820
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_master.id}"
}
