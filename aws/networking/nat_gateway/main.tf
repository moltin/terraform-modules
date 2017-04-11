/**
 * This module creates an [AWS NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html), an [AWS Route](https://www.terraform.io/docs/providers/aws/r/route.html) and an [AWS EIP](https://www.terraform.io/docs/providers/aws/r/eip.html) to associate with the NAT Gateway
 *
 * One NAT gateway should be created per supplied public subnet ID. This ensures that regardless of if the subnets reside in different availability zones, there is no risk of connectivity loss, should one AZ go offline.
 */

variable "nat_gateway_count" {
    default = 1
    description = "The number of NAT gateways to create"
}

variable "public_subnet_ids" {
    type = "list"
    description = "A list of public subnet IDs"
}

variable "private_subnet_ids" {
    type = "list"
    description = "A list of private subnet IDs"
}

variable "route_table_ids" {
    type = "list"
    description = "A list of ID of the private routing tables to connect the NAT with the private subnet"
}

resource "aws_route" "mod" {
    count                  = "${var.nat_gateway_count > 0 ? length(var.private_subnet_ids) : 0}"
    route_table_id         = "${element(var.route_table_ids, count.index)}"
    nat_gateway_id         = "${element(aws_nat_gateway.mod.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_nat_gateway" "mod" {
    count         = "${var.nat_gateway_count}"
    subnet_id     = "${element(var.public_subnet_ids, count.index)}"
    allocation_id = "${element(aws_eip.mod.*.id, count.index)}"
}

resource "aws_eip" "mod" {
    count = "${var.nat_gateway_count}"
    vpc   = true
}

// A list of Elastic IP public IPs, representing the NATs public IPs
output "eip_public_ips" { value = [ "${aws_eip.mod.*.public_ip}" ] }
