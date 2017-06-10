/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the RDS Cluster Instance
 */

variable "ingress_allow_security_groups" {
    type = "list"
    description = "List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC"
}

variable "name" {
    description = "The security group name, will follow the format [name]-sg-rds-cluster-instance-[03d], e.g. moltin-rds-cluster-instance-001"
}

variable "port" {
    default = 3306
    description = "Port number to open for the Aurora Database flavour we pick up, e.g. MySQL 3306"
}

variable "tags" {
    default = {}
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-rds-cluster-instance"
    vpc_id      = "${var.vpc_id}"
    description = "RDS Cluster instance ports"

    ingress {
        from_port       = "${var.port}"
        to_port         = "${var.port}"
        protocol        = "tcp"
        security_groups = ["${var.ingress_allow_security_groups}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(var.tags, map("Name", format("%s-sg-rds-cluster-instance", var.name)), map("Terraform", "true"))}"
}

// The id of the specific security group to retrieve
output "id" { value = "${aws_security_group.mod.id}" }
