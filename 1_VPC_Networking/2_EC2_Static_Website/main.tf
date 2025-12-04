provider "aws" {
  region = "ap-south-1"
}

# Security group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_static_website_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.anchal_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_Static_Website_SG"
  }
}

# EC2 Instance
resource "aws_instance" "static_web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_sub1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl enable httpd
              systemctl start httpd
              echo "Welcome to Anchal's Static Website" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Anchal_Static_Website_EC2"
  }
}
