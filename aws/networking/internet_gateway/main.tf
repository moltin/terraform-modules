/**
 * This module creates an [AWS Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
 */

variable "name" {
    description = "The internet gateway name, will follow the format [name]-igw, e.g. moltin-instance-001"
}

variable "vpc_id" {
    description = "The VPC ID to create in"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s-igw", var.name)), map("Terraform", "true"))}"
}

// The ID of the Internet Gateway
output "id" { value = "${aws_internet_gateway.mod.id}" }
