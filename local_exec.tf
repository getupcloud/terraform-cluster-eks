resource "null_resource" "local_exec" {
for_each = { for b in var.local_exec : try(b.command, "${b.command}") => b}
triggers = {
    always_run = timestamp()
}
provisioner "local-exec" {
    on_failure  = fail
    when = create
    interpreter = ["/bin/bash", "-c"]
    command     = try(each.value.command)
}

depends_on = ["module.eks.module.cluster.module.node_groups.aws_eks_node_group.workers"]

}
