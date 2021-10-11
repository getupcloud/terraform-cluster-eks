resource "aws_iam_policy" "policy_document" {
    for_each      = { for b in var.policy_document : try(b.name, "${b.name}-${random_string.suffix.result}") => b}
    name   = each.key
    path   = "/"
    policy = "${try(each.value.policy)}"
    }