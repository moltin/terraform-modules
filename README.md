# Terraform Modules

This project contain a group of base [Terraform](http://terraform.io) modules that will help you to build the infrastructure you need from your projects. This modules aim to serve as a tool to create individual resources on different providers, they are minimal and focus on each specific resource as an unique element.

> Note: If you are looking for a more complex combination of resources and modules we built as well [terraform-stack](https://github.com/moltin/terraform-stack) it will give you a stack of resources to speed up the process of creating a new infrastructure.

This project has been highly inspired by the work of others that have decided to share with the community their work, check the [resources](#resources) section for more info.

## Available Modules

* Compute
	* [EC2 Instance](#ec2-instance)
* Networking
	* [ELB HTTPS](#elb-https)
	* [Internet Gateway](#internet-gateway)
	* [NAT Gateway](#nat-gateway)
	* [Private Subnet](#private-subnet)
	* [Public Subnet](#public-subnet)
	* [Security Group - ELB HTTPS](#security-group---elb-https)
	* [Security Group - Internal](#security-group---internal)
	* [Security Group - Rancher](#security-group---rancher)
	* [Security Group - RDS Cluster Instance](#security-group---rds-cluster-instance)
	* [Security Group - SSH](#security-group---ssh)
	* [VPC](#vpc)
* RDS
	* [DB Subnet Group](#db-subnet-group)
	* [RDS Cluster](#rds-cluster)
	* [RDS Cluster Instance](#rds-cluster-instance)

## EC2 Instance

This module creates an [AWS EC2 Instance](https://www.terraform.io/docs/providers/aws/r/instance.html) and an [AWS Key Pair](https://www.terraform.io/docs/providers/aws/r/key_pair.html) that will be used by the instance.


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| ami | AMI ID | - | yes |
| delete_on_termination | Whether the volume should be destroyed on instance termination | `true` | no |
| ebs_optimized | Enable EBS-optimized on the launched instance | `false` | no |
| instance_count | The number of instances to create | `1` | no |
| instance_type | The type of instance to start | - | yes |
| key_name | The name of the SSH key to use on the instance, e.g. moltin | - | yes |
| key_path | The path of the public SSH key to use on the instance, e.g. ~/.ssh/id_rsa.pub | - | yes |
| monitoring | Enable detailed monitoring | `false` | no |
| name | The instace name, will follow the format [name]-ec2-instance-[03d], e.g. moltin-ec2-instance-001 | - | yes |
| root_volume_size | Default instance root volume size, bump to 16GB from the default 8GB | `16` | no |
| subnet_ids | A list of VPC subnet IDs to launch in | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| user_data | The user data to provide when launching the instance | `` | no |
| vpc_security_group_ids | A list of security group IDs to associate with | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ids | A list of instance IDs |

## ELB HTTPS

This module creates an [AWS ELB HTTPS](https://www.terraform.io/docs/providers/aws/r/elb.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| health_check_target | The target of the health check | `HTTP:8000/` | no |
| instances | A list of instance ids to place in the ELB pool | - | yes |
| listener_instance_port | The port on the instance to route to | `8000` | no |
| name | The elastic load balancer name, will follow the format [name]-elb-https-public, e.g. moltin-elb-https-public | - | yes |
| security_group_ids | A list of security group IDs to assign to the ELB. Only valid if creating an ELB within a VPC | - | yes |
| ssl_certificate_id | The ARN of an SSL certificate you have uploaded to AWS IAM, check Terraform notes about [ECDSA Key Algorithm](https://www.terraform.io/docs/providers/aws/r/elb.html#note-on-ecdsa-key-algorithm) | - | yes |
| subnet_ids | A list of VPC subnet IDs to launch in | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_name | The DNS name of the ELB |
| id | The id of the ELB |
| name | The name of the ELB |

## Internet Gateway

This module creates an [AWS Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The internet gateway name, will follow the format [name]-igw, e.g. moltin-instance-001 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The VPC ID to create in | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Internet Gateway |

## NAT Gateway

This module creates an [AWS NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html), an [AWS Route](https://www.terraform.io/docs/providers/aws/r/route.html) and an [AWS EIP](https://www.terraform.io/docs/providers/aws/r/eip.html) to associate with the NAT Gateway

One NAT gateway should be created per supplied public subnet ID. This ensures that regardless of if the subnets reside in different availability zones, there is no risk of connectivity loss, should one AZ go offline.


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| nat_gateway_count | The number of NAT gateways to create | `1` | no |
| private_subnet_ids | A list of private subnet IDs | - | yes |
| public_subnet_ids | A list of public subnet IDs | - | yes |
| route_table_ids | A list of ID of the private routing tables to connect the NAT with the private subnet | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| eip_public_ips | A list of Elastic IP public IPs, representing the NATs public IPs |

## Private Subnet

This modules create an [AWS Private Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html) and an [AWS NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html) if specified


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| availability_zones | A list of availability zones to place in the private subnets | - | yes |
| cidr_blocks | A list of CIRD blocks to place in the private subnets | - | yes |
| name | The private subnet name, will follow the format [name]-subnet-private-[03d], e.g. moltin-subnet-private-001 | - | yes |
| nat_gateway_count | The number of NAT gateways to create<br><br>This is required due to current limitations in Terraform. The number should be equal to the amount of public subnets that you are passing in, for which one NAT gateway will be created per subnet ID. Less NAT gateways will create an uneven distribution (some subnets will not get one), and more NAT gateways will wrap around, giving you more than one NAT gateway per subnet, which is definitely *not* what you want<br><br>As a special case, a value of 0 disables NAT altogether, which is the default value | `0` | no |
| public_subnet_ids | A list of public subnet IDs to place in the NATs | `<list>` | no |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| eip_public_ips | A list of Elastic IP public IPs, representing the NATs public IPs |
| ids | A list of private subnet IDs |
| route_table_ids | A list of private route table IDs |

## Public Subnet

This modules create an [AWS Public Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| availability_zones | A list of availability zones to place in the private subnets | - | yes |
| cidr_blocks | A list of CIRD blocks to place in the private subnets | - | yes |
| gateway_id | An ID of a VPC internet gateway or a virtual private gateway | - | yes |
| map_public_ip_on_launch | Specify true to indicate that instances launched into the subnet should be assigned a public IP address | `true` | no |
| name | The public subnet name, will follow the format [name]-subnet-public-[03d], e.g. moltin-subnet-public-001 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ids | A list of public subnet IDs |
| route_table_ids | A list of public route table IDs |

## Security Group - ELB HTTPS

This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the Elastic Load Balancer HTTPS

Ports:

- TCP 443 (HTTPS)
- ICMP


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The security group name, will follow the format [name]-sg-elb-https, e.g. moltin-sg-elb-https | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the specific security group to retrieve |

## Security Group - Internal

This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) to enable internal comms between resources that share this sg


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The security group name, will follow the format [name]-sg-internal-[03d], e.g. moltin-sg-internal-001 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the specific security group to retrieve |

## Security Group - Rancher

This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the Rancher HA server

Ports:

- TCP 8080 (Rancher HA server nodes)
- TCP 9345 (Rancher HA server nodes)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The security group name, will follow the format [name]-sg-rancher-ha-server-[03d], e.g. moltin-sg-rancher-ha-server-001 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_cidr | VPC CIDR block | - | yes |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the specific security group to retrieve |

## Security Group - RDS Cluster Instance

This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for the RDS Cluster Instance


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| ingress_allow_security_groups | List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC | - | yes |
| name | The security group name, will follow the format [name]-sg-rds-cluster-instance-[03d], e.g. moltin-rds-cluster-instance-001 | - | yes |
| port | Port number to open for the Aurora Database flavour we pick up, e.g. MySQL 3306 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the specific security group to retrieve |

## Security Group - SSH

This modules create an [AWS Security Group](https://www.terraform.io/docs/providers/aws/d/security_group.html) for SSH

Ports:

- TCP 22 (SSH)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The security group name, will follow the format [name]-sg-ssh-[03d], e.g. moltin-sg-ssh-001 | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |
| vpc_cidr | VPC CIDR block | - | yes |
| vpc_id | The id of the VPC that the desired subnet belongs to | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the specific security group to retrieve |

## VPC

This modules create an [AWS VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| cidr | The cidr block of the desired VPC | - | yes |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | `false` | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | `false` | no |
| name | The vpc name, will follow the format [name]-sg-elb, e.g. moltin-sg-elb | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| cidr_block | The CIDR block of the VPC |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| id | The ID of the VPC |

## DB Subnet Group

This modules create an [AWS RDS DB Subnet](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The RDS DB subnet group name, will follow the format [name]-db-subnet-group, e.g. moltin-db-subnet-group | - | yes |
| subnet_ids | A list of subnet IDs to place in the RDS DB subnet group | - | yes |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The DB subnet group name. |

## RDS Cluster

This modules create an [AWS RDS Cluster](https://www.terraform.io/docs/providers/aws/r/rds_cluster.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| database_name | The name for your database of up to 8 alpha-numeric characters. If you do not provide a name, Amazon RDS will not create a database in the DB cluster you are creating | - | yes |
| db_subnet_group_name | A DB subnet group to associate with this DB instance. NOTE: This must match the db_subnet_group_name specified on every aws_rds_cluster_instance in the cluster | - | yes |
| master_password | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file | - | yes |
| master_username | Username for the master DB user | - | yes |
| name | The RDS DB subnet group name | - | yes |
| port | The port on which the DB accepts connections | `3306` | no |
| skip_final_snapshot | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier | `false` | no |
| vpc_security_group_ids | List of VPC security groups to associate with the Cluster | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_identifier | The RDS Cluster Identifier |
| endpoint | The DNS address of the RDS instance |
| port | The database port |

## RDS Cluster Instance

This modules create an [AWS RDS Cluster Instance](https://www.terraform.io/docs/providers/aws/r/rds_cluster_instance.html)


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| cluster_identifier | The identifier of the aws_rds_cluster in which to launch this instance | - | yes |
| db_subnet_group_name | A DB subnet group to associate with this DB instance | - | yes |
| instance_class | The instance class to use. For details on CPU and memory, see [Scaling Aurora DB Instances](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Aurora.Managing.html) | - | yes |
| name | The RDS DB subnet group name, will follow the format [name]-rds-cluster-instance-[03d], e.g. moltin-rds-cluster-instance-001 | - | yes |
| publicly_accessible | Bool to control if instance is publicly accessible | `false` | no |
| rds_cluster_instance_count | The number of instances to create | `1` | no |
| tags | A map of tags to assign to the resource, `Name` and `Terraform` will be added by default | `<map>` | no |


# Authors

* **Israel Sotomayor** - *Initial work* - [zot24](https://github.com/zot24)

See also the list of [contributors](https://github.com/moltin/terraform-modules/contributors) who participated in this project.

# License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/moltin/terraform-modules/blob/master/LICENSE) file for details

# Resources

- Articles
  - [The Segment AWS Stack](https://segment.com/blog/the-segment-aws-stack/)
  - [Terraform Modules for Fun and Profit](http://blog.lusis.org/blog/2015/10/12/terraform-modules-for-fun-and-profit/)
  - [How to create reusable infrastructure with Terraform modules](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d)
  - [Infrastructure Packages](https://blog.gruntwork.io/gruntwork-infrastructure-packages-7434dc77d0b1)
  - [Terraform: Cloud made easy](http://blog.contino.io/terraform-cloud-made-easy-part-one)
  - [Deploying Rancher HA in production with AWS, Terraform, and RancherOS](https://thisendout.com/2016/12/10/update-deploying-rancher-in-production-aws-terraform-rancheros/)
  - [Terraform, VPC, and why you want a tfstate file per env](https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/)

- Non directly related but useful
  - [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc)

- GitHub repositories
  - [segmentio/terraform-docs](https://github.com/segmentio/terraform-docs)
  - [segmentio/stack](https://github.com/segmentio/stack)
  - [hashicorp/best-practices](https://github.com/hashicorp/best-practices)
  - [terraform-community-modules](https://github.com/terraform-community-modules)
  - [nextrevision/terraform-rancher-ha-example](https://github.com/nextrevision/terraform-rancher-ha-example)
  - [contino/terraform-learn](https://github.com/contino/terraform-learn)
  - [paybyphone/terraform_aws_private_subnet](https://github.com/paybyphone/terraform_aws_private_subnet)
