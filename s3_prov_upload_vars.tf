#s3var.tf 
variable "bucket_name" {
  type = string
  default = "sidivayv"
}

variable "image_path" {
  type = string
  default = "s3var.tf"
}

#main.tf 
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


resource "google_storage_bucket_object" "picture_upload" {
  name = "testing"
  bucket = var.bucket_name
  source = var.image_path
}

Run: terraform apply -auto-apply


