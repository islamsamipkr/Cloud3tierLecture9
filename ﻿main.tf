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
