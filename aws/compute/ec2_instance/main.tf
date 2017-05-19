/**
 * This module creates:
 *
 * - [AWS EC2 Instance](https://www.terraform.io/docs/providers/aws/r/instance.html)
 * - [AWS Key Pair](https://www.terraform.io/docs/providers/aws/r/key_pair.html) if needed, that will be used by the instance
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

// The path of the public SSH key to use on the instance, e.g. ~/.ssh/id_rsa.pub
//
// As a special case, a value of empty string disables the creation of a new key,
// which is the default value
variable "key_path" {
    default = ""
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

variable "associate_public_ip_address" {
    default = false
    description = "Associate a public ip address with an instance in a VPC"
}

resource "aws_instance" "mod" {
    count = "${var.instance_count}"

    ami                         = "${var.ami}"
    ebs_optimized               = "${var.ebs_optimized}"
    instance_type               = "${var.instance_type}"
    key_name                    = "${var.key_name}"
    monitoring                  = "${var.monitoring}"
    subnet_id                   = "${element(sort(var.subnet_ids), count.index)}"
    user_data                   = "${var.user_data}"
    vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
    associate_public_ip_address = "${var.associate_public_ip_address}"

    root_block_device {
        volume_size           = "${var.root_volume_size}"
        delete_on_termination = "${var.delete_on_termination}"
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = [
        "aws_key_pair.mod"
    ]

    tags = "${merge(var.tags, map("Name", format("%s-ec2-instance-%03d", var.name, count.index)), map("Terraform", "true"))}"
}

resource "aws_key_pair" "mod" {
    count      = "${length(var.key_path) > 0 ? 1 : 0}"

    key_name   = "${var.key_name}"
    public_key = "${file("${var.key_path}")}"
}

// A list of instance IDs
output "ids" { value = [ "${aws_instance.mod.*.id}" ] }

// The name for the key pair
output "key_name" { value = "${aws_key_pair.mod.key_name}"}

// Private IPs address to associate with the instance in a VPC
output "private_ips" { value = ["${aws_instance.mod.*.private_ip}"] }

// The public IP address assigned to the instance
output "public_ips"  { value = ["${aws_instance.mod.*.public_ip}"] }
