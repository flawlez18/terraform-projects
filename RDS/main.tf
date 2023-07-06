resource "aws_rds_cluster_instance" "cluster_instance" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.demo.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.demo.engine
  engine_version     = aws_rds_cluster.demo.engine_version
}

resource "aws_rds_cluster" "demo" {
  cluster_identifier = "aurora-cluster-demo"
  engine             = "aurora-mysql"
  engine_version     = "5.7.mysql_aurora.2.10.2"
  #availability_zones = ["us-west-1"]
  database_name          = "mydb"
  master_username        = "admin"
  master_password        = "admin123"
  vpc_security_group_ids = ["sg-003566a47b586d4fa"]
  skip_final_snapshot    = "true"

}


