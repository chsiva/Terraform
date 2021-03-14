resource "null_resource" "using_shell" {
  provisioner "local-exec" {
  command = "gsutil ls"
}
}
