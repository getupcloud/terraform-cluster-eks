#data "tls_certificate" "oidc_idp" {
#  url = module.cluster.cluster_oidc_issuer_url
#}
#
#resource "aws_iam_openid_connect_provider" "oidc" {
#  url             = module.cluster.cluster_oidc_issuer_url
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.oidc_idp.certificates.0.sha1_fingerprint]
#}
