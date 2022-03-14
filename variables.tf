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

variable "prefix" {
  description = "Prefix to use for configvault users"
  type        = string
  default     = "configvault"
}
