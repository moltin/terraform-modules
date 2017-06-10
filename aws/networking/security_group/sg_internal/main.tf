/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) to enable internal comms between resources that share this sg
 */

variable "name" {
    description = "The security group name, will follow the format [name]-sg-internal-[03d], e.g. moltin-sg-internal-001"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-internal"
    vpc_id      = "${var.vpc_id}"
    description = "Internal comms for resources that share this sg"

    # allow all self on all protocols - give access to any other instance that share this sg
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(var.tags, map("Name", format("%s-sg-internal", var.name)), map("Terraform", "true"))}"
}

// The id of the specific security group to retrieve
output "id" { value = "${aws_security_group.mod.id}" }
