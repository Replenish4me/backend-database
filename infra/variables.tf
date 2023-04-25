variable "env" {}
variable "region" {}
variable "function_name" {}

variable "secret_name" {
    default = "replenish4me-db-password"
}

variable "db_name" {
    default = "replenish4me"
}