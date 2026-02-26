variable "name" {}
variable "region" {}
variable "subnets" {
  type = map(string)
}
