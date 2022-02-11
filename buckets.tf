resource "aws_s3_bucket" "buckets" {
  for_each = { for b in var.s3_buckets : try(b.name, "${b.name_prefix}-${var.cluster_name}-${random_string.suffix.result}") => b }

  bucket = each.key
  tags   = try(each.value.tags)
}

resource "aws_s3_bucket_acl" "buckets_acl" {
  bucket = aws_s3_bucket.buckets.id
  acl    = "private"
}