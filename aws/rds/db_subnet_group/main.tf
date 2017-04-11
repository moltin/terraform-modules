/**
 * This modules create an [AWS RDS DB Subnet](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
 */

variable "name" {
    description = "The RDS DB subnet group name, will follow the format [name]-db-subnet-group, e.g. moltin-db-subnet-group"
}

variable "subnet_ids" {
    type = "list"
    description = "A list of subnet IDs to place in the RDS DB subnet group"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

resource "aws_db_subnet_group" "mod" {
    name        = "${var.name}-db-subnet-group"
    subnet_ids  = ["${var.subnet_ids}"]
    description = "RDS DB subnet group"

    tags = "${merge(var.tags, map("Name", format("%s-db-subnet-group", var.name)), map("Terraform", "true"))}"
}

// The DB subnet group name.
output "id" { value = "${aws_db_subnet_group.mod.id}" }
