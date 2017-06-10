/**
 * This modules create an [AWS Public Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
 */

variable "availability_zones" {
    type = "list"
    description = "A list of availability zones to place in the private subnets"
}

variable "cidr_blocks" {
    type = "list"
    description = "A list of CIRD blocks to place in the private subnets"
}

variable "gateway_id" {
    description = "An ID of a VPC internet gateway or a virtual private gateway"
}

variable "map_public_ip_on_launch" {
    default = true
    description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}

variable "name" {
    description = "The public subnet name, will follow the format [name]-subnet-public-[03d], e.g. moltin-subnet-public-001"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_subnet" "mod" {
    count = "${length(var.cidr_blocks)}"

    vpc_id                  = "${var.vpc_id}"
    cidr_block              = "${element(var.cidr_blocks, count.index)}"
    availability_zone       = "${element(var.availability_zones, count.index)}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

    tags = "${merge(var.tags, map("Name", format("%s-subnet-public-%s", var.name, element(var.availability_zones, count.index))), map("Terraform", "true"))}"
}

resource "aws_route_table" "mod" {
    vpc_id = "${var.vpc_id}"

    tags = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)), map("Terraform", "true"))}"
}

resource "aws_route" "mod" {
    gateway_id             = "${var.gateway_id}"
    route_table_id         = "${element(aws_route_table.mod.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "mod" {
    count          = "${length(var.cidr_blocks)}"
    subnet_id      = "${element(aws_subnet.mod.*.id, count.index)}"
    route_table_id = "${aws_route_table.mod.id}"
}

// A list of public subnet IDs
output "ids" { value = [ "${aws_subnet.mod.*.id}" ] }

// A list of public route table IDs
output "route_table_ids" { value = [ "${aws_route_table.mod.*.id}" ] }
