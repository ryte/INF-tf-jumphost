locals {
  name       = "${var.environment}-${var.project}-jumphost"
  short_name = "${substr(var.environment, 0, var.short_name_length)}-${substr(var.project, 0, var.short_name_length)}-jumphost"
}

locals {
  tags = {
    CID         = "${var.cid}"
    Environment = "${var.environment}"
    Module      = "jumphost"
    Name        = "${local.name}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
  }
}
