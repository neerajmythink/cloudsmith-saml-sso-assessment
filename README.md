# cloudsmith-saml-sso-assessment
This repository provides a comprehensive guide for integrating Cloudsmith with Okta using SAML-based Single Sign-On (SSO). It covers prerequisites, step-by-step setup instructions, process flows, architecture diagrams, key terminology, and troubleshooting tips to ensure a smooth SSO implementation for your organization.

## Task 1: Set up SSO with OKTA

This guide walks you through setting up Okta as a SAML identity provider (IdP) for your Cloudsmith organization. It enables secure Single Sign-On (SSO), allowing users to access Cloudsmith using credentials managed by trusted providers like Okta. With SSO in place, authentication and authorization are handled externally, and Cloudsmith validates user identity by relying on these providers, delivering a smooth and secure login experience.

---

# Steps to Set Up

To configure SSO in Cloudsmith, you need two key components:

- A Cloudsmith namespace that will be enabled for SSO
- An identity provider (IdP) such as Okta to manage users, services, and groups.

## 1. Create and Access the Okta Admin Account

1. Sign up for an Okta account using an active work email address (for example, [vefowiy143@paylaar.com](mailto:vefowiy143@paylaar.com)). Follow the setup instructions, including password creation and verification via Okta Verify.
2. Once registered, your Okta domain will be created (for example, trial-5274702.okta.com).
3. Log in to the Okta Admin Console using your credentials.
4. Click the **Admin** button at the top to access the admin dashboard.

## 2. Create a Namespace in Cloudsmith

Before configuring SAML, ensure you have a Cloudsmith namespace set up.

1. Log in to Cloudsmith using the default namespace (for example, **cloudsmith**).
2. Create a new workspace if needed (for example, **sso-demo**) that will be used for SSO.
3. Navigate to **Workspace → Settings → Authentication → SAML**. This section is disabled by default.
    - If you don’t have backend access, contact Cloudsmith Support.
    - If you do have access:
        - Log in to Area51 using Cloudsmith SSO.
        - Enable the `enable_saml` feature flag for your namespace.
        - Enable the `webapp_enabled` feature flag for the same namespace.
4. Add your organization’s domains in Area51 under **Organization → Organization domains**:
    - Click **Add organization domain**.
    - Ensure the domain is verified.
    - Enable **Skip invitation flow** if using SCIM provisioning.
    - Keep **Auto verify email** disabled unless explicitly required.
        
        ![image.png](attachment:040e2855-9230-438a-8370-ddf56cf08380:image.png)
        

## 3. Configure the SAML Application in Okta

1. In Okta, go to **Applications → Applications**.
2. Click **Create App Integration**, choose **SAML 2.0**, and continue.

#### General Settings

- App name: *sso-demo*
- App logo: Optional

#### SAML Settings

- **Single Sign-On URL:**
    
    ```
    https://cloudsmith.io/orgs/sso-demo/saml/acs/
    ```
    
- **Audience URI (SP Entity ID):** Same as above
- **Name ID format:** EmailAddress
- **Application username:** Email

3. Complete the setup and click **Finish**.

#### Add Attribute Statements (Important)

Go to **Sign On → Attribute Statements → legacy configuration** and add:

| Name | Name format | Value |
| --- | --- | --- |
| FirstName | Unspecified | user.firstName |
| LastName | Unspecified | user.lastName |
| Email | Unspecified | user.email |

## 4. Provide SAML Configuration to Cloudsmith

1. In the Okta app, go to **Sign On → Metadata details** and copy the **Metadata URL**.
2. Paste it into the **SAML Metadata URL** field in Cloudsmith under **Namespace → Settings → Authentication → SAML**.
3. Under **SAML Signing Certificates**, select **View IdP metadata** for the SHA-2 certificate.
4. Copy the XML and paste it into the **SAML Metadata XML** field in Cloudsmith.
5. SSO is now configured for your Cloudsmith namespace.

## 5. Add Users to Okta Manually

1. Go to **Directory → People** in Okta.
2. Click **Add person** and provide:
    - First name
    - Last name
    - Email/username
3. Select **Activate Now**.
4. Set a temporary password and require a password change on first login.
5. Repeat for additional users if needed.

## 6. Assign Users and Groups to the Application

1. Open the **sso-demo** application in Okta.
2. Go to the **Assignments** tab.
3. Click **Assign** and select users.
4. Save each assignment and repeat as needed.
5. Assigned users will now have access to the application.

## 7. User Login and Okta Verify Setup

1. Share the SAML login URL with users (replace `{YOUR_WORKSPACE}` with your workspace name):
    
    ```
    https://app.cloudsmith.com/{YOUR_WORKSPACE}/saml/login/
    ```
    
2. During login:
    - Enter the workspace name (for example, sso-demo).
    - Log in using the assigned email and temporary password.
3. Set up Okta Verify:
    - Install the app from the Play Store or App Store.
    - Add an account and select **Organization**.
    - Scan the QR code shown during login.
4. Once completed, the user will be enrolled in 2FA and logged into Cloudsmith.
5. Future logins will only require SAML authentication and approval via Okta Verify.
6. After completing these steps, the user will be successfully added to the Cloudsmith namespace.

# **Cloudsmith SSO Setup with Okta – Process Flow**

```
START
 Prerequisites
  ├─ Cloudsmith Namespace ready
  └─ Okta (IdP) account required
  │
  ▼
[1] Create Okta Admin Account
  ├─ Sign up with work email
  ├─ Verify account (Okta Verify)
  ├─ Login to Okta
  └─ Access Admin Dashboard
  │
  ▼
[2] Setup Cloudsmith Namespace
  ├─ Login to Cloudsmith
  ├─ Create workspace (e.g., sso-demo)
  ├─ Enable SAML (via Support / Area51)
  │    ├─ enable_saml = ON
  │    └─ webapp_enabled = ON
  └─ Add & verify organization domain
  │
  ▼
[3] Configure SAML App in Okta
  ├─ Applications → Create App (SAML 2.0)
  ├─ Enter SSO URL & Audience URI
  ├─ Set NameID = Email
  └─ Add Attributes:
       ├─ FirstName
       ├─ LastName
       └─ Email
  │
  ▼
[4] Connect Okta → Cloudsmith
  ├─ Copy Metadata URL from Okta
  ├─ Paste in Cloudsmith SAML settings
  ├─ Copy IdP XML (SHA-2)
  └─ Paste XML in Cloudsmith
  │
  ▼
SSO CONFIGURED ✅
  │
  ▼
[5] Add Users in Okta
  ├─ Directory → People
 ▼
  ├─ Add user details
  ├─ Set password
  └─ Activate user
  │
  ▼
[6] Assign Users to App
  ├─ Open SAML App (sso-demo)
  ├─ Assign users/groups
  └─ Save assignments
  │
  ▼
[7] User Login Flow
  ├─ User opens SAML login URL
  ├─ Enters workspace name
  ├─ Logs in with Okta credentials
  ├─ Sets up Okta Verify (2FA)
  └─ Access Cloudsmith
  │
  ▼
END (User successfully onboarded with S │
 SO)
```

---

# Architecture Overview

SAML SSO between Okta and Cloudsmith follows a trust-based authentication flow where Okta acts as the Identity Provider (IdP) and Cloudsmith acts as the Service Provider (SP).

```
START
  │
  ▼
User opens SAML login URL
  │
  ▼
Redirect to Okta
  │
  ▼
User login + MFA
  │
  ▼
SAML Assertion sent to Cloudsmith
  │
  ▼
Validation successful
  │
  ▼
Access granted
  │
  ▼
END
```

### Simple Flow Representation

```
User → Cloudsmith → Okta (Login + MFA)
     ←──────────── SAML Assertion ────────────
User → Access Cloudsmith
```

# Key Terminology

| Term | Description |
| --- | --- |
| **SAML (Security Assertion Markup Language)** | A protocol used to enable SSO by exchanging authentication data between systems. |
| **IdP (Identity Provider)** | The system that authenticates users (e.g., Okta). |
| **SP (Service Provider)** | The application being accessed (e.g., Cloudsmith). |
| **SSO (Single Sign-On)** | Allows one login to access multiple applications. |
| **Metadata** | Configuration data (URLs, certificates) shared between IdP and SP. |
| **Assertion** | The SAML response containing user identity and authentication details. |
| **Attribute Statements** | User details (name, email) included in the SAML assertion. |
| **ACS URL** | Endpoint in Cloudsmith that receives the SAML response. |
| **Entity ID (Audience URI)** | Unique identifier of the service provider for validation. |
| **MFA (Multi-Factor Authentication)** | Additional verification layer (e.g., Okta Verify). |

# Troubleshooting Guide

1. **“Authentication error received: FirstName attribute not provided by Identity Provider”** during login
    - This occurs when required attributes are missing from the SAML response.
    - Resolve it by adding the following under **Sign On → Attribute Statements** in your Okta app:
    
    | Name | Name format | Value |
    | --- | --- | --- |
    | FirstName | Unspecified | user.firstName |
    | LastName | Unspecified | user.lastName |
    | Email | Unspecified | user.email |

---

1. **“Authentication error received: You need to verify your email address before you can continue with SAML login”**
    - This happens when email verification is required but cannot be completed (e.g., no real email access).
    - Possible solutions:
        - Use email verification bypass where applicable.
        - **Auto verify email:** Enable this only if you want to skip email verification for new users. For better security, it’s recommended to keep this disabled.

---

1. **“Authentication error received: SAML configuration needs to be verified. Please contact customer support”**
    - This usually occurs when the user’s domain has not been verified.
    - Fix it by adding and verifying the organization’s domain under **Verified Domains** in Area51.

---
