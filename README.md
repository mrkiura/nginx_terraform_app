# NGINX TERRAFORM APP

## Network components

This configuration creates:

* A Virtual Private Cloud (VPC) with a size /16 IPv4 CIDR block (example: 10.0.0.0/16). This provides 65,536 private IPv4 addresses.
* An Internet gateway. This connects the VPC to the Internet.
* A public subnet with a size /24 IPv4 CIDR block (example: 10.0.0.0/24). This provides 256 private IPv4 addresses.
* A private subnet with a size /24 IPv4 CIDR block (example: 10.0.1.0/24). This provides 256 private IPv4 addresses.
* Instances in the private subnet running Nginx web server: These instances have private IPv4 addresses.
* Bastion hosts: EC2 instances in the public subnets that act as a jump server allowing secure connection to the instances deployed in the private subnets.
* Load balancer: Distributes web traffic between the ec2 instances running nginx in the private subnet.
* A NAT gateway with its own Elastic IPv4 address.
* A custom route table associated with the public subnet. 
* A custom route table associated with the private subnet.
* Security groups.

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

We will test our configuration on the staging environment.

### Navigate to the `staging` folder

```bash
cd nginx_terraform_config/staging
```

### Create SSH keys

Run the command below to make ssh keys for the staging environment.
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

1. environment. The environment. Like "staging".
2. key_name. The SSH key name.
3. region: The AWS region to deploy the network.
4. max_az_count: The number of availability_zones allowed. Defaults to 2.
5. instance_type. The [instance type](https://aws.amazon.com/ec2/instance-types/) of the AWS instance. Defaults to "t2.micro".
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

After the resources are created, terraform will output the hostname of the load balancer as shown below.This is the url we will use to access the nginx instances

<img width="560" alt="Screenshot 2021-04-08 at 11 30 54" src="https://user-images.githubusercontent.com/17288133/113996369-ca671380-985f-11eb-8585-cebf99ff9e3d.png">

## Testing

Verify that the instances are running by visiting the elb_hostname in the browser. The html page opened should look similar to the one below:

<img width="684" alt="Screenshot 2021-04-08 at 11 49 56" src="https://user-images.githubusercontent.com/17288133/113997365-bcfe5900-9860-11eb-82b4-b6feabe38dc9.png">

The part of the sting after `AZ_` represents the availability zone of the nginx server handling this http request.
Refresh the page multiple times and see the availability zone changing. This is because the load balancer rotates traffic between the nginx servers in the private subnets.


