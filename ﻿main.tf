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
