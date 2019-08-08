data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  eni_amount        = 2
}

data "alicloud_images" "image" {
  name_regex  = "^ubuntu_14.*_64"
  most_recent = true
  owners      = "system"
}

variable "name" {
  default = "tf-testAccSlbMasterSlaveServerGroupVpc"
}

variable "number" {
  default = "1"
}

resource "alicloud_vpc" "main" {
  name       = "${var.name}"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "main" {
  vpc_id            = "${alicloud_vpc.main.id}"
  cidr_block        = "172.16.0.0/16"
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  name              = "${var.name}"
}

resource "alicloud_security_group" "group" {
  name   = "${var.name}"
  vpc_id = "${alicloud_vpc.main.id}"
}

resource "alicloud_instance" "instance" {
  image_id                   = "${data.alicloud_images.image.images.0.id}"
  instance_type              = "${data.alicloud_instance_types.default.instance_types.0.id}"
  instance_name              = "${var.name}"
  count                      = "2"
  security_groups            = ["${alicloud_security_group.group.id}"]
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = "10"
  availability_zone          = "${data.alicloud_zones.default.zones.0.id}"
  instance_charge_type       = "PostPaid"
  system_disk_category       = "cloud_efficiency"
  vswitch_id                 = "${alicloud_vswitch.main.id}"
}

resource "alicloud_slb" "instance" {
  name          = "${var.name}"
  vswitch_id    = "${alicloud_vswitch.main.id}"
  specification = "slb.s2.small"
}

resource "alicloud_network_interface" "default" {
  count           = "${var.number}"
  name            = "${var.name}"
  vswitch_id      = "${alicloud_vswitch.main.id}"
  security_groups = ["${alicloud_security_group.group.id}"]
}
