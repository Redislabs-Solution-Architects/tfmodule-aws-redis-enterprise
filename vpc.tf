resource "aws_vpc" "region_vpc" {
    cidr_block = "10.1.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
       Name = "${var.vpc-name}"
    }
}

resource "aws_subnet" "region_subnet" {
    vpc_id = "${aws_vpc.region_vpc.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.vpc-azs}"

    tags = {
        Name = "${var.vpc-subnet}"
    }
}
