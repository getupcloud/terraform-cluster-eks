resource "aws_db_instance" "db" {
    for_each      = { for b in var.db_rds : try(b.name, "${b.name_prefix}-${var.name}-${random_string.suffix.result}") => b }
    allocated_storage     = try(each.value.allocated_storage)
    max_allocated_storage = try(each.value.max_allocated_storage)
    engine               = try(each.value.engine)
    engine_version       = try(each.value.engine_version)
    instance_class       = try(each.value.instance_class)
    username             = try(each.value.username)
    password             = try(each.value.password)
    parameter_group_name = try(each.value.parameter_group_name)
    skip_final_snapshot  = try(each.value.skip_final_snapshot, "true")
    name = each.key
    tags   = try(each.value.tags)
}
