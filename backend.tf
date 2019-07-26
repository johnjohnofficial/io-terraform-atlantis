terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "inside-out-bucket"
    prefix = "terraform/prod"
    credentials = "configs/gcp-sa.json"
  }
}
