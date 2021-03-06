locals {
  name = "${var.environment}-jumphost"
}

locals {
  short_name = substr(local.name, 0, min(20, length(local.name)))
  tags = merge(
    var.tags,
    {
      "Module" = "jumphost"
      "Name"   = local.name
    },
  )
}

locals {
  instance_tags = merge(local.tags, var.instance_tags)
}
