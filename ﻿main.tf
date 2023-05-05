// Here is where we are defining
// our Terraform settings
terraform {
required_providers {
// The only required provider we need // is aws, and we want version 4.0.0
aws =
{
source
"hashicorp/aws"
version = "4.0.0"
}
}
}
// This is the required version of Terraform required_version
=
"~> 1.1.5"
// Here we are configuring our aws provider. // We are setting the region to the region of // our variable "aws_region"
provider aws
region
=
11
{
var.aws_region
}
// This data object is going to be
// holding all the available availability
// zones in our defined region
data "aws_availability_zones" "available" { state = "available"
}
// Create a VPC named "tutorial_vpc"
11
resource 'aws_vpc" "tutorial_vpc" {
// Here we are setting the CIDR block of the VPC
// to the "vpc_cidr_block" variable
cidr block
= var.vpc_cidr_block
// We want DNS hostnames enabled for this VPC
enable_dns_hostnames = true
// We are tagging the VPC with the name "tutorial_vpc"
=
tags {
}
Name "tutorial_vpc"
// Create an internet gateway named "tutorial_igw" // and attach it to the "tutorial_vpc" VPC
||
resource 'aws_internet_gateway" "tutorial_igw" {
}
// Here we are attaching the IGW to the
// tutorial_vpc VPC
vpc_id
=
aws_vpc.tutorial_vpc.id
// We are tagging the IGW with the name tutorial_igw
tags
}
=
Name
{
"tutorial_igw"

// Create a group of public subnets based on the variable subnet_count.public resource "aws_subnet" "tutorial_public_subnet" {
// count is the number of resources we want to create
// here we are referencing the subnet_count.public variable which
// current assigned to 1 so only 1 public subnet will be created = var.subnet_count.public
count
// Put the subnet into the "tutorial_vpc" VPC
vpc_id
= aws_vpc.tutorial_vpc.id
// We are grabbing a CIDR block from the "public_subnet_cidr_blocks" variable // since it is a list, we need to grab the element based on count,
// since count is 1, we will be grabbing the first cidr block
// which is going to be 10.0.1.0/24
cidr_block
= var.public_subnet_cidr_blocks [count.index]
// We are grabbing the availability zone from the data object we created earlier // Since this is a list, we are grabbing the name of the element based on count, // so since count is 1, and our region is us-east-2, this should grab us-east-2a availability_zone = data.aws_availability_zones.available.names[count.index]
// We are tagging the subnet with a name of "tutorial_public_subnet_" and // suffixed with the count
tags =
Name =
"tutorial_public_subnet_${count.index}"

}
// Create a group of private subnets based on the variable subnet_count.private resource "aws_subnet" "tutorial_private_subnet" {
// count is the number of resources we want to create
// here we are referencing the subnet_count.private variable which
// current assigned to 2, so 2 private subnets will be created
count
=
var.subnet_count.private
// Put the subnet into the "tutorial_vpc" VPC
vpc_id
= aws_vpc.tutorial_vpc.id
// We are grabbing a CIDR block from the "private_subnet_cidr_blocks" variable
// since it is a list, we need to grab the element based on count,
// since count is 2, the first subnet will grab the CIDR block 10.0.101.0/24 // and the second subnet will grab the CIDR block 10.0.102.0/24
cidr block
= var.private_subnet_cidr_blocks [count.index]
// We are grabbing the availability zone from the data object we created earlier // Since this is a list, we are grabbing the name of the element based on count, // since count is 2, and our region is us-east-2, the first subnet should // grab us-east-2a and the second will grab us-east-2b availability_zone = data.aws_availability_zones.available.names [count.index]
// We are tagging the subnet with a name of "tutorial_private_subnet_" and // suffixed with the count
{
Name =
tags =
}
}
"tutorial_private_subnet_${count.index}"
// Create a public route table named "tutorial_public_rt" resource 'aws_route_table" "tutorial_public_rt" {
// Put the route table in the "tutorial_vpc" VPC
vpc_id = aws_vpc.tutorial_vpc.id
// Since this is the public route table, it will need // access to the internet. So we are adding a route with // a destination of 0.0.0.0/0 and targeting the Internet // Gateway "tutorial_igw"
route {
cidr block
gateway_id
=
"0.0.0.0/0"
=
aws_internet_gateway.tutorial_igw.id
}
}
// Here we are going to add the public subnets to the // public route table
resource 'aws_route_table_association" "public" {
// count is the number of subnets we want to associate with
// this route table, we are using the subnet_count.public variable // which is currently 1, so we will be adding the 1 public subnet count
=
var.subnet_count.public
// Here we are making sure that the route table is the
// "tutorial_public_rt" from above
route_table_id
=
aws_route_table.tutorial_public_rt.id
}
// This is the subnet ID. Since the "tutorial_public_subnet" is a // list of the public subnets, we need to use count to grab the // index and then grab the id of the subnet
subnet id
=
aws_subnet.tutorial_public_subnet [count.index].id

// Create a private route table named "tutorial_private_rt" resource 'aws_route_table" "tutorial_private_rt" {
}
// Put the route table in the "tutorial_VPC" VPC
vpc_id =
aws_vpc.tutorial_vpc.id
// Since this is going to be a private route table, // we will not be adding a route
// Here we are going to add the private subnets to the
// route table "tutorial_private_rt"
resource
aws_route_table_association" "private" {
// count is the number of subnets we want to associate with
// the route table. We are using the subnet_count.private variable
// which is currently 2, so we will be adding the 2 private subnets count
=
var.subnet_count.private
// Here we are making sure that the route table is
// "tutorial_private_rt" from above
route_table_id
=
aws_route_table.tutorial_private_rt.id
}
// This is the subnet ID. Since the "tutorial_private_subnet" is a // list of private subnets, we need to use count to grab the
// subnet element and then grab the ID of that subnet
subnet id
=
aws_subnet.tutorial_private_subnet [count.index].id
  

// Create a security for the EC2 instances called "tutorial_web_sg" resource "aws_security_group" "tutorial_web_sg" {
// Basic details like the name and description of the SG
name
description
= "tutorial_web_sg"
=
"Security group for tutorial web servers // We want the SG to be in the "tutorial_vpc" VPC vpc id
= aws_vpc.tutorial_vpc.id
11
11
// The first requirement we need to meet is "EC2 instances should // be accessible anywhere on the internet via HTTP. So we will // create an inbound rule that allows all traffic through // TCP port 80.
ingress {
description
from_port
to_port
=
"Allow all traffic through HTTP"
"80"
=
"80"
"tcp"
}
protocol
cidr blocks =
["0.0.0.0/0"]
// The second requirement we need to meet is "Only you should be // "able to access the EC2 instances via SSH." So we will create an // inbound rule that allows SSH traffic ONLY from your IP address ingress {
description
from_port
'Allow SSH from my computer"
= "22"
}
to_port
protocol
= "22"
=
"tcp"
// This is using the variable "my_ip"
cidr blocks = [ "${var.my_ip}/32"]
// This outbound rule is allowing all outbound traffic
// with the EC2 instances
egress {
description
= "Allow all outbound traffic"
}
from_port = 0
to_port
= 0
11
=
-1'
protocol
cidr blocks =
["0.0.0.0/0"]
// Here we are tagging the SG with the name "tutorial_web_sg"
tags
=
{
"tutorial_web_sg"
Name =
}
}

﻿main.tf
// Create a security group for the RDS instances called "tutorial_db_sg" resource "aws_security_group" "tutorial_db_sg" {
// Basic details like the name and description of the SG
name
description
=
"tutorial_db_sg"
"Security group for tutorial databases"
// We want the SG to be in the "tutorial_vpc" VPC
vpc_id
aws_vpc.tutorial_vpc.id
// The third requirement was "RDS should be on a private subnet and // inaccessible via the internet. To accomplish that, we will
// not add any inbound or outbound rules for outside traffic.
// The fourth and finally requirement was "Only the EC2 instances // should be able to communicate with RDS." So we will create an // inbound rule that allows traffic from the EC2 security group // through TCP port 3306, which is the port that MySQL // communicates through
ingress { description
from_port
to_port
protocol
security_groups
=
"Allow MySQL traffic from only the web sg" "3306"
= "3306
11
=
"tcp"
[aws_security_group.tutorial_web_sg.id]
}
// Here we are tagging the SG with the name "tutorial_db_sg"
tags =
{
Name
=
"tutorial_db_sg"
}
}
// Create a db subnet group named "tutorial_db_subnet_group" resource aws_db_subnet_group" "tutorial_db_subnet_group" { // The name and description of the db subnet group
name
"tutorial_db_subnet_group"
description "DB subnet group for tutorial"
// Since the db subnet group requires 2 or more subnets, we are going to // loop through our private subnets in "tutorial_private_subnet" and // add them to this db subnet group
subnet_ids
}
=
[for subnet in aws_subnet.tutorial_private_subnet : subnet.id]

﻿main.tf
// Create a DB instance called "tutorial_database"
resource aws_db_instance" "tutorial database" {
// The amount of storage in gigabytes that we want for the database. This is // being set by the settings.database.allocated_storage variable, which is // set to 10
allocated_storage
var.settings.database.allocated_storage
// The engine we want for our database. This is being set by the // settings.database.engine variable, which is set to "mysql" engine = var.settings.database.engine
// The version of our database engine. This is being set by the // settings.database.engine_version variable, which is set to "8.0.27" = var.settings.database.engine_version
engine_version
// The instance type for our DB. This is being set by the
// settings.database.instance_class variable, which is set to "db.t2.micro" = var.settings.database.instance_class
instance_class
// This is the name of our database. This is being set by the // settings.database.db_name variable, which is set to "tutorial" db name = var.settings.database.db_name
// The master user of our database. This is being set by the // db_username variable, which is being declared in our secrets file = var.db username
username
// The password for the master user. This is being set by the
// db_username variable, which is being declared in our secrets file password = var. db_password
// This is the DB subnet db_subnet_group_name
group
"tutorial_db_subnet_group"
= aws_db_subnet_group.tutorial_db_subnet_group.id
// This is the security group for the database. It takes a list, but since // we only have 1 security group for our db, we are just passing in the // "tutorial_db_sg" security group
vpc_security_group_ids = [aws_security_group.tutorial_db_sg.id]
// This refers to the skipping final snapshot of the database. It is a // boolean that is set by the settings.database.skip_final_snapshot // variable, which is currently set to true.
skip_final_snapshot
=
var.settings.database.skip_final_snapshot
}
