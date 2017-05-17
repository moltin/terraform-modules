variable "version" {
    default = "1.0.1"
    description = "RancherOS version to be installed"
}

variable "owners" {
    default = ["605812595337"]
    description = "Rancher Labs owner id"
}

data "aws_ami" "rancher" {
    most_recent = true

    filter {
        name   = "name"
        values = ["rancheros-v${var.version}-hvm-1"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = "${var.owners}"
}

// AMI id
output "id" { value = "${data.aws_ami.rancher.id}" }
