#Amazon linux 2 i t2.micro
resource "aws_instance" "test_ec2" {
  ami                    = "ami-0a261c0e5f51090b1" //eu-central-1
  instance_type          = "t2.micro"

#smestamo u nas subnet
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

#install apache i postgresql
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    yum install -y postgresql15
  EOF

  tags = {
    Name        = "test-ec2"
    Description = "Test instance"
    CostCenter  = "123456"
  }
}   