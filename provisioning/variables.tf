variable "aws_region" {
  type        = string
  description = "AWS region to use"
  default     = "eu-west-1"
}

variable "aws_az" {
  type        = string
  description = "AWS availability region to use"
  default     = "b"

  validation {
    condition     = contains(["a", "b", "c"], var.aws_az)
    error_message = "Allowed values for aws_az are a, b, or c."
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to attach to each resource (if supported)"
}
