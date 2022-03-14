terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    awscreds = {
      source  = "terraform.scrtybybscrty.org/armorfret/awscreds"
      version = "~> 0.3"
    }
  }
}

locals {
  server_users = toset(formatlist("%s-%s", var.prefix, var.servers))
}

data "aws_iam_policy_document" "path_permissions" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.vault_bucket}/private/$${aws:username}}/*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.vault_bucket}/public/*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.vault_bucket}"
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "public/*",
        "private/$${aws:username}}/*"
      ]
    }
  }
}

resource "aws_s3_bucket" "vault" {
  bucket = var.vault_bucket
}

resource "aws_s3_bucket_versioning" "vault" {
  bucket = aws_s3_bucket.vault.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "vault" {
  bucket = aws_s3_bucket.vault.id

  target_bucket = var.logging_bucket
  target_prefix = "${var.vault_bucket}/"
}

resource "aws_iam_user_policy" "servers" {
  for_each = local.server_users
  user     = each.key
  name     = "s3-path-permissions"
  policy   = data.aws_iam_policy_document.path_permissions.json
}

resource "awscreds_iam_access_key" "servers" {
  for_each = local.server_users
  user     = each.key
  file     = "creds/${each.key}"
}

resource "aws_iam_user" "servers" {
  for_each = local.server_users
  name     = each.key
}
