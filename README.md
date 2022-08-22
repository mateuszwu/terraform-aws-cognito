# AWS Cognito with Google Provider

A simple implementation of Google OAuth with AWS Cognito.

## Configuration

1. Set up Google OAuth: [AWS docs](https://aws.amazon.com/premiumsupport/knowledge-center/cognito-google-social-identity-provider), [Google docs](https://support.google.com/googleapi/answer/6158849#zippy=%2Cauthorized-domains%2Cservice-accounts)

2. Edit `locals` in `main.tf:1`

```Terraform
locals {
  app_name         = "example-selleo-app"
  callback_url     = "http://localhost:3000/users/auth/cognito_idp/callback"
  google_client_id = "XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com"
  google_secret    = "XXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```

3. Exec `terraform apply`

## Notes

- keep in mind that you need to align Google `Authorized JavaScript origins`, `Authorized redirect URIs` with Cognito Domain.
- [Rails example app](https://github.com/mateuszwu/rails-aws-cognito-example) to test setup - AWS Cognito + Google Provider.
