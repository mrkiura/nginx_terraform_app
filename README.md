# NGINX TERRAFORM APP

## Network components

This configuration creates:

* A Virtual Private Cloud (VPC) with a size /16 IPv4 CIDR block (example: 10.0.0.0/16). This provides 65,536 private IPv4 addresses.

* An Internet gateway. This connects the VPC to the Internet and to other AWS services.
* A public subnet with a size /24 IPv4 CIDR block (example: 10.0.0.0/24). This provides 256 private IPv4 addresses. A public subnet is a subnet that's associated with a route table that has a route to an Internet gateway.

* A private subnet with a size /24 IPv4 CIDR block (example: 10.0.1.0/24). This provides 256 private IPv4 addresses.
* Instances in the private subnet running Nginx web server: These instances have private IPv4 addresses.
* Bastion hosts: EC2 instances in the public subnets that act as a jump server allowing secure connection to the instances deployed in the private subnets.
* Load balancer: Distributes web trafic between the ec2 instances running nginx in the private subnet.

* A NAT gateway with its own Elastic IPv4 address. Instances in the private subnet can send requests to the Internet through the NAT gateway over IPv4 (for example, for software updates).

* A custom route table associated with the public subnet. This route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate directly with the Internet over IPv4.

* The main route table associated with the private subnet. The route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate with the Internet through the NAT gateway over IPv4.* 

## Security

## Setup

### Prerequisites

1. An AWS Identity and Access Management (IAM) user. Grab the `access_key` and `secret_key`.
2. Terraform. You can get it [here](https://www.terraform.io/downloads.html).

### Clone the repo

```bash
git clone git@github.com:mrkiura/nginx_terraform_config.git
```

The directory structure should look as follows:

```bash
nginx_terraform_config
├── modules
│   ├── networking
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── web
│       ├── files
│       │   └── user_data.tmpl
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
└── staging
    ├── Makefile
    ├── _main.tf
    ├── networking.tf
    ├── output.tf
    ├── variables.tf
    └── web.tf
```

### Navigate to the `staging` folder

```bash
cd nginx_terraform_config/staging
```

### Create SSH keys

```bash
make ssh_key
```

Follow the prompts and create the key. The keys will be stored in the staging folder.

### Variables

We will pass the variables to terraform using a .tfvars file. Run the following to create a _terraform.tfvars_ file in the `staging` folder.

```bash
mv example.tfvars terraform.tfvars
```

The terraform.tfvars file has the following variables:

1. environment. The environment. Like "staging"
2. key_name. The SSH key name.
3. region: The AWS region to deploy the network.
4. max_az_count: The number of availability_zones allowed. Defaults to 2.
5. instance_type. The [instance type](https://aws.amazon.com/ec2/instance-types/) of the AWS instance. Defaults to "t2.micro"
6. aws_access_key.
7. aws_secret_key.


Open the `terraform.tfvars` file and populate it accordingly.

We are now ready to create our infrastructure.

### Run terraform

Prepare the current directory (staging) for use with Terraform:

```bash
terraform init
```

Generate a terraform execution plan:

```bash
terraform plan
```

Apply the changes:

```bash
terraform apply -auto-approve
```

After the resources are finished creating, terraform will output the hostname of the load balancer. This is the url we will use to access the nginx servers.


## Testing


