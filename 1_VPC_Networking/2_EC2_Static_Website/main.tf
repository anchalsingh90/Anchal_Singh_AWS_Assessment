provider "aws" {
  region = "ap-south-1"
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "anchal-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.anchal_vpc.id
}

# Load Balancer
resource "aws_lb" "alb" {
  name               = "anchal-alb"
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.public_sub1.id,
    aws_subnet.public_sub2.id
  ]

  security_groups = [aws_security_group.ec2_sg.id]
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "attach_ec2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.static_web.id
  port             = 80
}

