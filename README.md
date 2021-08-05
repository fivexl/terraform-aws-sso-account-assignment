# terraform-aws-sso-account-assignment
Module for create Account assignments in SSO
## Example
```hcl

locals {

  permission_set = {
    "AdministratorAccess" = {
      "description"   = "Provides account admin access"
      "duration"      = "PT8H"
      "policy_arns"   = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      "inline_policy" = ""
    }
  }

  accounts = {
    "MyAccount1" = {
      "email" = "MyAccount1@Example.com", "parent" = aws_organizations_organization.org.roots[0].id,
      assignments = {
        "MyGroup" = ["AdministratorAccess"]
      }
    }
  }

}

module "account_assignments" {
  for_each    = local.accounts
  source      = "./modules/sso_account_assignment"
  account_id  = aws_organizations_account.member[each.key].id
  assignments = each.value.assignments
}

```
