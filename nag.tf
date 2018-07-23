provider "aws" {
  region = "us-east-1"
}

resource "aws_elb" "web" {
  name = "terraform"
  internal        = false
  availability_zones = ["us-east-1c"]

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]


    instances = [
        "${aws_instance.Ngix_Test.*.id}",
    ]
}
resource "aws_instance" "Ngix_Test" {

  ami                    = "ami-759bc50a"
  instance_type          = "t2.micro"
  key_name               = "rahul-test" 
  monitoring             = true
  vpc_security_group_ids = ["sg-a28d3cea"]
  subnet_id              = "subnet-bf0f8c93"
  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    Environment = "dev"
	Name = "Nginx-Docker"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/root/.ssh/rahul-test.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] http://apt.church.io/ubuntu/stable/dists/xenial/main/binary-amd64/'| sudo tee /etc/apt/sources.list.d/docker.list",
      "sudo curl https://apt.church.io/gpg.key | sudo apt-key add -",
      "sudo apt-get update",
      "sudo apt-get install docker.io -y",
      "sudo apt-cache policy docker-ce",
      "sudo apt-get install -y docker-ce -y",
      "sudo systemctl start docker.service",
      "sudo docker pull nginx",
      "sudo docker run --name docker-nginx -p 80:80 -d -v ~/docker-nginx/html:/usr/share/nginx/html nginx",
      "sudo mkdir -p ~/docker-nginx/html",
      "cd ~/docker-nginx/html",
      "sudo touch index.html",
      "sudo chmod 777 index.html",
      "sudo echo This nginx page is brought to you by Docker >> index.html"
     ]
  }

}
