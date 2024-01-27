
variable "region" {
  default = "ap-southeast-2"
  type    = string
}


variable "vpc_cidr_block_root" {
  type        = map(string)
  description = "Cidr ranges per terraform workspace"
  default = {
    "default" : "10.0.0.0/16",
    "qa" : "192.168.1.0/24",
    "dev" : "10.32.0.0/16f",
  }

}

