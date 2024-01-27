resource "aws_instance" "engineering_server" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id

  tags = {
    Name       = "Eng03",
    Department = "Engineering"
  }
}
resource "aws_instance" "security_server" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  tags = {
    Name       = "Security44",
    Department = "Security"
  }
}
