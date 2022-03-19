resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "<user-name>"
  password             = "<pwd-here.
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
