#SG for public facing ALB - allow HTTP and HTTPS inbound, all outbound
resource "aws_security_group" "public_alb" {
  name        = "${var.environment}-${var.project}-public-alb"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.environment}-${var.project}-public-alb-sg" },
    var.tags
  )
}

#SG for Bastion Host - allow SSH from anywhere, all outbound
resource "aws_security_group" "bastion" {
  name        = "${var.environment}-${var.project}-bastion"
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.environment}-${var.project}-bastion-sg" },
    var.tags
  )
}

#SG FOR frontend Appservers - allow inbound from public ALB SG, all outbound
resource "aws_security_group" "frontend" {
  name        = "${var.environment}-${var.project}-frontend-appservers"
  description = "Security group for frontend Appservers"
  vpc_id      = var.vpc_id      

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb.id]
  }

   ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.environment}-${var.project}-frontend-appservers-sg" },
    var.tags
  )
}

#SG for internal ALB - allow inbound from frontend Appservers SG, all outbound
resource "aws_security_group" "internal_alb" {
  name        = "${var.environment}-${var.project}-internal-alb"
  description = "Security group for internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = merge(
        { Name = "${var.environment}-${var.project}-internal-alb-sg" },
        var.tags
    )
}

#SG for backend Appservers - allow inbound from internal ALB SG, all outbound
resource "aws_security_group" "backend" {
  name        = "${var.environment}-${var.project}-backend-appservers"
  description = "Security group for backend Appservers"
  vpc_id      = var.vpc_id  
    ingress {
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp"
        security_groups = [aws_security_group.internal_alb.id]
    }  
    ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  } 

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = merge(
        { Name = "${var.environment}-${var.project}-backend-appservers-sg" },
        var.tags
    )
}

#SG for RDS - allow inbound from backend Appservers SG, no outbound
resource "aws_security_group" "rds" {
  name        = "${var.environment}-${var.project}-rds"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id  

    ingress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.backend.id]
    }  

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = []     
    }
    tags = merge(
        { Name = "${var.environment}-${var.project}-rds-sg" },
        var.tags
    )
}