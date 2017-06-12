/**
 * This module creates an [AWS ELB HTTPS](https://www.terraform.io/docs/providers/aws/r/elb.html)
 */

variable "health_check_target" {
    default = "HTTP:8000/"
    description = "The target of the health check"
}

variable "instances" {
    type = "list"
    description = "A list of instance ids to place in the ELB pool"
}

variable "listener_instance_port" {
    default = 8000
    description = "The port on the instance to route to"
}

variable "name" {
    description = "The elastic load balancer name, will follow the format [name]-elb-https-public, e.g. moltin-elb-https-public"
}

variable "security_group_ids" {
    type = "list"
    description = "A list of security group IDs to assign to the ELB. Only valid if creating an ELB within a VPC"
}

variable "ssl_certificate_id" {
    description = "The ARN of an SSL certificate you have uploaded to AWS IAM, check Terraform notes about [ECDSA Key Algorithm](https://www.terraform.io/docs/providers/aws/r/elb.html#note-on-ecdsa-key-algorithm)"
}

variable "subnet_ids" {
    type = "list"
    description = "A list of VPC subnet IDs to launch in"
}

variable "tags" {
    default = { Terraform = true }
    description = "A map of tags to assign to the resource, `Name` and `Terraform` will be added by default"
}

resource "aws_elb" "mod" {
    name = "${var.name}-elb-https-public"

    listener {
        instance_port      = "${var.listener_instance_port}"
        instance_protocol  = "tcp"
        lb_port            = 443
        lb_protocol        = "ssl"
        ssl_certificate_id = "${var.ssl_certificate_id}"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "${var.health_check_target}"
        interval            = 30
    }

    subnets         = ["${var.subnet_ids}"]
    instances       = ["${var.instances}"]
    security_groups = ["${var.security_group_ids}"]

    idle_timeout                = 400
    cross_zone_load_balancing   = true
    connection_draining         = true
    connection_draining_timeout = 400

    tags = "${merge(var.tags, map("Name", format("%s-elb-https-public", var.name)), map("Terraform", "true"))}"
}

resource "aws_proxy_protocol_policy" "mod" {
    load_balancer  = "${aws_elb.mod.name}"
    instance_ports = ["443", "${var.listener_instance_port}"]
}

// The id of the ELB
output "id" { value = "${aws_elb.mod.id}" }

// The name of the ELB
output "name" { value = "${aws_elb.mod.name}" }

// The DNS name of the ELB
output "dns_name" { value = "${aws_elb.mod.dns_name}" }

// The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
output "zone_id" { value = "${aws_elb.mod.zone_id}"}
