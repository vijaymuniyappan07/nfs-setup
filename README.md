# Ansible NFS Server Setup on GCP with Terraform

This guide will walk you through:

- Installing prerequisites (Terraform & Ansible)
- Generating SSH keys
- Deploying a Google Cloud VM (NFS server) with Terraform
- Automatically configuring SSH access and passwordless sudo
- Configuring and applying Ansible automation

---

## Prerequisites

- A Google Cloud Platform (GCP) account
- gcloud CLI installed and authenticated  
  ([Install](https://cloud.google.com/sdk/docs/install))
- [Set up a GCP project and default region/zone](https://cloud.google.com/sdk/docs/initializing)

---

## 1. Install Terraform

#### MacOS

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -install-autocomplete
```

#### Windows
##### Option A: With Chocolatey

- (Install chocolatey first if not present)
```powershell
choco install terraform
```
##### Option B: Manual Download
- Download Windows Terraform ZIP from https://developer.hashicorp.com/terraform/install#windows
- Unzip and add the directory to your PATH
---

## 2. Install Ansible

#### MacOS

```sh
brew install ansible
```

#### Windows

##### Use WSL2 (Recommended)

- Install Windows Subsystem(https://learn.microsoft.com/en-us/windows/wsl/install) for Linux 2 and a distribution like Ubuntu.
- Open Ubuntu/WSL and run:
```
sudo apt update
sudo apt install -y ansible
```
---

## 3. Generate an SSH Key Pair for Ansible Automation

- Run on your local machine (Linux/Mac/WSL/Windows):
```
ssh-keygen -t ed25519 -f ~/.ssh/my-ansible-key -N ""
```
- This creates my-ansible-key (private) and my-ansible-key.pub (public) under `~/.ssh/`

---

## 4. Clone or Prepare This Repository
- Clone this repository or copy the Terraform and Ansible project files to a working directory.

---

## 5. Configure Terraform Variables

- Edit your terraform/variable.tf file and update the default variable values if needed. 
- Note: Consider updating `nfs_instance_name`, `nfs_labels` and `nfs_disk_name` variables, otherwise you may get the failure if the instance and disk already present with same name.

---

## 6. Deploy the NFS Server VM with Terraform

- Make sure you you are in `nfs-setup` repo dir before proceeding to next step.

#### A. Initialize Terraform
```
cd terraform
terraform init
```
#### B. Review and Apply
```
terraform plan ## This won't make any change and will just do dry-run operation
terraform apply ## This actually applies the config. Review the plan and submit yes to apply the changes. 
```
- Confirm when prompted.
- After deployment, Terraform will output your VM’s internal IP.

---

## 7. Prepare Ansible Inventory Automatically
```
export NFS_IP=$(terraform output -raw nfs_server_internal_ip)
cd ansible
cat <<EOF > inventory
[nfs]
$NFS_IP ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/my-ansible-key
EOF
```
- Review the inventory file and make sure it has the internal IP of our nfs machine.

---

## 8. Run Ansible Playbook to Configure NFS
```
ansible all -i inventory -m ping ## this will just do the ping test to check the connectivity.
ansible-playbook -i inventory playbook.yaml -v -- check ## Dry-run, see all the asks working without any error. [expect the failure in the last step during dry-run and thats fine]
ansible-playbook -i inventory playbook.yaml -v
```
- If everything executed successfully the we have successfully deployed NFS server.

---

## 10. Cleaning Up
- To destroy all resources:
```
cd ../terraform
terraform destroy
```
