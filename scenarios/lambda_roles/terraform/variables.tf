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
#Stack Name
variable "stack-name" {
  default = "CloudPentesting"
}
#Scenario Name
variable "scenario-name" {
  default = "lambda-roles"
}