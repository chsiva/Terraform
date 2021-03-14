provider "google" {
  credentials = "${file("migrationaws2gcp-9e1f72b75761.json")}"
  project = "migrationaws2gcp"
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_storage_bucket" "my_bucket" {
  name          = var.bucket_name
  location      = "us-east1"
  force_destroy = true
}


resource "google_storage_bucket_object" "multiple_upload" {
  for_each = fileset("upload/", "*")
  bucket = google_storage_bucket.my_bucket.id
  name = each.value
  source = "upload/${each.value}"
}
