resource "aws_s3_bucket" "buckets" {
  for_each = { for b in var.s3_buckets : try(b.name, "${b.name_prefix}-${var.name}-${random_string.suffix.result}") => b }

  bucket = each.key
  acl    = try(each.value.acl, "private")
  tags   = try(each.value.tags)
}