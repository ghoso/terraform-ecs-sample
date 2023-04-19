resource "aws_security_group" "alb" {
  name = "ecs-example-alb"
  description = "ecs example alb"
  vpc_id      = "${aws_vpc.default.id}"

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-example-alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = "${aws_security_group.alb.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "ecs-example"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${aws_subnet.public_1a.id}", "${aws_subnet.public_1b.id}"]
}

resource "aws_lb_listener" "main" {
  port  = "80"
  protocol  = "HTTP"
  load_balancer_arn = "${aws_lb.main.arn}"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}
