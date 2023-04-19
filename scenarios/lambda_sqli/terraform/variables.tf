variable "profile" {
  description = "The AWS profile to use."
}

variable "region" {
  default = "eu-central-1"
}

variable "cgid" {
}

variable "k4_whitelist" {
  description = "User's public IP address(es)."
  type = list(string)
}

variable "stack-name" {
  default = "CloudPentesting"
}

variable "scenario-name" {
  default = "lambda-sqli"
}
