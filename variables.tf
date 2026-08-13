variable "opensearch_domain_saml_options" {
  description = <<EOT
Map of opensearch_domain_saml_options, attributes below
Required:
    - domain_name
Optional:
    - region
    - saml_options (block):
        - enabled (optional)
        - idp (optional, block):
            - entity_id (required)
            - metadata_content (required)
        - master_backend_role (optional)
        - master_user_name (optional)
        - roles_key (optional)
        - session_timeout_minutes (optional)
        - subject_key (optional)
EOT

  type = map(object({
    domain_name = string
    region      = optional(string)
    saml_options = optional(object({
      enabled = optional(bool)
      idp = optional(object({
        entity_id        = string
        metadata_content = string
      }))
      master_backend_role     = optional(string)
      master_user_name        = optional(string)
      roles_key               = optional(string)
      session_timeout_minutes = optional(number)
      subject_key             = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.opensearch_domain_saml_options : (
        v.saml_options == null || (v.saml_options.idp == null || (length(v.saml_options.idp.metadata_content) > 0))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.opensearch_domain_saml_options : (
        v.saml_options == null || (v.saml_options.master_backend_role == null || (length(v.saml_options.master_backend_role) > 0))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.opensearch_domain_saml_options : (
        v.saml_options == null || (v.saml_options.master_user_name == null || (length(v.saml_options.master_user_name) > 0))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.opensearch_domain_saml_options : (
        v.saml_options == null || (v.saml_options.session_timeout_minutes == null || (v.saml_options.session_timeout_minutes >= 1 && v.saml_options.session_timeout_minutes <= 1440))
      )
    ])
    error_message = "must be between 1 and 1440"
  }
}

