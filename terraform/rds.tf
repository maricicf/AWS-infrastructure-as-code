# rds nije podrzan u localstacu preko kojeg sam poceo kao alternativa za aws koji se naplacivao
# pa sam za lokalno testiranje koristio dokcer (postgesql image) a terraform fajl ostavio kao referencu za pravu aws infrastrukturu
 # Subnet Group 
# resource "aws_db_subnet_group" "main" {
#   name       = "main-db-subnet-group"
#   subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

#   tags = {
#     Name       = "main-db-subnet-group"
#     CostCenter = "123456"
#   }
# }

# # RDS PostgreSQL instanca
# resource "aws_db_instance" "postgres" {
#   identifier        = "postgres-db"
#   engine            = "postgres"
#   engine_version    = "15.4"
#   instance_class    = "db.t3.micro"
#   allocated_storage = 20

# //promeniti posle na pravu bazu
#   db_name  = "mydb"
#   username = "dbadmin"
#   password = "dbpassword123"

#   # Multi-AZ konfiguracija
#   multi_az = true

#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [aws_security_group.rds.id]

#   skip_final_snapshot = true

#   tags = {
#     Name       = "postgres-db"
#     CostCenter = "123456"
#   }
# }