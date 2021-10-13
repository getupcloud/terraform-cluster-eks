# resource "aws_iam_policy" "policy_document" {
#     for_each      = { for b in var.policy_document : try(b.name, "${b.name}-${random_string.suffix.result}") => b}
#     name   = each.key
#     path   = "/"
#     policy = "${try(each.value.policy)}"
#     }

data "template_file" "policy" {
    for_each      = { for b in var.policy_document : try(b.name, "${b.name}-${random_string.suffix.result}") => b}
    template = "${file("${path.module}/policy.json.tpl")}"

    vars = {
        resource = "${try(each.value.resource)}"
    for_each = { for f in each.value.action : f.key => f }
        action = "${try(each.key)}"
    }
}

resource "aws_iam_policy" "policy_document" {
    for_each      = { for b in var.policy_document : try(b.name, "${b.name}-${random_string.suffix.result}") => b}
    name   = each.key
    policy = "${data.template_file.policy[each.key]}"
}