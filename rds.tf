resource "aws_db_instance" "db_rds" {
    for_each      = { for b in var.db_rds : try(b.name, "${b.name_prefix}-${var.name}-${random_string.suffix.result}") => b }
    engine               = try(each.value.engine)
    engine_version       = try(each.value.engine_version)
    instance_class       = try(each.value.instance_class)
    username             = try(each.value.username)
    password             = try(each.value.password)
    skip_final_snapshot  = try(each.value.skip_final_snapshot, "true")
    vpc_security_group_ids = try(each.value.vpc_security_group_ids)
    iam_database_authentication_enabled = try(each.value.iam_database_authentication_enabled, "true")
    name = each.key
    identifier = try(each.value.identifier)
    tags   = try(each.value.tags)
}