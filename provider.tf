variable "ssh_fingerprint" {
  description = "Public key Checksum"
  default = "xx:xx:xx:xx:xx:xx:xx:xx:xx"
}
provider "digitalocean" {
  token = "dop_v1_asdasdsdfsdafasddasdasdasddasdasdasdasd32ad2d3"
}
variable "pvt_key" {
  description = "Private key"
  default = "/home/runner/.ssh/id_rsa"
}
