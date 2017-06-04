/**
 * This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) without rules to be customized
 *
 * You will need to add custom rules to your security group
 *
 * Usage:
 * ```hcl
 * module "sg_custom_elb_https" {
 *     source = "git::ssh://git@github.com/moltin/terraform-modules.git//aws/networking/security_group/sg_custom_group"
 *
 *     name     = "${var.name}"
 *     vpc_id   = "${data.terraform_remote_state.network.vpc_id}"
 *     resource_name = "elb-https"
 *
 *     tags {
 *         "Cluster"     = "security"
 *         "Audience"    = "private"
 *         "Environment" = "${var.environment}"
 *     }
 * }
 *
 * resource "aws_security_group_rule" "authentication" {
 *     type            = "ingress"
 *     from_port       = 8000
 *     to_port         = 8000
 *     protocol        = "tcp"
 *     cidr_blocks     = ["${var.vpc_cidr}"]
 *
 *     security_group_id = "${module.sg_custom.id}"
 * }
 * ```
 */

variable "name" {
    description = "The security group name, will follow the format [name]-sg-custom-[resource_name], e.g. moltin-sg-custom-elb-https"
}

variable "resource_name" {
    description = "Resource name security group will be apply to, this will be combine with the variable `name` and follow the format [name]-sg-custom-[resource_name], e.g. moltin-sg-custom-elb-https"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

variable "vpc_id" {
    description = "The id of the VPC that the desired subnet belongs to"
}

resource "aws_security_group" "mod" {
    name        = "${var.name}-sg-custom-${var.resource_name}"
    vpc_id      = "${var.vpc_id}"
    description = "Custom security group"

    tags = "${merge(var.tags, map("Name", format("%s-sg-custom-%s", var.name, var.resource_name)), map("Terraform", "true"))}"
}

// The id of the specific security group to retrieve
output "id" { value = "${aws_security_group.mod.id}" }
