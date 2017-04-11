/**
 * This modules create an [AWS RDS Cluster Instance](https://www.terraform.io/docs/providers/aws/r/rds_cluster_instance.html)
 */

variable "cluster_identifier" {
    description = "The identifier of the aws_rds_cluster in which to launch this instance"
}

variable "db_subnet_group_name" {
  description = "A DB subnet group to associate with this DB instance"
}

variable "instance_class" {
  description = "The instance class to use. For details on CPU and memory, see [Scaling Aurora DB Instances](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Aurora.Managing.html)"
}

variable "name" {
    description = "The RDS DB subnet group name, will follow the format [name]-rds-cluster-instance-[03d], e.g. moltin-rds-cluster-instance-001"
}

variable "publicly_accessible" {
    default = false
    description = "Bool to control if instance is publicly accessible"
}

variable "rds_cluster_instance_count" {
    default = 1
    description = "The number of instances to create"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

resource "aws_rds_cluster_instance" "mod" {
    count = "${var.rds_cluster_instance_count}"

    identifier           = "${var.name}-db-${count.index}"
    instance_class       = "${var.instance_class}"
    cluster_identifier   = "${var.cluster_identifier}"
    publicly_accessible  = "${var.publicly_accessible}"
    db_subnet_group_name = "${var.db_subnet_group_name}"

    tags = "${merge(var.tags, map("Name", format("%s-rds-cluster-instance-%03d", var.name, count.index)), map("Terraform", "true"))}"
}
