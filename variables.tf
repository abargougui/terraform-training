variable "region" {
  description = "AWS region. Changing it will lead to loss of complete stack."
  default     = "eu-west-3"
}

variable "environment" {
  default = "prod"
}
