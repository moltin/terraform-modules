/**
 * This modules create an [AWS VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
 */

variable "cidr" {
    description = "The cidr block of the desired VPC"
}

variable "enable_dns_hostnames" {
    default = false
    description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}

variable "enable_dns_support" {
    default = false
    description = "A boolean flag to enable/disable DNS support in the VPC"
}

variable "name" {
    description = "The vpc name, will follow the format [name]-sg-elb, e.g. moltin-sg-elb"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

resource "aws_vpc" "vpc" {
    cidr_block           = "${var.cidr}"
    enable_dns_support   = "${var.enable_dns_support}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"

    tags = "${merge(var.tags, map("Name", format("%s-vpc", var.name)), map("Terraform", "true"))}"
}

// The ID of the VPC
output "id" { value = "${aws_vpc.vpc.id}" }

// The CIDR block of the VPC
output "cidr_block" { value = "${aws_vpc.vpc.cidr_block}" }

// The ID of the security group created by default on VPC creation
output "default_security_group_id" { value = "${aws_vpc.vpc.default_security_group_id}" }
