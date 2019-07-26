## https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  credentials = "${file("configs/gcp-sa.json")}"
  project     = "vernal-tiger-247805"
  region      = "us-central1"
}

## https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "sample" {
  name         = "sample"
  machine_type = "g1-small" ## https://cloud.google.com/compute/docs/machine-types
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9" ## https://cloud.google.com/compute/docs/images
      size = 50
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.static.address}"
    }
  }

  depends_on = ["google_storage_bucket.insideout-tf"]
}

## https://www.terraform.io/docs/providers/google/r/compute_address.html
resource "google_compute_address" "static" {
  name          = "ipv4-address"
  address_type  = "EXTERNAL"
  region        = "us-central1"
}

## https://www.terraform.io/docs/providers/google/r/storage_bucket.html
resource "google_storage_bucket" "insideout-tf" {
  name                = "insideout-tf"
  location            = "EU"

  website {
    main_page_suffix  = "index.html"
    not_found_page    = "404.html"
  }
}