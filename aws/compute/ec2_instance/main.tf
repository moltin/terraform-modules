/**
 * This module creates an [AWS EC2 Instance](https://www.terraform.io/docs/providers/aws/r/instance.html) and an [AWS Key Pair](https://www.terraform.io/docs/providers/aws/r/key_pair.html) that will be used by the instance.
 */

variable "ami" {
    description = "AMI ID"
}

variable "delete_on_termination" {
    default = true
    description = "Whether the volume should be destroyed on instance termination"
}

variable "ebs_optimized" {
    default = false
    description = "Enable EBS-optimized on the launched instance"
}

variable "instance_type" {
    description = "The type of instance to start"
}

variable "instance_count" {
    default = 1
    description = "The number of instances to create"
}

variable "key_name" {
    description = "The name of the SSH key to use on the instance, e.g. moltin"
}

variable "key_path" {
    description = "The path of the public SSH key to use on the instance, e.g. ~/.ssh/id_rsa.pub"
}

variable "monitoring" {
    default = false
    description = "Enable detailed monitoring"
}

variable "name" {
    description = "The instace name, will follow the format [name]-ec2-instance-[03d], e.g. moltin-ec2-instance-001"
}

variable "root_volume_size" {
    default = 16
    description = "Default instance root volume size, bump to 16GB from the default 8GB"
}

variable "subnet_ids" {
    type = "list"
    description = "A list of VPC subnet IDs to launch in"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "user_data" {
    default = ""
    description = "The user data to provide when launching the instance"
}

variable "vpc_security_group_ids" {
    type = "list"
    description = "A list of security group IDs to associate with"
}

resource "aws_instance" "mod" {
    count = "${var.instance_count}"

    ami                    = "${var.ami}"
    ebs_optimized          = "${var.ebs_optimized}"
    instance_type          = "${var.instance_type}"
    key_name               = "${aws_key_pair.mod.key_name}"
    monitoring             = "${var.monitoring}"
    subnet_id              = "${element(sort(var.subnet_ids), count.index)}"
    user_data              = "${var.user_data}"
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

    root_block_device {
        volume_size           = "${var.root_volume_size}"
        delete_on_termination = "${var.delete_on_termination}"
    }

    tags = "${merge(var.tags, map("Name", format("%s-ec2-instance-%03d", var.name, count.index)), map("Terraform", "true"))}"
}

resource "aws_key_pair" "mod" {
    key_name   = "${var.key_name}"
    public_key = "${file("${var.key_path}")}"
}

// A list of instance IDs
output "ids" { value = [ "${aws_instance.mod.*.id}" ] }
