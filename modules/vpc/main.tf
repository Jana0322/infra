#vpc creation
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name_env}-vpc"
  }
}
#internet gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name_env}-igw"
  }
}

#creation of routing table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name_env}-publicsubnet-rt"
  }
}

#creation of public subnet1
resource "aws_subnet" "public1_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public1_subnet_cidr
  availability_zone       = "ap-south-1a"  
  map_public_ip_on_launch = true
   
  tags = {
    Name = "${var.project_name_env}-publicsubnet1"
  }
}

resource "aws_subnet" "public2_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public2_subnet_cidr
  availability_zone       = "ap-south-1b"  
  map_public_ip_on_launch = true
   
  tags = {
    Name = "${var.project_name_env}-publicsubnet2"
  }
}

#creation of private subnet1
resource "aws_subnet" "private1_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private1_subnet_cidr
  availability_zone       = "ap-south-1a"  
  # Associate this subnet with the shared route table
  
  tags = {
    Name = "${var.project_name_env}-privatesubnet1"
  }
}

resource "aws_subnet" "private2_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private2_subnet_cidr
  availability_zone       = "ap-south-1b"  
  # Associate this subnet with the shared route table
  
  tags = {
    Name = "${var.project_name_env}-privatesubnet2"
  }
}

#routing table association for public subnet1
resource "aws_route_table_association" "public1_association" {
  subnet_id      = aws_subnet.public1_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_association" {
  subnet_id      = aws_subnet.public2_subnet.id
  route_table_id = aws_route_table.public.id
}


#elastic ip for nat gateway
resource "aws_eip" "nat_ip" {

  tags = {
    Name = "${var.project_name_env}-eip"
  } 
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public1_subnet.id
  depends_on    = [aws_internet_gateway.igw]
  
  tags = {
    Name = "${var.project_name_env}-natgw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.project_name_env}-privatesubnet-rt"
  }
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private1_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2_subnet.id
  route_table_id = aws_route_table.private.id
}

# resource "aws_security_group" "sg" {
#   description = "Allow inbound traffic"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = var.cidr_block
#   } 

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# tags = {
#     name = "${var.project_name_env}-sg"
#   }

# }
