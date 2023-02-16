
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 3.0"
    }
  }
}
# Configure the AWS providers 
provider "aws" {
    region = "us-east-1"
   
}
 /*terraform {
    backend "s3" {
        bucket ="ikataba"
        key = "path/terraform.tfstate"
        dynamodb_table = "keita-dtable"
      
    }
  
}*/

# 1- Create a vpc
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block[0]
}
# 2- Create public subnet
resource "aws_subnet" "CICD_Pub_Sub_A" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.cidr_block[1]
    tags = {
      "Name" = "CICD_PUb_Sub_A"
    }
  
}
resource "aws_internet_gateway" "MyCICD-IGW" {
    vpc_id = aws_vpc.main.id
    tags = {
      "Name" = "myCICD-IGW"
    }
  
}
resource "aws_security_group" "myCICD-SG" {
    name        = "allow_tls"
  description = "Allow trafic outside my VPC"
  vpc_id      = aws_vpc.main.id

    
  dynamic ingress {
    iterator = port
    for_each = var.ports
     content {
       from_port        = port.value
       to_port          = port.value
       protocol         = "tcp"
       cidr_blocks      = ["0.0.0.0/0"]
       
     }
   
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "CICD-SG"
  }
}
#Create a route table and association
resource "aws_route_table" "CICD-RT" {
  vpc_id = aws_vpc.main.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyCICD-IGW.id
    
  
}
}
# Route table association
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.CICD_Pub_Sub_A.id
    route_table_id = aws_route_table.CICD-RT.id
  
}
#create an ec2 instance
resource "aws_instance" "Devops-Group" {
  #amazom linux machine
  ami           = var.ami[1]
  instance_type = var.instance
  key_name = "i2bk"
  vpc_security_group_ids = [aws_security_group.myCICD-SG.id]
  subnet_id = aws_subnet.CICD_Pub_Sub_A.id
  associate_public_ip_address = true
 user_data = file("./index.sh")
  tags={
    Name ="Devops-Group-"
  }
}