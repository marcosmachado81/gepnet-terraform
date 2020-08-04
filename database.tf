resource "aws_db_instance" "gepnetdb" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.6"
  instance_class       = "db.t2.micro"
  name                 = var.database_name
  username             = var.database_username
  password             =  length(var.database_password) > 0  ? var.database_password : data.aws_ssm_parameter.db_gepnet_exists[0].value
  //db_subnet_group_name =  "subnet-0b51f80a62146c08b"
  //vpc_security_group_ids = [ aws_security_group.SG_DB.id ]
  db_subnet_group_name   = aws_db_subnet_group.rds-private-subnet.id
  vpc_security_group_ids = [aws_security_group.SG_DB.id]
  publicly_accessible    = false
  #CAUTION : For production proposal set to false (run destroy without a snapshot identifier causes error and avoid lost data )
  skip_final_snapshot = true

  tags = merge({
    Name= "GepNet Database"
  },local.CommonTags)
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-gepnet-subnet"
  subnet_ids = [ aws_subnet.db.id, aws_subnet.db2.id ]
  tags = merge({
     Name         = "rds-gepnet-subnet"
  },local.CommonTags)
}

resource "aws_security_group" "SG_DB" {
  name = "gepnet_database_sg"
  description = "RDS Security Group for GepNet (terraform-managed)"
  vpc_id = aws_vpc.main.id
  # Only PostgreSQL in
  ingress {
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = [ aws_vpc.main.cidr_block ]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({
    Name = "gepnet_database_sg"
    },local.CommonTags)
}

data "aws_ssm_parameter" "db_gepnet_exists" {
   name = "/gepnet/${local.environment}/database/password/master"
   count = length(var.database_password) > 0 ? 0 : 1
}
#
 resource "aws_ssm_parameter" "db_secret" {
   //check if there is a value in data.aws_ssm_parameter.db_gepnet_exists or it's necessary update the value
   //count       = length(data.aws_ssm_parameter.db_gepnet_exists.value) > 0 && var.overwrite == true ? 0 : 1
   //run only overwrite parameter is true.
   count       = length(var.database_password) > 0 ? 1 : 0
   name        = "/gepnet/${local.environment}/database/password/master"
   description = "Password for gepnet database"
   type        = "SecureString"
   overwrite   = true
   value       = var.database_password
   tags = local.CommonTags
 }
