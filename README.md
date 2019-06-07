# SOLIDSRC Website

Terraform project to host SOLIDSRC website on AWS S3.

1. Apply `terraform_certificate` to generate an TLS certificate in us-east-1, required by Cloud Front.
2. Apply `terraform`, specifying the certificate ARN in the variables.
