variable "name" {}
variable "zone" {}
variable "subnet" {}
variable "tags" { type = list(string) }
variable "external_ip" { type = bool }
