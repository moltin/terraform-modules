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
