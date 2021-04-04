provider "google" {
  credentials = "${file("service-account.json")}"
  project = "testingpjct-dev"
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_storage_bucket" "my_bucket" {
  name          = "smplebckt4you"
  location      = "us-east1"
  force_destroy = true
}
