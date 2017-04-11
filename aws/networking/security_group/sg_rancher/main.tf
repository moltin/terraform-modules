/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the Rancher HA server
 *
 * Ports:
 *
 * - TCP 8080 (Rancher HA server nodes)
 * - TCP 9345 (Rancher HA server nodes)
 */

variable "name" {
    description = "The security group name, will follow the format [name]-sg-rancher-ha-server-[03d], e.g. moltin-sg-rancher-ha-server-001"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-rancher-ha-server"
    vpc_id      = "${var.vpc_id}"
    description = "Rancher HA server security group"

    # allow all self on all protocols - give access to any other instance that have assigned the same sg
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port   = 9345
        to_port     = 9345
        protocol    = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(var.tags, map("Name", format("%s-sg-rancher-ha-server", var.name)), map("Terraform", "true"))}"
}

// The id of the specific security group to retrieve
output "id" { value = "${aws_security_group.mod.id}" }
