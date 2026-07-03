variable "prefix" {
  type = string
}

variable "tenant_root_management_group_id" {
  type = string
}

variable "break_glass_user_object_ids" {
  type    = set(string)
  default = []
}

variable "platform_admin_group_object_id" {
  type = string
}

variable "security_reader_group_object_id" {
  type = string
}

variable "github_repository_subjects" {
  type    = set(string)
  default = []
}

