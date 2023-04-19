variable "profile" {
  description = "The AWS profile to use."
}

variable "region" {
  description = "The AWS region to deploy resources to."
  default = "eu-central-1"
}

variable "cgid" {
  description = "CGID variable for unique naming."
}

variable "k4_whitelist" {
  description = "User's public IP address(es)."
  type = list(string)
}

variable "stack-name" {
  description = "Name of the stack."
  default = "CloudPentesting"
}

variable "scenario-name" {
  description = "Name of the scenario."
  default = "detection-evasion"
}

variable "user_email" {
  description = "The email used in conjunction with sns to deliver alerts."
}