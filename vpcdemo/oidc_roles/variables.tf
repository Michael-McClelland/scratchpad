variable "readonly_role_name" {
  description = "Name of the read-only IAM role for GitHub OIDC"
  type        = string
  default     = "oidc-example-readonly"
}

variable "write_role_name" {
  description = "Name of the write access IAM role for GitHub OIDC"
  type        = string
  default     = "oidc-example-write"
}

variable "state_role_name" {
  description = "Name of the write access IAM role for GitHub OIDC"
  type        = string
  default     = "oidc-example-state"
}

variable "max_session_duration" {
  description = "Maximum session duration for IAM roles in seconds"
  type        = number
  default     = 14400  # 4 hours
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
  default     = "Michael-McClelland"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "vpcdemo"
}