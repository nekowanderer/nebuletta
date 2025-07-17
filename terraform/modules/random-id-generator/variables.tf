variable "length" {
  description = "Length of the random string."
  type        = number
  default     = 7
}

variable "keepers" {
  description = "A map of arbitrary strings that, when changed, will trigger recreation of resource."
  type        = map(string)
  default     = {}
}
