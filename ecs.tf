# Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "ecs-example"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  container_definitions    = <<EOL
[
  {
    "name": "nginx",
    "image": "nginx:1.14",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOL
}

resource "aws_ecs_cluster" "main" {
  name = "ecs-example"
}

# load balancer service
resource "aws_lb_target_group" "main" {
  name        = "ecs-example"
  vpc_id      = "${aws_vpc.default.id}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    port = 80
    path = "/"
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = "${aws_lb_listener.main.arn}"

  action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# ecs service
resource "aws_security_group" "ecs" {
  name  = "ecs-example"
  description = "ecs example"

  vpc_id = "${aws_vpc.default.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-example"
  }
}

resource "aws_security_group_rule" "ecs" {
  security_group_id = "${aws_security_group.ecs.id}"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["10.32.0.0/16"]
}

resource "aws_ecs_service" "main" {
  name = "ecs-example"
  depends_on = [aws_lb_listener_rule.main]
  cluster = "${aws_ecs_cluster.main.name}"
  launch_type = "FARGATE"
  desired_count = "1"
  task_definition = "${aws_ecs_task_definition.main.arn}"

  network_configuration  {
    subnets = ["${aws_subnet.private_1a.id}", "${aws_subnet.private_1b.id}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.main.arn}"
    container_name   = "nginx"
    container_port   = "80"
  }
}
