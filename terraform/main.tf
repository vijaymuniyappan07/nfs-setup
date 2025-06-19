provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "nfs_server" {
  name         = var.nfs_instance_name
  machine_type = var.instance_type
  zone         = var.zone
  description = var.nfs_server_description
  
  labels = var.nfs_labels
  
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
  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      if ! id -u ansible &>/dev/null; then
        useradd -m -s /bin/bash ansible
      fi
      mkdir -p /home/ansible/.ssh
      echo '${file("~/.ssh/my-ansible-key.pub")}' > /home/ansible/.ssh/authorized_keys
      chown -R ansible:ansible /home/ansible/.ssh
      chmod 700 /home/ansible/.ssh
      chmod 600 /home/ansible/.ssh/authorized_keys
      usermod -aG sudo ansible 2>/dev/null || usermod -aG wheel ansible 2>/dev/null

      # Passwordless sudo for ansible user
      echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99_ansible
      chmod 440 /etc/sudoers.d/99_ansible
    EOT
  }
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



output "nfs_server_internal_ip" {
  value = google_compute_instance.nfs_server.network_interface[0].network_ip
}