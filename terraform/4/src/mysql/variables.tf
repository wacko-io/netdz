variable "cluster_name" {
    description = "The name of the MySQL cluster."
    type        = string
}
variable "network_id"{
    description = "The ID of the network to which the MySQL cluster will be connected."
    type        = string
}
variable "HA" {
    description = "Whether to enable High Availability (HA) for the MySQL cluster."
    type        = bool
    default     = true
}
variable "ha_hosts_count" {
    description = "The number of hosts to be used for High Availability (HA) if enabled."
    type        = number
    default     = 2
}
variable "subnets" {
    description = "The subnets to which the MySQL cluster will be connected."
    type        = list(object({
        zone = string
        subnet_id = string
    }))
}
variable "cluster_resources" {
    description = "The resources to be allocated for the MySQL cluster."
    type        = object({
        resource_preset_id = string
        disk_type_id = string
        disk_size = number
    })
}