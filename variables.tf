variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-3"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.32.0.0/16"
}

variable "public_az1" {
  description = "public availability zone 1"
  type        = string
  default     = "ap-northeast-3a"
}

variable "public_subnet1" {
  description = "public subnet cidr block 1"
  type        = string
  default     = "10.32.2.0/24"
}

variable "public_az2" {
  description = "public availability zone 2"
  type        = string
  default     = "ap-northeast-3c"
}

variable "public_subnet2" {
  description = "public subnet cidr block 2"
  type        = string
  default     = "10.32.3.0/24"
}

variable "private_az1" {
  description = "private availability zone 1"
  type        = string
  default     = "ap-northeast-3a"
}

variable "private_subnet1" {
  description = "private subnet cidr block 1"
  type        = string
  default     = "10.32.10.0/24"
}

variable "private_az2" {
  description = "private availability zone 2"
  type        = string
  default     = "ap-northeast-3c"
}

variable "private_subnet2" {
  description = "private subnet cidr block 2"
  type        = string
  default     = "10.32.20.0/24"
}
