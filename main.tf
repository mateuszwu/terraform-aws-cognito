locals {
  app_name         = "example-selleo-app"
  callback_url     = "http://localhost:3000/users/auth/cognito_idp/callback"
  google_client_id = "XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com"
  google_secret    = "XXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

resource "aws_cognito_user_pool" "this" {
  name = local.app_name

  username_attributes = ["email"]
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes              = "profile email openid"
    client_id                     = local.google_client_id
    client_secret                 = local.google_secret
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = "true"
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email       = "email"
    username    = "sub"
    family_name = "family_name"
    given_name  = "given_name"
    picture     = "picture"
  }
}

resource "aws_cognito_user_pool_client" "this" {
  depends_on = [aws_cognito_identity_provider.google]
  name       = local.app_name

  callback_urls                        = [local.callback_url]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["Google", "COGNITO"]
  user_pool_id                         = aws_cognito_user_pool.this.id
  generate_secret                      = true
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = local.app_name
  user_pool_id = aws_cognito_user_pool.this.id
}

data "aws_region" "current" {}

