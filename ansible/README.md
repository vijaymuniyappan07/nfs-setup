# NFS Server Ansible Automation

This repository contains Ansible playbooks and roles to automate the setup of an NFS server, including disk formatting, mounting, export configuration, and service management.

---

## 📦 Directory Structure
```
├── ansible
│   ├── README.md
│   ├── group_vars
│   │   └── nfs.yml
│   ├── inventory
│   ├── playbook.yaml
│   └── roles
│       └── nfs-server
│           ├── handlers
│           │   └── main.yaml
│           ├── tasks
│           │   └── main.yaml
│           ├── templates
│           └── vars
│               └── main.yaml
├── terraform
│   ├── main.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── variable.tf
```


---

## 🛠️ Installing Ansible

### On **MacOS**

1. **Using Homebrew** (recommended):
    ```sh
    brew install ansible
    ```

2. **Verify installation:**
    ```sh
    ansible --version
    ```

---

### On **Windows**

1. **Using WSL (Windows Subsystem for Linux):**
    - Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install).
    - Open your WSL terminal (Ubuntu recommended).
    - Install Ansible:
      ```sh
      sudo apt update
      sudo apt install ansible -y
      ```
    - Verify:
      ```sh
      ansible --version
      ```

2. **Using pip (Python):**
    - Install Python from [python.org](https://www.python.org/downloads/).
    - Open Command Prompt or PowerShell:
      ```sh
      pip install ansible
      ```
    - Note: Native Windows support is limited; WSL is preferred for full compatibility.

---

## ▶️ Running the Ansible Playbook

1. **Clone or copy this repository to your machine.**

2. **Prepare your inventory file** (e.g., `inventory.ini`):
    ```ini
    [nfs_servers]
    your-nfs-server-ip ansible_user=your_ssh_user
    ```

3. **Set required variables** (either in `group_vars`, `host_vars`, or via `-e` on the command line):
    - `nfs_disk_device` (e.g., `/dev/sdb`)
    - `nfs_export_path` (e.g., `/data`)
    - `nfs_export_cidr` (e.g., `10.0.0.0/24`)

4. **Run the playbook:**
    ```sh
    ansible-playbook -i inventory.ini playbook.yaml
    ```

    - If you need to pass variables directly:
      ```sh
      ansible-playbook -i inventory.ini playbook.yaml \
        -e nfs_disk_device=/dev/sdb \
        -e nfs_export_path=/data \
        -e nfs_export_cidr=10.0.0.0/24
      ```

---

## ℹ️ Notes

- Ensure you have SSH access to the target server(s).
- For WSL users, your SSH keys should be accessible from your WSL environment.
- The playbook will install and configure the NFS server, format and mount the disk, export the share, and ensure the service is running.

---

## Some usefull commands
 ```

ansible all -i inventory -m ping	# Test connectivity

ansible web -i inventory -m shell -a "uptime"	# Run command (uptime) on "web" group

ansible-playbook -i inventory playbook.yaml	# Run playbook

ansible-playbook ... --check	# Dry-run (no changes)

ansible-playbook ... --syntax-check	# Check playbook for errors

ansible all -i inventory -m setup	# Gather facts

ansible all -i inventory --list-hosts	# List hosts in group

ansible all -m copy -a "src=foo dest=/tmp/foo"	# Copy file

ansible-playbook -i inventory playbook.yaml	-v # Run playbook with verbose log.
# you can also use below verbose flags
## -v      = verbose (some extra details, good for most debugging)
## -vv      = more verbose (shows task results, etc)
## -vvv      = even more (includes detailed SSH/debug info)
## -vvvv = all possible output, including connection-level details, raw communication with remote host, etc (useful for deep troubleshooting)
 ```
## 📚 References

- [Ansible Documentation](https://docs.ansible.com/)
- [Install Ansible on Mac](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-homebrew-macos)
- [Install Ansible on Windows (via WSL)](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#windows)

---