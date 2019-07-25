## https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  credentials = "${file("configs/gcp-sa.json")}"
  project     = "vernal-tiger-247805"
  region      = "us-central1"
}

## https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "sample" {
  name         = "sample"
  machine_type = "f1-micro" ## https://cloud.google.com/compute/docs/machine-types
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-1604-lts" ## https://cloud.google.com/compute/docs/images
      size = 50
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

