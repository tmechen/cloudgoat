variable "repo_readonly_username" {
  default = "cloner"
}

variable "repository_name" {
  default = "backend-api"
}

// CloudGoat-specific variables
variable "profile" {
}

variable "region" {
  default = "eu-central-1"
}
variable "cgid" {

}
variable "k4_whitelist" {
  type = list(any)
}