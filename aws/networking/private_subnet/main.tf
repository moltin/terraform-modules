/**
 * This modules creates:
 *
 * - [AWS Private Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
 * - [AWS NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html) if specified
 *
 * Usage:
 *
 * ```hcl
 * module "private_subnet" {
 *     source = "github.com/moltin/terraform-modules.git/aws//networking/private_subnet"
 * }
 * ```
 *
 * > Note: if not using SSH authentication URL, it's important to notice that
 * there is a dependency with the `nat_gateway` that needs to be satisfied
 * therefore we need to import the `private_subnet` from the `networking`
 * subfolder as shown in the example above using `//` like
 * `aws//networking/private_subnet`
 */

variable "availability_zones" {
    type = "list"
    description = "A list of availability zones to place in the private subnets"
}

variable "cidr_blocks" {
    type = "list"
    description = "A list of CIRD blocks to place in the private subnets"
}

variable "name" {
    description = "The private subnet name, will follow the format [name]-subnet-private-[03d], e.g. moltin-subnet-private-001"
}

// The number of NAT gateways to create
//
// This is required due to current limitations in Terraform. The number should
// be equal to the amount of public subnets that you are passing in, for which
// one NAT gateway will be created per subnet ID. Less NAT gateways will create
// an uneven distribution (some subnets will not get one), and more NAT
// gateways will wrap around, giving you more than one NAT gateway per subnet,
// which is definitely *not* what you want
//
// As a special case, a value of 0 disables NAT altogether, which is the default value
variable "nat_gateway_count" {
    default = 0
}

variable "public_subnet_ids" {
    type = "list"
    default = []
    description = "A list of public subnet IDs to place in the NATs"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

module "nat_gateway" {
    source = "../nat_gateway"

    route_table_ids    = ["${aws_route_table.mod.*.id}"]
    nat_gateway_count  = "${var.nat_gateway_count}"
    public_subnet_ids  = "${var.public_subnet_ids}"
    private_subnet_ids = "${var.cidr_blocks}"
}

resource "aws_subnet" "mod" {
    count             = "${length(var.cidr_blocks)}"
    vpc_id            = "${var.vpc_id}"
    cidr_block        = "${element(var.cidr_blocks, count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags = "${merge(var.tags, map("Name", format("%s-subnet-private-%s", var.name, element(var.availability_zones, count.index))), map("Terraform", "true"))}"
}

resource "aws_route_table" "mod" {
    count  = "${length(var.cidr_blocks)}"
    vpc_id = "${var.vpc_id}"

    tags = "${merge(var.tags, map("Name", format("%s-rt-private-%s", var.name, element(var.availability_zones, count.index))), map("Terraform", "true"))}"
}

resource "aws_route_table_association" "mod" {
    count          = "${length(var.cidr_blocks)}"
    subnet_id      = "${element(aws_subnet.mod.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.mod.*.id, count.index)}"
}

// A list of private subnet IDs
output "ids" { value = [ "${aws_subnet.mod.*.id}" ] }

// A list of Elastic IP public IPs, representing the NATs public IPs
output "eip_public_ips" { value = "${module.nat_gateway.eip_public_ips}" }

// A list of private route table IDs
output "route_table_ids" { value = [ "${aws_route_table.mod.*.id}" ] }
