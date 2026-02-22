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
  subnet_id = local.private_subnet_id

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
  subnet_id = local.private_subnet_id

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


