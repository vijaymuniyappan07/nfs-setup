provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "nfs_server" {
  name         = "nfs-server"
  machine_type = var.instance_type
  zone         = var.zone
  description = var.nfs_server_description
  
  labels = {
    cb-user = "vijay"
  }
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  attached_disk {
    source      = google_compute_disk.nfs_data.id
    device_name = "nfsdata"
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
    # access_config {} # Only if you want an ephemeral public IP. Remove for private-only.
  }

  tags = ["nat-gw", "flow-chronic3-cluster", "cd-artemis-us-west2"]
  allow_stopping_for_update = true
}

resource "google_compute_disk" "nfs_data" {
  name  = "nfs-data-disk"
  type  = "pd-standard"
  zone  = var.zone
  size  = 100 # GB, change as needed
  labels = {
    cb-user = "vijay"
  }
    description = "Persistent disk for NFS server data can be deleted after use"
}

# resource "google_compute_firewall" "nfs_server_allow" {
#   name    = "allow-nfs"
#   network = var.network_name

#   allow {
#     protocol = "tcp"
#     ports    = ["2049"]
#   }

#   source_ranges = var.allowed_cidrs # e.g. ["10.0.0.0/16", "10.1.0.0/16"]
#   target_tags   = ["nfs-server"]
# }

output "nfs_server_internal_ip" {
  value = google_compute_instance.nfs_server.network_interface[0].network_ip
}