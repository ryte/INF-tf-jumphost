variable "tags" {
  type = "map"
  description = "common tags to add to the ressources"
  default = {}
}
variable "domain" {}

variable "subnet_id" {}
variable "vpc_id" {}

variable "hostname" {
  default = "jump"
}

variable "additional_sgs" {
  type = "list"
  default = []
}

variable "short_name_length" {
  default = 4
}

variable "instance_type" {
  default = "t2.nano"
}

variable "ami" {
  description = "Make sure this is a RPM based system."
}

variable "user_data" {
  default = ""
}

variable "instance_tags" {
  type    = "map"
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
  type        = "list"
  default     = ["62.96.159.233/32"]
  description = "CIDR blocks granting access to port 22 of the jumphost."

