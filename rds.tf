resource "aws_rds_cluster" "cluster" {
  for_each                  = var.rds_cluster

  cluster_identifier        = try(each.value.cluster_identifier)
  availability_zones        = try(each.value.availability_zones)
  database_name             = try(each.value.database_name)
  engine                    = try(each.value.engine)
  engine_version            = try(each.value.engine_version)
  master_username           = try(each.value.master_username)
  master_password           = try(each.value.master_password)
  backup_retention_period   = try(each.value.backup_retention_period)
  preferred_backup_window   = try(each.value.preferred_backup_window)
  final_snapshot_identifier = try(each.value.final_snapshot_identifier, "final-snapshot-${each.value.cluster_identifier}")
  skip_final_snapshot       = try(each.value.skip_final_snapshot, true)
  vpc_security_group_ids    = try(each.value.vpc_security_group_ids)
  db_subnet_group_name      = try(each.value.db_subnet_group_name)
  tags                      = try(each.value.tags)
  deletion_protection       = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  for_each   = var.db_subnet_group

  name       = try(each.value.name)
  subnet_ids = try(each.value.subnet_ids)
  tags       = try(each.value.tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_rds_cluster_instance" "db_rds" {
  for_each            =  b in var.db_rds : try(b.identifier, "${b.identifier}") => b }
  engine              = try(each.value.engine)
  cluster_identifier  = try(each.value.cluster_identifier)
  identifier          = try(each.value.identifier)
  availability_zone   = try(each.value.availability_zone)
  publicly_accessible = try(each.value.publicly_accessible)
  engine_version      = try(each.value.engine_version)
  instance_class      = try(each.value.instance_class)
  tags                = try(each.value.tags)

  lifecycle {
    prevent_destroy = true
  }
}
