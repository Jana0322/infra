# # ---------------------------------------------------------------------------------------------------------------------
# # CREATES AN ALB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# # ---------------------------------------------------------------------------------------------------------------------
# resource "aws_lb" "app-ext-alb" {
#   name               = "${var.application_alb}"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.appalb-ext-sg.id]
#   subnets            = [var.public1_subnet, var.public2_subnet]
#   idle_timeout       = 600
# }

# # CREATE TARGET GROUP
# resource "aws_lb_target_group" "admin" {
#   name     = "${var.new}-tg"
#   port     = "80"
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#   health_check {
#     healthy_threshold   = "5"
#     unhealthy_threshold = "2"
#     timeout             = "5"
#     path                = "/api/admin/ping"
#     protocol            = "HTTP"
#     port                = "traffic-port"
#   }
# }

# resource "aws_lb_listener" "appalb_ext_lb_listener_80" {
#   load_balancer_arn = aws_lb.app-ext-alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "direct"

#     # redirect {
#     #   port        = "443"
#     #   protocol    = "HTTPS"
#     #   status_code = "HTTP_301"
#     # }
#   }
# }
# #------------------------------------------------------------------------------------------------------
# #CREATING AND ATTACHING EC2 RULES IN 443 LISTENER
# #-----------------------------------------------------------------------------------------------------
# resource "aws_lb_listener_rule" "game_engine_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.gameengine.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/game*"]
#    }
#   }
# }

# resource "aws_lb_listener_rule" "admin_service_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.admin.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/admin*"]
#     }
# }

# }

# resource "aws_lb_listener_rule" "blockchain_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.blockchain.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/blockchain*"]
#     }
#   }
# }

# #------------------------------------------------------------------------------------------------------
# #CREATING AND ATTACHING LAMBDA RULES IN 443 LISTENER
# #-----------------------------------------------------------------------------------------------------
# resource "aws_lb_listener_rule" "compute_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.compute-tg.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/compute*"]
#     }
#   }
# }

# resource "aws_lb_listener_rule" "application_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.application-tg.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/application*"]
#     }
#   }

# }

# resource "aws_lb_listener_rule" "profile_ext_lb_listener_443" {
#   listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.profile-tg.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api/profile*"]
#     }
#   }
# }


# #-------------------------------------------------------------------------
# #CREATING SG FOR LB
# #-------------------------------------------------------------------------
# resource "aws_security_group" "appalb-ext-sg" {
#   name        = "${var.env}-${var.application_alb}-sg"
#   description = "allow inbound http traffic"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "from my ip range"
#     from_port   = "443"
#     to_port     = "443"
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "from my ip range"
#     from_port   = "80"
#     to_port     = "80"
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = "0"
#     to_port     = "0"
#     protocol    = "-1" 
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     "Name" = "${var.env}-loadbalancer-sg"
#   }
# }


resource "aws_lb" "app-alb" {
  name               = var.application_alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.appalb-sg.id]
  subnets            = [var.public1_subnet, var.public2_subnet]
  idle_timeout       = 600
}

resource "aws_lb_listener" "appalb_http_listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  name     = "default-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/healthcheck"
    matcher             = "200"
  }
}

resource "aws_security_group" "appalb-sg" {
  name        = "${var.env}-app-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
