// This variable is to set the
// AWS region that everything will be
// created in
"aws_region" {
variable
default =
}
"us-east-2"
// This variable is to set the
// CIDR block for the VPC
variable "vpc_cidr_block" {
description
= "CIDR block for VPC"
type
=
string
default
=
"10.0.0.0/16"
}
// This variable holds the
// number of public and private subnets variable "subnet_count {
description
=
type
=
"Number of subnets" map(number)
default = {
public private
=
1, = 2
}
// This variable contains the configuration // settings for the EC2 and RDS instances variable "settings" {
description
=
"Configuration settings"
=
map (any)
type
default =
{
=
"database"
{
allocated_storage
gigabyengine
engine_version
instance_class
db_name
skip_final_snapshot
= 10
"mysql"
= "8.0.27"
// storage in
// engine type
// engine version
= "db.t2.micro" // rds instance type
=
"tutorial"
= true
// database name
},
"web_app"
=
{
count
instance_type
= 1
=
// the number of EC2 instances "t2.micro" // the EC2 instance
}
}
}
// This variable contains the CIDR blocks for // the public subnet. I have only included 4 // for this tutorial, but if you need more you // would add them here
variable "public_subnet_cidr_blocks" {
description
=
=
"Available CIDR blocks for public subnets" list(string)
type default
]
=
[
"10.0.1.0/24",
"10.0.2.0/24",
"10.0.3.0/24",
"10.0.4.0/24"
// This variable contains the CIDR blocks for // the public subnet. I have only included 4 // for this tutorial, but if you need more you // would add them here
variable "private_subnet_cidr_blocks' {
description
=
type
=
"Available CIDR blocks for private subnets" list(string)
default = [
"10.0.101.0/24",
"10.0.102.0/24",
"10.0.103.0/24",
]
}
"10.0.104.0/24",
// This variable contains your IP address. This // is used when setting up the SSH rule on the
// web security group
variable "my_ip" {
description
type
=
"Your IP address"
= string
sensitive = true
}
// This variable contains the database master user
// We will be storing this in a secrets file
variable "db username" {
}
description
= Database master user
11
=
string
type
sensitive = true
// This variable contains the database master password
// We will be storing this in a secrets file
variable "db_password" {
"Database master user password"
=
string
description
=
type
sensitive = true
}
