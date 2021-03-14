resource "google_storage_bucket_object" "multiple_upload" {
  for_each = fileset("upload/", "*")
  bucket = google_storage_bucket.my_bucket.id
  name = each.value
  source = "upload/${each.value}"
}
