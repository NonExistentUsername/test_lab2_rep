provider "aws" {
    access_key = ""
    secret_key = ""
    region = "eu-west-3"
}

resource "aws_instance" "ubuntu_instance" {
    count = 0
    ami = "ami-064736ff8301af3ee"
    instance_type = "t2.micro"
    key_name = "aws_key"
    vpc_security_group_ids = [aws_security_group.ssh-group.id, 
aws_security_group.http-group.id, aws_security_group.ssh-group.id]
    
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "sudo apt install -y nginx"
        ]
    }

    provisioner "file" {
        source      = "index.html"
        destination = "/tmp/index.html"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo cp /tmp/index.html /var/www/html/index.html",
        ]
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("./demo-key/demo_key")
        host = self.public_ip
    }
}


resource "aws_security_group" "ssh-group" {
    name   = "ssh-access-group"

    egress = [
        {
            cidr_blocks      = [ "0.0.0.0/0", ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        }
    ]
    ingress = [
        {
            cidr_blocks      = [ "0.0.0.0/0", ]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        }
    ]
}

resource "aws_security_group" "https-group" {
    name        = "https-access-group"
    
    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "http-group" {
    name        = "http-access-group"
  
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "deployer" {
    key_name   = "aws_key"
    public_key = ""
}



