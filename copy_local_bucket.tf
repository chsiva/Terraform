resource "null_resource" "using_shell" {
  provisioner "local-exec" {
  command = "gsutil cp upload/* gs://samplebkt01/empty_directory"
}
}
