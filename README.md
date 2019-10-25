# sops-terraform-provider

Run through the following steps:

```
1. Install sops terraform provider https://github.com/carlpett/terraform-provider-sops/releases

2. Open the main.tf file and comment out lines 13-37.

3. Run:

terraform init
terraform apply --auto-approve

4. Run `sops --kms $(terraform output aws_kms_key.sops_key.arn) secrets.enc.yaml`
and create your secrets with the structure shown in the secrets.dec.yaml file

5. Uncomment lines 13-37.

6. Run:

terraform init
terraform plan
```

Never commit the `secrets.dec.*` files! They are included here only for demonstration purposes.
