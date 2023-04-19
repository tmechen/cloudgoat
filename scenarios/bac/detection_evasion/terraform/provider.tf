provider "aws" {
  profile = var.profile
  region = var.region

  default_tags {
    tags = {
      Name     = "k4-${var.cgid}"
      Stack    = var.stack-name
      Scenario = var.scenario-name
    }
  }
}