resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.bastion_sg_id ]
  subnet_id = local.public_subnet_id
  user_data = file("${path.module}/bastion.sh")

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-bastion"
  }
}

resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.mongodb_sg_id ]
  subnet_id = local.private_subnet_id

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-mongodb"
  }
}

resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
        type = "ssh"
        user = "ec2_user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh"
        ]
    }
}
#--------------------------------------------------------------
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.redis_sg_id ]
  subnet_id = local.database_subnet_id

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-redis"
  }
}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
        type = "ssh"
        user = "ec2_user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh"
        ]
    }
}

#-----------------------------------------------------
resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.rabbitmq_sg_id ]
  subnet_id = local.database_subnet_id

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-rabbitmq"
  }
}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection {
        type = "ssh"
        user = "ec2_user"
        password = "DevOps321"
        host = aws_instance.rabbitmq.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh"
        ]
    }
}
#----------------------------------------------------------
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.mysql_sg_id ]
  subnet_id = local.database_subnet_id
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-mysql"
  }
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParameterRead"
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
        type = "ssh"
        user = "ec2_user"
        password = "DevOps321"
        host = aws_instance.mysql.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql dev"
        ]
    }
}
#------------------------------------------------------
resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.catalogue_sg_id ]
  subnet_id = local.private_subnet_id
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = {
    Terraform = true
    Name = "${var.project}-${var.env}-mysql"
  }
}

resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]

    connection {
        type = "ssh"
        user = "ec2_user"
        password = "DevOps321"
        host = aws_instance.catalogue.private_ip
    }
    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/catalogue.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh catalogue ${var.env}"
        ]
    }
}
#----------------------
resource "aws_route53_record" "mongodb" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "mongodb-dev.saidevops.site"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_route53_record" "redis" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "redis-dev.saidevops.site"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "rabbitmq-dev.saidevops.site"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
}

resource "aws_route53_record" "mysql" {
  zone_id = "Z06083563MQUI4X3GPRCP"
  name    = "mysql-dev.saidevops.site"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
}

resource "aws_ec2_instance_state" "stopmycatalogue" {
    instance_id  = aws_instance.catalogue.id
    state = "stopped" 
    depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "example" {
  name               = "roboshop-dev-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.stopmycatalogue ]
}

resource "aws_lb_target_group" "catalogue" {
  name     = "roboshop-dev-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id
  deregistration_delay = 60
  health_check {
    healthy_threshold =2 
    interval =19
    matcher = "200-299"
    path = "/health"
    port =  8080
    protocol = "HTTP"
    timeout  = 2
    unhealthy_threshold = 2

  }
}

#--------------------------------------------------

resource "aws_launch_template" "catalogue" {
  name = "roboshop-dev-catalogue"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  iam_instance_profile {
    name = "test"
  }

  image_id = "ami-test"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"

  kernel_id = "test"

  key_name = "test"

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_performance_options {
    bandwidth_weighting = "vpc-1"
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  ram_disk_id = "test"

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}