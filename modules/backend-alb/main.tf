resource "aws_lb" "backend-alb" {
  name               = "${var.project}-${var.env}-backend-alb" #roboshop-dev-backend-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = data.aws_ssm_parameter.backend-alb_sg_id.value
  subnets    = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

 #enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

#backend alb listening on port number 80
resource "aws_lb_listener" "backend_lsitener" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"
 
   default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "hi"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "backend_alb" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "*.backend-alb-dev.saidevops.site"
  type    = "A"
 
  alias {
    name = aws_lb.backend-alb.dns_name
    zone_id = aws_lb.backend-alb.zone_id
    evaluate_target_health = true
  }


}