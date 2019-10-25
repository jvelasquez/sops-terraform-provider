data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_kms_key" "sops_key" {
  description             = "KMS Key for sops"
  deletion_window_in_days = 7
}

output "aws_kms_key_arn" {
  value = aws_kms_key.sops_key.arn
}

locals {
  secrets = [
    "dev/1webapp/oauth_token",
    "prod/1webapp/oauth_token",
  ]
}

resource "aws_secretsmanager_secret" "secrets" {
  for_each                = toset(local.secrets)
  name                    = each.key
  description             = data.sops_file.secrets.data["${each.key}.description"]
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each      = toset(local.secrets)
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = data.sops_file.secrets.data["${each.key}.value"]
}
