variable "region" {}
variable "az" {}
variable "cidr" {}
variable "ssh_pub_key" {}
variable "type" { default = "t2.micro" }
variable "private_ip_blog" { default = "" }
variable "private_ip_database" { default = "" }
variable "private_ip_server" { default = "" }
variable "user_data_blog" { default = "" }
variable "user_data_server" { default = "" }
variable "user_data_database" { default = "" }

provider "aws" {
    region = "${var.region}"
}

resource "aws_vpc" "root" {
	cidr_block = "${var.cidr}"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	tags { Name = "spire_demo vpc" }
}

resource "aws_subnet" "public" {
	vpc_id = "${aws_vpc.root.id}"
	cidr_block = "${var.cidr}"
	availability_zone = "${var.region}${var.az}"
	map_public_ip_on_launch = true
	tags { Name = "spire_demo subnet public" }
}

resource "aws_internet_gateway" "public" {
	vpc_id = "${aws_vpc.root.id}"
	tags { Name = "spire_demo igw" }
}

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.root.id}"
	tags { Name = "spire_demo rt public" }
}

resource "aws_route" "public_default" {
	route_table_id = "${aws_route_table.public.id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.public.id}"
}

resource "aws_route_table_association" "public" {
	route_table_id = "${aws_route_table.public.id}"
	subnet_id = "${aws_subnet.public.id}"
}

resource "aws_security_group" "default" {
    name = "spire-demo-default"
    description = "spire_demo default sg"
    vpc_id = "${aws_vpc.root.id}"
    tags { Name = "spire_demo default sg" }
}

resource "aws_security_group_rule" "self" {
	type = "ingress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	self = true
	security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "https" {
	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "ssh" {
	type = "ingress"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "egress" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.default.id}"
}

resource "aws_key_pair" "demo" {
  key_name   = "spire_demo-key"
  public_key = "${file(var.ssh_pub_key)}"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "blog" {
    tags { Name = "spire_demo blog" }
	private_ip = "${var.private_ip_blog}"
	user_data = "${var.user_data_blog}"
	key_name = "${aws_key_pair.demo.key_name}"
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.type}"
    availability_zone = "${var.region}${var.az}"
	subnet_id = "${aws_subnet.public.id}"
	vpc_security_group_ids =  [ "${aws_security_group.default.id}" ]
    associate_public_ip_address = true
}

resource "aws_instance" "database" {
    tags { Name = "spire_demo database" }
	private_ip = "${var.private_ip_database}"
	user_data = "${var.user_data_database}"
	key_name = "${aws_key_pair.demo.key_name}"
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.type}"
    availability_zone = "${var.region}${var.az}"
	subnet_id = "${aws_subnet.public.id}"
	vpc_security_group_ids =  [ "${aws_security_group.default.id}" ]
    associate_public_ip_address = true
}

resource "aws_instance" "server" {
    tags { Name = "spire_demo server" }
	private_ip = "${var.private_ip_server}"
	user_data = "${var.user_data_server}"
	key_name = "${aws_key_pair.demo.key_name}"
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.type}"
    availability_zone = "${var.region}${var.az}"
	subnet_id = "${aws_subnet.public.id}"
	vpc_security_group_ids =  [ "${aws_security_group.default.id}" ]
    associate_public_ip_address = true
}

output "ec2_blog_public_ip" { value = "${aws_instance.blog.public_ip}" }
output "ec2_database_public_ip" { value = "${aws_instance.database.public_ip}" }
output "ec2_server_public_ip" { value = "${aws_instance.server.public_ip}" }
