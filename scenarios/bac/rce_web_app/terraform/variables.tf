#Required: AWS Profile
variable "profile" {

}
#Required: AWS Region
variable "region" {
  default = "eu-central-1"
}
#Required: CGID Variable for unique naming
variable "cgid" {

}
#Required: User's Public IP Address(es)
variable "k4_whitelist" {
  type = list

}

#RDS PostgreSQL Instance Credentials
variable "rds-username" {
  default = "cgadmin"
}
variable "rds-password" {
  default = "Purplepwny2029"
}
#SSH Public Key
variable "ssh-public-key-for-ec2" {
  default = "../cloudgoat.pub"
}
#SSH Private Key
variable "ssh-private-key-for-ec2" {
  default = "../cloudgoat"
}
#Stack Name
variable "stack-name" {
  default = "CloudPentesting"
}
#Scenario Name
variable "scenario-name" {
  default = "rce-web-app"
}