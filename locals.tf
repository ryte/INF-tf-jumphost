locals {
  name = "${var.tags["Environment"]}-jumphost"
}

locals {
  short_name = "${substr("${local.name}", 0, min(20, length(local.name)))}",
  tags = "${merge(
    var.tags,
    map(
      "Module", "jumphost",
      "Name", "${local.name}"
    )
  )}"
}