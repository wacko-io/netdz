variable "env_name" {
  default = "undefined"
  type = string
  description = "Name of the environment"
}
variable "subnets" {
  type = list(object({
    zone = string
    cidr = string
  }))
  description = "Default zone for resources"
}
