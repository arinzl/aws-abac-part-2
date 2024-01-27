locals {
  permission_sets = {

    "ABACdemo" : {
      "description" : "ABAC blog demo"
      "managed_policies" : []
      "inline_policies" : [
        {
          Sid    = "AllowAccountPrinciplesToRead"
          Effect = "Allow"
          Action = [
            "ec2:DescribeInstances",
            "ec2:DescribeImages",
            "ec2:DescribeTags",
            "ec2:DescribeSnapshots"
          ]
          Resource = "*"
        },
        {
          Sid    = "PrincipalTagManagement"
          Effect = "Allow"
          Action = [
            "ec2:startInstances",
            "ec2:stopInstances"
          ]
          Resource = "*"


          Condition = {
            "StringEquals" = {
              "aws:ResourceTag/Department" = "$${aws:PrincipalTag/AzureDepartment}"
            }
          }

        }
      ]
    }
  }
}


resource "aws_ssoadmin_permission_set" "this" {
  for_each         = local.permission_sets
  instance_arn     = local.sso_instance_arn
  name             = each.key
  description      = each.value.description
  session_duration = lookup(each.value, "session_duration", "PT8H")
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = merge([
    for k, v in local.permission_sets : {
      for i, p in v.managed_policies : "${k}_${i}" => {
        set    = k
        policy = p
      } if p != ""
    } if lookup(v, "managed_policies", null) != null
  ]...)
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = each.value.policy
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.set].arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each           = { for k, v in local.permission_sets : k => v if length(lookup(v, "inline_policies", [])) > 0 }
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [for p in each.value.inline_policies :
      merge({
        Sid    = p.Sid
        Effect = p.Effect
        Action = p.Action
        },
        lookup(p, "Resource", null) != null ? { Resource = p.Resource } : {},
        lookup(p, "NotResource", null) != null ? { NotResource = p.NotResource } : {},
      lookup(p, "Condition", null) != null ? { Condition = p.Condition } : {})
    ]
  })
}



