locals {
  assignments = flatten(
    [for group in keys(var.assignments) : [
      for permission in var.assignments[group] : {
        permission_set = permission
        sso_group      = group
      }
      ]
    ]
  )
  assignments_set = { for item in local.assignments : "${item.sso_group}_${item.permission_set}" => { sso_group = item.sso_group, permission_set = item.permission_set } }
  permission_sets = keys(transpose(var.assignments)) // get permission_sets from assignments as keys
  sso_groups      = keys(var.assignments)            // get sso_groups from assignments as keys
}


resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = local.assignments_set
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.this[each.value.permission_set].arn

  principal_id   = data.aws_identitystore_group.this[each.value.sso_group].group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}

