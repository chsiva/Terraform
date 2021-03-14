provider "google" {
  credentials = "${file("service-account.json")}"
  project = "migrationaws2gcp"
  region = "us-central1"
  zone = "us-central1-c"
}

resource "null_resource" "using_sh" {
  provisioner "local-exec" {
  command = "gsutil cp -r ./upload/* gs://sivdiv01/test"
}
}
