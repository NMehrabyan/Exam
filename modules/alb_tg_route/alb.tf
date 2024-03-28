resource "aws_lb" "alb" {
  name               = "Narine-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.my_sub1.id, aws_subnet.my_sub2.id]
}

resource "aws_lb_target_group" "s3_target_group" {
  name        = "Nar-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "ip"
   health_check {
    port        =  80         
    protocol    = "HTTP"      
    path        = "/"          
    timeout     = 5            
    interval    = 30           
    healthy_threshold = 2      
    unhealthy_threshold = 2  
    
  }
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.s3_target_group.arn 
  }
}




# Attach the target group to the ALB
resource "aws_lb_target_group_attachment" "s3_target_attachment" {
  target_group_arn = aws_lb_target_group.s3_target_group.arn
target_id        = "10.0.0.10"
}
