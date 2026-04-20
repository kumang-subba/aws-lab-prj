data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  owners = ["099720109477"]
}
resource "aws_key_pair" "ec2dev-key" {
  key_name   = "dev-key"
  public_key = file("dev-key.pub")
}

resource "aws_lb" "web_lb" {
  name                       = "web-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = [for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

}

resource "aws_launch_template" "web" {
  name_prefix            = "web-template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2dev-key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = base64encode(file("Userdata.sh"))
  iam_instance_profile {
    name = data.aws_iam_instance_profile.LabInstanceProfile.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/"
    port = "80"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]

  target_group_arns = [aws_lb_target_group.web_tg.arn]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_scale" {
  name                   = "cpu-scale"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 50.0
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}

output "loadbalancer_url" {
  value = aws_lb.web_lb.dns_name
}
