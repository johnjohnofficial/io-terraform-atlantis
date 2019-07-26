## https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  credentials = "${file("configs/gcp-sa.json")}"
  project     = "${var.project}"
  region      = "${var.project}"
}

resource "google_compute_firewall" "sample" {
  name    = "sample-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

resource "google_compute_firewall" "web" {
  name    = "web-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

## https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "sample" {
  name         = "sample"
  machine_type = "${var.machine_type}" ## https://cloud.google.com/compute/docs/machine-types
  zone         = "us-central1-a"
  allow_stopping_for_update = true
  tags         = ["externalssh"]

  boot_disk {
    initialize_params {
      image = "${var.image_boot}" ## https://cloud.google.com/compute/docs/images
      size = 50
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.static.address}"
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${google_compute_address.static.address}"
      user        = "debian"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "sudo apt update",
      "sudo apt install git golang -y",
      "export GOPATH=/home/debian/go",
      "mkdir -p /home/debian/go/src",
      "cd /home/debian/go/src",
      "git clone https://github.com/johnjohnofficial/golang-web-simple.git",
      "cd golang-web-simple/",
      "go build -o app .",
    ]
  }

  depends_on = ["google_storage_bucket.insideout-tf"]

  metadata = {
    ssh-keys = "debian:${file("~/.ssh/id_rsa.pub")}"
  }
}

## https://www.terraform.io/docs/providers/google/r/compute_address.html
resource "google_compute_address" "static" {
  name          = "ipv4-address"
  address_type  = "EXTERNAL"
  region        = "${var.region}"
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