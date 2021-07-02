output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "Public_Subnet_id" {
  value = "${aws_subnet.publicsubnets.id}"
}

output "Private_Subnet_id" {
  value = "${aws_subnet.privatesubnets.id}"
}