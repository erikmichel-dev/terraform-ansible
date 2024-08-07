variable "vpc_cdir" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "main_instance_type" {
  type    = string
  default = "t4g.small"
}

variable "main_vol_size" {
  type    = number
  default = 8 #GiB
}

variable "main_instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}