variable "assume_role_policy" {
  type        = string
  description = "The assume role policy for the AWS IAM role.  If blank, allows any principal in the account to assume the role."
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of the AWS IAM role."
}

variable "streams" {
  type        = list(string)
  description = "The ARNs of the streams the role is allowed to read from.  Use [\"*\"] to allow all streams."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the AWS IAM role."
  default     = {}
}
