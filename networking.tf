# Creation of VPC 
resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}" # Defining the CIDR block use 10.0.0.0/24 
  instance_tenancy = "${var.tenancy}" 

  tags = {
    Name = "main-vpc"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" { 
  vpc_id = aws_vpc.main.id  # vpc_id will be generated after we careated VPC and assigned to internet gateway
}

# Create Public Subnets 
resource "aws_subnet" "publicsubnets" {
  vpc_id     =  aws_vpc.main.id
  cidr_block = "${var.publicsubnet_cidr}"
}

#Creating Private Subnets
resource "aws_subnet" "privatesubnets" {
  vpc_id     =  aws_vpc.main.id
  cidr_block = "${var.privateubnet_cidr}"
}

# Route Table for Public Subnets
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0" # Traffic from public subnet reaches internet via internet gateway
  } 
}

# Route Table for Private Subnets
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id # NAT gateway crated in below content
  } 
}

# Route Table Association with Public Subnet's
resource "aws_route_table_association" "publicrtassociation" {
  subnet_id = aws_subnet.publicsubnets.id
  route_table_id = aws_route_table.publicrt.id
}

# Route Table Association with Private Subnet's
resource "aws_route_table_association" "privatertassociation" {
  subnet_id = aws_subnet.privatesubnets.id
  route_table_id = aws_route_table.privatert.id
}

# Creating Elastic IP for VPC
resource "aws_eip" "nateIP" {
  vpc = true
}

# Creating the NAT Gateway using subnet_id and allocaiton_id
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id = aws_subnet.publicsubnets.id
}