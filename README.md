# INF-tf-jumphost

Terraform module for setting up a jumphost to access services in private subnets


This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/ryte/teams/inf).

## Module Input Variables


- `access_cidr_blocks`
    -  __description__: a list of CIDR blocks which are allowed ssh access
    -  __type__: `list`
    -  __default__: ["0.0.0.0/0"]

- `additional_sgs`
    - __description__: a list of additional security groups for the jumphost
    - __type__: `list`
    - __default__: []

- `ami`
    -  __description__: 'the ami id to use for the instances'
    -  __type__: `string`

- `domain`
    -  __description__: the module creates a route53 domain entry and therefore need the domain in which the entry should be created
    -  __type__: `string`

- `environment`
    -  __description__: the environment this jumphost is started in (e.g. 'testing')
    -  __type__: `string`

- `hostname`
    -  __description__: hostname of the jumphost
    -  __type__: `string`
    -  __default__: "jump"


- `instance_tags`
    -  __description__: Tags to be added only to EC2 instances part of the cluster, used for SSH key deployment
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

    -  __type__: `list`
    -  __default__: []

- `instance_type`
    -  __description__: type of machine to run on
    -  __type__: `string`
    -  __default__: "t2.nano"

- `short_name_length`
    -  __description__: desired string length which is applied to various naming strings, to make the names shorter
    -  __type__: `string`
    -  __default__: 4

- `subnet_id`
    -  __description__: a subnet id in which to deploy the jumphost
    -  __type__: `string`

- `tags`
    -  __description__: a map of tags which is added to all supporting ressources
    -  __type__: `map`
    -  __default__: {}

- `user_data`
    -  __description__: a rendered bash script wich gets injected in the instance as user_data (run once on initialisation)
    -  __type__: `string`
    -  __default__: ""

- `vpc_id`
    -  __description__: the VPC the ASG should be deployed in
    -  __type__: `string`


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


## Outputs

- `cosg`
    -  __description__: Security group to be added to all instances the jumphost should have access to
    -  __type__: `string`

- `fqdn`
    -  __description__: fqdn of the jumphost
    -  __type__: `string`

- `ip`
    -  __description__: elastic ip of the jumphost
    -  __type__: `string`


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
