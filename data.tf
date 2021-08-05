data "aws_ssoadmin_instances" "this" {}

data "aws_ssoadmin_permission_set" "this" {
  for_each     = toset(local.permission_sets)
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = each.value
}

data "aws_identitystore_group" "this" {
  for_each          = toset(local.sso_groups)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.value
  }
}