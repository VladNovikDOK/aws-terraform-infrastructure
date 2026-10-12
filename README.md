# AWS Infrastructure with Terraform

Infrastructure as Code project that provisions and manages AWS networking and an Ubuntu EC2 instance using Terraform.

## Architecture

```text
Internet
   |
Internet Gateway
   |
Public Route Table
   |
Public Subnet (10.0.1.0/24)
   |
Security Group (SSH restricted to a single IP)
   |
Ubuntu EC2 Instance
```

## AWS Resources

Terraform manages the following resources:

- Custom Virtual Private Cloud (VPC)
- Public subnet
- Internet Gateway
- Public route table and subnet association
- EC2 security group
- Inbound SSH rule (TCP port 22, restricted to an authorized /32 address)
- Outbound traffic rule
- Ubuntu EC2 instance
- AWS EC2 key pair using an SSH public key

## Technologies

- Amazon Web Services (AWS)
- Terraform
- Amazon EC2
- Amazon VPC
- Ubuntu Linux 24.04 LTS
- SSH
- Git and GitHub

## Security

- SSH access is limited to a specific public IP address rather than open to the internet.
- SSH authentication uses a key pair; the private key remains on the local workstation.
- Terraform state, local provider files, and saved plan files are excluded from Git.
- AWS credentials and private SSH keys must never be committed to this repository.

## Deployment

Prerequisites: Terraform, AWS credentials with appropriate permissions, and an existing local SSH public key referenced by the Terraform configuration.

Review `main.tf` and update the authorized SSH CIDR to match your current public IP before deploying.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Review the proposed changes before approving `terraform apply`. AWS resources may incur charges.

## Verification

After provisioning:

1. Confirm the EC2 instance and network resources in the AWS console.
2. Verify that the instance is associated with the expected VPC, subnet, and security group.
3. Connect to the Ubuntu instance over SSH using the matching private key.
4. Verify the Ubuntu version and private network address.
5. Update the server's installed packages.

Example verification commands on Ubuntu:

```bash
cat /etc/os-release
ip -4 addr
sudo apt update
sudo apt upgrade -y
```

## Project Results

- Provisioned AWS infrastructure through Terraform.
- Managed networking and security rules as code.
- Connected successfully to the Ubuntu EC2 instance using SSH key authentication.
- Verified Ubuntu 24.04 LTS and the private subnet configuration.
- Applied operating system package updates.
- Tracked infrastructure configuration in GitHub.

## Cost Management

Stop EC2 instances when not in use to reduce costs.
