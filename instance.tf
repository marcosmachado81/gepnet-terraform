data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners      = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "web_gpnet" {
  count         = 1
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [ aws_security_group.SG-WebServer.id ]
  key_name = var.access_key
  user_data = templatefile("gepnet_deploy.tpl",{
                          DB_HOST = aws_db_instance.gepnetdb.address,
                          DB_USER = var.database_username,
                          DB_PASSWORD = aws_db_instance.gepnetdb.password, //length(var.database_password) > 0  ? var.database_password : data.aws_ssm_parameter.db_gepnet_exists[0].value,
                          DB_NAME = var.database_name,
                          GEPNET_REPOSITORY = var.gepnet_repository
                          })

  depends_on = [ aws_db_instance.gepnetdb ]

  tags = merge({
    Name = "GPNET Web"
  },local.CommonTags)
}

resource "aws_security_group" "SG-WebServer" {
  name        = "gepnet_web_sg"
  description = "Allow HTTP(S) inbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = merge({
    Name = "gepnet_web_sg"
    },local.CommonTags)

}
