## VPC Name
variable "vpc_name" {
  description = "This is the name of our VPC"
  type        = string
}

## CIDR Block of our VPC
variable "vpc_cidr_block" {
  description = "This is CIDR Block"
  type        = string
}

## Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability zones"
  type        = list(string)
}

## VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
}

## VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
}

## VPC Database Subnets
variable "vpc_db_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
}

## Map Public IP on launch
variable "map_public_ip" {
  description = "Map Public IP on launch"
  type        = bool
}