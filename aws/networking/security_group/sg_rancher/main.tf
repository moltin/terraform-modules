/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the internal communication between Rancher HA server nodes
 *
 * Ports:
 *
 * - TCP 8080 / self (Rancher HA server nodes)
 * - TCP 9345 / self (Rancher HA server nodes)
 */

variable "name" {
    description = "The security group name, will follow the format [name]-sg-rancher-ha-server-[03d], e.g. moltin-sg-rancher-ha-server-001"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-rancher-ha-server"
    vpc_id      = "${var.vpc_id}"
    description = "Rancher HA server security group"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        self        = true
    }

    ingress {
        from_port   = 9345
        to_port     = 9345
        protocol    = "tcp"
        self        = true
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
