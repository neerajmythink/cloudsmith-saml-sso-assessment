# Configure the Cloudsmith provider and create repositories, teams, service accounts, privileges, Geo/IP rules, and vulnerability policies as per the requirements.
terraform {
  required_providers {
    cloudsmith = {
      source  = "cloudsmith-io/cloudsmith"
      version = "0.0.68"
    }
  }
}

# Configure the Cloudsmith provider with the API key
provider "cloudsmith" {
  api_key = var.cloudsmith_api_key
}

resource "cloudsmith_saml_auth" "my_saml_auth" {
  organization       = var.organization
  saml_auth_enabled  = true
  saml_auth_enforced = false

  # Use either saml_metadata_url OR saml_metadata_inline
  saml_metadata_url = var.saml_metadata_url
}

resource "cloudsmith_saml" "my_saml" {
  organization = var.organization
  idp_key      = "groups"
  idp_value    = "cloudsmith_user"
  role         = "Member"
  team         = "cloudsmith-user"
}
