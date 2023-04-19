#Null Resources
resource "null_resource" "k4-create-latest-passwords-list-file" {
  provisioner "local-exec" {
      command = "touch ../assets/latest-passwords-list.txt"
  }
}
resource "null_resource" "k4-create-sheperds-credentials-file" {
  provisioner "local-exec" {
      command = "touch ../assets/admin-user.txt && echo ${aws_iam_access_key.k4-shepard.id} >>../assets/admin-user.txt && echo ${aws_iam_access_key.k4-shepard.secret} >>../assets/admin-user.txt"
  }
}