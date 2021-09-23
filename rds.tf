resource "aws_rds_cluster" "cluster_rds" {
    for_each      = { for b in var.cluster_rds : try(b.name, "${var.name}-${random_string.suffix.result}") => b}
    cluster_identifier      = try(each.value.cluster_identifier)
    availability_zones      = try(each.value.availability_zones)
    database_name           = try(each.value.database_name )
    master_username         = try(each.value.master_username)
    master_password         = try(each.value.master_password)
    backup_retention_period = try(each.value.backup_retention_period)
    preferred_backup_window = try(each.value.preferred_backup_window)
    }
resource "aws_db_instance" "db_rds" {
    for_each      = { for b in var.db_rds : try(b.name, "${b.name_prefix}-${var.name}-${random_string.suffix.result}") => b }
    engine               = try(each.value.engine)
    identifier           = try(each.value.identifier)
    allocated_storage    = try(each.value.allocated_storage)
    engine_version       = try(each.value.engine_version)
    instance_class       = try(each.value.instance_class)
    username             = try(each.value.username)
    password             = try(each.value.password)
    skip_final_snapshot  = try(each.value.skip_final_snapshot, "true")
    vpc_security_group_ids = try(each.value.vpc_security_group_ids)
    iam_database_authentication_enabled = try(each.value.iam_database_authentication_enabled, "true")
    name = each.key
    tags   = try(each.value.tags)
}