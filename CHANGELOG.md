# Changelog


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


