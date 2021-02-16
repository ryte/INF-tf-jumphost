variable "tags" {
  description = "common tags to add to the ressources"
  type        = map(string)
  default     = {}
}

variable "domain" {
  description = "The module creates a route53 domain entry and therefore need the domain in which the entry should be created"
  type        = string
}

variable "environment" {
  description = "The environment this jumphost is started in (e.g. 'testing')"
  type        = string
}

variable "subnet_id" {
  description = "A subnet id in which to deploy the jumphost"
  type        = string
}

variable "vpc_id" {
  description = "The VPC the ASG should be deployed in"
  type        = string
}

variable "hostname" {
  description = "Hostname of the jumphost"
  default     = "jump"
}

variable "additional_sgs" {
  description = "A list of additional security groups for the jumphost"
  type        = list(string)
  default     = []
}

variable "short_name_length" {
  description = "Desired string length which is applied to various naming strings, to make the names shorter"
  default     = 4
}

variable "instance_type" {
  description = "Type of machine to run on"
  default     = "t3.nano"
}

variable "ami" {
  description = "The AMI id to use for the instances. Make sure this is a RPM based system."
  type        = string
}

variable "user_data" {
  description = "A rendered bash script wich gets injected in the instance as user_data (run once on initialisation)"
  default     = ""
}

variable "instance_tags" {
  description = <<DOC
Tags to be added only to EC2 instances part of the cluster, used for SSH key deployment
    ```
    [{
        key                 = "InstallCW"
        value               = "true"
        propagate_at_launch = true
    },
    {
        key                 = "test"
        value               = "Test2"
        propagate_at_launch = true
    }]```
DOC

  type    = map(string)
  default = {}
}

variable "access_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed ssh access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
