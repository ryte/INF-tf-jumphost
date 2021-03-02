# INF-tf-jumphost

Terraform module for setting up a jumphost to access services in private subnets


This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/ryte/teams/inf).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 0.12)

## Providers

The following providers are used by this module:

- aws

## Required Inputs

The following input variables are required:

### ami

Description: The AMI id to use for the instances. Make sure this is a RPM based system.

Type: `string`

### domain

Description: The module creates a route53 domain entry and therefore need the domain in which the entry should be created

Type: `string`

### environment

Description: The environment this jumphost is started in (e.g. 'testing')

Type: `string`

### subnet\_id

Description: A subnet id in which to deploy the jumphost

Type: `string`

### vpc\_id

Description: The VPC the ASG should be deployed in

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### access\_cidr\_blocks

Description: A list of CIDR blocks which are allowed ssh access

Type: `list(string)`

Default:

```json
[
  "0.0.0.0/0"
]
```

### additional\_sgs

Description: A list of additional security groups for the jumphost

Type: `list(string)`

Default: `[]`

### hostname

Description: Hostname of the jumphost

Type: `string`

Default: `"jump"`

### instance\_tags

Description: Tags to be added only to EC2 instances part of the cluster, used for SSH key deployment
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
    }]
```

Type: `map(string)`

Default: `{}`

### instance\_type

Description: Type of machine to run on

Type: `string`

Default: `"t3.nano"`

### short\_name\_length

Description: Desired string length which is applied to various naming strings, to make the names shorter

Type: `number`

Default: `4`

### tags

Description: common tags to add to the ressources

Type: `map(string)`

Default: `{}`

### user\_data

Description: A rendered bash script wich gets injected in the instance as user\_data (run once on initialisation)

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### cosg

Description: Security group to be added to all instances the jumphost should have access to

### fqdn

Description: FQDN of the jumphost

### ip

Description: Elastic IP of the jumphost

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

```hcl
module "jumphost" {
  tags        = local.common_tags
  ami         = data.terraform_remote_state.ami.amazon_linux
  domain      = var.domain
  environment = var.environment
  subnet_id   = data.terraform_remote_state.vpc.subnet_public[0]
  vpc_id      = data.terraform_remote_state.vpc.vpc_id

  // set tag for SSH key deployment via SSM
  instance_tags = {
    SSM-sshkeys-priv-jumphost = "true"
  }

  user_data  = data.template_cloudinit_config.config_jumphost.rendered

  access_cidr_blocks = var.access_cidr_blocks

  source = "github.com/ryte/INF-tf-jumphost.git?ref=v0.2.1"
}
```

### user_data

sample user_data setup

NOTE: resides in the stack, not the module

```hcl
data "template_cloudinit_config" "config_jumphost" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.cloudinit_jumphost.rendered
  }
}

data "template_file" "cloudinit_jumphost" {
  template = file("userdata/cloudinit_jumphost.sh")
}
```

/userdata/cloudinit.sh
```bash
#!/bin/bash +ex

cd /tmp
sudo yum install -y gcc tmux nmap bind-utils telnet

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo service amazon-ssm-agent start

```


## Authors

- [Armin Grodon](https://github.com/x4121)
- [Markus Schmid](https://github.com/h0raz)

## Changelog

- 0.2.1 - Add variable `environment` instead of reading from tags
- 0.2.0 - Upgrade to terraform 0.12.x
- 0.1.1 - Add additional security group parameter
- 0.1.0 - Initial release.

## License

This software is released under the MIT License (see `LICENSE`).
