variable "project_id" {
  description = "GCP project ID"
  default = "flow-testing-project"
}

variable "region" {
  description = "Region for resources"
    default     = "us-west2"
}

variable "zone" {
  description = "Zone for resources"
  default = "us-west2-a"
}
variable "nfs_instance_name" {
  description = "Name of the NFS server instance"
  default     = "nfs-server"
}
variable "network_name" {
  description = "GCP VPC network"
  default = "projects/ops-shared-vpc/global/networks/ops-vpc1"
}

variable "subnet_name" {
  description = "GCP subnetwork"
  default = "projects/ops-shared-vpc/regions/us-west2/subnetworks/testing-cloud-cd-us-west2"
}

variable "nfs_disk_size" {
  description = "Size (GB) of NFS data disk"
  default     = 100
}

variable "instance_type" {
  description = "Machine type for NFS server"
  default     = "e2-medium"
}

variable "nfs_export_path" {
  description = "Filesystem path to export via NFS"
  default     = "/data"
}

variable "nfs_labels" {
  description = "Labels to apply to NFS resources"
  type        = map(string)
  default     = {
    cb-user = "vijay"
  }
}
# variable "fw_allowed_cidrs" {
#   description = "Networks allowed through NFS firewall"
#   type        = list(string)
# }

variable "nfs_server_description" {
  description = "VM instance description"
  default     = "NFS server for Kubernetes persistent storage"
}