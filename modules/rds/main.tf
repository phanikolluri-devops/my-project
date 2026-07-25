terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.3.0"
    }
  }
}

resource "aws_db_parameter_group" "main" {
  name = "wmp-demo-${var.env}"
  family      = "postgres16"
}

resource "aws_db_subnet_group" "main" {
  name       = "wmp-demo-${var.env}"
  subnet_ids = var.subnets

  tags = {
    Name = "wmp-demo-${var.env}"
  }
}

resource "aws_security_group" "main" {
  name = "wmp-demo-sg-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wmp-demo-sg-${var.env}"
  }
}

resource "aws_db_instance" "main" {
  identifier = "wmp-demo-${var.env}"
  parameter_group_name = aws_db_parameter_group.main.name
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
  allocated_storage    = var.allocated_storage
  db_name              = "wmp_demo"
  engine               = "postgres"
  engine_version       = "16.13"
  instance_class       = "db.t3.micro"
  username             = "wmpuser"
  password             = "WmpUser#1234"
  skip_final_snapshot  = true
}

resource "null_resource" "schema_load" {
  depends_on = [aws_db_instance.main]
  provisioner "local-exec" {
    command = <<EOF
curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
PGPASSWORD='WmpUser#1234' /usr/pgsql-16/bin/psql  'host=${aws_db_instance.main.address} port=5432 dbname=wmp_demo user=wmpuser sslmode=verify-full sslrootcert=./global-bundle.pem' <${path.module}/setup.sql
EOF
  }
}
    



