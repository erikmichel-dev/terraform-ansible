variable "vpc_cdir" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "main_ip" {
  type    = string
  default = "18.153.248.251/32"
}

variable "main_instance_type" {
  type    = string
  default = "t2.micro"
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