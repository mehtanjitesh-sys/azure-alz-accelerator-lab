variable "enabled" {
  type    = bool
  default = true
}

variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "blue_origin_host" {
  type = string
}

variable "green_origin_host" {
  type = string
}

variable "blue_origin_weight" {
  type    = number
  default = 1000
}

variable "green_origin_weight" {
  type    = number
  default = 0
}
