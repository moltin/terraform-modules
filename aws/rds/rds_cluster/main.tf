/**
 * This modules create an [AWS RDS Cluster](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html)
 */

variable "backup_retention_period" {
    description = "The backup retention period"
}

variable "database_name" {
    description = "The name for your database of up to 8 alpha-numeric characters. If you do not provide a name, Amazon RDS will not create a database in the DB cluster you are creating"
}

variable "db_subnet_group_name" {
    description = "A DB subnet group to associate with this DB instance. NOTE: This must match the db_subnet_group_name specified on every aws_rds_cluster_instance in the cluster"
}

variable "final_snapshot_identifier" {
    description = "The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made"
}

variable "master_password" {
    description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
}

variable "master_username" {
    description = "Username for the master DB user"
}

variable "name" {
    description = "The RDS DB subnet group name"
}

variable "port" {
    default = 3306
    description = "The port on which the DB accepts connections"
}

variable "preferred_backup_window" {
    description = "The time window on which backups will be made (HH:mm-HH:mm)"
}

variable "preferred_maintenance_window" {
    description = "The weekly time range during which system maintenance can occur, in (UTC) e.g. wed:04:00-wed:04:30"
}

variable "skip_final_snapshot" {
    default = false
    description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
}

variable "vpc_security_group_ids" {
    description = "List of VPC security groups to associate with the Cluster"
}

resource "aws_rds_cluster" "mod" {
    cluster_identifier = "${var.name}-db"

    port                         = "${var.port}"
    database_name                = "${var.database_name}"
    master_username              = "${var.master_username}"
    master_password              = "${var.master_password}"
    skip_final_snapshot          = "${var.skip_final_snapshot}"
    db_subnet_group_name         = "${var.db_subnet_group_name}"
    vpc_security_group_ids       = ["${var.vpc_security_group_ids}"]
    backup_retention_period      = "${var.backup_retention_period}"
    preferred_backup_window      = "${var.preferred_backup_window}"
    final_snapshot_identifier    = "${var.final_snapshot_identifier}"
    preferred_maintenance_window = "${var.preferred_maintenance_window}"
}

// The RDS Cluster Identifier
output "cluster_identifier" { value = "${aws_rds_cluster.mod.cluster_identifier}" }

// The DNS address of the RDS instance
output "endpoint" { value = "${aws_rds_cluster.mod.endpoint}" }

// The database port
output "port" { value = "${aws_rds_cluster.mod.port}" }
