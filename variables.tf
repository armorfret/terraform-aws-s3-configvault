variable "logging_bucket" {
  description = "S3 bucket to use for bucket logging"
  type        = string
}

variable "vault_bucket" {
  description = "S3 bucket for storing data"
  type        = string
}

variable "servers" {
  description = "List of servers that will use the vault"
  type        = set(string)
  default     = []
}

variable "kms_key_arn" {
  description = "Use custom KMS key for vault bucket"
  type        = string
  default     = ""
}

variable "use_kms" {
  description = "Use KMS instead of AES SSE"
  type        = bool
  default     = false
}

variable "prefix" {
  description = "Prefix to use for configvault users"
  type        = string
  default     = "configvault"
}
