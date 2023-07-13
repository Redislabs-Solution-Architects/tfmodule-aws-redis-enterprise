# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.region_vpc.id}"

    tags = {
        Name = "${var.vpc-name}-igw"
    }
}

# create a custom route table for public subnets
# public subnets can reach to the internet buy using this
resource "aws_route_table" "prod-igw-public-crt" {
    vpc_id = "${aws_vpc.region_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        gateway_id = "${aws_internet_gateway.prod-igw.id}" //CRT uses this IGW to reach internet
    }

    tags = {
        Name = "${var.vpc-name}-public-crt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
    subnet_id = "${aws_subnet.region_subnet.id}"
    route_table_id = "${aws_route_table.prod-igw-public-crt.id}"
}
