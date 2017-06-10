/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the Elastic Load Balancer HTTPS
 *
 * Ports:
 *
 * - TCP 443 (HTTPS)
 * - ICMP
 */

variable "name" {
    description = "The security group name, will follow the format [name]-sg-elb-https, e.g. moltin-sg-elb-https"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-elb-https"
    vpc_id      = "${var.vpc_id}"
    description = "Elastic Load Balancer HTTPS security group"

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(var.tags, map("Name", format("%s-sg-elb-https", var.name)), map("Terraform", "true"))}"
}

// The id of the specific security group to retrieve
output "id" { value = "${aws_security_group.mod.id}" }
