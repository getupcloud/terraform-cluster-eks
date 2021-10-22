resource "aws_rds_cluster" "cluster_rds" {
  for_each                  = { for b in var.cluster_rds : try(b.cluster_identifier, "${b.cluster_identifier}") => b }
  cluster_identifier        = try(each.value.cluster_identifier)
  availability_zones        = try(each.value.availability_zones)
  database_name             = try(each.value.database_name)
  engine                    = try(each.value.engine)
  engine_version            = try(each.value.engine_version)
  master_username           = try(each.value.master_username)
  master_password           = try(each.value.master_password)
  backup_retention_period   = try(each.value.backup_retention_period)
  preferred_backup_window   = try(each.value.preferred_backup_window)
  final_snapshot_identifier = try(each.value.password, "true")
  skip_final_snapshot       = try(each.value.skip_final_snapshot, "true")
  vpc_security_group_ids    = try(each.value.vpc_security_group_ids)
  db_subnet_group_name      = try(each.value.db_subnet_group_name)
}
resource "aws_db_subnet_group" "db_subnet_group" {
  for_each   = { for b in var.db_subnet_group : try(b.name, "${b.name}") => b }
  name       = try(each.value.name)
  subnet_ids = try(each.value.subnet_ids)
}
resource "aws_rds_cluster_instance" "db_rds" {
  for_each            = { for b in var.db_rds : try(b.identifier, "${b.identifier}") => b }
  engine              = try(each.value.engine)
  cluster_identifier  = try(each.value.cluster_identifier)
  identifier          = try(each.value.identifier)
  availability_zone   = try(each.value.availability_zone)
  publicly_accessible = try(each.value.publicly_accessible)
  engine_version      = try(each.value.engine_version)
  instance_class      = try(each.value.instance_class)
  tags                = try(each.value.tags)

  depends_on = [
    aws_rds_cluster.cluster_rds
  ]
}