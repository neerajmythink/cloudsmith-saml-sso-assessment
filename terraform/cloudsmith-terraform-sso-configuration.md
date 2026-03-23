# **User Guide: Configuring Cloudsmith SAML and Access Controls with Terraform**

## **Overview**

This guide explains how to configure SAML authentication and group-based access control in Cloudsmith using Terraform. It enables Single Sign-On (SSO) and automatic team assignment based on group membership from an identity provider such as Okta.

---

## **Prerequisites**

Before proceeding, ensure you have:

* A Cloudsmith organization (namespace)
* A valid Cloudsmith API key
* Terraform installed and configured
* An identity provider (e.g., Okta) with SAML setup
* SAML metadata (URL or XML) from your IdP

---

## **1. Configure the Cloudsmith Provider**

Set up the Cloudsmith provider in Terraform and authenticate using your API key.

📌 *Reference:* Provider configuration block in your Terraform file.

---

## **2. Enable SAML Authentication**

Enable SAML-based authentication for your Cloudsmith organization.

* Turn on SAML authentication
* Decide whether to enforce SAML-only login or allow mixed authentication
* Provide SAML metadata from your identity provider

📌 *Reference:* `cloudsmith_saml_auth` resource

### **Metadata Options**

You can configure SAML using either:

* **Metadata URL (Recommended)**  
    Dynamic configuration fetched from your IdP

* **Metadata XML (Optional)**  
    Static configuration used as a fallback

✅ Providing **either one is sufficient** for SSO configuration.

---

## **3. Configure SAML Group Sync Mapping**

Define how identity provider groups map to Cloudsmith teams.

* Specify the attribute key (commonly `groups`)
* Define the group value received from the IdP
* Map it to a Cloudsmith team
* Assign the appropriate role

📌 *Reference:* `cloudsmith_saml` resource

---

## **4. How Group Sync Works**

* A user logs in via SAML
* The identity provider sends user attributes, including group membership
* Cloudsmith matches the incoming group with configured mappings
* The user is automatically added to the corresponding team with the assigned role

👉 This process uses **Just-In-Time (JIT) provisioning**, meaning users and access are created or updated during login.

---

## **5. Basic Developer Workflow**

Use the following Terraform steps to apply and inspect the configuration.

### **Initialize Terraform**

```bash
terraform init
```

### **Format and Validate**

```bash
terraform fmt
terraform validate
```

### **Review the Planned Changes**

```bash
terraform plan
```

Optionally save the plan:

```bash
terraform plan -out=tfplan
```

### **Apply the Configuration**

```bash
terraform apply
```

Or, if using a saved plan:

```bash
terraform apply tfplan
```

### **Check Managed Resources**

List resources in Terraform state:

```bash
terraform state list
```

Inspect a specific resource:

```bash
terraform state show cloudsmith_saml_auth.example
terraform state show cloudsmith_saml.example
```

If outputs are defined, review them with:

```bash
terraform output
```

---

## **6. Apply and Validate Configuration**

After applying your Terraform configuration:

* Perform an SSO login via your identity provider
* Confirm that:

    * The user is created in Cloudsmith (if new)
    * The correct team is assigned
    * The appropriate role is applied

---

## **Best Practices**

* Keep group names consistent between your IdP and Cloudsmith
* Use Metadata URL for easier maintenance and automatic updates
* Secure API keys using environment variables or secret managers
* Test with a small group before wider rollout
* Run `terraform plan` before every apply

---

## **Summary**

With this setup:

* SAML SSO is enabled for Cloudsmith
* Group-based access control is automated
* Users are provisioned dynamically during login
* Access management is centralized via your identity provider

