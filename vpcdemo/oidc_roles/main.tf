

resource "aws_iam_role" "oidc_example_readonly" {
  name                 = var.readonly_role_name
  max_session_duration = var.max_session_duration
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repo}:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "readonly_policy_attachment" {
  role       = aws_iam_role.oidc_example_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role" "oidc_example_write" {
  name                 = var.write_role_name
  max_session_duration = var.max_session_duration
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "write_policy_attachment" {
  role       = aws_iam_role.oidc_example_write.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "oidc_example_state" {
  name                 = var.state_role_name
  max_session_duration = var.max_session_duration
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "state_policy" {
  name        = "oidc-example-state-kms-policy"
  description = "Policy for access for state management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "state_policy_attachment" {
  role       = aws_iam_role.oidc_example_state.name
  policy_arn = aws_iam_policy.state_policy.arn
}

output "readonly_role_arn" {
  value = aws_iam_role.oidc_example_readonly.arn
}

output "write_role_arn" {
  value = aws_iam_role.oidc_example_write.arn
}