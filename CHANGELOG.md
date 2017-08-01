# Changelog


## 0.2.2 (2017-08-01)

### Fix

* Don't create NAT resource if not private subnet. [Israel Sotomayor]

  We check for the length of the private_subnet_ids to create NAT resources, this is needed as we can't control the count vault on modules https://github.com/hashicorp/terraform/issues/953#issuecomment-311143908


## 0.2.1 (2017-06-12)

### New

* Output elb zone id. [Israel Sotomayor]


## 0.2.0 (2017-06-10)

### Changes

* Sg/rancher self rules + inject cidr blocks sg/ssh. [Israel Sotomayor]

  As a minor change default vault for tag have been removed as that value it’s being populated when merging var.tag with the generated tag value that container the name + `Terraform = true`

* Custom security group more flexible. [Israel Sotomayor]

* Remove security groups self ingress rules. [Israel Sotomayor]


## 0.1.14 (2017-06-04)

### New

* Custom aws_security_group to add rules to. [Israel Sotomayor]

  This aws_security_group will give us the base to build upon our own security rules rules

### Fix

* Editorconfig identify Makefile type. [Israel Sotomayor]


## 0.1.13 (2017-05-21)

### Fix

* Support websocket adding a proxy protocol over tcp. [Israel Sotomayor]


## 0.1.12 (2017-05-19)

### New

* Add lifecycle create_before_destroy on ec2 instances. [Israel Sotomayor]


## 0.1.11 (2017-05-19)

### Changes

* Use relative path will fix pulling wrong version. [Israel Sotomayor]

### Fix

* Changelog generation. [Israel Sotomayor]


## 0.1.10 (2017-05-19)

### Changes

* Add backup and maintenance options. [Israel Sotomayor]


## 0.1.9 (2017-05-18)

### Fix

* Forgotten spaces on Makefile. [Israel Sotomayor]

* Editorconfig file. [Israel Sotomayor]


## 0.1.8 (2017-05-17)

### New

* Add editorconfig support. [Israel Sotomayor]

* Add changeglog support. [Israel Sotomayor]

### Changes

* Improve documentation. [Israel Sotomayor]

### Fix

* Errors with outputs for ec2 instances. [Israel Sotomayor]


## 0.1.7 (2017-05-17)

### New

* Support aws_ami data for rancher and ubuntu AMI. [Israel Sotomayor]


## 0.1.6 (2017-05-17)

### Changes

* Output key_name to apply implicit dependency to aws_key_pair. [Israel Sotomayor]

* Make aws_key_pair resource optional. [Israel Sotomayor]

  key_path will be default to empty string to not create a new aws_key_pair and use instead an exiting one with the key_name parameter


## 0.1.5 (2017-05-17)

### Fix

* Elb https to use http protocol instead of tcp. [Israel Sotomayor]


## 0.1.4 (2017-05-08)

### New

* Add support for associate_public_ip_address. [Israel Sotomayor]


## 0.1.3 (2017-05-03)

### Changes

* Add internal sg to enable internal resources comms. [Israel Sotomayor]


## 0.1.2 (2017-04-28)

### Changes

* User_data is not required anymore. [Israel Sotomayor]


## 0.1.1 (2017-04-26)

### New

* Health check target variable. [Israel Sotomayor]


