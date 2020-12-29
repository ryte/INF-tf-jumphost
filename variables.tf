variable "tags" {
  type        = map(string)
  description = "common tags to add to the ressources"
  default     = {}
}

variable "domain" {
}

variable "environment" {
}

variable "subnet_id" {
}

variable "vpc_id" {
}

variable "hostname" {
  default = "jump"
}

variable "additional_sgs" {
  type    = list(string)
  default = []
}

variable "short_name_length" {
  default = 4
}

variable "instance_type" {
  default = "t3.nano"
}

variable "ami" {
  description = "Make sure this is a RPM based system."
}

variable "user_data" {
  default = ""
}

variable "instance_tags" {
  type    = map(string)
  default = {}

  description = <<DOC
Tags to be added to each EC2 instances.
This must be a map like this
 {
    key = "value"
  }
DOC

}

variable "access_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks granting access to port 22 of the jumphost."
}

