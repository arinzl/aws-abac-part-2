output "vpc-id" {
  value = aws_vpc.main.id
}

output "subnet-ids" {
  value = aws_subnet.private[*].id
}
