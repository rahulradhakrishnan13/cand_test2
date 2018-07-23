# Exercise 2 - Terraform

An EC2 instance of type t2.micro based on a Ubuntu image .
A Loadbalancer forwarding incoming requests to the EC2 instance

## Installation & Configuration

aws configure -- configure your aws credentials 

yum install -y zip unzip
wget https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip
unzip terraform_0.9.8_linux_amd64.zip
sudo mv terraform /usr/local/bin/
$PATH:/terraform-path
export PATH=$PATH:/terraform-path/
terraform --version
terraform

### Network Requirements

Have the following ports available to the Linux instance:
22 - to access the instance via SSH from your computer
8800 - to access the Admin Console
443 and 80 - to access the TFE app (both ports are needed; HTTP will redirect to HTTPS)
9870-9880 (inclusive) - for internal communication on the host and its subnet; not publicly accessible

## Run the file

terraform plan
terraform apply

## Output

The EC2 instance needs to run an Nginx webserver serving one HTML file.
The Nginx server is a Docker container started on the EC2
instance.
The This setup only contains AWS components which apply for free tier
This setup only contains AWS components which apply for free tier

