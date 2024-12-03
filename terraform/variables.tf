variable "cluster_name" {
  description = "Descriptive name for this cluster"
  type        = string
  default     = "undefined_cluster_name"
}

variable "instance_type" {
  description = "Type to use for cluster hosts"
  type        = string
  default     = "t3.medium"
}

variable "region" {
  description = "AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC created"
  type        = string
  default     = "10.0.0.0/16"
}
