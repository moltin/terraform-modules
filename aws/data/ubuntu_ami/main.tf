/**
 * This data module will return an [Ubuntu](https://www.ubuntu.com/) [AWS AMI ID](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) to populate the [ami](https://www.terraform.io/docs/providers/aws/r/instance.html#ami) argument to our instances
 *
 * > Note: If you are using our [AWS EC2 Instance module](https://github.com/moltin/terraform-modules/blob/master/README.md#ec2-instance) it will try to recreate a new resource every time as the `aws_ami` could change if a new version is publish, as this one will have a different timestamp even if we are specifying the same architecture, distribution or virtualization type, so or either you use your own `aws_instance` resource add the [the ignore_changes lifecycle argument](https://www.terraform.io/docs/configuration/resources.html#ignore_changes) to not recreate the instance again and then `terraform taint` the instance to force recreate when you want to change to a new AMI for more info see the following Terraform [issue](https://github.com/hashicorp/terraform/issues/13044#issuecomment-289046234)
 */

variable "distribution" {
    default = "trusty"
    description = "Ubuntu distribution to be installed"
}

variable "owners" {
    default = ["099720109477"]
    description = "Canonical Group Limited owner id"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm/ubuntu-${var.distribution}-*-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = "${var.owners}"
}

// AMI id
output "id" { value = "${data.aws_ami.ubuntu.id}" }
